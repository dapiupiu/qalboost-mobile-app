import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/components/app_drawer.dart';
import '../../../core/components/custom_bottom_nav.dart';
import '../provider/home_provider.dart';
import '../../main_features/model/mood_model.dart';
import '../../sub_features/presentation/diary.dart';
import '../../sub_features/presentation/tips.dart';
import '../../sub_features/presentation/consul.dart';
import '../../sub_features/presentation/quotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeProvider _homeProvider = HomeProvider();

  final PageController _articleController = PageController();
  Timer? _sliderTimer;
  int _currentArticle = 0;

  final List<Map<String, String>> articles = [
    {
      'title': 'Kenapa Gen Z Gampang Overthinking? Psikolog Ungkap Penyebab Utamanya',
      'image': 'assets/images/article1.png',
      'link': 'https://www.inews.id/lifestyle/health/kenapa-gen-z-gampang-overthinking-psikolog-ungkap-penyebab-utamanya?',
    },

    {
      'title': 'Manfaat Journaling bagi Kesehatan Mental yang Sayang untuk Dilewatkan',
      'image': 'assets/images/article2.png',
      'link': 'https://www.alodokter.com/manfaat-journaling-bagi-kesehatan-mental-yang-sayang-untuk-dilewatkan',
    },

    {
      'title': 'Jangan Berlarut-larut, Ini Cara Bangkit dari Kesalahan di Masa Lalu',
      'image': 'assets/images/article3.png',
      'link': 'https://www.alodokter.com/jangan-berlarut-larut-ini-cara-bangkit-dari-kesalahan-di-masa-lalu',
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshData();

    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      if (_currentArticle < articles.length - 1) {
        _currentArticle++;
      } else {
        _currentArticle = 0;
      }

      _articleController.animateToPage(
        _currentArticle,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _articleController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _homeProvider.loadUserData();
    if (mounted) setState(() {});
  }

  Color _getMoodColor(String? emoji) {
    if (emoji == '😊') return const Color(0xFFE8F5E9);
    if (emoji == '😢') return const Color(0xFFFFEBEE);
    return Colors.white;
  }

  Widget _getMoodImage(String? emoji) {
    if (emoji == '😊') {
      return Image.asset('assets/images/baik.png', width: 80, height: 80);
    } else if (emoji == '😢') {
      return Image.asset('assets/images/buruk.png', width: 80, height: 80);
    } else {
      return Image.asset(
        'assets/images/b_aja.png',
        width: 80,
        height: 80,
        errorBuilder: (c, e, s) =>
            const Text('🌙', style: TextStyle(fontSize: 36)),
      );
    }
  }

  Future<void> _openArticle(String link) async {
    final Uri url = Uri.parse(link);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDarkMode),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Bagaimana Perasaan\nKamu Hari Ini?',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F1B18),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuItem(
                      'assets/images/quotes.png',
                      'Q-Quotes',
                      const QuotesSimpleScreen(),
                    ),
                    _buildMenuItem(
                      'assets/images/consul.png',
                      'Q-Consul',
                      const ConsulPage(),
                    ),
                    _buildMenuItem(
                      'assets/images/diary.png',
                      'Q-Diary',
                      const DiaryPage(),
                    ),
                    _buildMenuItem(
                      'assets/images/tips.png',
                      'Q-Tips',
                      const TipsPage(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              _buildHistorySection(),
              const SizedBox(height: 12),
              _buildMoodRow(),
              const SizedBox(height: 30),
              _buildDailyPerasaan(),
              const SizedBox(height: 30),
              _buildArticleSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildMenuItem(String path, String label, Widget page) {
    return Expanded(
      child: AnimatedMenuButton(assetPath: path, label: label, page: page),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF58A6F0),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.black54,
                    ),
                  ),
                  Text(
                    _homeProvider.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            'assets/images/app_logo.png',
            width: 48,
            height: 48,
            errorBuilder: (c, e, s) =>
                const Icon(Icons.auto_awesome, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'History Mood',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, '/mood').then((_) => _refreshData()),
            child: const Text(
              'Buka Kalender',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodRow() {
    final List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: days.map((dayName) {
            final dayIndex = days.indexOf(dayName) + 1;
            final currentWeekDay = now.weekday;
            final targetDate = now.add(Duration(days: dayIndex - currentWeekDay));

            final dateKey =
                "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}";

            MoodModel? moodData;

            try {
              moodData = _homeProvider.weeklyMoods
                  .firstWhere((m) => m.dateKey == dateKey);
            } catch (_) {}

            final bool isToday = dayIndex == currentWeekDay;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: moodData != null
                          ? _getMoodColor(moodData.emoji)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday
                          ? Border.all(color: Colors.orange, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        moodData?.emoji ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 10,
                      color: isToday ? Colors.orange : Colors.grey,
                      fontWeight:
                          isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDailyPerasaan() {
    final todayMood = _homeProvider.todayMood;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              color: todayMood != null
                  ? _getMoodColor(todayMood.emoji)
                  : const Color(0xFFFFEFD6),
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
                _getMoodImage(todayMood?.emoji),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayMood != null
                            ? '"${todayMood.note}"'
                            : '"Belum ada catatan hari ini"',
                        style: const TextStyle(
                          color: Color(0xFF2E2A28),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        todayMood != null
                            ? (todayMood.emoji == '😊' ? 'Baik' : 'Buruk')
                            : 'Kosong',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
          child: GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, '/checker').then((_) => _refreshData()),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tuliskan aktivitas atau perasaanmu hari ini...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hari Ini Ada Apa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _articleController,
            itemCount: articles.length,
            onPageChanged: (index) {
              setState(() {
                _currentArticle = index;
              });
            },
            itemBuilder: (context, index) {
              final article = articles[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => _openArticle(article['link']!),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color(0xFFD6EAF8),
                            child: Image.asset(
                              article['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.65),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 18,
                          child: Text(
                            article['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            articles.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentArticle == index ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentArticle == index
                    ? Colors.orange
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedMenuButton extends StatefulWidget {
  final String assetPath;
  final String label;
  final Widget page;

  const AnimatedMenuButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.page,
  });

  @override
  State<AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse().then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.page),
          );
        });
      },
      onTapCancel: () => _controller.reverse(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    widget.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.extension, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}