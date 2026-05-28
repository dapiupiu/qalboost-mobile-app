import 'package:flutter/material.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../core/components/app_drawer.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();
    final settingsProvider = SettingsProvider();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: BackButton(color: isDarkMode ? Colors.white : Colors.black87),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([themeService, settingsProvider]),
        builder: (context, child) {
          return ListView(
            children: [
              _buildSectionHeader(theme, 'Tampilan'),
              ListTile(
                title: const Text('Tema Gelap'),
                subtitle: const Text('Gunakan tema gelap untuk mengurangi kelelahan mata'),
                trailing: Switch(
                  value: themeService.themeMode == ThemeMode.dark,
                  onChanged: (value) => themeService.toggleTheme(value),
                ),
              ),
              const Divider(),
              _buildSectionHeader(theme, 'Pengingat'),
              ListTile(
                title: const Text('Notifikasi Harian'),
                subtitle: const Text('Dapatkan pengingat untuk cek mood kamu'),
                trailing: Switch(
                  value: settingsProvider.isNotificationEnabled,
                  onChanged: (value) => settingsProvider.toggleNotification(value),
                ),
              ),
              if (settingsProvider.isNotificationEnabled)
                ListTile(
                  title: const Text('Waktu Pengingat'),
                  subtitle: Text(
                    'Pukul ${settingsProvider.notificationTime.format(context)}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: settingsProvider.notificationTime,
                    );
                    if (picked != null) {
                      settingsProvider.updateNotificationTime(picked);
                    }
                  },
                ),
              const Divider(),
              _buildSectionHeader(theme, 'Informasi'),
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
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
