import 'package:flutter/material.dart';
import 'main.dart';
import 'checker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 2; // karena ini halaman Settings
  
  // ✅ Checkbox State
  bool _notifAktif = true;
  bool _notifReminder = false;
  bool _notifUpdate = true;
  
  // ✅ RadioButton State
  String _selectedTheme = 'light';
  String _selectedFrequency = 'daily';
  
  // ✅ Chip State
  Set<String> _selectedLanguages = {'id'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(radius: 36),
                      const SizedBox(height: 12),
                      const Text('Nama Pengguna',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('Pengguna@gmail.com',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit Profil'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.question_answer),
                        title: const Text('FAQ'),
                        children: const [
                          ListTile(
                              title: Text('Pertanyaan 1 - Jawaban singkat')),
                        ],
                      ),
                    ),
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notifikasi'),
                        children: [
                          CheckboxListTile(
                            title: const Text('Aktifkan Notifikasi'),
                            value: _notifAktif,
                            onChanged: (bool? value) {
                              setState(() => _notifAktif = value ?? false);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Reminder Harian'),
                            value: _notifReminder,
                            onChanged: (bool? value) {
                              setState(() => _notifReminder = value ?? false);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Update & Berita'),
                            value: _notifUpdate,
                            onChanged: (bool? value) {
                              setState(() => _notifUpdate = value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Contact Person'),
                        children: const [
                          ListTile(title: Text('Kontak 1 - 0812xxxxxxx')),
                        ],
                      ),
                    ),
                    
                    // ✅ Preferences dengan RadioButton
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.palette),
                        title: const Text('Preferensi'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tema:', style: TextStyle(fontWeight: FontWeight.bold)),
                                RadioListTile<String>(
                                  title: const Text('Terang (Light)'),
                                  value: 'light',
                                  groupValue: _selectedTheme,
                                  onChanged: (String? value) {
                                    setState(() => _selectedTheme = value ?? 'light');
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('Gelap (Dark)'),
                                  value: 'dark',
                                  groupValue: _selectedTheme,
                                  onChanged: (String? value) {
                                    setState(() => _selectedTheme = value ?? 'dark');
                                  },
                                ),
                                const SizedBox(height: 12),
                                const Text('Frekuensi Notifikasi:', style: TextStyle(fontWeight: FontWeight.bold)),
                                RadioListTile<String>(
                                  title: const Text('Harian'),
                                  value: 'daily',
                                  groupValue: _selectedFrequency,
                                  onChanged: (String? value) {
                                    setState(() => _selectedFrequency = value ?? 'daily');
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('Mingguan'),
                                  value: 'weekly',
                                  groupValue: _selectedFrequency,
                                  onChanged: (String? value) {
                                    setState(() => _selectedFrequency = value ?? 'weekly');
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('Tidak Pernah'),
                                  value: 'never',
                                  groupValue: _selectedFrequency,
                                  onChanged: (String? value) {
                                    setState(() => _selectedFrequency = value ?? 'never');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // ✅ Bahasa dengan Chip
                    Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Bahasa'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                FilterChip(
                                  label: const Text('Indonesia'),
                                  selected: _selectedLanguages.contains('id'),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedLanguages.add('id');
                                      } else {
                                        _selectedLanguages.remove('id');
                                      }
                                    });
                                  },
                                ),
                                FilterChip(
                                  label: const Text('English'),
                                  selected: _selectedLanguages.contains('en'),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedLanguages.add('en');
                                      } else {
                                        _selectedLanguages.remove('en');
                                      }
                                    });
                                  },
                                ),
                                FilterChip(
                                  label: const Text('中文'),
                                  selected: _selectedLanguages.contains('zh'),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedLanguages.add('zh');
                                      } else {
                                        _selectedLanguages.remove('zh');
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout),
                        label: const Text('Log out'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Bottom Nav Konsisten
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckerSimpleScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: 'Q-Checker'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}