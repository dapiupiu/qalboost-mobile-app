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
    final bg = const Color(0xFFF6E9E1);
    final accentBlue = const Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Q-Quotes', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/menu_quotes.png',
              width: 28,
              height: 28,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.info_outline, color: Colors.black54),
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
}
