class MoodStorage {
  static final Map<String, Map<String, dynamic>> _moodData = {};

  static void saveMood(DateTime date, String emoji, String catatan) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    _moodData[key] = {
      'emoji': emoji,
      'catatan': catatan,
      'timestamp': DateTime.now(),
    };
  }

  static Map<String, dynamic>? getMood(DateTime date) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _moodData[key];
  }
}
