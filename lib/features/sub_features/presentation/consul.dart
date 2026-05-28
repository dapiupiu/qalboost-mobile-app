import 'package:flutter/material.dart';
import '../../../core/components/app_drawer.dart';

class ConsulPage extends StatefulWidget {
  const ConsulPage({Key? key}) : super(key: key);

  @override
  State<ConsulPage> createState() => _ConsulPageState();
}

class _ConsulPageState extends State<ConsulPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController(); 
  bool _showBackToTop = false;

  final List<Map<String, String>> _allAdvisors = [
    {'name': 'Ustadz Abdul Somad', 'title': 'Fiqih & Dakwah', 'status': 'Online', 'percent': '99%'},
    {'name': 'Ustadz Adi Hidayat', 'title': 'Al-Quran & Hadits', 'status': 'Online', 'percent': '100%'},
    {'name': 'Ustadz Hanan Attaki', 'title': 'Pemuda & Hijrah', 'status': 'Online', 'percent': '98%'},
    {'name': 'Ustadz Buya Yahya', 'title': 'Akhlak & Tasawuf', 'status': 'Online', 'percent': '97%'},
    {'name': 'Ustadz Das\'ad Latif', 'title': 'Sosial & Budaya', 'status': 'Online', 'percent': '96%'},
    {'name': 'Ustadz Khalid Basalamah', 'title': 'Sirah Nabawiyah', 'status': 'Online', 'percent': '95%'},
    {'name': 'Ustadzah Oki Setiana', 'title': 'Keluarga & Wanita', 'status': 'Online', 'percent': '99%'},
    {'name': 'Ustadz Salim A. Fillah', 'title': 'Sejarah & Jodoh', 'status': 'Online', 'percent': '94%'},
    {'name': 'Ustadz Maulana', 'title': 'Umum & Ceria', 'status': 'Online', 'percent': '92%'},
    {'name': 'Ustadz Wijayanto', 'title': 'Keluarga Sakinah', 'status': 'Online', 'percent': '93%'},
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
          .where((user) =>
              user["name"]!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user["title"]!.toLowerCase().contains(enteredKeyword.toLowerCase()))
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('💎 Fitur Sultan Premium', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Akses eksklusif konsultasi dengan:', textAlign: TextAlign.center),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
            const SizedBox(height: 15),
            const Text(
              'Biaya Langganan:\n\$100.000.000 USD\n(Sekitar Rp 1,5 Triliun)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Saldo Anda tidak cukup.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Selesaikan Cicilan 100 Tahun')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      // Ubah dari 30 menjadi dinamis (berdasarkan persentase lebar layar HP kamu)
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.15,
      appBar: AppBar(
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
          'Q-Konsul',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.info_outline, color: isDarkMode ? Colors.white70 : Colors.black54),
              onPressed: () {
                // Panggil fungsi tutorial konsul kamu di sini jika ada
              },
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text('Kamu bisa ngobrol dan bertanya dengan ustadz di sini', style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black87))),
                  SizedBox(width: 96, height: 96, child: Image.asset('assets/images/consul.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const Center(child: Text('🌙', style: TextStyle(fontSize: 42))))),
                ],
              ),
              const SizedBox(height: 12),
              
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))]),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _runFilter(value),
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Cari Ustadz di sini',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text('Pilih Ustadz untuk Konsultasi', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
              const SizedBox(height: 12),

              Expanded(
                child: _filteredAdvisors.isNotEmpty
                    ? GridView.builder(
                        controller: _scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78, // DIPERKECIL agar muat teks ke bawah
                        ),
                        itemCount: _filteredAdvisors.length,
                        itemBuilder: (context, index) => _buildAdvisorCard(_filteredAdvisors[index]),
                      )
                    : const Center(child: Text('Ustadz tidak ditemukan...', style: TextStyle(color: Colors.grey))),
              ),
              const SizedBox(height: 8),
              _buildPrivacyBanner(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFab(isDarkMode),
    );
  }

  Widget _buildAdvisorCard(Map<String, String> a) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD7EAF8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Avatar tetap di atas
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['name']!, 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
                      maxLines: 2, // Biarkan teks turun ke baris ke-2
                      overflow: TextOverflow.visible, // Tampilkan teks
                    ),
                    Text(
                      a['title']!, 
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
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
              const Text('Status:', style: TextStyle(fontSize: 11, color: Colors.black54)),
              const SizedBox(width: 4),
              Text(a['status']!, style: const TextStyle(fontSize: 11, color: Colors.black87)),
              const SizedBox(width: 4),
              const Icon(Icons.circle, color: Colors.green, size: 8),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.thumb_up, size: 12, color: Colors.black54),
              const SizedBox(width: 6),
              Text(a['percent']!, style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFFFFEFD6), borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () => _showPremiumDialog(a['name']!),
                child: const Text('Mulai Konsultasi', style: TextStyle(color: Colors.black87, fontSize: 11)),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildTutorialSheet() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      color: Color(0xFFF6E9E1),
      borderRadius: BorderRadius.vertical(
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
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Cara Menggunakan Q-Qonsul',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        _tutorialItem(
          Icons.search,
          'Cari Ustadz',
          'Gunakan kolom pencarian untuk mencari ustadz berdasarkan nama atau bidang konsultasi.',
        ),

        _tutorialItem(
          Icons.person_outline,
          'Pilih Ustadz',
          'Pilih ustadz yang tersedia untuk mulai berkonsultasi.',
        ),

        _tutorialItem(
          Icons.chat_bubble_outline,
          'Mulai Konsultasi',
          'Tekan tombol konsultasi untuk memulai percakapan.',
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
}

Widget _tutorialItem(IconData icon, String title, String desc) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF1976D2),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

 Widget _buildPrivacyBanner() {
    return const Center(
      child: Chip(
        avatar: Icon(Icons.lock, size: 16, color: Colors.green),
        label: Text('Privasi Kamu Aman', style: TextStyle(fontSize: 12, color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFab(bool isDarkMode) {
    return AnimatedOpacity(
      opacity: _showBackToTop ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 260),
      child: FloatingActionButton(
        onPressed: () => _scrollController.animateTo(0, duration: const Duration(milliseconds: 420), curve: Curves.easeOut),
        backgroundColor: isDarkMode ? Colors.tealAccent.shade700 : Colors.blueAccent,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}