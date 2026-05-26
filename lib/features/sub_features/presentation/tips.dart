import 'package:flutter/material.dart';
import '../../../core/components/app_drawer.dart';


class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  // --- 1. WIDGET PINTASAN FITUR (Ukuran Mobile-Friendly) ---
  Widget _buildShortcutButton({
    required BuildContext context,
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // Padding disesuaikan untuk HP
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18, // Ukuran lingkaran ikon lebih proporsional di HP
              backgroundColor: bgColor,
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- 2. WIDGET ITEM REKOMENDASI LIST (Ukuran Ringkas) ---
  Widget _buildRecommendationItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFFFB74D)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

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
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18), // Font AppBar standar HP
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF1976D2),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1976D2),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.5,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), // Ukuran teks Tab disesuaikan
            tabs: [
              Tab(text: 'Sedih'),
              Tab(text: 'Marah'),
              Tab(text: 'Tenang'),
            ],
          ),
        ),
        body: Column(
          children: [
            // HEADER CARD (Responsif & Lebih Compact untuk HP)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFD6),
                borderRadius: BorderRadius.circular(20), // Sudut tidak terlalu melengkung berlebih di layar kecil
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
                    width: 50, // Ukuran gambar dikecilkan agar seimbang di HP
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('🌙', style: TextStyle(fontSize: 36));
                    },
                  ),
                ],
              ),
            ),

            // TABBARVIEW ISI KONTEN
            Expanded(
              child: TabBarView(
                children: [
                  
                  // === 1. KONTEN TAB SEDIH ===
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBDF2B8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Kamu ngerasa sedih ya...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              SizedBox(height: 6),
                              Text(
                                'Ceritakan apa yang membuatmu sedih, lalu coba tarik napas dalam-dalam dan tuliskan hal kecil yang membuatmu bersyukur.',
                                style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('PINTASAN FITUR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        _buildShortcutButton(
                          context: context,
                          title: 'Tulis di Q-Diary',
                          desc: 'Tuangkan perasaan sedihmu secara pribadi.',
                          icon: Icons.menu_book_rounded,
                          iconColor: const Color(0xFF1976D2),
                          bgColor: const Color(0xFFE3F2FD),
                          onTap: () {},
                        ),
                        const SizedBox(height: 18),
                        const Text('REKOMENDASI', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                        const SizedBox(height: 10),
                        _buildRecommendationItem('Angin Malam - Instrumen', '4:20 Menit', Icons.music_note),
                        _buildRecommendationItem('Warm Hug - Piano', '3:15 Menit', Icons.music_note),
                      ],
                    ),
                  ),

                  // === 2. KONTEN TAB MARAH ===
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6BDF2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Lagi marah ya...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              SizedBox(height: 6),
                              Text(
                                'Coba hitung sampai 10, beri jarak sejenak, lalu ungkapkan perasaanmu secara tenang.',
                                style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('PINTASAN FITUR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        _buildShortcutButton(
                          context: context,
                          title: 'Q-Konsul Sekarang',
                          desc: 'Bicara langsung dengan Ustadz.',
                          icon: Icons.person_rounded,
                          iconColor: const Color(0xFF1976D2),
                          bgColor: const Color(0xFFE3F2FD),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // === 3. KONTEN TAB TENANG ===
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBCDFF2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Hati lagi tenang ya...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              SizedBox(height: 6),
                              Text(
                                'Nikmati momen tenang: dengarkan musik lembut, catat perasaan positif.',
                                style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 18),
                        const Text('PINTASAN FITUR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        _buildShortcutButton(
                          context: context,
                          title: 'Cek Mood (Q-Checker)',
                          desc: 'Simpan energi positif ini.',
                          icon: Icons.analytics_rounded,
                          iconColor: const Color(0xFF1976D2),
                          bgColor: const Color(0xFFE3F2FD),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}