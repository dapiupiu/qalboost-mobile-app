import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryLocalData {
  // PAKAI SATU KUNCI MATI: Tidak peduli siapa yang login, laci ini satu untuk semua.
  static const String _globalKey = 'SUPER_PERSISTENT_DIARY_KEY';

  Future<void> saveDiary(String email, List<Map<String, String>> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = json.encode(entries);
      
      // Simpan dan paksa sinkronisasi
      await prefs.setString(_globalKey, encodedData);
      
      // Verifikasi detik itu juga
      final String? verify = prefs.getString(_globalKey);
      print("DEBUG_SYSTEM: Data masuk ke $_globalKey | Karakter: ${verify?.length ?? 0}");
    } catch (e) {
      print("DEBUG_SYSTEM_ERROR: Gagal simpan -> $e");
    }
  }

  Future<List<Map<String, String>>> getDiary(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // RELOAD ADALAH KOENTJI
      await prefs.reload(); 
      
      final String? diaryData = prefs.getString(_globalKey);
      print("DEBUG_SYSTEM: Muat dari $_globalKey | Hasil: ${diaryData != null ? 'ADA' : 'KOSONG'}");

      if (diaryData != null) {
        final List<dynamic> decodedData = json.decode(diaryData);
        return decodedData.map((item) => Map<String, String>.from(item)).toList();
      }
    } catch (e) {
      print("DEBUG_SYSTEM_ERROR: Gagal muat -> $e");
    }
    return [];
  }
}