import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatbotFAB extends StatefulWidget {
  const ChatbotFAB({super.key});

  @override
  State<ChatbotFAB> createState() => _ChatbotFABState();
}

class _ChatbotFABState extends State<ChatbotFAB> with SingleTickerProviderStateMixin {
  Offset _position = const Offset(300, 600);
  late AnimationController _animationController;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
        if (mounted) {
          setState(() {
            for (var i = 0; i < _particles.length; i++) {
              _particles[i].update();
              if (_particles[i].opacity <= 0) {
                _particles.removeAt(i);
              }
            }
          });
        }
      })..repeat();

    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted) {
        _particles.add(_Particle());
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, 
      children: [
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: Draggable(
            feedback: _buildTransparentLogo(opacity: 0.6),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              setState(() => _position = details.offset);
            },
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, 
              children: [
                // --- ANIMASI TANDA TANYA ---
                ..._particles.map((p) => Positioned(
                  bottom: 40 + p.y, 
                  left: 35 + p.x,   
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: p.opacity,
                      child: Text(
                        "?",
                        style: TextStyle(
                          fontSize: p.size,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )).toList(),

                // --- LOGO QALBOT ---
                _buildTransparentLogo(),

                // --- NAMA QALBOT (OVERLAY DI DEPAN LOGO BAGIAN BAWAH) ---
                Positioned(
                  bottom: 5, // Mengatur teks agar berada di area bawah logo
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      // Warna putih transparan agar logo di belakangnya tetap samar terlihat
                      color: Colors.white.withOpacity(0.7), 
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: const Text(
                      "Qalbot",
                      style: TextStyle(
                        fontSize: 11, // Ukuran agak kecil agar pas di dalam logo
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 34, 88, 181),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransparentLogo({double opacity = 1.0}) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const ChatScreen(),
          );
        },
        child: Opacity(
          opacity: opacity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shadow Tebal
              Transform.translate(
                offset: const Offset(0, 8),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Image.asset(
                    'assets/images/logo_qalbot.png',
                    width: 75,
                    height: 75,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              // Gambar Asli
              Image.asset(
                'assets/images/logo_qalbot.png',
                width: 75,
                height: 75,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.chat_bubble, size: 55, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Particle {
  double x = 0;
  double y = 0;
  double opacity = 1.0;
  double size = 16.0;
  double speedY = 1.2; 
  double speedX = (DateTime.now().millisecond % 10 - 5) / 5;

  void update() {
    y += speedY; 
    x += speedX;
    opacity -= 0.015; // Lebih cepat menghilang biar gak numpuk
    if (opacity < 0) opacity = 0;
  }
}