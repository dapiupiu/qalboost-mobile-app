import 'package:flutter/material.dart';
import '../../../../core/components/app_drawer.dart';

class ConsulPage extends StatelessWidget {
  const ConsulPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: BackButton(color: isDarkMode ? Colors.white : Colors.black87),
        title: Text('Q-Konsul', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('Halaman Konsultasi akan segera hadir!'),
      ),
    );
  }
}
