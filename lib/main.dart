import 'package:flutter/material.dart';
import 'core/theme/theme_service.dart';

// Import hasil pemindahan
import 'features/home/presentation/splash_screen.dart';
import 'features/home/presentation/home_page.dart';
import 'features/settings/presentation/settings.dart';
import 'features/main_features/presentation/mood.dart';
import 'features/main_features/presentation/checker.dart';

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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              surfaceTintColor: Colors.transparent,
            ),
          ),
          // Menggunakan SplashScreen yang sudah dipindah
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