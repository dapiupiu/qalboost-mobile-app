import 'package:flutter/material.dart';
import '../../../core/components/app_drawer.dart';
import '../../sub_features/presentation/diary.dart';
import '../../sub_features/presentation/tips.dart';
import '../../sub_features/presentation/consul.dart';
import '../../sub_features/presentation/quotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
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
                          child: const CircleAvatar(child: Icon(Icons.person)),
                        );
                      }),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selamat Datang',
                              style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.black54)),
                          Text('Pengguna QalBoost',
                              style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.asset('assets/images/app_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(Icons.auto_awesome, color: Colors.blue)),
                  ),
                ],
              ),
            ),

            // --- TITLE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bagaimana Perasaan\nKamu Hari Ini?',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F1B18)),
              ),
            ),
            const SizedBox(height: 20),

            // --- MENU BUTTONS ---
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

            // --- HISTORY MOOD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('History Mood', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/mood'),
                    child: const Text('Buka Kalender', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildMoodRow(),

            const SizedBox(height: 30),
            _buildDailyPerasaan(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // --- WIDGET HELPER (Agar code tidak terlalu panjang) ---
  Widget _buildMoodRow() {
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
                      color: isFirst ? const Color(0xFFFFEFD6) : const Color(0xFFD7EAF8),
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

  Widget _buildDailyPerasaan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Perasaan Kamu Hari ini', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEFD6),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Row(
              children: [
                Image.asset('assets/images/moon_small.png', width: 80, height: 80, errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 36))),
                const SizedBox(width: 16),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('"catatan kecil dari isi q-checker"', style: TextStyle(color: Color(0xFF2E2A28))),
                  SizedBox(height: 12),
                  Text('Kecewa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
              child: const Text('Tuliskan aktivitas atau perasaanmu hari ini...', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          height: 72, color: const Color(0xFF58A6F0),
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
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Padding(padding: const EdgeInsets.all(6), child: Image.asset('assets/icons/moon_nav.png', errorBuilder: (c, e, s) => const Center(child: Text('🌙', style: TextStyle(fontSize: 28))))),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// 🔥 REUSABLE BUTTON (Tetap di sini dulu sesuai requestmu)
Widget menuButton(BuildContext context, {String? assetPath, required String label, required Widget page}) {
  return Column(
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
            child: Center(child: Image.asset(assetPath!, width: 44, height: 44, errorBuilder: (c, e, s) => const Icon(Icons.extension))),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(label),
    ],
  );
}