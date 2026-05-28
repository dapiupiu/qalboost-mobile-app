import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/theme_service.dart';
import '../../../core/components/app_drawer.dart';

// ================= MODEL =================

class QuoteModel {
  final String videoPath;
  final String contentText;

  QuoteModel({
    required this.videoPath,
    required this.contentText,
  });
}

// ================= SCREEN =================

class QuotesSimpleScreen extends StatefulWidget {
  final String headerTitle;
  final String headerSubtitle;

  const QuotesSimpleScreen({
    super.key,
    this.headerTitle = 'Hari ini...',
    this.headerSubtitle = 'Pelan-pelan kita perbaiki ya...',
  });

  @override
  State<QuotesSimpleScreen> createState() => _QuotesSimpleScreenState();
}

class _QuotesSimpleScreenState extends State<QuotesSimpleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  late PageController _pageController;

  final List<QuoteModel> _quotesData = [
    QuoteModel(
      videoPath: 'assets/videos/quote_1.mp4',
      contentText:
          'Orang itu wajar kalau sedih, tapi ketika sudah sedih sepatutnya ia berdoa.',
    ),
    QuoteModel(
      videoPath: 'assets/videos/quote_2.mp4',
      contentText:
          'Jangan menyerah ketika doamu belum dikabulkan. Allah tahu waktu yang tepat.',
    ),
    QuoteModel(
      videoPath: 'assets/videos/quote_3.mp4',
      contentText:
          'Kunci ketenangan hati adalah dengan selalu bersyukur atas apa yang dimiliki.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 1.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showTutorial(BuildContext context) {
    final themeService =
        Provider.of<ThemeService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeService.dialogBackgroundColor,
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
                'Cara Menggunakan Q-Quotes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeService.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 20),

              _tutorialItem(
                Icons.swipe_outlined,
                'Swipe',
                'Geser ke kanan atau kiri untuk melihat quotes video lainnya.',
                themeService,
              ),

              _tutorialItem(
                Icons.play_circle_outline,
                'Play/Pause',
                'Ketuk video untuk memulai atau menghentikan video.',
                themeService,
              ),

              _tutorialItem(
                Icons.replay_10_rounded,
                'Replay',
                'Gunakan tombol replay untuk mengulang 10 detik sebelumnya.',
                themeService,
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeService.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Mengerti',
                    style: TextStyle(
                      color: themeService.buttonTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tutorialItem(
    IconData icon,
    String title,
    String desc,
    ThemeService themeService,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeService.primaryColor,
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
                    color: themeService.textPrimaryColor,
                  ),
                ),

                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
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
    final themeService = Provider.of<ThemeService>(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeService.backgroundColor,
      drawer: const CustomAppDrawer(),

      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: screenWidth * 0.15,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeService.iconColor,
            size: 22,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Q-Quotes',
          style: TextStyle(
            color: themeService.textPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.info_outline,
                color: themeService.textSecondaryColor,
              ),
              onPressed: () => _showTutorial(context),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) {
            if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
              if (details.delta.dx < -2) {
                Navigator.pop(context);
              }
            }
          },
          child: Column(
            children: [
              // HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.headerTitle,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color:
                                  themeService.textPrimaryColor,
                            ),
                          ),

                          Text(
                            widget.headerSubtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeService
                                  .textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Image.asset(
                      'assets/images/quotes.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
              ),

              // PAGEVIEW
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics:
                      const BouncingScrollPhysics(),
                  itemCount: _quotesData.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;

                        if (_pageController
                            .position.haveDimensions) {
                          value =
                              _pageController.page! - index;

                          value = (1 -
                                  (value.abs() * 0.2))
                              .clamp(0.0, 1.0);
                        }

                        return Transform.scale(
                          scale: Curves.easeInOut
                              .transform(value),
                          child: child,
                        );
                      },
                      child: QHVideoCard(
                        quote: _quotesData[index],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  '← swipe left/right →',
                  style: TextStyle(
                    color:
                        themeService.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= VIDEO CARD =================

class QHVideoCard extends StatefulWidget {
  final QuoteModel quote;

  const QHVideoCard({
    super.key,
    required this.quote,
  });

  @override
  State<QHVideoCard> createState() => _QHVideoCardState();
}

class _QHVideoCardState extends State<QHVideoCard> {
  late VideoPlayerController _controller;

  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      widget.quote.videoPath,
    );

    _initializeVideoPlayerFuture =
        _controller.initialize().then((_) {
      if (mounted) setState(() {});
    });

    _controller.setLooping(true);

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rewind10Seconds() {
    final currentPos = _controller.value.position;

    final newPos =
        currentPos - const Duration(seconds: 10);

    _controller.seekTo(
      newPos < Duration.zero
          ? Duration.zero
          : newPos,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: themeService.quotesCardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              themeService.isDarkMode ? 0.35 : 0.1,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          // VIDEO
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FutureBuilder(
                      future:
                          _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return GestureDetector(
                            onTap: () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            },
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller
                                    .value.size.width,
                                height: _controller
                                    .value.size.height,
                                child: VideoPlayer(
                                    _controller),
                              ),
                            ),
                          );
                        }

                        return Center(
                          child:
                              CircularProgressIndicator(
                            color:
                                themeService.primaryColor,
                          ),
                        );
                      },
                    ),

                    if (!_controller.value.isPlaying)
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            padding:
                                const EdgeInsets.all(10),
                            decoration:
                                const BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // CONTROL PANEL
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  themeService.quotesControlColor,
              borderRadius:
                  const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.quote.contentText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                SliderTheme(
                  data:
                      SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape:
                        const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                  ),
                  child: Slider(
                    value: _controller
                        .value.position.inMilliseconds
                        .toDouble(),
                    max: _controller
                        .value.duration.inMilliseconds
                        .toDouble(),
                    onChanged: (v) {
                      _controller.seekTo(
                        Duration(
                          milliseconds: v.toInt(),
                        ),
                      );
                    },
                    activeColor: Colors.white,
                    inactiveColor:
                        themeService.quotesSliderInactive,
                  ),
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.replay_10_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _rewind10Seconds,
                    ),

                    const SizedBox(width: 20),

                    GestureDetector(
                      onTap: () {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            themeService
                                .quotesButtonColor,
                        radius: 25,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_rounded
                              : Icons
                                  .play_arrow_rounded,
                          color: themeService
                              .quotesButtonIconColor,
                          size: 35,
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    IconButton(
                      icon: Icon(
                        _controller.value.isLooping
                            ? Icons
                                .all_inclusive_rounded
                            : Icons
                                .arrow_right_alt_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.setLooping(
                            !_controller
                                .value.isLooping,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}