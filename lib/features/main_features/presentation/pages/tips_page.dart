import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/components/app_drawer.dart';
import '../../../../core/components/shortcut_button.dart';
import '../../../../core/components/recommendation_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  void _triggerHaptic() {
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const CustomAppDrawer(),
        drawerEdgeDragWidth: 100.0,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text('Q-Tips'),
          bottom: TabBar(
            labelColor: colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Sedih'),
              Tab(text: 'Marah'),
              Tab(text: 'Tenang'),
            ],
            onTap: (_) => _triggerHaptic(),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(
              context,
              color: isDarkMode ? colorScheme.primaryContainer.withOpacity(0.3) : const Color(0xFFBDF2B8).withOpacity(0.4),
              statusText: 'Kamu ngerasa sedih ya...',
              descText:
                  'Ceritakan apa yang membuatmu sedih, lalu coba tarik napas dalam-dalam dan tuliskan hal kecil yang membuatmu bersyukur.',
              shortcuts: [
                ShortcutButton(
                  title: 'Tulis di Q-Diary',
                  desc: 'Tuangkan perasaan sedihmu secara pribadi.',
                  icon: Icons.menu_book_rounded,
                  iconColor: colorScheme.primary,
                  bgColor: colorScheme.primaryContainer.withOpacity(0.5),
                  onTap: () {},
                ),
              ],
              recommendations: [
                const RecommendationItem(
                  title: 'Angin Malam - Instrumen',
                  subtitle: '4:20 Menit',
                  icon: Icons.music_note,
                ),
                const RecommendationItem(
                  title: 'Warm Hug - Piano',
                  subtitle: '3:15 Menit',
                  icon: Icons.music_note,
                ),
              ],
            ),
            _buildTabContent(
              context,
              color: isDarkMode ? colorScheme.secondaryContainer.withOpacity(0.3) : const Color(0xFFD6BDF2).withOpacity(0.4),
              statusText: 'Lagi marah ya...',
              descText:
                  'Coba hitung sampai 10, beri jarak sejenak, lalu ungkapkan perasaanmu secara tenang.',
              shortcuts: [
                ShortcutButton(
                  title: 'Q-Konsul Sekarang',
                  desc: 'Bicara langsung dengan Ustadz.',
                  icon: Icons.person_rounded,
                  iconColor: colorScheme.primary,
                  bgColor: colorScheme.primaryContainer.withOpacity(0.5),
                  onTap: () {},
                ),
              ],
            ),
            _buildTabContent(
              context,
              color: isDarkMode ? colorScheme.tertiaryContainer.withOpacity(0.3) : const Color(0xFFBCDFF2).withOpacity(0.4),
              statusText: 'Hati lagi tenang ya...',
              descText:
                  'Nikmati momen tenang: dengarkan musik lembut, catat perasaan positif.',
              extraWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REFLEKSI HARIAN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground.withOpacity(0.5),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '"Sebutkan satu hal paling bermakna yang terjadi hari ini."',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              shortcuts: [
                ShortcutButton(
                  title: 'Cek Mood (Q-Checker)',
                  desc: 'Simpan energi positif ini.',
                  icon: Icons.analytics_rounded,
                  iconColor: colorScheme.primary,
                  bgColor: colorScheme.primaryContainer.withOpacity(0.5),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required Color color,
    required String statusText,
    required String descText,
    List<Widget> shortcuts = const [],
    List<Widget> recommendations = const [],
    Widget? extraWidget,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    descText,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (extraWidget != null) ...[
              const SizedBox(height: 24),
              extraWidget,
            ],
            if (shortcuts.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                'PINTASAN FITUR',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground.withOpacity(0.5),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              ...shortcuts
                  .expand((s) => [s, const SizedBox(height: 12)])
                  .toList()
                ..removeLast(),
            ],
            if (recommendations.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                'REKOMENDASI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground.withOpacity(0.5),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              ...recommendations,
            ],
          ],
        ),
      ),
    );
  }
}
