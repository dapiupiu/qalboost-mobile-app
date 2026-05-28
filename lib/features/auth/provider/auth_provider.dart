import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../data/auth_local_data.dart';
import '../model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final AuthLocalData _localData = AuthLocalData();

  // Menyimpan objek UserModel utuh di memori RAM aplikasi
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Proses Registrasi
  Future<bool> register(String name, String email, String password) async {
    final user = UserModel(fullName: name, email: email, password: password);
    return await _repository.registerUser(user);
  }

  // Proses Login
  Future<bool> login(String email, String password) async {
    bool loginSuccess = false;
    UserModel? loggedInUser;

    // 1. Logika Akun Admin
    if (email == 'admin@gmail.com' && password == 'admin123') {
      loginSuccess = true;
      loggedInUser = UserModel(fullName: 'Administrator', email: email, password: password);
    } else {
      // 2. Logika Akun Normal
      final user = await _repository.login(email, password);
      if (user != null) {
        loginSuccess = true;
        loggedInUser = user; 
      }
    }

    // 3. JIKA LOGIN BERHASIL (Admin atau User Biasa)
    if (loginSuccess && loggedInUser != null) {
      // Simpan email aktif ke SharedPreferences via AuthLocalData
      await _localData.saveSession(email);
      
      // Simpan objek user lengkap ke variabel lokal (Memori RAM)
      _currentUser = loggedInUser;
      
      // Beritahu seluruh komponen/widget penyimak (termasuk Drawer) untuk re-build UI
      notifyListeners(); 
      return true;
    }

    return false;
  }

  // Fungsi untuk memulihkan data user dari database lokal saat aplikasi baru dibuka (Auto-login)
  Future<void> restoreSession() async {
    try {
      // SINKRONISASI: Menggunakan getEmail() sesuai dengan fungsi di AuthLocalData kamu
      String? savedEmail = await _localData.getEmail(); 

      if (savedEmail != null) {
        if (savedEmail == 'admin@gmail.com') {
          _currentUser = UserModel(
            fullName: 'Administrator', 
            email: savedEmail, 
            password: 'admin123',
          );
        } else {
          // Cari data profil pengguna lengkap dari basis data lewat repository berdasarkan email
          // Catatan: Pastikan method di bawah ini tersedia di kelas AuthRepository Anda
          final user = await _repository.getUserByEmail(savedEmail); 
          if (user != null) {
            _currentUser = user;
          }
        }
        // Perbarui state agar CustomAppDrawer langsung membaca data pengguna yang valid
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Gagal memulihkan sesi pengguna: $e");
    }
  }

  // Fungsi Logout yang sinkron untuk membersihkan memori RAM dan penyimpanan HP
  Future<void> logout() async {
    await _localData.clearSession();
    _currentUser = null; // Menghapus data user di RAM
    notifyListeners(); // Memicu perubahan UI kembali ke kondisi guest/awal
  }
}