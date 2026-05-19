import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendeteksi brightness tema saat ini (Dark atau Light) secara dinamis
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // --- HEADER DRAWER (Identitas Mahasiswa diubah ke Umum) ---
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF58A6F0),
            ),
            accountName: const Text(
              'Pengguna',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            accountEmail: const Text(
              'user@q-mind.com',
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF58A6F0)),
            ),
          ),

          // --- MENU ITEMS ---
          ListTile(
            leading: Icon(
              Icons.home_outlined, 
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            title: Text(
              'Beranda', 
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context); // Tutup drawer terlebih dahulu
              // Gunakan pushReplacementNamed agar tidak menumpuk stack halaman utama
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mood_outlined, 
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            title: Text(
              'History Mood', 
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/mood');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.fact_check_outlined, 
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            title: Text(
              'Q-Checker', 
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/checker');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings_outlined, 
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            title: Text(
              'Pengaturan', 
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          
          const Divider(), // Garis pembatas antara menu utama dan sekunder

          ListTile(
            leading: Icon(
              Icons.info_outline, 
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            title: Text(
              'Tentang QalBoost', 
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context);
              // Tambahkan dialog About jika diperlukan nanti
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Keluar', 
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              // Tempatkan logika logout atau pembersihan sesi di sini
            },
          ),
        ],
      ),
    );
  }
}