import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifAktif = true;
  bool _notifReminder = false;
  bool _notifUpdate = true;

  String _selectedTheme = 'light';
  String _selectedFrequency = 'daily';

  Set<String> _selectedLanguages = {'id'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.black87)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFD6),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nama Pengguna',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pengguna@gmail.com',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit Profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content list
              Expanded(
                child: ListView(
                  children: [
                    _roundedExpansion(
                      icon: Icons.question_answer,
                      title: 'FAQ',
                      children: const [
                        ListTile(title: Text('Pertanyaan 1 - Jawaban singkat')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      icon: Icons.notifications,
                      title: 'Notifikasi',
                      children: [
                        CheckboxListTile(
                          title: const Text('Aktifkan Notifikasi'),
                          value: _notifAktif,
                          onChanged: (bool? value) =>
                              setState(() => _notifAktif = value ?? false),
                        ),
                        CheckboxListTile(
                          title: const Text('Reminder Harian'),
                          value: _notifReminder,
                          onChanged: (bool? value) =>
                              setState(() => _notifReminder = value ?? false),
                        ),
                        CheckboxListTile(
                          title: const Text('Update & Berita'),
                          value: _notifUpdate,
                          onChanged: (bool? value) =>
                              setState(() => _notifUpdate = value ?? false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      icon: Icons.phone,
                      title: 'Contact Person',
                      children: const [
                        ListTile(title: Text('Kontak 1 - 0812xxxxxxx')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      icon: Icons.palette,
                      title: 'Preferensi',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tema:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              RadioListTile<String>(
                                title: const Text('Terang (Light)'),
                                value: 'light',
                                groupValue: _selectedTheme,
                                onChanged: (String? value) => setState(
                                  () => _selectedTheme = value ?? 'light',
                                ),
                              ),
                              RadioListTile<String>(
                                title: const Text('Gelap (Dark)'),
                                value: 'dark',
                                groupValue: _selectedTheme,
                                onChanged: (String? value) => setState(
                                  () => _selectedTheme = value ?? 'dark',
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Frekuensi Notifikasi:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              RadioListTile<String>(
                                title: const Text('Harian'),
                                value: 'daily',
                                groupValue: _selectedFrequency,
                                onChanged: (String? value) => setState(
                                  () => _selectedFrequency = value ?? 'daily',
                                ),
                              ),
                              RadioListTile<String>(
                                title: const Text('Mingguan'),
                                value: 'weekly',
                                groupValue: _selectedFrequency,
                                onChanged: (String? value) => setState(
                                  () => _selectedFrequency = value ?? 'weekly',
                                ),
                              ),
                              RadioListTile<String>(
                                title: const Text('Tidak Pernah'),
                                value: 'never',
                                groupValue: _selectedFrequency,
                                onChanged: (String? value) => setState(
                                  () => _selectedFrequency = value ?? 'never',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _roundedExpansion(
                      icon: Icons.language,
                      title: 'Bahasa',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              FilterChip(
                                label: const Text('Indonesia'),
                                selected: _selectedLanguages.contains('id'),
                                onSelected: (bool selected) => setState(() {
                                  if (selected) {
                                    _selectedLanguages.add('id');
                                  } else {
                                    _selectedLanguages.remove('id');
                                  }
                                }),
                              ),
                              FilterChip(
                                label: const Text('English'),
                                selected: _selectedLanguages.contains('en'),
                                onSelected: (bool selected) => setState(() {
                                  if (selected) {
                                    _selectedLanguages.add('en');
                                  } else {
                                    _selectedLanguages.remove('en');
                                  }
                                }),
                              ),
                              FilterChip(
                                label: const Text('中文'),
                                selected: _selectedLanguages.contains('zh'),
                                onSelected: (bool selected) => setState(() {
                                  if (selected) {
                                    _selectedLanguages.add('zh');
                                  } else {
                                    _selectedLanguages.remove('zh');
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout),
                        label: const Text('Log out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Nav (custom)
      bottomNavigationBar: SizedBox(
        height: 72,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 72,
              color: const Color(0xFF58A6F0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                  ),
                  const SizedBox(width: 56),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Positioned(
              top: -22,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/checker'),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Center(
                        child: Text('🌙', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundedExpansion({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7C2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black87),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          children: children,
        ),
      ),
    );
  }
}
