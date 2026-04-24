import 'package:flutter/material.dart';
import 'diary.dart';
import 'tips.dart';
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
            // Header: User info and date
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(child: Icon(Icons.person)),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selamat Datang'),
                              Text('Nama Pengguna', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.location_on),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Maret 15 2026', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            // Main title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bagaimana Perasaan Kamu Hari Ini?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            // Four buttons: Quotes, Konsul, Diary, Tips
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(width: 60, height: 60, decoration: BoxDecoration(border: Border.all()), child: Icon(Icons.format_quote)),
                      SizedBox(height: 8),
                      Text('Q-Quotes'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(width: 60, height: 60, decoration: BoxDecoration(border: Border.all()), child: Icon(Icons.chat)),
                      SizedBox(height: 8),
                      Text('Q-Konsul'),
                    ],
                  ),
                  Column(
  children: [
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiaryPage()),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(border: Border.all()),
        child: Icon(Icons.event_note),
      ),
    ),
    SizedBox(height: 8),
    Text('Q-Diary'),
  ],
),
                  Column(
  children: [
    InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TipsPage()),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(border: Border.all()),
        child: Icon(Icons.lightbulb),
      ),
    ),
    SizedBox(height: 8),
    Text('Q-Tips'),
  ],
),
                ],
              ),
            ),
            SizedBox(height: 30),
            // History Mood section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('History Mood', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Lihat Kalender', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    'Senin',
                    'Selasa',
                    'Rabu',
                    'Kamis',
                    'Jumat',
                    'Sabtu',
                    'Minggu',
                  ].map((day) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(width: 30, height: 30, decoration: BoxDecoration(border: Border.all()), child: Center(child: Text('😊'))),
                        SizedBox(height: 4),
                        Text(day, style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Perasaan Kamu Hari Ini section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Perasaan Kamu Hari Ini', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    Icon(Icons.emoji_people, size: 40),
                    SizedBox(height: 8),
                    Text('Kecewa'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all()),
                child: Text('catatan kecil dari isi q-checker'),
              ),
            ),
            SizedBox(height: 30),
            // Hari ini ada apa ya? section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Hari ini ada apa ya?', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all()),
                child: Text('Tuliskan aktivitas atau perasaanmu hari ini...'),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
