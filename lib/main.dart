import 'package:flutter/material.dart';
import 'core/theme/theme_service.dart';

import 'features/home/presentation/pages/splash_screen.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/main_features/presentation/pages/mood_page.dart';
import 'features/main_features/presentation/pages/checker_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();

    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return MaterialApp(
          title: 'QalBoost',
          debugShowCheckedModeBanner: false,
          themeMode: themeService.themeMode,
          theme: themeService.lightTheme,
          darkTheme: themeService.darkTheme,
          home: const VideoSplashScreen(),
          routes: {
            '/settings': (context) => const SettingsPage(),
            '/checker': (context) => const CheckerSimpleScreen(),
            '/mood': (context) => const MoodPage(),
            '/home': (context) => const HomePage(),
          },
        );
      },
    );
  }
}
