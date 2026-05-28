import 'dart:ui'; // WAJIB DIIMPORT UNTUK EFEK BLUR (ImageFilter)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:provider/provider.dart';
import '../../features/auth/provider/auth_provider.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  // --- FUNGSI UNTUK MENAMPILKAN POP-UP BLUR TENTANG DEVELOPER ---
  void _showAboutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      barrierDismissible: true, // User bisa menutup pop-up dengan mengetuk area luar
      builder: (BuildContext context) {
        return BackdropFilter(
          // Mengatur tingkat keburaman latar belakang (Blur)
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            // REVISI: Menggunakan .withValues(alpha: ...) menggantikan withOpacity yang deprecated
            color: Colors.black.withValues(alpha: 0.4),
            child: AlertDialog(
              backgroundColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 45,
                    color: isDarkMode ? const Color(0xFF58A6F0) : const Color(0xFF1E679F),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tentang QalBoost',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: isDarkMode ? Colors.white : Colors.black, // REVISI: Typo blackDE diperbaiki
                    ),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                      textAlign: TextAlign.center, // REVISI: Alignment.center diganti ke TextAlign.center
                    ),
                    const SizedBox(height: 20),
                    
                    // --- DAFTAR DEVELOPER ---
                    _buildDeveloperTile(context, '1', 'Kaka Davi Dharmawan', isDarkMode),
                    _buildDeveloperTile(context, '2', 'Dodyk Fahlome', isDarkMode),
                    _buildDeveloperTile(context, '3', 'Dea Alya', isDarkMode),
                    _buildDeveloperTile(context, '4', 'Nazwa Aliya Muthmainnah Hasibuan', isDarkMode),
                    
                    const SizedBox(height: 10),
                    Divider(color: isDarkMode ? Colors.white24 : Colors.black12),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        '© 2026 Kelompok 1 - IK-4.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white38 : Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF58A6F0),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
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
  }

  // Widget pembantu untuk merender baris nama developer secara rapi
  Widget _buildDeveloperTile(BuildContext context, String number, String name, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              // REVISI: Menggunakan .withValues(alpha: ...) menggantikan withOpacity
              color: const Color(0xFF58A6F0).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF58A6F0),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              // REVISI: Menggunakan EdgeInsets.only(top: 4.0) karena EdgeInsets.top tidak valid
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87, // REVISI: Typo whiteDE diperbaiki
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Mendengarkan perubahan objek user secara reaktif (Real-time)
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final String displayName = user?.fullName ?? 'Pengguna';
    final String displayEmail = user?.email ?? 'user@q-mind.com';

    return Drawer(
      elevation: 16.0,
      backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // --- HEADER DRAWER (Dinamis) ---
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF58A6F0),
            ),
            accountName: Text(
              displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              displayEmail,
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF58A6F0)),
            ),
          ),

          // --- MENU ITEMS ---
          ListTile(
            leading: Icon(Icons.home_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('Beranda', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.mood_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('History Mood', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/mood');
            },
          ),
          ListTile(
            leading: Icon(Icons.fact_check_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('Q-Checker', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/checker');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('Pengaturan', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          
          const Divider(),

          // --- MENU TENTANG QALBOOST ---
          ListTile(
            leading: Icon(Icons.info_outline, color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('Tentang QalBoost', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
            onTap: () {
              Navigator.pop(context); 
              _showAboutDialog(context, isDarkMode); 
            },
          ),
          
          // --- TOMBOL KELUAR (HANYA KELUAR APLIKASI) ---
          ListTile(
            leading: const Icon(Icons.power_settings_new, color: Colors.redAccent),
            title: const Text(
              'Keluar Aplikasi', 
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              SystemNavigator.pop(); 
            },
          ),
        ],
      ),
    );
  }
}