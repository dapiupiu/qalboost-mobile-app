import 'package:flutter/material.dart';

class QuotesSimpleScreen extends StatelessWidget {
  final String headerTitle;
  final String headerSubtitle;
  final String avatarLabel;
  final String contentText;

  const QuotesSimpleScreen({
    Key? key,
    this.headerTitle = 'Hari ini...',
    this.headerSubtitle = 'Pelan-pelan kita perbaiki ya dengerin dulu yuk...',
    this.avatarLabel = 'P',
    this.contentText = 'Orang itu wajar kalau sedih tapi ketika sudah sedih sepatutnya ia berdoa',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Q-Quotes'),
        centerTitle: true,
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.info_outline))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header text block
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headerTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(headerSubtitle, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            // Card with avatar and content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar / image placeholder (large rounded rectangle)
                      Container(
                        width: double.infinity,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 44,
                            child: Text(avatarLabel, style: const TextStyle(fontSize: 36)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Content card below image
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contentText, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 12),

                            // Media controls row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.favorite_border),
                                    SizedBox(width: 12),
                                    Icon(Icons.share),
                                  ],
                                ),

                                // Play controls
                                Row(
                                  children: const [
                                    Icon(Icons.skip_previous),
                                    SizedBox(width: 8),
                                    CircleAvatar(
                                      radius: 20,
                                      child: Icon(Icons.play_arrow),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.skip_next),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom swipe hint
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: const [
                  Text('swipe', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
