import 'package:flutter/material.dart';

// Penyimpanan data mood dipindah ke file mood.dart agar tidak terjadi import sirkular
class MoodStorage {
  static final Map<String, Map<String, dynamic>> _moodData = {};

  static void saveMood(DateTime date, String emoji, String catatan) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    _moodData[key] = {
      'emoji': emoji,
      'catatan': catatan,
      'timestamp': DateTime.now(),
    };
  }

  static Map<String, dynamic>? getMood(DateTime date) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _moodData[key];
  }
}

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

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<int?> days = List.generate(42, (index) {
      final dayNum = index - (startWeekday - 1) + 1;
      return (dayNum > 0 && dayNum <= daysInMonth) ? dayNum : null;
    });

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      appBar: AppBar(
  backgroundColor:
      isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
  elevation: 0,

  // tombol kembali
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),

  centerTitle: true,

  // judul bulan & tahun
  title: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: _previousMonth,
    ),

    GestureDetector(
      onTap: () {
        _showMonthYearPicker(context);
      },
      child: Text(
        '${_getMonthName(_currentMonth)} $_currentYear',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),

    IconButton(
      icon: const Icon(Icons.chevron_right),
      onPressed: _nextMonth,
    ),
  ],
),
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Hari
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'S', 'R', 'K', 'J', 'S', 'M']
                  .map(
                    (d) => Text(
                      d,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                  .toList(),
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

  Widget _buildDayCell(
    BuildContext context,
    int day,
    Map<String, dynamic>? data,
  ) {
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
                  Text(
                    'Tanggal $day',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
          border: data != null
              ? Border.all(color: Colors.blue.withOpacity(0.3))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            if (data != null)
              Text(data['emoji'], style: const TextStyle(fontSize: 18)),
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
          ? const Text(
              'Belum ada mood untuk hari ini.',
              textAlign: TextAlign.center,
            )
          : Row(
              children: [
                Text(data['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mood Hari Ini',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data['catatan'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  showModalBottomSheet(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Bulan & Tahun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButton<int>(
                  value: selectedMonth,
                  isExpanded: true,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(_getMonthName(index + 1)),
                    );
                  }),
                  onChanged: (value) {
                    setModalState(() {
                      selectedMonth = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                DropdownButton<int>(
                  value: selectedYear,
                  isExpanded: true,
                  items: List.generate(20, (index) {
                    int year = 2020 + index;

                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (value) {
                    setModalState(() {
                      selectedYear = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = selectedMonth;
                      _currentYear = selectedYear;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Pilih'),
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
