import 'package:flutter/material.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../core/components/app_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.transparent,
        elevation: 0,
        leading: BackButton(color: isDarkMode ? Colors.white : Colors.black87),
        title: Text('Pengaturan', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Tema Gelap'),
            trailing: ListenableBuilder(
              listenable: themeService,
              builder: (context, child) {
                return Switch(
                  value: themeService.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeService.toggleTheme(value);
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'QalBoost',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.auto_awesome, color: Colors.blue),
                children: [
                  const Text('Aplikasi untuk membantu kesehatan mental kamu.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
