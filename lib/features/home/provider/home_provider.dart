import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/data/auth_repository.dart';
import '../../main_features/data/mood_repository.dart'; // Import Mood Repo
import '../../main_features/model/mood_model.dart';

class HomeProvider extends ChangeNotifier {
  String _userName = "Pengguna QalBoost";
  final AuthRepository _authRepository = AuthRepository();
  final MoodRepository _moodRepository = MoodRepository();
  
  List<MoodModel> _weeklyMoods = [];
  MoodModel? _todayMood;

  String get userName => _userName;
  List<MoodModel> get weeklyMoods => _weeklyMoods;
  MoodModel? get todayMood => _todayMood;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');

    if (email != null) {
      // 1. Ambil Nama User
      final user = await _authRepository.getUserByEmail(email);
      if (user != null) {
        _userName = user.fullName?.split(' ')[0] ?? "Pengguna";
      }

      // 2. Ambil Semua Mood User
      final allMoods = await _moodRepository.getAllMoods();
      final userMoods = allMoods.where((m) => m.userEmail == email).toList();

      // 3. Cari Mood Hari Ini
      final now = DateTime.now();
      final todayKey = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      try {
        _todayMood = userMoods.firstWhere((m) => m.dateKey == todayKey);
      } catch (_) {
        _todayMood = null;
      }

      // 4. Ambil Mood 7 Hari Terakhir (untuk Baris Mood)
      _weeklyMoods = userMoods; // Kita simpan semua, nanti di UI kita filter per hari
      
      notifyListeners();
    }
  }
}