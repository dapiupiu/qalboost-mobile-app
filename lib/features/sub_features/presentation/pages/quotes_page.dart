import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/components/app_drawer.dart';
import '../../../../core/components/tutorial_item.dart';
import '../../../../core/components/qh_rect.dart';
import 'package:animations/animations.dart';

class QuotesSimpleScreen extends StatefulWidget {
  final String headerTitle;
  final String headerSubtitle;
  final String contentText;

  const QuotesSimpleScreen({
    Key? key,
    this.headerTitle = 'Hari ini...',
    this.headerSubtitle = 'Pelan-pelan kita perbaiki ya dengerin dulu yuk...',
    this.contentText =
        'Orang itu wajar kalau sedih tapi ketika sudah sedih sepatutnya ia berdoa',
  }) : super(key: key);

  @override
  State<QuotesSimpleScreen> createState() => _QuotesSimpleScreenState();
}

class _QuotesSimpleScreenState extends State<QuotesSimpleScreen> {
  double _position = 0.2;
  bool _isPlaying = false;

  void _togglePlay() {
    HapticFeedback.mediumImpact();
    setState(() => _isPlaying = !_isPlaying);
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
        title: const Text('Q-Quotes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                _showTutorial(context);
              },
              child: Image.asset(
                'assets/images/menu_quotes.png',
                width: 28,
                height: 28,
                errorBuilder: (c, e, s) => const Icon(Icons.info_outline),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // Header area
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.headerTitle,
                            style: textTheme.displayLarge?.copyWith(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.headerSubtitle,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'mood_moon',
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/moon_large.png',
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Center(
                            child: Text('🌙', style: TextStyle(fontSize: 48)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Main card with transition
                Center(
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey(_isPlaying),
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QHRect(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    color: colorScheme.surfaceVariant
                                        .withOpacity(0.3),
                                    height: 280,
                                    width: double.infinity,
                                    child: Image.asset(
                                      'assets/images/ustadz_avatar.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Center(
                                        child: CircleAvatar(
                                          radius: 60,
                                          child: Text(
                                            'U',
                                            style: TextStyle(fontSize: 48),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_isPlaying)
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.graphic_eq,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'PLAYING',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(32),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  widget.contentText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          HapticFeedback.lightImpact(),
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              HapticFeedback.lightImpact(),
                                          icon: const Icon(
                                            Icons.skip_previous_rounded,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: _togglePlay,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _isPlaying
                                                  ? Icons.pause_rounded
                                                  : Icons.play_arrow_rounded,
                                              color: colorScheme.primary,
                                              size: 36,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () =>
                                              HapticFeedback.lightImpact(),
                                          icon: const Icon(
                                            Icons.skip_next_rounded,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          HapticFeedback.lightImpact(),
                                      icon: const Icon(
                                        Icons.file_download_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.white
                                        .withOpacity(0.3),
                                    thumbColor: Colors.white,
                                    overlayColor: Colors.white.withOpacity(0.1),
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: _position,
                                    onChanged: (v) {
                                      HapticFeedback.selectionClick();
                                      setState(() => _position = v);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      Text(
                        'swipe down for next quote',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    child: const Icon(
                      Icons.tips_and_updates,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Tutorial',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const TutorialItem(
                icon: Icons.play_circle_fill,
                title: 'Play',
                desc: 'Tekan untuk memutar audio quotes yang menenangkan.',
              ),
              const TutorialItem(
                icon: Icons.swipe_vertical,
                title: 'Swipe',
                desc: 'Geser ke bawah untuk menemukan inspirasi baru.',
              ),
              const TutorialItem(
                icon: Icons.favorite,
                title: 'Favorite',
                desc: 'Simpan kata-kata yang menyentuh hatimu.',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Saya Mengerti',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
