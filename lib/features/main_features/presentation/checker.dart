import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_service.dart';
import '../provider/mood_provider.dart';
import '../../../core/components/app_drawer.dart';
import '../../../core/components/custom_bottom_nav.dart';

class CheckerSimpleScreen extends StatefulWidget {
  const CheckerSimpleScreen({super.key});

  @override
  State<CheckerSimpleScreen> createState() => _CheckerSimpleScreenState();
}

class _CheckerSimpleScreenState extends State<CheckerSimpleScreen> {
  String? _selectedMoodEmoji;
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final MoodProvider _moodProvider = MoodProvider();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() async {
    HapticFeedback.mediumImpact();
    if (_selectedMoodEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mood terlebih dahulu!')),
      );
      return;
    }

    await _moodProvider.saveMood(
      _selectedDate,
      _selectedMoodEmoji!,
      _controller.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mood tanggal ${_selectedDate.day} berhasil disimpan!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _controller.clear();
        _selectedMoodEmoji = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.checkerBackgroundColor,
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: themeService.checkerAppBarColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: themeService.iconColor,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Q-Checker',
          style: AppTextStyles.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeService.primaryColor.withValues(alpha: 0.20),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/checker.png',
                    height: 140,
                    errorBuilder: (c, e, s) => Text(
                      '🌙',
                      style: AppTextStyles.titleLarge(context).copyWith(fontSize: 60),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'BAGAIMANA MOOD\nKAMU HARI INI?',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge(context).copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _buildDateTile(themeService),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MoodSelector(
                    label: 'Baik',
                    assetPath: 'assets/images/baik.png',
                    selected: _selectedMoodEmoji == '😊',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedMoodEmoji = '😊');
                    },
                    activeColor: themeService.checkerMoodGoodColor,
                    normalTextColor: themeService.checkerMoodLabelColor,
                  ),
                  const SizedBox(width: 40),
                  _MoodSelector(
                    label: 'Buruk',
                    assetPath: 'assets/images/buruk.png',
                    selected: _selectedMoodEmoji == '😢',
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedMoodEmoji = '😢');
                    },
                    activeColor: themeService.checkerMoodBadColor,
                    normalTextColor: themeService.checkerMoodLabelColor,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    bottom: 8,
                  ),
                  child: Text(
                    'Apa yang kamu rasakan?',
                    style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Stack(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 6,
                    style: AppTextStyles.bodyMedium(context),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeService.checkerTextFieldColor,
                      hintText: 'Tulis cerita kamu di sini...',
                      hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                        color: themeService.checkerTextFieldHintColor,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: themeService.primaryColor.withValues(alpha: 0.45),
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              themeService.checkerSaveButtonColor,
                          foregroundColor:
                              themeService.checkerSaveButtonTextColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeService.checkerSaveButtonTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: -1),
    );
  }

  Widget _buildDateTile(ThemeService themeService) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: themeService.isDarkMode
                  ? ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: themeService.primaryColor,
                        surface: const Color(0xFF1E1E1E),
                        onSurface: Colors.white,
                      ),
                    )
                  : ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: themeService.primaryColor,
                      ),
                    ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: themeService.checkerDateBoxColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: themeService.isDarkMode
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: themeService.isDarkMode ? 0.25 : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month,
              size: 18,
              color: themeService.primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
              style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month - 1];
  }
}

class _MoodSelector extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color normalTextColor;

  const _MoodSelector({
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
    required this.activeColor,
    required this.normalTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: selected
                    ? Border.all(
                        color: activeColor.withValues(alpha: 0.35),
                        width: 1.5,
                      )
                    : Border.all(
                        color: Colors.transparent,
                        width: 1.5,
                      ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.18),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Image.asset(
                assetPath,
                width: 85,
                height: 85,
                cacheWidth: 255,
                errorBuilder: (c, e, s) => Text(
                  label == 'Baik' ? '😊' : '😢',
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium(context).copyWith(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? activeColor : normalTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}