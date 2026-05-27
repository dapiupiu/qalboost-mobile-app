import 'package:flutter/material.dart';
import '../../../core/components/app_drawer.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  void _showTutorial(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF6E9E1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Cara Menggunakan Q-Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _tutorialItem(
                Icons.tab,
                'Pilih Kategori',
                'Gunakan tab Sedih, Marah, atau Tenang sesuai dengan kondisi perasaanmu.',
              ),
              _tutorialItem(
                Icons.tips_and_updates_outlined,
                'Baca Tips',
                'Baca saran yang tersedia untuk membantu menenangkan hati dan pikiran.',
              ),
              _tutorialItem(
                Icons.touch_app_outlined,
                'Gunakan Pintasan',
                'Tekan pintasan fitur untuk menuju halaman lain yang sesuai dengan kebutuhanmu.',
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tutorialItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1976D2)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutButton({
    required BuildContext context,
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String routeName,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
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
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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

  Widget _buildTipPoint(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatCard({
    required String arab,
    required String arti,
    required String sumber,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            arab,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              height: 1.8,
              color: Color(0xFF4E342E),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              arti,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = const Color(0xFF1E679F);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
        drawer: const CustomAppDrawer(),
        drawerEdgeDragWidth: 100.0,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                onPressed: () => _showTutorial(context),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black87,
              size: 22,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(
            'Q-Tips',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryBlue,
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
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFD6),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Harus\nNgapain Sih\nKalau Lagi...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF4E342E),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/tips.png',
                    width: 65,
                    height: 65,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/tips.png',
                      width: 65,
                      height: 65,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent(
                    context,
                    color: const Color(0xFFBDF2B8),
                    intro:
                        'Wajar kok kalau sesekali merasa sedih. Jangan dipendam sendiri ya...',
                    ayatArab: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
                    ayatArti:
                        'Maka sesungguhnya bersama kesulitan ada kemudahan.',
                    ayatSumber: 'QS. Al-Insyirah: 5',
                    tips: [
                      _buildTipPoint(
                        'Menangis secukupnya untuk melepaskan beban emosi yang menyesak.',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                      _buildTipPoint(
                        'Ambil air wudhu dan ceritakan segalanya kepada Allah dalam sujud.',
                        Icons.self_improvement,
                        Colors.green,
                      ),
                      _buildTipPoint(
                        'Cari udara segar atau jalan kaki santai selama 5-10 menit.',
                        Icons.directions_walk,
                        Colors.orange,
                      ),
                    ],
                    shortcutTitle: 'Tulis di (Q-Diary)',
                    shortcutDesc:
                        'Tuangkan perasaanmu lewat tulisan agar hati lebih lega.',
                    shortcutIcon: Icons.menu_book_rounded,
                    routeName: '/diary',
                  ),

                  _buildTabContent(
                    context,
                    color: const Color(0xFFF2BDC3),
                    intro:
                        'Marah itu api. Yuk, kita dinginkan perlahan agar tidak melukai diri sendiri.',
                    ayatArab:
                        'وَالْكَاظِمِينَ الْغَيْظَ وَالْعَافِينَ عَنِ النَّاسِ',
                    ayatArti:
                        'Dan orang-orang yang menahan amarahnya serta memaafkan kesalahan orang lain.',
                    ayatSumber: 'QS. Ali Imran: 134',
                    tips: [
                      _buildTipPoint(
                        'Diam sejenak. Jangan mengambil keputusan atau bicara saat emosi meluap.',
                        Icons.timer,
                        Colors.red,
                      ),
                      _buildTipPoint(
                        'Ubah posisi; jika marah saat berdiri maka duduklah, jika duduk maka berbaringlah.',
                        Icons.airline_seat_legroom_extra,
                        Colors.brown,
                      ),
                      _buildTipPoint(
                        'Tarik napas dalam (4 detik), tahan (4 detik), dan buang perlahan (4 detik).',
                        Icons.air,
                        Colors.blueGrey,
                      ),
                    ],
                    shortcutTitle: 'Konsultasi (Q-Konsul)',
                    shortcutDesc: 'Butuh teman bicara untuk menenangkan pikiran?',
                    shortcutIcon: Icons.person_rounded,
                    routeName: '/consul',
                  ),

                  _buildTabContent(
                    context,
                    color: const Color(0xFFBCDFF2),
                    intro:
                        'Alhamdulillah, hati sedang tenang. Yuk, jaga momentum positif ini!',
                    ayatArab:
                        'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                    ayatArti:
                        'Ingatlah, hanya dengan mengingat Allah hati menjadi tenteram.',
                    ayatSumber: 'QS. Ar-Ra’d: 28',
                    tips: [
                      _buildTipPoint(
                        'Lakukan dzikir pagi atau petang untuk mengunci ketenangan hati.',
                        Icons.vibration,
                        Colors.blue,
                      ),
                      _buildTipPoint(
                        'Baca kembali catatan diary lamamu untuk melihat sejauh mana kamu berkembang.',
                        Icons.history_edu,
                        Colors.purple,
                      ),
                      _buildTipPoint(
                        'Bagikan energi positifmu dengan memberikan bantuan atau senyuman pada orang lain.',
                        Icons.volunteer_activism,
                        Colors.pink,
                      ),
                    ],
                    shortcutTitle: 'Cek Mood (Q-Checker)',
                    shortcutDesc: 'Pantau grafik kebahagiaanmu hari ini.',
                    shortcutIcon: Icons.analytics_rounded,
                    routeName: '/checker',
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
    required Color color,
    required String intro,
    required String ayatArab,
    required String ayatArti,
    required String ayatSumber,
    required List<Widget> tips,
    required String shortcutTitle,
    required String shortcutDesc,
    required IconData shortcutIcon,
    required String routeName,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              intro,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAyatCard(
            arab: ayatArab,
            arti: ayatArti,
            sumber: ayatSumber,
          ),
          const SizedBox(height: 20),
          const Text(
            'TIPS UNTUKMU',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          ...tips,
          const SizedBox(height: 20),
          const Text(
            'PINTASAN FITUR',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          _buildShortcutButton(
            context: context,
            title: shortcutTitle,
            desc: shortcutDesc,
            icon: shortcutIcon,
            iconColor: const Color(0xFF1E679F),
            bgColor: const Color(0xFFE3F2FD),
            routeName: routeName,
          ),
        ],
      ),
    );
  }
}