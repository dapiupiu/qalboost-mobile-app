import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mood_repository.dart';
import '../model/mood_model.dart';

class MoodProvider extends ChangeNotifier {
  final MoodRepository _repository = MoodRepository();
  List<MoodModel> _userMoods = [];
  
  // Logika Kalender
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  List<MoodModel> get userMoods => _userMoods;
  int get currentMonth => _currentMonth;
  int get currentYear => _currentYear;

  // Navigasi Kalender
  void nextMonth() {
    if (_currentMonth == 12) {
      _currentMonth = 1;
      _currentYear++;
    } else {
      _currentMonth++;
    }
    notifyListeners();
  }

  void previousMonth() {
    if (_currentMonth == 1) {
      _currentMonth = 12;
      _currentYear--;
    } else {
      _currentMonth--;
    }
    notifyListeners();
  }

  void setMonthYear(int month, int year) {
    _currentMonth = month;
    _currentYear = year;
    notifyListeners();
  }

  // Database Logic
  Future<void> fetchMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email != null) {
      final all = await _repository.getAllMoods();
      _userMoods = all.where((m) => m.userEmail == email).toList();
      notifyListeners();
    }
  }

  Future<void> saveMood(DateTime date, String emoji, String note) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email != null) {
      final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final newMood = MoodModel(
        userEmail: email,
        dateKey: dateKey,
        emoji: emoji,
        note: note,
      );
      await _repository.saveMood(newMood);
      await fetchMoods(); 
    }
  }
}