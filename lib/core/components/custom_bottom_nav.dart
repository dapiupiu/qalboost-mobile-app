import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex; // 0 untuk Home, 1 untuk Settings

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 72,
            color: const Color(0xFF58A6F0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tombol Home
                IconButton(
                  icon: Icon(
                    Icons.home, 
                    color: currentIndex == 0 ? Colors.white : Colors.white60
                  ),
                  onPressed: () {
                    if (currentIndex != 0) {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    }
                  },
                ),
                const SizedBox(width: 56), // Ruang untuk tombol Bulan
                // Tombol Settings
                IconButton(
                  icon: Icon(
                    Icons.settings, 
                    color: currentIndex == 1 ? Colors.white : Colors.white60
                  ),
                  onPressed: () {
                    if (currentIndex != 1) {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                ),
              ],
            ),
          ),
          // Tombol Bulan (Floating di tengah)
          Positioned(
            top: -22,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Jika sudah di checker, jangan push lagi, atau sesuaikan kebutuhan
                  Navigator.pushNamed(context, '/checker');
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: const Center(
                    child: Text('🌙', style: TextStyle(fontSize: 28)),
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