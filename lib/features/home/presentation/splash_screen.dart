import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // IMPORT PROVIDER UNTUK MENGAKSES STATE MANAGEMENT
import 'package:video_player/video_player.dart';
import '../../auth/data/auth_local_data.dart'; 
import '../../auth/provider/auth_provider.dart'; // IMPORT AUTH_PROVIDER

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
          // Jika video gagal dimuat/error, jalankan pengecekan auth segera agar aplikasi tidak stuck
          _navigateToNext();
        });

    _controller.addListener(() {
      // Jika durasi video sudah habis/selesai diputar
      if (_controller.value.position == _controller.value.duration) {
        _navigateToNext();
      }
    });
  }

  // Fungsi penentu arah navigasi sekaligus pemulih kondisi state user
  Future<void> _navigateToNext() async {
    // Memeriksa kevalidan durasi token/sesi yang tersimpan di local storage HP
    bool isValid = await _authLocalData.isSessionValid();
    
    if (mounted) {
      if (isValid) {
        // TAHAP PENTING: Mengisi kembali data user dari local ke RAM Provider sebelum masuk ke HomePage
        await context.read<AuthProvider>().restoreSession();

        // Pastikan widget masih aktif di dalam struktur widget tree sebelum pindah halaman
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Jika sesi kadaluarsa/belum login, bersihkan sisa instans lalu arahkan ke login
        await context.read<AuthProvider>().logout();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Mematikan controller video agar tidak memicu memory leak
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