import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../theme/theme_service.dart';
import '../../features/auth/provider/auth_provider.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  // -1 artinya tidak ada foto yang sedang ditekan (semua normal)
  int _selectedIndex = -1;

  void _showAboutDialog(
    BuildContext context,
    ThemeService themeService,
  ) {
    HapticFeedback.selectionClick();

    // MENAMBAHKAN DATA WHATSAPP DI SETIAP FOUNDER
    final List<Map<String, String>> founders = [
      {
        'name': 'Kaka Davi\nDharmawan',
        'role': 'Front-end Developer',
        'image': 'assets/images/founder_kaka.png',
        'direction': 'top',
        'whatsapp': '+62 852-6066-6148',
      },
      {
        'name': 'Dodyk\nFahlome',
        'role': 'Back-end Developer',
        'image': 'assets/images/founder_dodyk.png',
        'direction': 'bottom',
        'whatsapp': '+62 877-5103-2488',
      },
      {
        'name': 'Dea\nAlya',
        'role': 'UI/UX Designer',
        'image': 'assets/images/founder_dea.png',
        'direction': 'top',
        'whatsapp': '+62 838-3517-8502',
      },
      {
        'name': 'Nazwa\nAliya M.',
        'role': 'QA Engineer',
        'image': 'assets/images/founder_nazwa.png',
        'direction': 'bottom',
        'whatsapp': '+62 822-7265-8094',
      },
    ];

    // Reset status klik setiap kali dialog baru dibuka
    setState(() {
      _selectedIndex = -1;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: themeService.drawerOverlayColor,
                child: AlertDialog(
                  backgroundColor: themeService.drawerAboutDialogColor,
                  elevation: 10,
                  contentPadding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.storefront_rounded,
                              size: 45,
                              color: themeService.drawerAboutIconColor,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tentang QalBoost',
                        style: AppTextStyles.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: AnimationLimiter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Aplikasi ini dikembangkan dengan dedikasi penuh oleh Tim Developer kami:',
                            style: AppTextStyles.bodySmall(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // ================== INTERACTIVE GRID SECTION ==================
                          SizedBox(
                            height: 190,
                            child: Row(
                              children: List.generate(founders.length, (index) {
                                final founder = founders[index];
                                final isFromTop = founder['direction'] == 'top';
                                
                                int flexValue = 1;
                                if (_selectedIndex != -1) {
                                  flexValue = (_selectedIndex == index) ? 4 : 0; 
                                }

                                return AnimatedExpanded(
                                  flex: flexValue,
                                  duration: const Duration(milliseconds: 550),
                                  curve: Curves.easeOutQuint,
                                  child: _selectedIndex != -1 && _selectedIndex != index
                                      ? const SizedBox.shrink()
                                      : AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 600),
                                          child: SlideAnimation(
                                            verticalOffset: isFromTop ? -100.0 : 100.0,
                                            child: FadeInAnimation(
                                              child: GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.mediumImpact();
                                                  setDialogState(() {
                                                    _selectedIndex = (_selectedIndex == index) ? -1 : index;
                                                  });
                                                },
                                                child: _buildInteractiveCard(
                                                  context: context,
                                                  index: index,
                                                  name: founder['name']!,
                                                  role: founder['role']!,
                                                  imagePath: founder['image']!,
                                                  whatsAppNumber: founder['whatsapp']!,
                                                  themeService: themeService,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              }),
                            ),
                          ),
                          // ==============================================================

                          // ================== TAP TO SEE INDICATOR ANIMATION ============
                          const SizedBox(height: 14),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _selectedIndex == -1
                                ? _buildTapHint(context, themeService)
                                : SizedBox(
                                    key: const ValueKey('hint_close'),
                                    height: 22,
                                    child: Text(
                                      '*Ketuk kembali foto untuk menutup detail',
                                      style: AppTextStyles.bodySmall(context).copyWith(
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic,
                                        color: themeService.drawerIconColor.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                          ),
                          // ==============================================================

                          const SizedBox(height: 10),
                          Divider(color: themeService.drawerDividerColor),
                          const SizedBox(height: 5),
                          Text(
                            'Kelompok 1 — IK-4',
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: themeService.drawerAboutIconColor,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: themeService.drawerAboutButtonColor,
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Tutup',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // WIDGET PETUNJUK KETUK
  Widget _buildTapHint(BuildContext context, ThemeService themeService) {
    return Row(
      key: const ValueKey('hint_tap'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _LoopingTapIcon(),
        const SizedBox(width: 6),
        Text(
          'Ketuk foto untuk detail developer',
          style: AppTextStyles.bodySmall(context).copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: themeService.drawerIconColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  // WIDGET CARD DEVELOPER
  Widget _buildInteractiveCard({
    required BuildContext context,
    required int index,
    required String name,
    required String role,
    required String imagePath,
    required String whatsAppNumber,
    required ThemeService themeService,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          // 1. BAGIAN FOTO
          Expanded(
            flex: 2,
            child: AnimatedScale(
              scale: isSelected ? 0.92 : 1.0, 
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOutCubic,
              child: ClipRRect(
                borderRadius: isSelected
                    ? BorderRadius.circular(12)
                    : BorderRadius.horizontal(
                        left: Radius.circular(index == 0 ? 12 : 0),
                        right: Radius.circular(index == 3 ? 12 : 0),
                      ),
                child: Image.asset(
                  imagePath,
                  height: 180,
                  fit: isSelected ? BoxFit.contain : BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: themeService.drawerDeveloperCircleColor,
                      child: Icon(Icons.person, color: themeService.drawerDeveloperNumberColor),
                    );
                  },
                ),
              ),
            ),
          ),

          // 2. BAGIAN IDENTITAS + WHATSAPP
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isSelected ? MediaQuery.of(context).size.width * 0.44 : 0,
            curve: Curves.easeOutQuint,
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.close, size: 16, color: themeService.drawerIconColor.withValues(alpha: 0.5)),
                    ),
                    Text(
                      name.replaceAll('\n', ' '),
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: themeService.drawerIconColor.withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_android_rounded,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            whatsAppNumber,
                            style: AppTextStyles.bodySmall(context).copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: themeService.drawerIconColor.withValues(alpha: 0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required BuildContext context,
    required ThemeService themeService,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: themeService.drawerIconColor),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final String displayName = user?.fullName ?? 'Pengguna';
    final String displayEmail = user?.email ?? 'user@q-mind.com';

    return Drawer(
      elevation: 16.0,
      backgroundColor: themeService.drawerBackgroundColor,
      child: AnimationLimiter(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: themeService.drawerHeaderColor),
                accountName: Text(
                  displayName,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  displayEmail,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: themeService.drawerAvatarBackground,
                  child: Icon(Icons.person, size: 40, color: themeService.drawerAvatarIconColor),
                ),
              ),
              _drawerItem(
                context: context,
                themeService: themeService,
                icon: Icons.home_outlined,
                title: 'Beranda',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              _drawerItem(
                context: context,
                themeService: themeService,
                icon: Icons.mood_outlined,
                title: 'History Mood',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/mood');
                },
              ),
              _drawerItem(
                context: context,
                themeService: themeService,
                icon: Icons.fact_check_outlined,
                title: 'Q-Checker',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/checker');
                },
              ),
              _drawerItem(
                context: context,
                themeService: themeService,
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              Divider(color: themeService.drawerDividerColor),
              _drawerItem(
                context: context,
                themeService: themeService,
                icon: Icons.info_outline,
                title: 'Tentang QalBoost',
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context, themeService);
                },
              ),
              ListTile(
                leading: Icon(Icons.power_settings_new, color: themeService.drawerExitColor),
                title: Text(
                  'Keluar Aplikasi',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: themeService.drawerExitColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== HELPER WIDGET ANIMASI GENERIK ==================

class AnimatedExpanded extends StatelessWidget {
  final int flex;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedExpanded({
    super.key,
    required this.flex,
    required this.child,
    required this.duration,
    this.curve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: flex.toDouble(), end: flex.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Expanded(
          flex: (value * 10).round(),
          child: child!,
        );
      },
      child: child,
    );
  }
}

// WIDGET KUSTOM: LOOPING ANIMASI JARI KETUK (TAP INDICATOR)
class _LoopingTapIcon extends StatefulWidget {
  const _LoopingTapIcon();

  @override
  State<_LoopingTapIcon> createState() => _LoopingTapIconState();
}

class _LoopingTapIconState extends State<_LoopingTapIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true); // Loop kontinu bolak-balik
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 4), // Efek naik-turun halus (4 piksel)
          child: Transform.scale(
            scale: 1.0 + (_controller.value * 0.18), // Efek denyut membesar mengecil
            child: Icon(
              Icons.touch_app_rounded,
              size: 16,
              color: themeService.drawerAboutIconColor,
            ),
          ),
        );
      },
    );
  }
}