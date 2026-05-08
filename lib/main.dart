import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'diary.dart';
import 'tips.dart';
import 'mood.dart';
import 'consul.dart';
import 'checker.dart';
import 'settings.dart';
import 'quotes.dart';
import 'theme_service.dart';

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

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey[400] : Colors.black54,
                                ),
                              ),
                              Text(
                                'Nama Pengguna',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.asset(
                          'assets/images/moon_small.png',
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.location_on),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mei 07 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // --- TITLE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bagaimana Perasaan\nKamu Hari Ini?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F1B18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- MENU BUTTONS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  menuButton(
                    context,
                    assetPath: 'assets/images/menu_quotes.png',
                    label: 'Q-Quotes',
                    page: const QuotesSimpleScreen(),
                  ),
                  menuButton(
                    context,
                    assetPath: 'assets/images/menu_consul.png',
                    label: 'Q-Qonsul',
                    page: const ConsulPage(),
                  ),
                  menuButton(
                    context,
                    assetPath: 'assets/images/menu_diary.png',
                    label: 'Q-Diary',
                    page: const DiaryPage(),
                  ),
                  menuButton(
                    context,
                    assetPath: 'assets/images/menu_tips.png',
                    label: 'Q-Tips',
                    page: const TipsPage(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- HISTORY MOOD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'History Mood',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MoodPage()),
                      );
                    },
                    child: const Text(
                      'Buka Kalender',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Senin',
                    'Selasa',
                    'Rabu',
                    'Kamis',
                    'Jumat',
                    'Sabtu',
                    'Minggu',
                  ].map((day) {
                    final isFirst = day == 'Senin';
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isFirst
                                  ? const Color(0xFFFFEFD6)
                                  : const Color(0xFFD7EAF8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text(isFirst ? '😞' : '')),
                          ),
                          const SizedBox(height: 6),
                          Text(day, style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- PERASAAN HARI INI ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Perasaan Kamu Hari ini',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFD6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        'assets/images/moon_small.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(
                          child: Text('🌙', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"catatan kecil dari isi q-checker"',
                            style: TextStyle(color: Color(0xFF2E2A28)),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Kecewa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1F1B18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tuliskan aktivitas atau perasaanmu hari ini...',
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: SizedBox(
        height: 72,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 72,
              color: const Color(0xFF58A6F0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 56),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -22,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/checker'),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/icons/moon_nav.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(
                          child: Text('🌙', style: TextStyle(fontSize: 28)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔥 REUSABLE BUTTON
Widget menuButton(
  BuildContext context, {
  IconData? icon,
  String? assetPath,
  required String label,
  required Widget page,
}) {
  return Column(
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: assetPath != null
                  ? Image.asset(
                      assetPath,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Icon(icon ?? Icons.extension),
                    )
                  : Icon(icon ?? Icons.extension),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(label),
    ],
  );
}