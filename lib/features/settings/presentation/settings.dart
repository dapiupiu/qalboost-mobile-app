import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/components/custom_bottom_nav.dart';
import '../../home/provider/home_provider.dart';
import 'edit_profile_page.dart'; // Import halaman edit profil baru

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final HomeProvider _homeProvider = HomeProvider();
  String _userEmail = "Memuat...";

  bool _notifAktif = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? "email@gmail.com";
      _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    });
    await _homeProvider.loadUserData();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:isDarkMode ? const Color(0xFF2B2420) : const Color(0xFFFFE0C6),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Profile Card ---
              _buildProfileCard(isDarkMode),

              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    // --- FAQ Section (Dropdown Berjenjang) ---
                    _roundedExpansion(
                      icon: Icons.question_answer,
                      title: 'FAQ',
                      children: [
                        _buildNestedFAQ(
                          'Bagaimana cara simpan mood?',
                          'Buka menu Q-Checker di navigasi bawah (ikon bulan), pilih mood kamu, tulis cerita singkat, lalu klik simpan.'
                        ),
                        _buildNestedFAQ(
                          'Apakah data saya aman?',
                          'Tentu! QalBoost menyimpan data kamu secara lokal di perangkat dan terenkripsi berdasarkan akun loginmu.'
                        ),
                        _buildNestedFAQ(
                          'Bagaimana cara melihat riwayat?',
                          'Klik "Buka Kalender" di halaman Home atau klik tab Mood Tracker untuk melihat grafik perasaanmu.'
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // --- Notifikasi ---
                    _roundedExpansion(
                      icon: Icons.notifications,
                      title: 'Notifikasi',
                      children: [
                        SwitchListTile(
                          title: const Text('Aktifkan Notifikasi'),
                          subtitle: const Text('Dapatkan pengingat untuk mengisi mood harian'),
                          value: _notifAktif,
                          onChanged: (val) => setState(() => _notifAktif = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // --- Preferensi (Dark Mode) ---
                    _roundedExpansion(
                      icon: Icons.palette,
                      title: 'Preferensi',
                      children: [
                        SwitchListTile(
                          title: const Text('Mode Malam (Dark Mode)'),
                          value: _isDarkMode,
                          onChanged: (val) {
                            setState(() => _isDarkMode = val);
                            ThemeService().setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // --- Logout Button ---
                    _buildLogoutButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  // Widget FAQ dengan dropdown di dalam dropdown
  Widget _buildNestedFAQ(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(answer, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
        ),
      ],
    );
  }

  Widget _buildProfileCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFFFEFD6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36, 
            backgroundColor: Colors.white, 
            child: Icon(Icons.person, size: 40, color: Color(0xFF58A6F0))
          ),
          const SizedBox(height: 12),
          Text(_homeProvider.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_userEmail, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // Navigasi ke halaman Edit Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              ).then((_) => _loadSettings()); // Refresh data saat kembali dari edit
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? const Color(0xFF2F2F2F) : Colors.white,
              foregroundColor: isDarkMode ? Colors.white : Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout),
        label: const Text('Keluar Akun'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB5757),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _roundedExpansion({required IconData icon, required String title, required List<Widget> children}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          iconColor: const Color(0xFF58A6F0),
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2F2F2F) : const Color(0xFFFFF7C2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: isDarkMode ? Colors.white : Colors.black87),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          children: children,
        ),
      ),
    );
  }
}