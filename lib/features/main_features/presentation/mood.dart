import 'package:flutter/material.dart';
import '../provider/mood_provider.dart';
import '../model/mood_model.dart';
import '../../../core/components/app_drawer.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final MoodProvider _moodProvider = MoodProvider();

  @override
  void initState() {
    super.initState();
    _moodProvider.fetchMoods().then((_) {
      if (mounted) setState(() {});
    });
  }

  // Helper Warna Background Kotak Kalender
  Color _getDayColor(String? emoji) {
    if (emoji == '😊') return Colors.green.shade100; // Baik
    if (emoji == '😢') return Colors.red.shade100;   // Buruk
    return Colors.white;
  }

  // HELPER MASKOT: Digunakan untuk Recap (bawah) dan Detail (pop-up)
  Widget _getMoodImage(String? emoji, {double size = 20}) {
    if (emoji == '😊') {
      return Image.asset('assets/images/baik.png', width: size, height: size);
    } else if (emoji == '😢') {
      return Image.asset('assets/images/buruk.png', width: size, height: size);
    }
    return const SizedBox.shrink();
  }

  // HELPER EMOJI: Digunakan khusus untuk Grid Kalender agar terlihat "Pop"
  Widget _buildStyledEmoji(String emoji) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: 20,
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final firstDay = DateTime(_moodProvider.currentYear, _moodProvider.currentMonth, 1);
    final daysInMonth = DateTime(_moodProvider.currentYear, _moodProvider.currentMonth + 1, 0).day;
    final startWeekday = firstDay.weekday;

    final List<int?> days = List.generate(42, (index) {
      final dayNum = index - (startWeekday - 1) + 1;
      return (dayNum > 0 && dayNum <= daysInMonth) ? dayNum : null;
    });

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: BackButton(color: isDarkMode ? Colors.white : Colors.black87),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left), 
              onPressed: () => setState(() => _moodProvider.previousMonth())
            ),
            Text(
              '${_getMonthName(_moodProvider.currentMonth)} ${_moodProvider.currentYear}', 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right), 
              onPressed: () => setState(() => _moodProvider.nextMonth())
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildWeekdayHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      physics: const ClampingScrollPhysics(), 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, 
                        mainAxisSpacing: 8, 
                        crossAxisSpacing: 8,
                        // Diubah ke 0.82 agar kotak sedikit ceper dan muat di layar pendek tanpa overflow
                        childAspectRatio: 0.82, 
                      ),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final dayNum = days[index];
                        if (dayNum == null) return const SizedBox.shrink();

                        final dateKey = "${_moodProvider.currentYear}-${_moodProvider.currentMonth.toString().padLeft(2, '0')}-${dayNum.toString().padLeft(2, '0')}";
                        
                        final MoodModel? moodData = _moodProvider.userMoods.cast<MoodModel?>().firstWhere(
                          (m) => m?.dateKey == dateKey, orElse: () => null
                        );

                        return _buildDayCell(context, dayNum, moodData);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10), 
              _buildTodayRecap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int day, MoodModel? data) {
    return GestureDetector(
      onTap: () {
        if (data != null) _showMoodDetail(context, day, data);
      },
      child: Container(
        decoration: BoxDecoration(
          color: data != null ? _getDayColor(data.emoji) : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: data != null 
            ? Border.all(color: data.emoji == '😊' ? Colors.green.shade200 : Colors.red.shade200, width: 1) 
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day', 
              style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)
            ),
            if (data != null) _buildStyledEmoji(data.emoji), 
          ],
        ),
      ),
    );
  }

  Widget _buildTodayRecap() {
    final now = DateTime.now();
    final todayKey = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final MoodModel? data = _moodProvider.userMoods.cast<MoodModel?>().firstWhere((m) => m?.dateKey == todayKey, orElse: () => null);

    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data != null ? _getDayColor(data.emoji) : Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]
      ),
      child: data == null
          ? const Text('Belum ada mood untuk hari ini.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54))
          : Row(
              children: [
                _getMoodImage(data.emoji, size: 50), 
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data.emoji == '😊' ? 'Mood Baik' : 'Mood Buruk', 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text(data.note, maxLines: 1, overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(color: Colors.black54)),
                ])),
              ],
            ),
    );
  }

  void _showMoodDetail(BuildContext context, int day, MoodModel data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _getDayColor(data.emoji),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _getMoodImage(data.emoji, size: 80), 
          const SizedBox(height: 15),
          Text('Tanggal $day ${_getMonthName(_moodProvider.currentMonth)}', 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Text(data.note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, 
      children: ['S', 'S', 'R', 'K', 'J', 'S', 'M'].map((d) => 
        Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))).toList()
    );
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }
}