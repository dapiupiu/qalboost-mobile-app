import 'package:flutter/material.dart';

// Asset image paths used here:
// - assets/images/moon_small.png      (top-right moon graphic)
// - assets/images/ustadz_avatar.png   (fallback avatar image)
// Add them to `pubspec.yaml` under `flutter/assets:` before using.

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
        'percent': '100%',
      },
    );

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

              // Title row: large text left, moon image right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kamu bisa ngobrol dan bertanya dengan ustadz di sini',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  // moon graphic aligned to top-right
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 96,
                      height: 96,
                      child: Image.asset(
                        'assets/images/moon_small.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(
                          child: Text('🌙', style: TextStyle(fontSize: 42)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Search field using Row to show rounded input
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Ustadz di sini',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  childAspectRatio: 0.9,
                  children: advisors.map((a) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7EAF8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // top row: avatar + name/title
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/images/ustadz_avatar.png',
                                  width: 30,
                                  height: 30,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      a['title']!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // status and percent (column)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Status:',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    a['status']!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.thumb_up, size: 14),
                                  const SizedBox(width: 6),
                                  Text(a['percent']!),
                                ],
                              ),
                            ],
                          ),

                          const Spacer(),

                          // mulai konsultasi button (small rounded)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEFD6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Mulai Konsultasi',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Privacy banner at bottom
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade700),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_outline, size: 16, color: Colors.green),
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
