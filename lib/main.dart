import 'package:flutter/material.dart';
import 'diary.dart';
import 'tips.dart';
import 'mood.dart';
import 'consul.dart';
import 'checker.dart';
import 'settings.dart';
import 'quotes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QalBoost',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          CircleAvatar(child: Icon(Icons.person)),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selamat Datang'),
                              Text(
                                'Nama Pengguna',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.location_on),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Maret 15 2026',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bagaimana Perasaan Kamu Hari Ini?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // Menu Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuButton(
                    context,
                    icon: Icons.format_quote,
                    label: 'Q-Quotes',
                    page: const QuotesSimpleScreen(),
                  ),
                  menuButton(
                    context,
                    icon: Icons.chat,
                    label: 'Q-Konsul',
                    page: const ConsulPage(),
                  ),
                  menuButton(
                    context,
                    icon: Icons.event_note,
                    label: 'Q-Diary',
                    page: const DiaryPage(),
                  ),
                  menuButton(
                    context,
                    icon: Icons.lightbulb,
                    label: 'Q-Tips',
                    page: const TipsPage(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

           // History Mood
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'History Mood',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MoodPage(),
            ),
          );
        },
        child: const Text(
          'Lihat Kalender',
          style: TextStyle(fontSize: 12),
        ),
      ),
    ],
  ),
),
 
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Senin',
                    'Selasa',
                    'Rabu',
                    'Kamis',
                    'Jumat',
                    'Sabtu',
                    'Minggu',
                  ].map((day) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(child: Text('😊')),
                          ),
                          const SizedBox(height: 4),
                          Text(day,
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Perasaan Hari Ini
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Perasaan Kamu Hari Ini',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.emoji_people, size: 40),
                    SizedBox(height: 8),
                    Text('Kecewa'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('catatan kecil dari isi q-checker'),
              ),
            ),

            const SizedBox(height: 30),

            // Catatan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Hari ini ada apa ya?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                    'Tuliskan aktivitas atau perasaanmu hari ini...'),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CheckerSimpleScreen(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            }
          },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: 'Q-Checker'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  // 🔥 REUSABLE BUTTON (INI YANG BIKIN ADA EFEK KEDIP)
  Widget menuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget page}) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.blue.withOpacity(0.3),
            highlightColor: Colors.blue.withOpacity(0.1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}