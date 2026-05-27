import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../data/auth_local_data.dart';
import '../model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final AuthLocalData _localData = AuthLocalData();

  // Tambahkan variabel ini untuk menyimpan email aktif di memori Provider
  String? _currentUserEmail;
  String? get currentUserEmail => _currentUserEmail;

  // Proses Registrasi
  Future<bool> register(String name, String email, String password) async {
    final user = UserModel(fullName: name, email: email, password: password);
    return await _repository.registerUser(user);
  }

  // Proses Login
  Future<bool> login(String email, String password) async {
    bool loginSuccess = false;

    // 1. Logika Akun Admin
    if (email == 'admin@gmail.com' && password == 'admin123') {
      loginSuccess = true;
    } else {
      // 2. Logika Akun Normal
      final user = await _repository.login(email, password);
      if (user != null) {
        loginSuccess = true;
      }
    }

    // 3. JIKA LOGIN BERHASIL (Admin atau User Biasa)
    if (loginSuccess) {
      // Simpan ke SharedPreferences (Harddisk HP)
      await _localData.saveSession(email);
      
      // Simpan ke variabel lokal (Memori RAM)
      _currentUserEmail = email;
      
      // Beritahu semua halaman (termasuk Diary) bahwa login sukses
      notifyListeners(); 
      return true;
    }

    return false;
  }

  // Tambahkan fungsi Logout di sini agar sinkron
  Future<void> logout() async {
    await _localData.clearSession();
    _currentUserEmail = null;
    notifyListeners();
  }
}