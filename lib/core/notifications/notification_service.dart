import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async'; // Tambahkan ini

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // List untuk menampung timer agar bisa dibatalkan total
  final List<Timer> _activeTimers = [];

  Future<void> init() async {
    try {
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher'); 
      const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
      await _notificationsPlugin.initialize(initSettings);
    } catch (e) {
      print("Notification Init Error: $e");
    }
  }

  Future<void> schedulePresentationNotifs(String userName) async {
    // Bersihkan dulu timer lama kalau ada, biar gak numpuk
    _clearAllTimers();

    List<String> messages = [
      "Halo $userName! Jangan lupa isi mood kamu sekarang ya 🌙",
      "Gimana perasaanmu, $userName? Yuk ceritakan di Q-Diary!",
      "Jangan biarin harimu berlalu begitu saja, $userName sudah cek mood hari ini?"
    ];

    const RawResourceAndroidNotificationSound customSound = 
        RawResourceAndroidNotificationSound('notif_sound');

    for (int i = 0; i < messages.length; i++) {
      // Simpan timer ke dalam list
      final timer = Timer(Duration(seconds: i * 15), () async {
        await _notificationsPlugin.show(
          i,
          'QalBoost Reminder',
          messages[i],
          NotificationDetails(
            android: AndroidNotificationDetails(
              'presentation_channel_custom',
              'Pengingat Presentasi',
              channelDescription: 'Channel dengan logo dan suara custom',
              importance: Importance.max,
              priority: Priority.high,
              sound: customSound,
              playSound: true,
              icon: '@mipmap/ic_launcher', 
            ),
          ),
        );
      });
      _activeTimers.add(timer);
    }
  }

  // Fungsi internal untuk mematikan semua timer yang sedang menunggu
  void _clearAllTimers() {
    for (var timer in _activeTimers) {
      if (timer.isActive) timer.cancel();
    }
    _activeTimers.clear();
  }

  Future<void> cancelAll() async {
    _clearAllTimers(); // Hentikan antrean yang belum muncul
    await _notificationsPlugin.cancelAll(); // Hapus yang sudah muncul di layar
  }
}