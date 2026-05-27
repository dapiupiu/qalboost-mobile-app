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
              
              // --- LOGO UTAMA DENGAN HIGHLIGHT SHADOW ---
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/checker.png', 
                    height: 140,
                    errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 60)),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              const Text(
                'BAGAIMANA MOOD\nKAMU HARI INI?', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 20),
              
              _buildDateTile(),
              const SizedBox(height: 35),

              // --- PILIHAN MOOD DENGAN SOFT OUTLINE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MoodSelector(
                    label: 'Baik',
                    assetPath: 'assets/images/baik.png',
                    selected: _selectedMoodEmoji == '😊',
                    onTap: () => setState(() => _selectedMoodEmoji = '😊'),
                    activeColor: Colors.green,
                  ),
                  const SizedBox(width: 40),
                  _MoodSelector(
                    label: 'Buruk',
                    assetPath: 'assets/images/buruk.png',
                    selected: _selectedMoodEmoji == '😢',
                    onTap: () => setState(() => _selectedMoodEmoji = '😢'),
                    activeColor: Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft, 
                child: Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text('Apa yang kamu rasakan?', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ),
              
              // --- TEXTFIELD DENGAN BUTTON SIMPAN DI DALAM ---
              Stack(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Tulis cerita kamu di sini...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), 
                        borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.withValues(alpha: 0.3), width: 1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF58A6F0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Simpan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
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
        final picked = await showDatePicker(
          context: context, 
          initialDate: _selectedDate, 
          firstDate: DateTime(2024), 
          lastDate: DateTime.now()
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10, 
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month, size: 18, color: Color(0xFF58A6F0)),
            const SizedBox(width: 10),
            Text(
              '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}', 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
            ),
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

class _MoodSelector extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  const _MoodSelector({
    required this.label, 
    required this.assetPath, 
    required this.selected, 
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Soft Outline: Menggunakan opacity lebih rendah dan border lebih tipis
                border: selected 
                    ? Border.all(color: activeColor.withValues(alpha: 0.3), width: 1.5) 
                    : Border.all(color: Colors.transparent, width: 1.5),
                boxShadow: selected ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.15), 
                    blurRadius: 12, 
                    spreadRadius: 1
                  )
                ] : [],
              ),
              child: Image.asset(
                assetPath, 
                width: 85, 
                height: 85,
                errorBuilder: (c, e, s) => Text(label == 'Baik' ? '😊' : '😢', style: const TextStyle(fontSize: 40))
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label, 
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal, 
                color: selected ? activeColor : Colors.black54,
                fontSize: 14,
              )
            ),
          ],
        ),
      ),
    );
  }
}