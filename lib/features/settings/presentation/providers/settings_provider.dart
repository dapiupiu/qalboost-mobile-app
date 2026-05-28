import 'package:flutter/material.dart';
import '../../data/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();

  final NotificationService _notificationService = NotificationService();

  bool _isNotificationEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 08, minute: 00);

  bool get isNotificationEnabled => _isNotificationEnabled;
  TimeOfDay get notificationTime => _notificationTime;

  Future<void> toggleNotification(bool value) async {
    _isNotificationEnabled = value;
    if (value) {
      await _notificationService.requestPermissions();
      await _updateSchedule();
    } else {
      await _notificationService.cancelNotification(1);
    }
    notifyListeners();
  }

  Future<void> updateNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    if (_isNotificationEnabled) {
      await _updateSchedule();
    }
    notifyListeners();
  }

  Future<void> _updateSchedule() async {
    await _notificationService.scheduleDailyNotification(
      id: 1,
      title: 'QalBoost Reminder',
      body: 'Waktunya cek kesehatan mental kamu hari ini!',
      hour: _notificationTime.hour,
      minute: _notificationTime.minute,
    );
  }
}
