import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_service.dart';
import '../../../core/components/app_drawer.dart';

class ConsulPage extends StatefulWidget {
  const ConsulPage({super.key});

  @override
  State<ConsulPage> createState() => _ConsulPageState();
}

class _ConsulPageState extends State<ConsulPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _showBackToTop = false;

  final List<Map<String, String>> _allAdvisors = [
    {
      'name': 'Ustadz Abdul Somad',
      'title': 'Fiqih & Dakwah',
      'status': 'Online',
      'percent': '99%',
    },
    {
      'name': 'Ustadz Adi Hidayat',
      'title': 'Al-Quran & Hadits',
      'status': 'Online',
      'percent': '100%',
    },
    {
      'name': 'Ustadz Hanan Attaki',
      'title': 'Pemuda & Hijrah',
      'status': 'Online',
      'percent': '98%',
    },
    {
      'name': 'Ustadz Buya Yahya',
      'title': 'Akhlak & Tasawuf',
      'status': 'Online',
      'percent': '97%',
    },
    {
      'name': 'Ustadz Das\'ad Latif',
      'title': 'Sosial & Budaya',
      'status': 'Online',
      'percent': '96%',
    },
    {
      'name': 'Ustadz Khalid Basalamah',
      'title': 'Sirah Nabawiyah',
      'status': 'Online',
      'percent': '95%',
    },
    {
      'name': 'Ustadzah Oki Setiana',
      'title': 'Keluarga & Wanita',
      'status': 'Online',
      'percent': '99%',
    },
    {
      'name': 'Ustadz Salim A. Fillah',
      'title': 'Sejarah & Jodoh',
      'status': 'Online',
      'percent': '94%',
    },
    {
      'name': 'Ustadz Maulana',
      'title': 'Umum & Ceria',
      'status': 'Online',
      'percent': '92%',
    },
    {
      'name': 'Ustadz Wijayanto',
      'title': 'Keluarga Sakinah',
      'status': 'Online',
      'percent': '93%',
    },
  ];

  List<Map<String, String>> _filteredAdvisors = [];

  @override
  void initState() {
    super.initState();
    _filteredAdvisors = _allAdvisors;
    _scrollController.addListener(_onScroll);
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];

    if (enteredKeyword.isEmpty) {
      results = _allAdvisors;
    } else {
      results = _allAdvisors
          .where(
            (user) =>
                user["name"]!
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                user["title"]!
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _filteredAdvisors = results;
    });
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 200;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showPremiumDialog(String name) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeService.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '💎 Fitur Sultan Premium',
          textAlign: TextAlign.center,
          style: AppTextStyles.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Akses eksklusif konsultasi dengan:',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: themeService.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Biaya Langganan:\n\$100.000.000 USD\n(Sekitar Rp 1,5 Triliun)',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Saldo Anda tidak cukup.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall(context).copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text(
              'Selesaikan Cicilan 100 Tahun',
              style: TextStyle(
                color: themeService.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildTutorialSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.15,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
          'Q-Konsul',
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(themeService),
              const SizedBox(height: 12),
              _buildSearchBox(themeService),
              const SizedBox(height: 16),
              Text(
                'Pilih Ustadz untuk Konsultasi',
                style: AppTextStyles.bodyMedium(context),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _filteredAdvisors.isNotEmpty
                    ? AnimationLimiter(
                        child: GridView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: _filteredAdvisors.length,
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildAdvisorCard(
                                  _filteredAdvisors[index],
                                  themeService,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Ustadz tidak ditemukan...',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: themeService.textSecondaryColor,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              _buildPrivacyBanner(themeService),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFab(themeService),
    );
  }

  Widget _buildHeader(ThemeService themeService) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Kamu bisa ngobrol dan bertanya dengan ustadz di sini',
            style: AppTextStyles.titleMedium(context),
          ),
        ),
        SizedBox(
          width: 96,
          height: 96,
          child: Image.asset(
            'assets/images/consul.png',
            fit: BoxFit.contain,
            cacheWidth: 288,
            errorBuilder: (c, e, s) => Center(
              child: Text(
                '🌙',
                style: AppTextStyles.titleLarge(context).copyWith(fontSize: 42),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox(ThemeService themeService) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: themeService.consulSearchColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: themeService.consulShadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _runFilter(value),
        style: AppTextStyles.bodyMedium(context),
        decoration: InputDecoration(
          hintText: 'Cari Ustadz di sini',
          hintStyle: AppTextStyles.bodyMedium(context).copyWith(
            color: themeService.hintTextColor,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: themeService.textSecondaryColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAdvisorCard(
    Map<String, String> a,
    ThemeService themeService,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: themeService.consulCardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: themeService.consulShadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: themeService.consulAvatarColor,
                child: Icon(
                  Icons.person,
                  color: themeService.textSecondaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['name']!,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      a['title']!,
                      style: AppTextStyles.bodySmall(context).copyWith(
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Status:',
                style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11),
              ),
              const SizedBox(width: 4),
              Text(
                a['status']!,
                style: AppTextStyles.bodySmall(context).copyWith(
                  fontSize: 11,
                  color: themeService.textPrimaryColor,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.circle,
                color: Colors.green,
                size: 8,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.thumb_up,
                size: 12,
                color: themeService.textSecondaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                a['percent']!,
                style: AppTextStyles.bodySmall(context).copyWith(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: themeService.consulButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => _showPremiumDialog(a['name']!),
                child: Text(
                  'Mulai Konsultasi',
                  style: AppTextStyles.bodySmall(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialSheet() {
    final themeService = Provider.of<ThemeService>(context, listen: false);

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
            'Cara Menggunakan Q-Qonsul',
            style: AppTextStyles.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _tutorialItem(
            Icons.search,
            'Cari Ustadz',
            'Gunakan kolom pencarian untuk mencari ustadz berdasarkan nama atau bidang konsultasi.',
            themeService,
          ),
          _tutorialItem(
            Icons.person_outline,
            'Pilih Ustadz',
            'Pilih ustadz yang tersedia untuk mulai berkonsultasi.',
            themeService,
          ),
          _tutorialItem(
            Icons.chat_bubble_outline,
            'Mulai Konsultasi',
            'Tekan tombol konsultasi untuk memulai percakapan.',
            themeService,
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
  }

  Widget _tutorialItem(
    IconData icon,
    String title,
    String desc,
    ThemeService themeService,
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
                  style: AppTextStyles.bodySmall(context).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyBanner(ThemeService themeService) {
    return Center(
      child: Chip(
        avatar: const Icon(
          Icons.lock,
          size: 16,
          color: Colors.green,
        ),
        label: Text(
          'Privasi Kamu Aman',
          style: AppTextStyles.bodySmall(context).copyWith(fontSize: 12),
        ),
        backgroundColor: themeService.cardColor,
      ),
    );
  }

  Widget _buildFab(ThemeService themeService) {
    return AnimatedOpacity(
      opacity: _showBackToTop ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 260),
      child: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOut,
          );
        },
        backgroundColor: themeService.primaryColor,
        child: Icon(
          Icons.arrow_upward,
          color: themeService.buttonTextColor,
        ),
      ),
    );
  }
}
