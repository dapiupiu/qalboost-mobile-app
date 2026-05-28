import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart'; 
import '../../../core/theme/theme_service.dart';
import '../../../core/components/custom_bottom_nav.dart';
import '../../../core/notifications/notification_service.dart'; 
import '../../home/provider/home_provider.dart';
import 'edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final HomeProvider _homeProvider = HomeProvider();
  String _userEmail = "Memuat...";

  bool _notifAktif = false; 
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    
    setState(() {
      _userEmail = prefs.getString('user_email') ?? "email@gmail.com";
      _isDarkMode = Theme.of(context).brightness == Brightness.dark;
      _notifAktif = prefs.getBool('notif_active') ?? false;
    });
    await _homeProvider.loadUserData();
    if (mounted) setState(() {});
  }

  // --- LOGIKA NOTIFIKASI PRESENTASI ---
  Future<void> _toggleNotification(bool val) async {
    if (val) {
      var status = await Permission.notification.request();

      if (status.isGranted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notif_active', true);
        
        if (!mounted) return;
        setState(() => _notifAktif = true);

        String namaUser = _homeProvider.userName;
        if (namaUser == "Memuat..." || namaUser.isEmpty) {
          namaUser = "User";
        }
        
        await NotificationService().schedulePresentationNotifs(namaUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Halo $namaUser, simulasi dimulai!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin notifikasi ditolak.')),
          );
        }
        await openAppSettings();
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notif_active', false);
      if (!mounted) return;
      setState(() => _notifAktif = false);
      await NotificationService().cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // --- BACKGROUND DISAMAKAN DENGAN CHECKER.DART ---
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileCard(isDarkMode),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
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
                    _roundedExpansion(
                      icon: Icons.notifications,
                      title: 'Notifikasi',
                      children: [
                        SwitchListTile(
                          title: const Text('Aktifkan Notifikasi'),
                          subtitle: const Text('Notifikasi akan muncul setiap 15 detik'),
                          value: _notifAktif,
                          activeTrackColor: const Color(0xFF58A6F0),
                          onChanged: (val) => _toggleNotification(val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      icon: Icons.palette,
                      title: 'Preferensi',
                      children: [
                        SwitchListTile(
                          title: const Text('Mode Malam (Dark Mode)'),
                          value: _isDarkMode,
                          activeTrackColor: const Color(0xFF58A6F0),
                          onChanged: (val) {
                            setState(() => _isDarkMode = val);
                            ThemeService().setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              ).then((_) => _loadSettings());
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
              await NotificationService().cancelAll();
              await prefs.clear();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
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