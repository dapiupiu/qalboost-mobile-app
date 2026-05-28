import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qalboost/core/theme/theme_service.dart';
import 'package:qalboost/core/components/app_drawer.dart';
import 'package:qalboost/features/main_features/data/mood_storage.dart';
import '../../../sub_features/presentation/pages/diary_page.dart';
import '../../../sub_features/presentation/pages/quotes_page.dart';
import '../../../sub_features/presentation/pages/consul_page.dart';
import '../../../main_features/presentation/pages/tips_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  void _triggerHaptic() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                _triggerHaptic();
                                Scaffold.of(context).openDrawer();
                              },
                              child: Hero(
                                tag: 'avatar_hero',
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: colorScheme.primaryContainer,
                                  child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_getGreeting(), style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.6))),
                              Text('Pengguna QalBoost', style: textTheme.titleLarge),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 54,
                        height: 54,
                        child: Hero(
                          tag: 'logo_hero',
                          child: Image.asset('assets/images/app_logo.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => Icon(Icons.auto_awesome, color: colorScheme.primary, size: 32)),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- TITLE ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Bagaimana Perasaan\nKamu Hari Ini?',
                    style: textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 24),

                // --- MENU BUTTONS ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAnimatedMenuButton(context, assetPath: 'assets/images/menu_quotes.png', label: 'Q-Quotes', page: const QuotesSimpleScreen()),
                        _buildAnimatedMenuButton(context, assetPath: 'assets/images/menu_consul.png', label: 'Q-Qonsul', page: const ConsulPage()),
                        _buildAnimatedMenuButton(context, assetPath: 'assets/images/menu_diary.png', label: 'Q-Diary', page: const DiaryPage()),
                        _buildAnimatedMenuButton(context, assetPath: 'assets/images/menu_tips.png', label: 'Q-Tips', page: const TipsPage()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- HISTORY MOOD ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('History Mood', style: textTheme.titleLarge?.copyWith(fontSize: 18)),
                      TextButton(
                        onPressed: () {
                          _triggerHaptic();
                          Navigator.pushNamed(context, '/mood').then((_) => setState(() {}));
                        },
                        child: Text('Buka Kalender', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildMoodRow(colorScheme),

                const SizedBox(height: 32),
                _buildDailyPerasaan(colorScheme, textTheme, isDarkMode),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, colorScheme),
    );
  }

  Widget _buildAnimatedMenuButton(BuildContext context, {required String assetPath, required String label, required Widget page}) {
    IconData getFallbackIcon(String label) {
      switch (label) {
        case 'Q-Quotes': return Icons.format_quote_rounded;
        case 'Q-Qonsul': return Icons.chat_bubble_rounded;
        case 'Q-Diary': return Icons.menu_book_rounded;
        case 'Q-Tips': return Icons.lightbulb_rounded;
        default: return Icons.extension_rounded;
      }
    }

    return GestureDetector(
      onTap: () {
        _triggerHaptic();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                assetPath, 
                width: 36, 
                height: 36, 
                errorBuilder: (c, e, s) => Icon(
                  getFallbackIcon(label), 
                  color: AppColors.primary, 
                  size: 32
                )
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildMoodRow(ColorScheme colorScheme) {
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return date;
    });

    bool hasAnyData = false;
    final moodWidgets = last7Days.map((date) {
      final data = MoodStorage.getMood(DateTime(date.year, date.month, date.day));
      if (data != null) hasAnyData = true;
      
      final dayName = _getDayName(date.weekday);
      final isToday = date.day == now.day && date.month == now.month && date.year == now.year;

      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: data != null 
                    ? colorScheme.primaryContainer 
                    : (isToday ? colorScheme.primary.withOpacity(0.1) : colorScheme.surfaceVariant.withOpacity(0.3)), 
                borderRadius: BorderRadius.circular(12),
                border: isToday ? Border.all(color: colorScheme.primary, width: 2) : null,
              ),
              child: Center(child: Text(data?['emoji'] ?? '', style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(height: 8),
            Text(dayName, style: TextStyle(fontSize: 10, fontWeight: isToday ? FontWeight.bold : FontWeight.w500, color: isToday ? colorScheme.primary : colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: hasAnyData 
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(children: moodWidgets),
          )
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.calendar_today_rounded, color: colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Belum ada data mood', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                      Text('Yuk, isi mood kamu hari ini di Q-Checker!', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }

  Widget _buildDailyPerasaan(ColorScheme colorScheme, TextTheme textTheme, bool isDarkMode) {
    final now = DateTime.now();
    final data = MoodStorage.getMood(DateTime(now.year, now.month, now.day));
    
    final gradientColors = isDarkMode 
        ? [colorScheme.primaryContainer.withOpacity(0.4), colorScheme.primaryContainer.withOpacity(0.2)]
        : [const Color(0xFFFFEFD6), const Color(0xFFFFF7C2)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Perasaan Kamu Hari ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: isDarkMode ? Colors.black26 : Colors.orange.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'mood_moon',
                  child: Image.asset('assets/images/moon_small.png', width: 80, height: 80, errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 48))),
                ),
                const SizedBox(width: 20),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    data != null ? '"catatan kecil dari isi q-checker"' : '"tunggu apa lagi? yuk isi"', 
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? colorScheme.onPrimaryContainer.withOpacity(0.7) : Colors.brown.shade700, 
                      fontStyle: FontStyle.italic
                    )
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data != null ? data['catatan'] : 'Belum mengisi mood', 
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 18, 
                      color: isDarkMode ? colorScheme.onPrimaryContainer : Colors.brown.shade900,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ])),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {
              _triggerHaptic();
              Navigator.pushNamed(context, '/checker').then((_) => setState(() {}));
            },
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)), 
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_note, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tuliskan aktivitas atau perasaanmu hari ini...', 
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.1), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 10, 
            offset: const Offset(0, -4)
          )
        ],
      ),
      child: Stack(clipBehavior: Clip.none, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(icon: Icon(Icons.home_rounded, color: colorScheme.primary, size: 28), onPressed: () => _triggerHaptic()),
          const SizedBox(width: 64),
          IconButton(icon: Icon(Icons.settings_rounded, color: Colors.grey.shade400, size: 28), onPressed: () {
            _triggerHaptic();
            Navigator.pushNamed(context, '/settings');
          }),
        ]),
        Positioned(
          top: -30, left: 0, right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _triggerHaptic();
                Navigator.pushNamed(context, '/checker');
              },
              child: Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  color: colorScheme.primary,
                  boxShadow: [
                    BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Padding(padding: const EdgeInsets.all(12), child: Image.asset('assets/icons/moon_nav.png', errorBuilder: (c, e, s) => const Center(child: Text('🌙', style: TextStyle(fontSize: 28))))),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
