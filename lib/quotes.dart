import 'package:flutter/material.dart';

class QuotesSimpleScreen extends StatefulWidget {
  final String headerTitle;
  final String headerSubtitle;
  final String contentText;

  const QuotesSimpleScreen({
    Key? key,
    this.headerTitle = 'Hari ini...',
    this.headerSubtitle = 'Pelan-pelan kita perbaiki ya dengerin dulu yuk...',
    this.contentText =
        'Orang itu wajar kalau sedih tapi ketika sudah sedih sepatutnya ia berdoa',
  }) : super(key: key);

  @override
  State<QuotesSimpleScreen> createState() => _QuotesSimpleScreenState();
}

class _QuotesSimpleScreenState extends State<QuotesSimpleScreen> {
  double _position = 0.2;
  bool _isPlaying = false;

  void _togglePlay() => setState(() => _isPlaying = !_isPlaying);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bg = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1);
    final accentBlue = const Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Q-Quotes', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
        centerTitle: true,
actions: [
  Padding(
    padding: const EdgeInsets.only(right: 12.0),
    child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.orangeAccent,
                        child: const Icon(
                          Icons.tips_and_updates,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        'Tutorial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _tutorialItem(
                    Icons.play_circle_fill,
                    'Play',
                    'Tekan untuk memutar atau menghentikan audio quotes',
                  ),

                  _tutorialItem(
                    Icons.swipe,
                    'Swipe',
                    'Geser layar kebawah untuk melihat quotes lain',
                  ),

                  _tutorialItem(
                    Icons.download,
                    'Download',
                    'Simpan quotes ke perangkat',
                  ),

                  _tutorialItem(
                    Icons.favorite,
                    'Favorite',
                    'Tambah ke favorit',
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Mengerti',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Image.asset(
        'assets/images/menu_quotes.png',
        width: 28,
        height: 28,
        errorBuilder: (c, e, s) => Icon(
          Icons.info_outline,
          color: isDarkMode ? Colors.grey : Colors.black54,
        ),
      ),
    ),
  ),
],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              // Top area: large left heading and decorative moon on right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.headerTitle,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.headerSubtitle,
                          style: const TextStyle(fontSize: 18, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      'assets/images/moon_large.png',
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Center(
                        child: Text('🌙', style: TextStyle(fontSize: 48)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Main card
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image area with rounded corners
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          child: Container(
                            color: Colors.grey.shade200,
                            height: 320,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/ustadz_avatar.png',
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Center(
                                child: CircleAvatar(
                                  radius: 56,
                                  child: Text(
                                    'U',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom blue control panel
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1976D2),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(28),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                widget.contentText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),

                              // Controls
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.replay_10,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),

                                  // Play button
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.skip_previous,
                                          color: Colors.white,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _togglePlay,
                                        child: CircleAvatar(
                                          radius: 26,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            _isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: accentBlue,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.skip_next,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Icon(
                                    Icons.file_download,
                                    color: Colors.white,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              // Progress slider
                              Slider.adaptive(
                                value: _position,
                                onChanged: (v) => setState(() => _position = v),
                                activeColor: Colors.white,
                                inactiveColor: Colors.white30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // swipe hint
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Column(
                  children: const [
                    Text(
                      'swipe',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _tutorialItem(
  IconData icon,
  String title,
  String desc,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                desc,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
