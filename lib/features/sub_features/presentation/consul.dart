import 'package:flutter/material.dart';
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
          style: TextStyle(
            color: themeService.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Akses eksklusif konsultasi dengan:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeService.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: themeService.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Biaya Langganan:\n\$100.000.000 USD\n(Sekitar Rp 1,5 Triliun)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Saldo Anda tidak cukup.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: themeService.textSecondaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Q-Konsul',
          style: TextStyle(
            color: themeService.textPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                style: TextStyle(
                  color: themeService.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _filteredAdvisors.isNotEmpty
                    ? GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: _filteredAdvisors.length,
                        itemBuilder: (context, index) => _buildAdvisorCard(
                          _filteredAdvisors[index],
                          themeService,
                        ),
                      )
                    : Center(
                        child: Text(
                          'Ustadz tidak ditemukan...',
                          style: TextStyle(
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
            style: TextStyle(
              fontSize: 18,
              color: themeService.textPrimaryColor,
            ),
          ),
        ),
        SizedBox(
          width: 96,
          height: 96,
          child: Image.asset(
            'assets/images/consul.png',
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Center(
              child: Text(
                '🌙',
                style: TextStyle(
                  fontSize: 42,
                  color: themeService.textPrimaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox(ThemeService themeService) {
    return Container(
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
        style: TextStyle(
          color: themeService.textPrimaryColor,
        ),
        decoration: InputDecoration(
          hintText: 'Cari Ustadz di sini',
          hintStyle: TextStyle(
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
    return Container(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeService.textPrimaryColor,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      a['title']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: themeService.textSecondaryColor,
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
                style: TextStyle(
                  fontSize: 11,
                  color: themeService.textSecondaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                a['status']!,
                style: TextStyle(
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
                style: TextStyle(
                  fontSize: 12,
                  color: themeService.textPrimaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: themeService.consulButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => _showPremiumDialog(a['name']!),
                child: Text(
                  'Mulai Konsultasi',
                  style: TextStyle(
                    color: themeService.textPrimaryColor,
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeService.textPrimaryColor,
            ),
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
              onPressed: () => Navigator.pop(context),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeService.textPrimaryColor,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeService.textSecondaryColor,
                  ),
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
          style: TextStyle(
            fontSize: 12,
            color: themeService.textPrimaryColor,
          ),
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
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOut,
        ),
        backgroundColor: themeService.primaryColor,
        child: Icon(
          Icons.arrow_upward,
          color: themeService.buttonTextColor,
        ),
      ),
    );
  }
}