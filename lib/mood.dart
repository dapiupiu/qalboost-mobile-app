import 'package:flutter/material.dart';
import 'checker.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

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
    final startWeekday = firstDay.weekday; // 1 = Senin, 7 = Minggu

    final List<int?> days = List.generate(42, (index) {
      final dayNum = index - (startWeekday - 1) + 1;
      return (dayNum > 0 && dayNum <= daysInMonth) ? dayNum : null;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E1),
      appBar: AppBar(
        title: Text('${_getMonthName(_currentMonth)} $_currentYear'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Hari
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'S', 'R', 'K', 'J', 'S', 'M']
                  .map((d) => Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))).toList(),
            ),
            const SizedBox(height: 10),
            
            // Grid Kalender
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
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
            ),
            
            // Recap Hari Ini
            _buildTodayRecap(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int day, Map<String, dynamic>? data) {
    return GestureDetector(
      onTap: () {
        if (data != null) {
          showModalBottomSheet(
            context: context,
            builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data['emoji'], style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 10),
                  Text('Tanggal $day', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(data['catatan'] ?? 'Tidak ada catatan'),
                ],
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: data != null ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(8),
          border: data != null ? Border.all(color: Colors.blue.withOpacity(0.3)) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            if (data != null) Text(data['emoji'], style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayRecap() {
    final data = MoodStorage.getMood(DateTime.now());
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: data == null
          ? const Text('Belum ada mood untuk hari ini.', textAlign: TextAlign.center)
          : Row(
              children: [
                Text(data['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mood Hari Ini', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data['catatan'], maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }
}