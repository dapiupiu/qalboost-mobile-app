import 'package:flutter/material.dart';
import '../../../../core/components/app_drawer.dart';
import '../../../../core/components/shortcut_button.dart';
import '../../../../core/components/recommendation_item.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6E9E1),
        drawer: const CustomAppDrawer(),
        drawerEdgeDragWidth: 100.0,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Q-Tips',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF1976D2),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1976D2),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.5,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: 'Sedih'),
              Tab(text: 'Marah'),
              Tab(text: 'Tenang'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFD6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Harus\nNgapain Sih\nKalau Lagi...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.2, color: Colors.black87),
                    ),
                  ),
                  Image.asset(
                    'assets/images/moon_large.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('🌙', style: TextStyle(fontSize: 36));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent(
                    context,
                    bgColor: const Color(0xFFBDF2B8),
                    statusText: 'Kamu ngerasa sedih ya...',
                    descText: 'Ceritakan apa yang membuatmu sedih, lalu coba tarik napas dalam-dalam dan tuliskan hal kecil yang membuatmu bersyukur.',
                    shortcuts: [
                      ShortcutButton(
                        title: 'Tulis di Q-Diary',
                        desc: 'Tuangkan perasaan sedihmu secara pribadi.',
                        icon: Icons.menu_book_rounded,
                        iconColor: const Color(0xFF1976D2),
                        bgColor: const Color(0xFFE3F2FD),
                        onTap: () {},
                      ),
                    ],
                    recommendations: [
                      const RecommendationItem(title: 'Angin Malam - Instrumen', subtitle: '4:20 Menit', icon: Icons.music_note),
                      const RecommendationItem(title: 'Warm Hug - Piano', subtitle: '3:15 Menit', icon: Icons.music_note),
                    ],
                  ),
                  _buildTabContent(
                    context,
                    bgColor: const Color(0xFFD6BDF2),
                    statusText: 'Lagi marah ya...',
                    descText: 'Coba hitung sampai 10, beri jarak sejenak, lalu ungkapkan perasaanmu secara tenang.',
                    shortcuts: [
                      ShortcutButton(
                        title: 'Q-Konsul Sekarang',
                        desc: 'Bicara langsung dengan Ustadz.',
                        icon: Icons.person_rounded,
                        iconColor: const Color(0xFF1976D2),
                        bgColor: const Color(0xFFE3F2FD),
                        onTap: () {},
                      ),
                    ],
                  ),
                  _buildTabContent(
                    context,
                    bgColor: const Color(0xFFBCDFF2),
                    statusText: 'Hati lagi tenang ya...',
                    descText: 'Nikmati momen tenang: dengarkan musik lembut, catat perasaan positif.',
                    extraWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('REFLEKSI HARIAN', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '"Sebutkan satu hal paling bermakna yang terjadi hari ini."',
                            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    shortcuts: [
                      ShortcutButton(
                        title: 'Cek Mood (Q-Checker)',
                        desc: 'Simpan energi positif ini.',
                        icon: Icons.analytics_rounded,
                        iconColor: const Color(0xFF1976D2),
                        bgColor: const Color(0xFFE3F2FD),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required Color bgColor,
    required String statusText,
    required String descText,
    List<Widget> shortcuts = const [],
    List<Widget> recommendations = const [],
    Widget? extraWidget,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 6),
                Text(
                  descText,
                  style: const TextStyle(fontSize: 11.5, height: 1.4, color: Colors.black87),
                ),
              ],
            ),
          ),
          if (extraWidget != null) ...[
            const SizedBox(height: 16),
            extraWidget,
          ],
          if (shortcuts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('PINTASAN FITUR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            ...shortcuts.expand((s) => [s, const SizedBox(height: 10)]).toList()..removeLast(),
          ],
          if (recommendations.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text('REKOMENDASI', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            ...recommendations,
          ],
        ],
      ),
    );
  }
}
