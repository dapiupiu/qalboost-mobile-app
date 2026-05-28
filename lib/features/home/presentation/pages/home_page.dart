import 'package:flutter/material.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../core/components/app_drawer.dart';
import '../../../../core/components/menu_button.dart';
import '../../../sub_features/presentation/pages/diary_page.dart';
import '../../../sub_features/presentation/pages/quotes_page.dart';
import '../../../sub_features/presentation/pages/consul_page.dart';
import '../../../main_features/presentation/pages/tips_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selamat Datang', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.6))),
                          Text('Pengguna QalBoost', style: textTheme.titleLarge),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.asset('assets/images/app_logo.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => Icon(Icons.auto_awesome, color: colorScheme.primary)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bagaimana Perasaan\nKamu Hari Ini?',
                style: textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  menuButton(context, assetPath: 'assets/images/menu_quotes.png', label: 'Q-Quotes', page: const QuotesSimpleScreen()),
                  menuButton(context, assetPath: 'assets/images/menu_consul.png', label: 'Q-Qonsul', page: const ConsulPage()),
                  menuButton(context, assetPath: 'assets/images/menu_diary.png', label: 'Q-Diary', page: const DiaryPage()),
                  menuButton(context, assetPath: 'assets/images/menu_tips.png', label: 'Q-Tips', page: const TipsPage()),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('History Mood', style: textTheme.titleLarge?.copyWith(fontSize: 16)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/mood'),
                    child: Text('Buka Kalender', style: textTheme.labelSmall?.copyWith(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildMoodRow(colorScheme),
            const SizedBox(height: 30),
            _buildDailyPerasaan(colorScheme, textTheme),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, colorScheme),
    );
  }

  Widget _buildMoodRow(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'].map((day) {
            final isFirst = day == 'Senin';
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: isFirst ? AppColors.cardLight : colorScheme.surfaceVariant, 
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
    );
  }

  Widget _buildDailyPerasaan(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Perasaan Kamu Hari ini', style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardLight, 
              borderRadius: BorderRadius.circular(12), 
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Row(
              children: [
                Image.asset('assets/images/moon_small.png', width: 80, height: 80, errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 36))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('"catatan kecil dari isi q-checker"', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 12),
                  Text('Kecewa', style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
                ])),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/checker'),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Tuliskan aktivitas atau perasaanmu hari ini...', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      height: 72,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          height: 72, color: colorScheme.primary,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(icon: const Icon(Icons.home, color: Colors.white), onPressed: () {}),
            const SizedBox(width: 56),
            IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/settings')),
          ]),
        ),
        Positioned(
          top: -22, left: 0, right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/checker'),
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.surface),
                child: Padding(padding: const EdgeInsets.all(6), child: Image.asset('assets/icons/moon_nav.png', errorBuilder: (c, e, s) => const Center(child: Text('🌙', style: TextStyle(fontSize: 28))))),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
