import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_service.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  double _buttonScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: themeService.bottomNavColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    themeService.isDarkMode ? 0.35 : 0.15,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home_rounded,
                    size: 30,
                    color: widget.currentIndex == 0
                        ? themeService.bottomNavActiveIconColor
                        : themeService.bottomNavInactiveIconColor,
                  ),
                  onPressed: () {
                    if (widget.currentIndex != 0) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                ),

                const SizedBox(width: 60),

                IconButton(
                  icon: Icon(
                    Icons.settings_rounded,
                    size: 30,
                    color: widget.currentIndex == 1
                        ? themeService.bottomNavActiveIconColor
                        : themeService.bottomNavInactiveIconColor,
                  ),
                  onPressed: () {
                    if (widget.currentIndex != 1) {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                ),
              ],
            ),
          ),

          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => setState(() => _buttonScale = 1.2),
                onTapUp: (_) {
                  setState(() => _buttonScale = 1.0);
                  Navigator.pushNamed(context, '/checker');
                },
                onTapCancel: () => setState(() => _buttonScale = 1.0),
                child: AnimatedScale(
                  scale: _buttonScale,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 115,
                    height: 115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeService.bottomNavShadowColor
                              .withOpacity(themeService.isDarkMode ? 0.35 : 0.5),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/bulan.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}