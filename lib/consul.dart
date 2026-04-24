import 'package:flutter/material.dart';

class ConsulPage extends StatelessWidget {
  const ConsulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final advisors = List.generate(
        6,
        (i) => {
              'name': 'Nama Ustadz',
              'title': 'Gelar',
              'status': 'Online',
              'percent': '100%'
            });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Q-Qonsul'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Kamu bisa ngobrol dan bertanya dengan ustadz di sini',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),

              // Search field (no fancy styling)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Ustadz di sini',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),

              const SizedBox(height: 16),
              const Text('Pilih Ustadz untuk Konsultasi'),
              const SizedBox(height: 12),

              // Grid of advisor cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: advisors.map((a) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(radius: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(a['name']!),
                                      Text(
                                        a['title']!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Status: ${a['status']}'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.thumb_up, size: 14),
                                const SizedBox(width: 6),
                                Text(a['percent']!),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Mulai Konsultasi'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Privacy banner at bottom
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_outline, size: 16),
                    SizedBox(width: 8),
                    Text('Privasi Kamu Aman dan Terjaga'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// To preview this page, use `ConsulPage()` from your app's existing
// `main.dart` or a temporary test harness.
