import 'package:flutter/material.dart';
import 'main.dart';
import 'settings.dart';

/// Asset image paths used in this screen:
/// - assets/images/moon_large.png          (top moon graphic)
/// - assets/images/mood_baik.png          (mood card: Baik)
/// - assets/images/mood_buruk.png         (mood card: Buruk)
/// - assets/icons/moon_nav.png            (bottom center moon icon)
/// Make sure to add these to `pubspec.yaml` under `flutter/assets:`.

class CheckerSimpleScreen extends StatefulWidget {
  const CheckerSimpleScreen({Key? key}) : super(key: key);

  @override
  State<CheckerSimpleScreen> createState() => _CheckerSimpleScreenState();
}

class _CheckerSimpleScreenState extends State<CheckerSimpleScreen> {
  String? _mood;
  final TextEditingController _controller = TextEditingController();
// karena ini halaman Q-Checker

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6E9E1);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
        title: const Text('Q-Checker', style: TextStyle(color: Colors.black87)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              // Top moon graphic (use asset path shown above)
              Center(
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Image.asset(
                    'assets/images/moon_large.png',
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Center(
                      child: Text('🌙', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'BAGAIMANA MOOD\nKAMU HARI INI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 18),

              // Mood choices
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MoodCard(
                    label: 'Baik',
                    assetPath: 'assets/images/mood_baik.png',
                    selected: _mood == 'baik',
                    onTap: () => setState(() => _mood = 'baik'),
                  ),
                  const SizedBox(width: 18),
                  _MoodCard(
                    label: 'Buruk',
                    assetPath: 'assets/images/mood_buruk.png',
                    selected: _mood == 'buruk',
                    onTap: () => setState(() => _mood = 'buruk'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apa emosi yang sedang kamu rasakan?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    Text(
                      'Kamu mau cerita apa yang terjadi?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('Jangan ragu untuk menuangkan isi pikiran kamu'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Text field with small save button positioned at bottom-right
              Stack(
                children: [
                  TextField(
                    controller: _controller,
                    minLines: 4,
                    maxLines: 6,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tulis di sini...',
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(64, 36),
                        ),
                        onPressed: () {
                          final mood = _mood ?? 'belum dipilih';
                          final text = _controller.text.isEmpty
                              ? '-'
                              : _controller.text;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Mood: $mood, Text: $text')),
                          );
                        },
                        icon: const Icon(Icons.save, size: 16),
                        label: const Text(
                          'Simpan',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      // Custom bottom bar with center moon icon like screenshot
      bottomNavigationBar: SizedBox(
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
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    ),
                  ),
                  const SizedBox(width: 56), // space for center moon
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    ),
                  ),
                ],
              ),
            ),
            // center moon icon overlap
            Positioned(
              top: -22,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      'assets/icons/moon_nav.png',
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Center(
                        child: Text('🌙', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  const _MoodCard({
    Key? key,
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = label.toLowerCase() == 'baik'
        ? const Color(0xFFFFF7C2)
        : const Color(0xFFD7EAF8);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 140,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: selected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Center(
                  child: Text('🌙', style: TextStyle(fontSize: 36)),
                ),
              ),
            ),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
