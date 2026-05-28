import 'dart:ui';
import 'package:flutter/material.dart';
import '../../auth/data/auth_local_data.dart';
import '../data/diary_repository.dart'; 
import '../../../core/components/app_drawer.dart';

import 'package:provider/provider.dart';
import '../../../core/theme/theme_service.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final AuthLocalData _authLocal = AuthLocalData();
  final DiaryRepository _diaryRepo = DiaryRepository(); 
  final ScrollController _scrollController = ScrollController();
  
  // Key utama untuk mengontrol state Scaffold dari widget child di dalamnya
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<Map<String, String>> _entries = [];
  String? currentUserEmail;
  bool _isLoading = true;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _refreshDiaryData(); 
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 200;
      if (shouldShow != _showBackToTop) {
        setState(() => _showBackToTop = (shouldShow));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshDiaryData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final email = await _authLocal.getEmail(); 
    
    if (email != null) {
      final data = await _diaryRepo.getDiaryByEmail(email);
      if (mounted) {
        setState(() {
          currentUserEmail = email;
          _entries = data;
          _isLoading = false;
        });
        print("DEBUG_UI: Diary berhasil ditampilkan. Jumlah: ${_entries.length}");
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _entries = [];
        });
      }
    }
  }

 void _openDiaryDialog({int? index}) {
  final themeService = Provider.of<ThemeService>(context, listen: false);

  final isEdit = index != null;
  final titleController = TextEditingController(
    text: isEdit ? _entries[index]['title'] : '',
  );
  final contentController = TextEditingController(
    text: isEdit ? _entries[index]['content'] : '',
  );

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => const SizedBox(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: ScaleTransition(
          scale: anim1,
          child: AlertDialog(
            backgroundColor: themeService.dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              isEdit ? 'Lihat & Edit Diary' : 'Tulis Ceritamu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeService.textPrimaryColor,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeService.textPrimaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Judul Diary',
                    hintStyle: TextStyle(
                      color: themeService.hintTextColor,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeService.inputBorderColor,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeService.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: contentController,
                  maxLines: 6,
                  style: TextStyle(
                    color: themeService.textPrimaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Apa yang kamu rasakan hari ini?',
                    hintStyle: TextStyle(
                      color: themeService.hintTextColor,
                    ),
                    filled: true,
                    fillColor: themeService.inputFillColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeService.inputBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeService.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: TextStyle(
                    color: themeService.textSecondaryColor,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeService.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    _saveEntry(
                      titleController.text,
                      contentController.text,
                      index: index,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    color: themeService.buttonTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void _saveEntry(String title, String content, {int? index}) async {
    final now = DateTime.now();
    final dateString = "${now.day} ${_getMonth(now.month)} ${now.year}";

    setState(() {
      if (index != null) {
        _entries[index] = {
          'title': title,
          'content': content,
          'date': _entries[index]['date']!, 
        };
      } else {
        _entries.insert(0, {
          'title': title,
          'content': content,
          'date': dateString,
        });
      }
    });
    
    if (currentUserEmail != null) {
      await _diaryRepo.saveDiary(currentUserEmail!, _entries);
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }

  void _deleteEntry(int index) async {
    setState(() {
      _entries.removeAt(index);
    });
    if (currentUserEmail != null) {
      await _diaryRepo.saveDiary(currentUserEmail!, _entries);
    }
  }

void _showTutorial(BuildContext context) {
  final themeService = Provider.of<ThemeService>(context, listen: false);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeService.infoSheetBackground,
        borderRadius: const BorderRadius.vertical(
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
              color: themeService.textSecondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'Cara Menggunakan Q-Diary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeService.textPrimaryColor,
            ),
          ),

          const SizedBox(height: 20),

          _tutRow(
            Icons.add,
            'Tambah',
            'Gunakan tombol + untuk menulis diary baru.',
            themeService,
          ),

          _tutRow(
            Icons.edit_note,
            'Lihat & Edit',
            'Ketuk kartu diary untuk membaca atau mengubah isinya.',
            themeService,
          ),

          _tutRow(
            Icons.delete_outline,
            'Hapus',
            'Klik ikon sampah di dalam menu kartu untuk menghapus.',
            themeService,
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeService.infoSheetButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Mengerti',
                style: TextStyle(
                  color: themeService.infoSheetButtonText,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _tutRow(
  IconData icon,
  String title,
  String desc,
  ThemeService themeService,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: themeService.infoSheetIconColor,
          size: 22,
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: themeService.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                desc,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: themeService.textSecondaryColor,
                ),
              ),
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
      key: _scaffoldKey, 
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      
      // Mengaktifkan gesture bawaan sistem agar laci ditarik presisi nempel jempol
      drawerEnableOpenDragGesture: true, 
      // Ubah dari 30 menjadi dinamis (berdasarkan persentase lebar layar HP kamu)
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.15,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Tetap mempertahankan tombol back asli request kamu
            color: isDarkMode ? Colors.white : Colors.black87,
            size: 22,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Q-Diary',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.info_outline, color: isDarkMode ? Colors.white70 : Colors.black54),
              onPressed: () => _showTutorial(context),
            ),
          ),
        ],
      ),
      body: _isLoading 
      ? const Center(child: CircularProgressIndicator())
      : SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              // Jika drawer terdeteksi sedang terbuka, usapan jempol ke kiri (< -2) akan menutup laci secara natural (drag out)
              if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                if (details.delta.dx < -2) {
                  Navigator.pop(context); 
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Diary\nKamu', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, height: 1.1)),
                      FloatingActionButton.small(
                        heroTag: 'add_diary',
                        onPressed: () => _openDiaryDialog(),
                        backgroundColor: const Color(0xFF58A6F0),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  Expanded(
                    child: _entries.isEmpty 
                      ? const Center(child: Text('Belum ada catatan hari ini.'))
                      : ListView.separated(
                          controller: _scrollController,
                          // BouncingScrollPhysics wajib agar scroll list tidak menelan event horizontal drag milik drawer
                          physics: const BouncingScrollPhysics(), 
                          itemCount: _entries.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final e = _entries[index];
                            return GestureDetector(
                              onTap: () => _openDiaryDialog(index: index), 
                              child: _DiaryCard(
                                title: e['title']!,
                                content: e['content']!,
                                date: e['date']!,
                                onDelete: () => _deleteEntry(index),
                              ),
                            );
                          },
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Chip(
                      avatar: Icon(Icons.lock, size: 16, color: Colors.green),
                      label: Text('Privasi Kamu Aman', style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: () => _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
              backgroundColor: const Color(0xFF58A6F0),
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final VoidCallback onDelete;

  const _DiaryCard({required this.title, required this.content, required this.date, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFD7EAF8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Hapus Catatan', style: TextStyle(color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            onDelete();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Text(content, style: const TextStyle(color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}