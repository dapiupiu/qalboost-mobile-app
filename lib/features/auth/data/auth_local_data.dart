import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalData {
  // Simpan email saat login
  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    // Gunakan setString dan pastikan berhasil
    await prefs.setString('user_email', email); 
    await prefs.setInt('last_activity', DateTime.now().millisecondsSinceEpoch);
    
    // Opsional: Cek apakah benar tersimpan (untuk debug)
    print("DEBUG_AUTH: Session disimpan untuk $email");
  }

  // AMBIL EMAIL
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    
    // REVISI: Paksa sistem membaca ulang dari disk/penyimpanan fisik
    // Ini krusial agar data tidak 'KOSONG' setelah login ulang
    await prefs.reload(); 
    
    final String? email = prefs.getString('user_email');
    print("DEBUG_AUTH: Email yang dibaca -> $email");
    return email;
  }

  // Cek apakah session masih valid (5 menit)
  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Selalu reload sebelum cek
    
    final String? email = prefs.getString('user_email');
    final int? lastActivity = prefs.getInt('last_activity');

    if (email == null || lastActivity == null) return false;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final int diff = currentTime - lastActivity;
    
    // 300.000 ms = 5 Menit
    return diff < 300000; 
  }

  // LOGOUT (Hapus status login, diary aman)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Menghapus kunci secara spesifik agar data diary tidak ikut terhapus
    await prefs.remove('user_email');
    await prefs.remove('last_activity');
    
    print("DEBUG_AUTH: Session dibersihkan. Logout berhasil.");
  }
}