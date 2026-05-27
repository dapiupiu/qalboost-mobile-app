import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../auth/data/auth_local_data.dart'; // Import local data

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;
  final AuthLocalData _authLocalData = AuthLocalData();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4');
    _controller
        .initialize()
        .then((_) {
          setState(() {});
          _controller.play();
        })
        .catchError((error) {
          // Jika video gagal, jalankan pengecekan auth segera
          _navigateToNext();
        });

    _controller.addListener(() {
      // Jika video selesai
      if (_controller.value.position == _controller.value.duration) {
        _navigateToNext();
      }
    });
  }

  // Fungsi cerdas untuk menentukan tujuan setelah splash
  Future<void> _navigateToNext() async {
    bool isValid = await _authLocalData.isSessionValid();
    
    if (mounted) {
      if (isValid) {
        // Jika belum 5 menit, langsung ke Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Jika sudah lebih 5 menit atau belum login, ke Login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
      ),
    );
  }
}