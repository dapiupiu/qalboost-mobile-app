import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final tips = [
      {
        'title': 'Kamu ngerasa sedih ya...',
        'content':
            'Ceritakan apa yang membuatmu sedih, lalu coba tarik napas dalam-dalam dan tuliskan hal kecil yang membuatmu bersyukur saat ini.',
        'color': const Color(0xFFBDF2B8),
      },
      {
        'title': 'Lagi marah ya...',
        'content':
            'Coba hitung sampai 10, beri jarak sejenak, lalu ungkapkan perasaanmu secara tenang atau tuliskan di buku diary.',
        'color': const Color(0xFFD6BDF2),
      },
      {
        'title': 'Hati kamu lagi tenang ya...',
        'content':
            'Nikmati momen tenang: dengarkan musik lembut, catat perasaan positif, dan simpan rencana kecil untuk menjaga keseimbangan.',
        'color': const Color(0xFFBCDFF2),
      },
    ];

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color(0xFF1F1F1F)
            : Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Q-Tips',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
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
                          // garis atas
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // title
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.orangeAccent,
                                child: const Icon(
                                  Icons.lightbulb,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),

                              const SizedBox(width: 10),

                              const Text(
                                'Tutorial Q-Tips',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          _tutorialItem(
                            Icons.touch_app,
                            'Tap Card',
                            'Tekan card untuk membuka tips.',
                          ),

                          _tutorialItem(
                            Icons.keyboard_arrow_down,
                            'Expand',
                            'Card akan terbuka dan menampilkan solusi.',
                          ),

                          _tutorialItem(
                            Icons.palette,
                            'Warna Emosi',
                            'Setiap warna menunjukkan kondisi emosi berbeda.',
                          ),

                          _tutorialItem(
                            Icons.favorite,
                            'Self Healing',
                            'Gunakan tips untuk membantu menenangkan diri.',
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Header card (peach) with moon image and rounded bottom
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFD6),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Harus\nNgapain Sih\nKalau Lagi\nNgerasa...',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.asset(
                        'assets/images/moon_large.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(
                          child: Text('🌙', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Bubble decorative placeholders (to mimic figma speech bubbles)
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: const [
                    SizedBox(height: 8),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFFFEFD6),
                    ),
                    SizedBox(height: 8),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFFFEFD6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Tips list as rounded colored cards
              Expanded(
                child: ListView.separated(
                  itemCount: tips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final t = tips[index];
                    return _ColoredExpansionCard(
                      title: t['title'] as String,
                      content: t['content'] as String,
                      color: t['color'] as Color,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  

  Widget _tutorialItem(
    IconData icon,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: 16,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

class _ColoredExpansionCard extends StatefulWidget {
  final String title;
  final String content;
  final Color color;

  const _ColoredExpansionCard({
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  State<_ColoredExpansionCard> createState() => _ColoredExpansionCardState();
}

class _ColoredExpansionCardState extends State<_ColoredExpansionCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _open ? 0.0 : 0.5,
                        duration: const Duration(milliseconds: 250),
                        child: const Icon(Icons.keyboard_arrow_up),
                      ),
                    ],
                  ),
                ),

                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 8,
                      right: 8,
                    ),
                    child: Text(
                      widget.content,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  crossFadeState: _open
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}
