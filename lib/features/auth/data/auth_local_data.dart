import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalData {
  // Simpan status login & waktu login (Timestamp)
  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setInt('last_activity', DateTime.now().millisecondsSinceEpoch);
  }

  // Cek apakah session masih valid (kurang dari 5 menit)
  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');
    final int? lastActivity = prefs.getInt('last_activity');

    // Jika tidak ada data email atau waktu, berarti belum login
    if (email == null || lastActivity == null) return false;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final int diff = currentTime - lastActivity;
    
    // 5 menit = 300.000 milidetik
    return diff < 300000; 
  }

  // Hapus session (Logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}