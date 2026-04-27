import 'package:flutter/material.dart';
import 'main.dart'; // Pastikan file main.dart ada
import 'settings.dart'; // Pastikan file settings.dart ada
import 'mood.dart';

// ✅ Penyimpanan Data Statis
class MoodStorage {
  static final Map<String, Map<String, dynamic>> _moodData = {};

  static void saveMood(DateTime date, String emoji, String catatan) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    _moodData[key] = {
      'emoji': emoji,
      'catatan': catatan,
      'timestamp': DateTime.now(),
    };
  }

  static Map<String, dynamic>? getMood(DateTime date) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _moodData[key];
  }
}

class CheckerSimpleScreen extends StatefulWidget {
  const CheckerSimpleScreen({Key? key}) : super(key: key);

  @override
  State<CheckerSimpleScreen> createState() => _CheckerSimpleScreenState();
}

class _CheckerSimpleScreenState extends State<CheckerSimpleScreen> {
  String? _selectedMoodEmoji;
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_selectedMoodEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mood terlebih dahulu!')),
      );
      return;
    }

    MoodStorage.saveMood(
      _selectedDate,
      _selectedMoodEmoji!,
      _controller.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood tanggal ${_selectedDate.day} berhasil disimpan!')),
    );

    setState(() {
      _controller.clear();
      _selectedMoodEmoji = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text('Q-Checker', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/images/moon_large.png',
                  height: 120,
                  errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'BAGAIMANA MOOD\nKAMU HARI INI?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Pilih Tanggal
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Mood Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MoodCard(
                    label: 'Baik',
                    assetPath: 'assets/images/mood_baik.png',
                    selected: _selectedMoodEmoji == '😊',
                    onTap: () => setState(() => _selectedMoodEmoji = '😊'),
                  ),
                  const SizedBox(width: 20),
                  _MoodCard(
                    label: 'Sedih',
                    assetPath: 'assets/images/mood_buruk.png',
                    selected: _selectedMoodEmoji == '😢',
                    onTap: () => setState(() => _selectedMoodEmoji = '😢'),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Apa yang kamu rasakan?', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Tulis cerita kamu di sini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58A6F0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan Mood Hari Ini'),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 72,
            color: const Color(0xFF58A6F0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: const Icon(Icons.home, color: Colors.white), onPressed: () {}),
                const SizedBox(width: 56),
                IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
              ],
            ),
          ),
          Positioned(
            top: -22, left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodPage())),
                child: Container(
                  width: 70, height: 70,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Center(child: Text('🌙', style: TextStyle(fontSize: 30))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }
}

class _MoodCard extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  const _MoodCard({required this.label, required this.assetPath, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130, height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : (label == 'Baik' ? const Color(0xFFFFF7C2) : const Color(0xFFD7EAF8)),
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: Colors.blue, width: 2) : null,
          boxShadow: [if (selected) const BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(assetPath, errorBuilder: (c, e, s) => Text(label == 'Baik' ? '😊' : '😢', style: const TextStyle(fontSize: 40)))),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}