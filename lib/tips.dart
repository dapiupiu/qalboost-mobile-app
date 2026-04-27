import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Q-Tips', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
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
                            'Harus\nNgapain Sih\nKalau Lagi\ Ngerasa...',
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Transform.rotate(
                  angle: _open ? 3.14 : 0,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
