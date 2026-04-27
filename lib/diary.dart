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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Q-Diary', style: TextStyle(color: Colors.black87)),
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
                    height: 110,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Your',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Diary',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _addEntry,
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.add, size: 22),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 4,
                    child: Text(
                      '🌙',
                      style: TextStyle(
                        fontSize: 68,
                        shadows: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Divider(thickness: 1),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
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
        color: const Color(0xFFD7EAF8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
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
