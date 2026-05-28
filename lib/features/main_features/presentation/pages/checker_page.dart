import 'package:flutter/material.dart';
import 'mood_page.dart';
import '../../data/mood_storage.dart';
import '../../../../core/components/app_drawer.dart';

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
    MoodStorage.saveMood(_selectedDate, _selectedMoodEmoji!, _controller.text);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: colorScheme.onBackground),
        title: Text(
          'Q-Checker',
          style: TextStyle(color: colorScheme.onBackground, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Hero(
                  tag: 'mood_moon',
                  child: Image.asset(
                    'assets/images/moon_large.png',
                    height: 120,
                    errorBuilder: (c, e, s) => const Text('🌙', style: TextStyle(fontSize: 60)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'BAGAIMANA MOOD\nKAMU HARI INI?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: colorScheme.onBackground
                ),
              ),
              const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface, 
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
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
                    label: 'Sedih',
                    assetPath: 'assets/images/mood_buruk.png',
                    selected: _selectedMoodEmoji == '😢',
                    onTap: () => setState(() => _selectedMoodEmoji = '😢'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft, 
                child: Text(
                  'Apa yang kamu rasakan?', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onBackground)
                )
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                maxLines: 4,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  hintText: 'Tulis cerita kamu di sini...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), 
                    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2))
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), 
                    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.1))
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Text('Simpan Mood Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, colorScheme),
    );
  }

  Widget _buildBottomNav(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.1), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 10, 
            offset: const Offset(0, -4)
          )
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_rounded, color: colorScheme.onSurfaceVariant),
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              ),
              const SizedBox(width: 64),
              IconButton(
                icon: Icon(Icons.settings_rounded, color: colorScheme.onSurfaceVariant),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodPage())),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.primary, 
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: const Center(child: Text('🌙', style: TextStyle(fontSize: 28))),
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected 
              ? colorScheme.primaryContainer 
              : (isDarkMode ? colorScheme.surfaceVariant.withOpacity(0.2) : (label == 'Baik' ? const Color(0xFFFFF7C2) : const Color(0xFFD7EAF8))),
          borderRadius: BorderRadius.circular(24),
          border: selected ? Border.all(color: colorScheme.primary, width: 2) : Border.all(color: colorScheme.outline.withOpacity(0.1)),
          boxShadow: [
            if (selected) BoxShadow(color: colorScheme.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                assetPath,
                errorBuilder: (c, e, s) => Text(label == 'Baik' ? '😊' : '😢', style: const TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
