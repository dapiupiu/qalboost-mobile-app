import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_service.dart';
import '../provider/mood_provider.dart';
import '../model/mood_model.dart';
import '../../../core/components/app_drawer.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

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

  Color _getDayColor(String? emoji, ThemeService themeService) {
    if (emoji == '😊') return themeService.moodPageGoodDayColor;
    if (emoji == '😢') return themeService.moodPageBadDayColor;
    return themeService.moodPageEmptyDayColor;
  }

  Color _getDayBorderColor(String? emoji, ThemeService themeService) {
    if (emoji == '😊') return themeService.moodPageGoodBorderColor;
    if (emoji == '😢') return themeService.moodPageBadBorderColor;
    return Colors.transparent;
  }

  Widget _getMoodImage(String? emoji, {double size = 20}) {
    if (emoji == '😊') {
      return Image.asset(
        'assets/images/baik.png',
        width: size,
        height: size,
        cacheWidth: (size * 3).toInt(),
      );
    } else if (emoji == '😢') {
      return Image.asset(
        'assets/images/buruk.png',
        width: size,
        height: size,
        cacheWidth: (size * 3).toInt(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildStyledEmoji(String emoji) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: 20,
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    final firstDay = DateTime(
      _moodProvider.currentYear,
      _moodProvider.currentMonth,
      1,
    );

    final daysInMonth = DateTime(
      _moodProvider.currentYear,
      _moodProvider.currentMonth + 1,
      0,
    ).day;

    final startWeekday = firstDay.weekday;

    final List<int?> days = List.generate(42, (index) {
      final dayNum = index - (startWeekday - 1) + 1;
      return (dayNum > 0 && dayNum <= daysInMonth) ? dayNum : null;
    });

    return Scaffold(
      backgroundColor: themeService.moodPageBackgroundColor,
      drawer: const CustomAppDrawer(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: themeService.moodPageAppBarColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: themeService.iconColor,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: themeService.iconColor,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _moodProvider.previousMonth());
              },
            ),
            Text(
              '${_getMonthName(_moodProvider.currentMonth)} ${_moodProvider.currentYear}',
              style: AppTextStyles.titleMedium(context),
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: themeService.iconColor,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _moodProvider.nextMonth());
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildWeekdayHeader(themeService),
              const SizedBox(height: 10),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimationLimiter(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final dayNum = days[index];

                          if (dayNum == null) {
                            return const SizedBox.shrink();
                          }

                          final dateKey =
                              "${_moodProvider.currentYear}-${_moodProvider.currentMonth.toString().padLeft(2, '0')}-${dayNum.toString().padLeft(2, '0')}";

                          final MoodModel? moodData =
                              _moodProvider.userMoods.cast<MoodModel?>().firstWhere(
                                    (m) => m?.dateKey == dateKey,
                                    orElse: () => null,
                                  );

                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 7,
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: FadeInAnimation(
                                child: _buildDayCell(
                                  context,
                                  dayNum,
                                  moodData,
                                  themeService,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              Builder(
                builder: (innerContext) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      Scaffold.of(innerContext).openDrawer();
                      return false;
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      color: Colors.transparent,
                    ),
                  );
                },
              ),

              _buildTodayRecap(themeService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    int day,
    MoodModel? data,
    ThemeService themeService,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (data != null) {
          _showMoodDetail(context, day, data, themeService);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: data != null
              ? _getDayColor(data.emoji, themeService)
              : themeService.moodPageEmptyDayColor,
          borderRadius: BorderRadius.circular(10),
          border: data != null
              ? Border.all(
                  color: _getDayBorderColor(data.emoji, themeService),
                  width: 1,
                )
              : Border.all(
                  color: themeService.isDarkMode
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.transparent,
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: themeService.isDarkMode ? 0.20 : 0.04,
              ),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: AppTextStyles.bodySmall(context).copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (data != null) _buildStyledEmoji(data.emoji),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayRecap(ThemeService themeService) {
    final now = DateTime.now();

    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final MoodModel? data =
        _moodProvider.userMoods.cast<MoodModel?>().firstWhere(
              (m) => m?.dateKey == todayKey,
              orElse: () => null,
            );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data != null
            ? _getDayColor(data.emoji, themeService)
            : themeService.moodPageEmptyDayColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: themeService.isDarkMode
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeService.isDarkMode ? 0.25 : 0.12,
            ),
            blurRadius: 4,
          ),
        ],
      ),
      child: data == null
          ? Text(
              'Belum ada mood untuk hari ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeService.moodPageRecapSubTextColor,
              ),
            )
          : Row(
              children: [
                _getMoodImage(data.emoji, size: 50),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.emoji == '😊' ? 'Mood Baik' : 'Mood Buruk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeService.moodPageRecapTextColor,
                        ),
                      ),
                      Text(
                        data.note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: themeService.moodPageRecapSubTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showMoodDetail(
    BuildContext context,
    int day,
    MoodModel data,
    ThemeService themeService,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeService.isDarkMode
          ? themeService.moodPageSheetColor
          : _getDayColor(data.emoji, themeService),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getMoodImage(data.emoji, size: 80),
            const SizedBox(height: 15),
            Text(
              'Tanggal $day ${_getMonthName(_moodProvider.currentMonth)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: themeService.moodPageRecapTextColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.note,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: themeService.moodPageRecapSubTextColor,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(ThemeService themeService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['S', 'S', 'R', 'K', 'J', 'S', 'M']
          .map(
            (d) => Text(
              d,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeService.moodPageWeekTextColor,
              ),
            ),
          )
          .toList(),
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