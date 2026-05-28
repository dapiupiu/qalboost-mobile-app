import 'package:flutter/material.dart';
import 'package:qalboost/core/components/app_drawer.dart';
import 'package:qalboost/features/main_features/data/mood_storage.dart';

/// [MoodPage] menampilkan kalender riwayat catatan mood bulanan pengguna.
///
/// Rationale: Memungkinkan pengguna melakukan refleksi kesehatan mental secara visual
/// dengan membaca rekap data historis dari [MoodStorage].
class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  late int _currentMonth;
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_currentYear, _currentMonth, 1);
    final lastDay = DateTime(_currentYear, _currentMonth + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<int?> days = List.generate(42, (index) {
      final dayNum = index - (startWeekday - 1) + 1;
      return (dayNum > 0 && dayNum <= daysInMonth) ? dayNum : null;
    });

    return Scaffold(
      backgroundColor: colorScheme.background, // 🚀 PERBAIKAN: Menggunakan warna background dinamis dari tema global
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: colorScheme.onBackground),
              onPressed: _previousMonth,
            ),
            GestureDetector(
              onTap: () => _showMonthYearPicker(context),
              child: Text(
                '${_getMonthName(_currentMonth)} $_currentYear',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.onBackground),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: colorScheme.onBackground),
              onPressed: _nextMonth,
            ),
          ],
        ),
      ),
      // 🚀 PERBAIKAN OVERFLOW: Memastikan area body aman menggunakan ScrollPhysics yang responsif
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'S', 'R', 'K', 'J', 'S', 'M']
                      .map((d) => Text(d, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onBackground.withOpacity(0.5))))
                      .toList(),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final dayNum = days[index];
                    if (dayNum == null) return const SizedBox.shrink();
                    final date = DateTime(_currentYear, _currentMonth, dayNum);
                    final data = MoodStorage.getMood(date);
                    return _buildDayCell(context, dayNum, data);
                  },
                ),
                const SizedBox(height: 24),
                _buildTodayRecap(colorScheme),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int day, Map<String, dynamic>? data) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (data != null) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outline.withOpacity(0.2), borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 24),
                  Text(data['emoji'], style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Tanggal $day ${_getMonthName(_currentMonth)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.onSurface)),
                  const SizedBox(height: 12),
                  Text(
                    data['catatan'] ?? 'Tidak ada catatan', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: data != null ? colorScheme.primaryContainer : colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: data != null ? Border.all(color: colorScheme.primary.withOpacity(0.5)) : Border.all(color: colorScheme.outline.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: data != null ? colorScheme.onPrimaryContainer : colorScheme.onSurface.withOpacity(0.5))),
            if (data != null) const SizedBox(height: 2),
            if (data != null) Text(data['emoji'], style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayRecap(ColorScheme colorScheme) {
    final now = DateTime.now();
    final data = MoodStorage.getMood(DateTime(now.year, now.month, now.day));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface, 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: data == null
          ? Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text('Belum ada mood untuk hari ini.', style: TextStyle(color: colorScheme.onSurfaceVariant))),
              ],
            )
          : Row(
              children: [
                Text(data['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mood Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text(data['catatan'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _previousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  void _showMonthYearPicker(BuildContext context) {
    int selectedMonth = _currentMonth;
    int selectedYear = _currentYear;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface, // 🚀 PERBAIKAN: Modal background adaptif
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pilih Bulan & Tahun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  const SizedBox(height: 20),
                  DropdownButton<int>(
                    value: selectedMonth,
                    isExpanded: true,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                    items: List.generate(12, (index) => DropdownMenuItem(value: index + 1, child: Text(_getMonthName(index + 1)))),
                    onChanged: (value) => setModalState(() => selectedMonth = value!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<int>(
                    value: selectedYear,
                    isExpanded: true,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                    items: List.generate(20, (index) {
                      int year = 2020 + index;
                      return DropdownMenuItem(value: year, child: Text(year.toString()));
                    }),
                    onChanged: (value) => setModalState(() => selectedYear = value!),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = selectedMonth;
                        _currentYear = selectedYear;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary, 
                      foregroundColor: colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Pilih', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }
}