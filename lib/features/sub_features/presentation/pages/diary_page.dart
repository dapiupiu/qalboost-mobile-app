import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/components/app_drawer.dart';
import '../../../../core/components/tutorial_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final List<Map<String, String>> _entries = [
    {'title': 'Menerima Diri Sendiri', 'content': 'Hari ini aku belajar bahwa tidak apa-apa untuk tidak menjadi sempurna...', 'date': '28 Mei 2026'},
    {'title': 'Rasa Syukur', 'content': 'Terima kasih atas kopi hangat di pagi hari yang mendamaikan...', 'date': '27 Mei 2026'},
    {'title': 'Perjalanan Kecil', 'content': 'Berhasil menyelesaikan tugas tepat waktu, bangga pada diri sendiri!', 'date': '26 Mei 2026'},
  ];

  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  void _triggerHaptic() {
    HapticFeedback.lightImpact();
  }

  void _addEntry() {
    _triggerHaptic();
    setState(() {
      _entries.insert(0, {
        'title': 'Cerita Baru',
        'content': 'Apa yang ingin kamu tuliskan hari ini?',
        'date': 'Baru saja',
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Q-Diary'),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              _showTutorial(context);
            },
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimationLimiter(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            physics: const BouncingScrollPhysics(),
            children: [
              // Header section
              AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 600),
                child: FadeInAnimation(
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Diary', style: textTheme.displayLarge?.copyWith(fontSize: 40)),
                              Text('Kamu', style: textTheme.displayLarge?.copyWith(fontSize: 40, color: colorScheme.primary)),
                            ],
                          ),
                          FloatingActionButton.large(
                            heroTag: 'add_diary_fab',
                            onPressed: _addEntry,
                            backgroundColor: colorScheme.primary,
                            elevation: 8,
                            child: const Icon(Icons.add_rounded, size: 36, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 16),

              // Entries list
              _entries.isEmpty 
                ? _buildEmptyState(textTheme, colorScheme)
                : AnimationLimiter(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final e = _entries[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _DiaryCard(
                                title: e['title'] ?? '',
                                content: e['content'] ?? '',
                                date: e['date'] ?? '',
                                onDelete: () {
                                  _triggerHaptic();
                                  setState(() => _entries.removeAt(index));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline_rounded, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text('Privasi Kamu Aman & Terjaga', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _showBackToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          mini: true,
          onPressed: () {
            _triggerHaptic();
            _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          backgroundColor: colorScheme.secondary,
          child: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Icon(Icons.auto_stories_outlined, size: 80, color: colorScheme.outline.withOpacity(0.3)),
        const SizedBox(height: 16),
        Text('Hati yang tenang dimulai dari cerita.', style: textTheme.titleMedium?.copyWith(color: colorScheme.outline)),
        const SizedBox(height: 8),
        Text('Tuliskan ceritamu hari ini?', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline.withOpacity(0.7))),
      ],
    );
  }

  void _showTutorial(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              const Row(
                children: [
                  CircleAvatar(child: Icon(Icons.menu_book_rounded)),
                  SizedBox(width: 16),
                  Text('Tutorial Q-Diary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              const TutorialItem(icon: Icons.add, title: 'Tambah Diary', desc: 'Tekan tombol + untuk menuangkan ceritamu.'),
              const TutorialItem(icon: Icons.edit_note, title: 'Tulis Bebas', desc: 'Tidak ada batasan, tulis apa pun yang kamu rasakan.'),
              const TutorialItem(icon: Icons.lock, title: 'Privasi', desc: 'Semua cerita disimpan secara lokal di perangkatmu.'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final VoidCallback onDelete;

  const _DiaryCard({Key? key, required this.title, required this.content, required this.date, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => _showOptions(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(content, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), height: 1.5)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(date, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(leading: const Icon(Icons.edit_rounded), title: const Text('Edit Cerita'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.share_rounded), title: const Text('Bagikan'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.delete_outline_rounded, color: Colors.red), title: const Text('Hapus Permanen', style: TextStyle(color: Colors.red)), onTap: () {
                onDelete();
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }
}
