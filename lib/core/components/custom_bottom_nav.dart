import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex; // 0 untuk Home, 1 untuk Settings

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  // Variabel untuk mengontrol skala animasi
  double _buttonScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- BACKGROUND BAR ---
          Container(
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFF58A6F0),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tombol Home
                IconButton(
                  icon: Icon(
                    Icons.home_rounded, 
                    size: 30,
                    color: widget.currentIndex == 0 ? Colors.white : Colors.white.withValues(alpha: 0.5)
                  ),
                  onPressed: () {
                    if (widget.currentIndex != 0) {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    }
                  },
                ),
                
                const SizedBox(width: 60), // Ruang untuk maskot
                
                // Tombol Settings
                IconButton(
                  icon: Icon(
                    Icons.settings_rounded, 
                    size: 30,
                    color: widget.currentIndex == 1 ? Colors.white : Colors.white.withValues(alpha: 0.5)
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

          // --- TOMBOL MASKOT TENGAH DENGAN ANIMASI MENGEMBANG ---
          Positioned(
            top: -30, 
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                // Logika Animasi Saat Ditekan
                onTapDown: (_) => setState(() => _buttonScale = 1.2), // Mengembang ke 1.2x
                onTapUp: (_) {
                  setState(() => _buttonScale = 1.0); // Mengecil kembali
                  Navigator.pushNamed(context, '/checker');
                },
                onTapCancel: () => setState(() => _buttonScale = 1.0), // Batal tekan, kecil kembali
                
                child: AnimatedScale(
                  scale: _buttonScale,
                  duration: const Duration(milliseconds: 150), // Durasi transisi halus
                  curve: Curves.easeOutBack, // Efek membal sedikit agar keren
                  child: Container(
                    width: 115,
                    height: 115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB3E5FC).withValues(alpha: 0.5),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/bulan.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.error_outline, color: Colors.white, size: 40),
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