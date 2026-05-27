import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/mood_model.dart';

class MoodRepository {
  Future<File> _getMoodFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/moods.json');
  }

  // Simpan mood baru
  Future<void> saveMood(MoodModel newMood) async {
    final file = await _getMoodFile();
    List<MoodModel> allMoods = await getAllMoods();

    // Hapus data lama jika tanggal dan email sama (update)
    allMoods.removeWhere((m) => m.dateKey == newMood.dateKey && m.userEmail == newMood.userEmail);
    
    allMoods.add(newMood);

    final String rawJson = jsonEncode(allMoods.map((m) => m.toJson()).toList());
    await file.writeAsString(rawJson);
  }

  // Ambil semua mood
  Future<List<MoodModel>> getAllMoods() async {
    try {
      final file = await _getMoodFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      if (contents.isEmpty) return [];
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((e) => MoodModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Ambil mood spesifik untuk user tertentu
  Future<MoodModel?> getUserMoodByDate(String email, DateTime date) async {
    final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final moods = await getAllMoods();
    try {
      return moods.firstWhere((m) => m.userEmail == email && m.dateKey == dateKey);
    } catch (e) {
      return null;
    }
  }
}