import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme_service.dart';
import '../../../core/components/app_drawer.dart';
import '../../../core/components/custom_bottom_nav.dart';
import '../provider/home_provider.dart';
import '../../main_features/model/mood_model.dart';

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
      'title':
          'Kenapa Gen Z Gampang Overthinking? Psikolog Ungkap Penyebab Utamanya',
      'image': 'assets/images/article1.png',
      'link':
          'https://www.inews.id/lifestyle/health/kenapa-gen-z-gampang-overthinking-psikolog-ungkap-penyebab-utamanya?',
    },
    {
      'title':
          'Manfaat Journaling bagi Kesehatan Mental yang Sayang untuk Dilewatkan',
      'image': 'assets/images/article2.png',
      'link':
          'https://www.alodokter.com/manfaat-journaling-bagi-kesehatan-mental-yang-sayang-untuk-dilewatkan',
    },
    {
      'title':
          'Jangan Berlarut-larut, Ini Cara Bangkit dari Kesalahan di Masa Lalu',
      'image': 'assets/images/article3.png',
      'link':
          'https://www.alodokter.com/jangan-berlarut-larut-ini-cara-bangkit-dari-kesalahan-di-masa-lalu',
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshData();

    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      _currentArticle =
          _currentArticle < articles.length - 1 ? _currentArticle + 1 : 0;

      if (_articleController.hasClients) {
        _articleController.animateToPage(
          _currentArticle,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
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

  Color _getMoodColor(String? emoji, ThemeService themeService) {
    if (emoji == '😊') {
      return themeService.isDarkMode
          ? const Color(0xFF1B3D2A)
          : const Color(0xFFE8F5E9);
    }

    if (emoji == '😢') {
      return themeService.isDarkMode
          ? const Color(0xFF4A1F1F)
          : const Color(0xFFFFEBEE);
    }

    return themeService.homeMoodEmptyBoxColor;
  }

  Widget _getMoodImage(String? emoji) {
    if (emoji == '😊') {
      return Image.asset(
        'assets/images/baik.png',
        width: 80,
        height: 80,
        cacheWidth: 240,
      );
    } else if (emoji == '😢') {
      return Image.asset(
        'assets/images/buruk.png',
        width: 80,
        height: 80,
        cacheWidth: 240,
      );
    } else {
      return Image.asset(
        'assets/images/b_aja.png',
        width: 80,
        height: 80,
        cacheWidth: 240,
        errorBuilder: (c, e, s) =>
            const Text('🌙', style: TextStyle(fontSize: 36)),
      );
    }
  }

  Future<void> _openArticle(String link) async {
    HapticFeedback.lightImpact();
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
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      body: RefreshIndicator(
        color: themeService.primaryColor,
        backgroundColor: themeService.cardColor,
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(themeService),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Bagaimana Perasaan\nKamu Hari Ini?',
                      style: AppTextStyles.titleLarge(context).copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
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
                          '/quotes',
                        ),
                        _buildMenuItem(
                          'assets/images/consul.png',
                          'Q-Consul',
                          '/consul',
                        ),
                        _buildMenuItem(
                          'assets/images/diary.png',
                          'Q-Diary',
                          '/diary',
                        ),
                        _buildMenuItem(
                          'assets/images/tips.png',
                          'Q-Tips',
                          '/tips',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildHistorySection(themeService),
                  const SizedBox(height: 12),
                  _buildMoodRow(themeService),
                  const SizedBox(height: 30),
                  _buildDailyPerasaan(themeService),
                  const SizedBox(height: 30),
                  _buildArticleSection(themeService),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildMenuItem(String path, String label, String routeName) {
    return Expanded(
      child: AnimatedMenuButton(
        assetPath: path,
        label: label,
        routeName: routeName,
      ),
    );
  }

  Widget _buildHeader(ThemeService themeService) {
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
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Scaffold.of(context).openDrawer();
                    },
                    child: CircleAvatar(
                      backgroundColor: themeService.primaryColor,
                      child: Icon(
                        Icons.person,
                        color: themeService.buttonTextColor,
                      ),
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
                    style: AppTextStyles.bodySmall(context),
                  ),
                  Text(
                    _homeProvider.userName,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
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
            cacheWidth: 144,
            errorBuilder: (c, e, s) => Icon(
              Icons.auto_awesome,
              color: themeService.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'History Mood',
            style: AppTextStyles.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/mood').then((_) => _refreshData());
            },
            child: Text(
              'Buka Kalender',
              style: AppTextStyles.bodySmall(context).copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodRow(ThemeService themeService) {
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
            final targetDate =
                now.add(Duration(days: dayIndex - currentWeekDay));

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
                          ? _getMoodColor(moodData.emoji, themeService)
                          : themeService.homeMoodEmptyBoxColor,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday
                          ? Border.all(
                              color: themeService.homeMoodTodayBorderColor,
                              width: 2,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: themeService.isDarkMode ? 0.25 : 0.05,
                          ),
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
                    style: AppTextStyles.bodySmall(context).copyWith(
                      fontSize: 10,
                      color: isToday
                          ? themeService.homeMoodTodayBorderColor
                          : themeService.textSecondaryColor,
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

  Widget _buildDailyPerasaan(ThemeService themeService) {
    final todayMood = _homeProvider.todayMood;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Perasaan Kamu Hari ini',
            style: AppTextStyles.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: todayMood != null
                  ? _getMoodColor(todayMood.emoji, themeService)
                  : themeService.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: themeService.isDarkMode ? 0.35 : 0.12,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
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
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        todayMood != null
                            ? (todayMood.emoji == '😊' ? 'Baik' : 'Buruk')
                            : 'Kosong',
                        style: AppTextStyles.titleMedium(context).copyWith(
                          fontWeight: FontWeight.bold,
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
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/checker')
                  .then((_) => _refreshData());
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeService.cardColor,
                border: Border.all(
                  color: themeService.textSecondaryColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tuliskan aktivitas atau perasaanmu hari ini...',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: themeService.textSecondaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleSection(ThemeService themeService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hari Ini Ada Apa',
            style: AppTextStyles.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
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
                      color: themeService.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: themeService.isDarkMode ? 0.35 : 0.12,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
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
                            color: themeService.secondaryColor,
                            child: Image.asset(
                              article['image']!,
                              fit: BoxFit.cover,
                              cacheHeight: 570,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey,
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
                                Colors.black.withValues(alpha: 0.65),
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
                            style: AppTextStyles.titleMedium(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                    ? themeService.primaryColor
                    : themeService.textSecondaryColor.withValues(alpha: 0.5),
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
  final String routeName;

  const AnimatedMenuButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.routeName,
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
    final themeService = Provider.of<ThemeService>(context);

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse().then((_) {
          if (mounted) {
            Navigator.pushNamed(context, widget.routeName);
          }
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
              color: themeService.homeMenuBoxColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: themeService.isDarkMode ? 0.35 : 0.12,
                  ),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
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
                    cacheWidth: 225,
                    errorBuilder: (c, e, s) => Icon(
                      Icons.extension,
                      color: themeService.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}