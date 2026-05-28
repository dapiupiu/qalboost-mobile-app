import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
      _isDarkMode = ThemeService().isDarkMode;
      _notifAktif = prefs.getBool('notif_active') ?? false;
    });

    await _homeProvider.loadUserData();

    if (mounted) setState(() {});
  }

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
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      appBar: AppBar(
        backgroundColor:
            themeService.isDarkMode ? const Color(0xFF1E1E1E) : Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeService.iconColor,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: themeService.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileCard(themeService),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _roundedExpansion(
                      themeService: themeService,
                      icon: Icons.question_answer,
                      title: 'FAQ',
                      children: [
                        _buildNestedFAQ(
                          themeService,
                          'Bagaimana cara simpan mood?',
                          'Buka menu Q-Checker di navigasi bawah (ikon bulan), pilih mood kamu, tulis cerita singkat, lalu klik simpan.',
                        ),
                        _buildNestedFAQ(
                          themeService,
                          'Apakah data saya aman?',
                          'Tentu! QalBoost menyimpan data kamu secara lokal di perangkat dan terenkripsi berdasarkan akun loginmu.',
                        ),
                        _buildNestedFAQ(
                          themeService,
                          'Bagaimana cara melihat riwayat?',
                          'Klik "Buka Kalender" di halaman Home atau klik tab Mood Tracker untuk melihat grafik perasaanmu.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      themeService: themeService,
                      icon: Icons.notifications,
                      title: 'Notifikasi',
                      children: [
                        SwitchListTile(
                          title: Text(
                            'Aktifkan Notifikasi',
                            style: TextStyle(
                              color: themeService.textPrimaryColor,
                            ),
                          ),
                          subtitle: Text(
                            'Notifikasi akan muncul setiap 15 detik',
                            style: TextStyle(
                              color: themeService.textSecondaryColor,
                            ),
                          ),
                          value: _notifAktif,
                          activeTrackColor: themeService.primaryColor,
                          activeColor: themeService.isDarkMode
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          onChanged: (val) => _toggleNotification(val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      themeService: themeService,
                      icon: Icons.palette,
                      title: 'Preferensi',
                      children: [
                        SwitchListTile(
                          title: Text(
                            'Mode Malam (Dark Mode)',
                            style: TextStyle(
                              color: themeService.textPrimaryColor,
                            ),
                          ),
                          value: _isDarkMode,
                          activeTrackColor: themeService.primaryColor,
                          activeColor: themeService.isDarkMode
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          onChanged: (val) {
                            setState(() => _isDarkMode = val);
                            themeService.setThemeMode(
                              val ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildLogoutButton(themeService),
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

  Widget _buildNestedFAQ(
    ThemeService themeService,
    String question,
    String answer,
  ) {
    return ExpansionTile(
      iconColor: themeService.primaryColor,
      collapsedIconColor: themeService.textSecondaryColor,
      title: Text(
        question,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: themeService.textPrimaryColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            answer,
            style: TextStyle(
              color: themeService.textSecondaryColor,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(ThemeService themeService) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeService.settingsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              themeService.isDarkMode ? 0.35 : 0.12,
            ),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor:
                themeService.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: themeService.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _homeProvider.userName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeService.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail,
            style: TextStyle(
              fontSize: 12,
              color: themeService.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              ).then((_) => _loadSettings());
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  themeService.isDarkMode ? const Color(0xFF2F2F2F) : Colors.white,
              foregroundColor: themeService.textPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout),
        label: const Text('Keluar Akun'),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeService.settingsLogoutColor,
          foregroundColor: themeService.settingsLogoutTextColor,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: themeService.isDarkMode ? 0 : 2,
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final themeService = ThemeService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeService.dialogBackgroundColor,
        title: Text(
          'Logout',
          style: TextStyle(
            color: themeService.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin keluar dari akun?',
          style: TextStyle(
            color: themeService.textPrimaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: themeService.textSecondaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await NotificationService().cancelAll();
              await prefs.clear();

              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Ya, Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundedExpansion({
    required ThemeService themeService,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: themeService.settingsExpansionColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeService.isDarkMode
              ? Colors.white.withOpacity(0.06)
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              themeService.isDarkMode ? 0.28 : 0.10,
            ),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          iconColor: themeService.primaryColor,
          collapsedIconColor: themeService.textSecondaryColor,
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: themeService.settingsIconBoxColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: themeService.isDarkMode
                  ? Colors.white
                  : const Color(0xFF1F1B18),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: themeService.textPrimaryColor,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}