import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
              // Profile card
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

              // Expansion sections
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
                        children: const [
                          ListTile(title: Text('Atur notifikasi di sini')),
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

                    const SizedBox(height: 12),
                    // Logout button
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

      // Bottom navigation mimic
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              // center moon mascot placeholder
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.brightness_3)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}
