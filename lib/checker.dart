import 'package:flutter/material.dart';
import 'main.dart';
import 'settings.dart';

class CheckerSimpleScreen extends StatefulWidget {
  const CheckerSimpleScreen({Key? key}) : super(key: key);

  @override
  State<CheckerSimpleScreen> createState() => _CheckerSimpleScreenState();
}

class _CheckerSimpleScreenState extends State<CheckerSimpleScreen> {
  String? _mood;
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 1; // karena ini halaman Q-Checker

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Q-Checker'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'BAGAIMANA MOOD KAMU HARI INI',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _mood = 'baik'),
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _mood == 'baik'
                            ? Colors.grey.shade200
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.sentiment_satisfied, size: 36),
                          SizedBox(height: 8),
                          Text('Baik'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  GestureDetector(
                    onTap: () => setState(() => _mood = 'buruk'),
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _mood == 'buruk'
                            ? Colors.grey.shade200
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.sentiment_dissatisfied, size: 36),
                          SizedBox(height: 8),
                          Text('Buruk'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Apa emosi yang sedang kamu rasakan?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Pilih 1 emosi yang paling menggambarkan'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kamu mau cerita apa yang terjadi?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Jangan ragu untuk menuangkan isi pikiran kamu'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _controller,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Tulis di sini...',
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    final mood = _mood ?? 'belum dipilih';
                    final text =
                        _controller.text.isEmpty ? '-' : _controller.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mood: $mood, Text: $text')),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ✅ Bottom Nav Konsisten
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
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
}