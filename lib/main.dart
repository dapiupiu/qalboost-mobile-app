import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_service.dart';
import 'core/notifications/notification_service.dart'; // IMPORT SERVICE BARU

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
  // 1. WAJIB: Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. INISIALISASI: Siapkan sistem notifikasi sebelum aplikasi jalan
  await NotificationService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita buat instansinya satu kali di sini
    final themeService = ThemeService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Jika nanti kamu buat DiaryProvider atau MoodProvider, taruh di sini
      ],
      child: ListenableBuilder(
        listenable: themeService,
        builder: (context, child) {
          return MaterialApp(
            title: 'QalBoost',
            debugShowCheckedModeBanner: false,
            themeMode: themeService.themeMode,
            
            // Tema Terang
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1E679F), 
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF6E9E1),
            ),

            // Tema Gelap
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1E679F),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1F1F1F),
                surfaceTintColor: Colors.transparent,
              ),
            ),

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
        },
      ),
    );
  }
}