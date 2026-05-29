import 'package:animations/animations.dart';
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

      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/login':
            page = const LoginPage();
            break;
          case '/register':
            page = const RegisterPage();
            break;
          case '/home':
            page = const HomePage();
            break;
          case '/settings':
            page = const SettingsPage();
            break;
          case '/mood':
            page = const MoodPage();
            break;
          case '/tips':
            page = const TipsPage();
            break;
          case '/checker':
            page = const CheckerSimpleScreen();
            break;
          case '/consul':
            page = const ConsulPage();
            break;
          case '/quotes':
            page = const QuotesSimpleScreen();
            break;
          case '/diary':
            page = const DiaryPage();
            break;
          default:
            return null;
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      },
    );
  }
}