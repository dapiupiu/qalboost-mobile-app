import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('ic_notif'); 
        
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  // TAMBAHKAN PARAMETER String userName DI SINI
  Future<void> schedulePresentationNotifs(String userName) async {
    List<String> messages = [
      "Halo $userName! Jangan lupa isi mood kamu sekarang ya 🌙",
      "Gimana perasaanmu, $userName? Yuk ceritakan di Q-Diary!",
      "Sesi login hampir habis, $userName sudah cek mood hari ini?"
    ];

    const RawResourceAndroidNotificationSound customSound = RawResourceAndroidNotificationSound('notif_sound');

    for (int i = 0; i < messages.length; i++) {
      Future.delayed(Duration(seconds: i * 15), () async {
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
            ),
          ),
        );
      });
    }
  }

  Future<void> cancelAll() async => await _notificationsPlugin.cancelAll();
}