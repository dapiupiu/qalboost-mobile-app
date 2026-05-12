import 'package:flutter/material.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final List<Map<String, String>> _entries = [
    {'title': 'Judul', 'content': 'Isi......', 'date': '30 Maret 2026'},
    {'title': 'Judul', 'content': 'Isi......', 'date': '30 Maret 2026'},
    {'title': 'Judul', 'content': 'Isi......', 'date': '30 Maret 2026'},
  ];

  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;
  bool _hoveringFab = false;

  void _addEntry() {
    setState(() {
      _entries.insert(0, {
        'title': 'Judul',
        'content': 'Isi......',
        'date': '30 Maret 2026',
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 200;
      if (shouldShow != _showBackToTop) {
        setState(() => _showBackToTop = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          'Q-Diary',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Diary',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Kamu',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add button positioned top-right of header (centered icon)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _addEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF58A6F0),
                          elevation: 4,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(48, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: _entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final e = _entries[index];
                    return _DiaryCard(
                      title: e['title'] ?? '',
                      content: e['content'] ?? '',
                      date: e['date'] ?? '',
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade700),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lock, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Privasi Kamu Aman dan Terjaga',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _showBackToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 260),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hoveringFab = true),
          onExit: (_) => setState(() => _hoveringFab = false),
          child: Transform.scale(
            scale: _hoveringFab ? 1.08 : 1.0,
            child: FloatingActionButton(
              heroTag: 'diary_back_to_top',
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOut,
                );
              },
              backgroundColor: isDarkMode
                  ? Colors.tealAccent.shade700
                  : const Color(0xFF58A6F0),
              tooltip: 'Kembali ke atas',
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const _DiaryCard({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
        border: Border.all(color: const Color(0xFFD7EAF8)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
