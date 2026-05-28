import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_service.dart';
import 'core/notifications/notification_service.dart';

// --- IMPORT FEATURES ---
import 'features/home/presentation/splash_screen.dart';
import 'features/home/presentation/home_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/settings/presentation/settings.dart';
import 'features/main_features/presentation/mood.dart';
import 'features/main_features/presentation/checker.dart';

// --- IMPORT SUB FEATURES ---
import 'features/sub_features/presentation/tips.dart';
import 'features/sub_features/presentation/consul.dart';
import 'features/sub_features/presentation/quotes.dart';
import 'features/sub_features/presentation/diary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'QalBoost',
      debugShowCheckedModeBanner: false,

      themeMode: themeService.themeMode,
      theme: themeService.lightTheme,
      darkTheme: themeService.darkTheme,

      home: const VideoSplashScreen(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/mood': (context) => const MoodPage(),
        '/tips': (context) => const TipsPage(),
        '/checker': (context) => const CheckerSimpleScreen(),
        '/consul': (context) => const ConsulPage(),
        '/quotes': (context) => const QuotesSimpleScreen(),
        '/diary': (context) => const DiaryPage(),
      },
    );
  }
}