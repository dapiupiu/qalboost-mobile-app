import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../theme/theme_service.dart';
import '../../features/auth/provider/auth_provider.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  void _showAboutDialog(
    BuildContext context,
    ThemeService themeService,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: themeService.drawerOverlayColor,
            child: AlertDialog(
              backgroundColor: themeService.drawerAboutDialogColor,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 45,
                    color: themeService.drawerAboutIconColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tentang QalBoost',
                    style: AppTextStyles.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aplikasi ini dikembangkan dengan dedikasi penuh oleh Tim Developer kami:',
                      style: AppTextStyles.bodySmall(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    _buildDeveloperTile(
                      '1',
                      'Kaka Davi Dharmawan',
                      themeService,
                      context,
                    ),
                    _buildDeveloperTile(
                      '2',
                      'Dodyk Fahlome',
                      themeService,
                      context,
                    ),
                    _buildDeveloperTile(
                      '3',
                      'Dea Alya',
                      themeService,
                      context,
                    ),
                    _buildDeveloperTile(
                      '4',
                      'Nazwa Aliya Muthmainnah Hasibuan',
                      themeService,
                      context,
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      color: themeService.drawerDividerColor,
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        '© 2026 Kelompok 1 - IK-4.',
                        style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          themeService.drawerAboutButtonColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildDeveloperTile(
    String number,
    String name,
    ThemeService themeService,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: themeService.drawerDeveloperCircleColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: AppTextStyles.bodySmall(context).copyWith(
                fontWeight: FontWeight.bold,
                color: themeService.drawerDeveloperNumberColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                name,
                style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
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
      leading: Icon(
        icon,
        color: themeService.drawerIconColor,
      ),
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
                decoration: BoxDecoration(
                  color: themeService.drawerHeaderColor,
                ),
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
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: themeService.drawerAvatarIconColor,
                  ),
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

              Divider(
                color: themeService.drawerDividerColor,
              ),

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
                leading: Icon(
                  Icons.power_settings_new,
                  color: themeService.drawerExitColor,
                ),
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