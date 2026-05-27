import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DiaryRepository {
  // Ambil lokasi file diary.json (Sama kyk mood)
  Future<File> _getDiaryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/diaries.json');
  }

  // Simpan/Update Diary
  Future<void> saveDiary(String email, List<Map<String, String>> entries) async {
    try {
      final file = await _getDiaryFile();
      List<dynamic> allData = await _getAllRawData();

      // Hapus data lama milik user ini (biar gak duplikat)
      allData.removeWhere((item) => item['userEmail'] == email);

      // Tambahkan data baru dengan identitas email
      allData.add({
        'userEmail': email,
        'entries': entries,
      });

      await file.writeAsString(jsonEncode(allData));
      print("DEBUG_FILE: Berhasil tulis ke JSON untuk $email");
    } catch (e) {
      print("DEBUG_FILE_ERROR: $e");
    }
  }

  // Ambil Diary milik user tertentu
  Future<List<Map<String, String>>> getDiaryByEmail(String email) async {
    try {
      final List<dynamic> allData = await _getAllRawData();
      final userData = allData.firstWhere(
        (item) => item['userEmail'] == email,
        orElse: () => null,
      );

      if (userData != null) {
        return List<Map<String, String>>.from(
          userData['entries'].map((e) => Map<String, String>.from(e))
        );
      }
    } catch (e) {
      print("DEBUG_FILE_LOAD_ERROR: $e");
    }
    return [];
  }

  // Helper ambil semua isi file
  Future<List<dynamic>> _getAllRawData() async {
    try {
      final file = await _getDiaryFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      if (contents.isEmpty) return [];
      return jsonDecode(contents);
    } catch (e) {
      return [];
    }
  }
}