import 'package:flutter/material.dart';
import '../provider/mood_provider.dart';
import '../../../core/components/app_drawer.dart';
import '../../../core/components/custom_bottom_nav.dart';

class CheckerSimpleScreen extends StatefulWidget {
  const CheckerSimpleScreen({super.key});

  @override
  State<CheckerSimpleScreen> createState() => _CheckerSimpleScreenState();
}

class _CheckerSimpleScreenState extends State<CheckerSimpleScreen> {
  String? _selectedMoodEmoji;
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final MoodProvider _moodProvider = MoodProvider();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_selectedMoodEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mood terlebih dahulu!')),
      );
      return;
    }

    await _moodProvider.saveMood(_selectedDate, _selectedMoodEmoji!, _controller.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood tanggal ${_selectedDate.day} berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _controller.clear();
        _selectedMoodEmoji = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text('Q-Checker', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(child: Image.asset('assets/images/moon_large.png', height: 120, errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 60)))),
              const SizedBox(height: 15),
              const Text('BAGAIMANA MOOD\nKAMU HARI INI?', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildDateTile(),
              const SizedBox(height: 25),
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
                    label: 'Buruk', // Ganti dari Sedih ke Buruk
                    assetPath: 'assets/images/mood_buruk.png',
                    selected: _selectedMoodEmoji == '😢',
                    onTap: () => setState(() => _selectedMoodEmoji = '😢'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Align(alignment: Alignment.centerLeft, child: Text('Apa yang kamu rasakan?', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                maxLines: 4,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Tulis cerita kamu di sini...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
      bottomNavigationBar: const CustomBottomNav(currentIndex: -1),
    );
  }

  Widget _buildDateTile() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2024), lastDate: DateTime.now());
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Text('${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
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

  const _MoodCard({super.key, required this.label, required this.assetPath, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Tentukan warna seleksi berdasarkan label
    Color selectionColor = label == 'Baik' ? Colors.green : Colors.red;
    Color bgColor = label == 'Baik' ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130, height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : bgColor,
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: selectionColor, width: 2) : null,
          boxShadow: [if (selected) BoxShadow(color: selectionColor.withOpacity(0.2), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(assetPath, errorBuilder: (c, e, s) => Text(label == 'Baik' ? '😊' : '😢', style: const TextStyle(fontSize: 40)))),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? selectionColor : Colors.black87)),
          ],
        ),
      ),
    );
  }
}