import 'package:flutter/material.dart';
import 'core/theme/theme_service.dart';

// --- IMPORT FEATURES ---
import 'features/home/presentation/splash_screen.dart';
import 'features/home/presentation/home_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/settings/presentation/settings.dart';
import 'features/main_features/presentation/mood.dart';
import 'features/main_features/presentation/checker.dart';

// --- IMPORT SUB FEATURES ---
import 'features/sub_features/presentation/tips.dart';
import 'features/sub_features/presentation/consul.dart';
import 'features/sub_features/presentation/quotes.dart';
// AKTIF: Baris import diary sudah dibuka
import 'features/sub_features/presentation/diary.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E679F), 
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF6E9E1),
          ),

          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E679F),
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

          home: const VideoSplashScreen(),
          
          // --- REGISTER SEMUA ALAMAT RUTE DI SINI ---
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
            
            // AKTIF: Tanda // sudah dihapus, rute diary sekarang resmi terdaftar
            '/diary': (context) => const DiaryPage(), 
          },
        );
      },
    );
  }
}