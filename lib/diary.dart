import 'package:flutter/material.dart';
// Sesuaikan path import jika file kamu tidak berada di dalam folder 'components'
import 'components/app_drawer.dart';

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

  Widget _tutorialItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(icon, color: const Color(0xFF1976D2), size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title only for tutorial items. The three-dot menu
                // (edit/delete/share) should only appear on diary cards,
                // so we don't include the IconButton here.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF6E9E1),

      // --- DRAWER TETAP ADA AGAR BISA DI-DRAG DARI KIRI ---
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0, // Pakai yang ini agar tidak error lagi

      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color(0xFF1F1F1F)
            : Colors.transparent,
        elevation: 0,

        // --- KEMBALIKAN TOMBOL BACK DI SINI ---
        // Karena ada leading, Flutter tidak akan memunculkan tombol Hamburger Menu otomatis
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
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(
                                  Icons.menu_book,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Tutorial Q-Diary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _tutorialItem(
                            Icons.add,
                            'Tambah Diary',
                            'Tekan tombol + untuk membuat diary baru.',
                          ),
                          _tutorialItem(
                            Icons.edit_note,
                            'Tulis Perasaan',
                            'Tuliskan cerita atau perasaanmu hari ini.',
                          ),
                          _tutorialItem(
                            Icons.calendar_today,
                            'Tanggal Diary',
                            'Setiap diary memiliki tanggal penyimpanan.',
                          ),
                          _tutorialItem(
                            Icons.lock,
                            'Privasi Aman',
                            'Diary kamu aman dan tidak dibagikan.',
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
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
                            children: [
                              Text(
                                'Diary',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              Text(
                                'Kamu',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            const SizedBox(height: 18),

                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);

                                // TODO: EDIT
                              },
                            ),

                            ListTile(
                              leading: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {
                                Navigator.pop(context);

                                // TODO: DELETE
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('Share'),
                              onTap: () {
                                Navigator.pop(context);

                                // TODO: SHARE
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
