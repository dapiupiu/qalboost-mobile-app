import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_service.dart';
import '../../../core/components/app_drawer.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  void _showTutorial(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeService.dialogBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: themeService.textSecondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Cara Menggunakan Q-Tips',
                style: AppTextStyles.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _tutorialItem(
                Icons.tab,
                'Pilih Kategori',
                'Gunakan tab Sedih, Marah, atau Tenang sesuai dengan kondisi perasaanmu.',
                themeService,
                context,
              ),
              _tutorialItem(
                Icons.tips_and_updates_outlined,
                'Baca Tips',
                'Baca saran yang tersedia untuk membantu menenangkan hati dan pikiran.',
                themeService,
                context,
              ),
              _tutorialItem(
                Icons.touch_app_outlined,
                'Gunakan Pintasan',
                'Tekan pintasan fitur untuk menuju halaman lain yang sesuai dengan kebutuhanmu.',
                themeService,
                context,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeService.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Mengerti',
                    style: TextStyle(
                      color: themeService.buttonTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tutorialItem(
    IconData icon,
    String title,
    String desc,
    ThemeService themeService,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeService.primaryColor,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  style: AppTextStyles.bodySmall(context),
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
    required ThemeService themeService,
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required String routeName,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, routeName);
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: themeService.tipsShortcutColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: themeService.isDarkMode
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: themeService.isDarkMode ? 0.25 : 0.05,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: themeService.tipsShortcutIconBg,
              child: Icon(
                icon,
                color: themeService.isDarkMode ? Colors.white : iconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: themeService.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipPoint(
    String text,
    IconData icon,
    Color color,
    ThemeService themeService,
    BuildContext context,
  ) {
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
              style: AppTextStyles.bodySmall(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatCard({
    required ThemeService themeService,
    required BuildContext context,
    required String arab,
    required String arti,
    required String sumber,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeService.tipsAyatCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeService.isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeService.isDarkMode ? 0.25 : 0.04,
            ),
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
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              height: 1.8,
              color: themeService.isDarkMode
                  ? const Color(0xFFFFD8C2)
                  : const Color(0xFF4E342E),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              arti,
              textAlign: TextAlign.left,
              style: AppTextStyles.bodySmall(context).copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sumber,
              style: AppTextStyles.bodySmall(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryBlue = const Color(0xFF1E679F);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: themeService.backgroundColor,
        drawer: const CustomAppDrawer(),
        drawerEdgeDragWidth: 100.0,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: themeService.iconColor,
              size: 22,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.maybePop(context);
            },
          ),
          title: Text(
            'Q-Tips',
            style: AppTextStyles.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: themeService.textSecondaryColor,
                ),
                onPressed: () => _showTutorial(context),
              ),
            ),
          ],
          bottom: TabBar(
            labelColor:
                themeService.isDarkMode ? themeService.primaryColor : primaryBlue,
            unselectedLabelColor: themeService.textSecondaryColor,
            indicatorColor:
                themeService.isDarkMode ? themeService.primaryColor : primaryBlue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            onTap: (index) => HapticFeedback.selectionClick(),
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: themeService.tipsHeaderCardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: themeService.isDarkMode ? 0.25 : 0.05,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Harus\nNgapain Sih\nKalau Lagi...',
                      style: AppTextStyles.titleLarge(context).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/tips.png',
                    width: 65,
                    height: 65,
                    cacheWidth: 195,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 55,
                      color: themeService.primaryColor,
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
                    themeService: themeService,
                    color: themeService.tipsIntroSadColor,
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
                        themeService,
                        context,
                      ),
                      _buildTipPoint(
                        'Ambil air wudhu dan ceritakan segalanya kepada Allah dalam sujud.',
                        Icons.self_improvement,
                        Colors.green,
                        themeService,
                        context,
                      ),
                      _buildTipPoint(
                        'Cari udara segar atau jalan kaki santai selama 5-10 menit.',
                        Icons.directions_walk,
                        Colors.orange,
                        themeService,
                        context,
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
                    themeService: themeService,
                    color: themeService.tipsIntroAngryColor,
                    intro:
                        'Marah itu api. Yuk, kita dinginkan perlahan agar tidak melukai diri sendiri.',
                    ayatArab:
                        'وَALْكَاظِمِينَ الْغَيْظَ وَALْكَاظِمِينَ الْغَيْظَ وَالْعَافِينَ عَنِ النَّاسِ',
                    ayatArti:
                        'Dan orang-orang yang menahan amarahnya serta memaafkan kesalahan orang lain.',
                    ayatSumber: 'QS. Ali Imran: 134',
                    tips: [
                      _buildTipPoint(
                        'Diam sejenak. Jangan mengambil keputusan atau bicara saat emosi meluap.',
                        Icons.timer,
                        Colors.redAccent,
                        themeService,
                        context,
                      ),
                      _buildTipPoint(
                        'Ubah posisi; jika marah saat berdiri maka duduklah, jika duduk maka berbaringlah.',
                        Icons.airline_seat_legroom_extra,
                        Colors.brown,
                        themeService,
                        context,
                      ),
                      _buildTipPoint(
                        'Tarik napas dalam (4 detik), tahan (4 detik), dan buang perlahan (4 detik).',
                        Icons.air,
                        Colors.blueGrey,
                        themeService,
                        context,
                      ),
                    ],
                    shortcutTitle: 'Konsultasi (Q-Konsul)',
                    shortcutDesc: 'Butuh teman bicara untuk menenangkan pikiran?',
                    shortcutIcon: Icons.person_rounded,
                    routeName: '/consul',
                  ),
                  _buildTabContent(
                    context,
                    themeService: themeService,
                    color: themeService.tipsIntroCalmColor,
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
                        themeService,
                        context,
                      ),
                      _buildTipPoint(
                        'Baca kembali catatan diary lamamu untuk melihat sejauh mana kamu berkembang.',
                        Icons.history_edu,
                        Colors.purple,
                        themeService,
                        context,
                      ),
                      _buildTipPoint(
                        'Bagikan energi positifmu dengan memberikan bantuan atau senyuman pada orang lain.',
                        Icons.volunteer_activism,
                        Colors.pink,
                        themeService,
                        context,
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
    required ThemeService themeService,
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              intro,
              style: AppTextStyles.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: themeService.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAyatCard(
            context: context,
            themeService: themeService,
            arab: ayatArab,
            arti: ayatArti,
            sumber: ayatSumber,
          ),
          const SizedBox(height: 20),
          Text(
            'TIPS UNTUKMU',
            style: AppTextStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          ...tips,
          const SizedBox(height: 20),
          Text(
            'PINTASAN FITUR',
            style: AppTextStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          _buildShortcutButton(
            context: context,
            themeService: themeService,
            title: shortcutTitle,
            desc: shortcutDesc,
            icon: shortcutIcon,
            iconColor: const Color(0xFF1E679F),
            routeName: routeName,
          ),
        ],
      ),
    );
  }
}