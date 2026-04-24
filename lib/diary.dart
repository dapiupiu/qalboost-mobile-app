import 'package:flutter/material.dart';

class DiaryPage extends StatelessWidget {
	const DiaryPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final sampleEntries = [
			{
				'title': 'Judul',
				'content': 'Isi......',
				'date': '30 Maret 2026',
			},
			{
				'title': 'Judul',
				'content': 'Isi......',
				'date': '30 Maret 2026',
			},
			{
				'title': 'Judul',
				'content': 'Isi......',
				'date': '30 Maret 2026',
			},
		];

		return Scaffold(
			appBar: AppBar(
				leading: IconButton(
					icon: const Icon(Icons.arrow_back),
					onPressed: () => Navigator.maybePop(context),
				),
				title: const Text('Q-Diary'),
				centerTitle: true,
				actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.book))],
			),
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Row(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Expanded(
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: const [
												Text('Your', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
												Text('Diary', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
											],
										),
									),
									Column(
										children: [
											IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_outlined)),
										],
									),
								],
							),
							const SizedBox(height: 8),
							const Divider(thickness: 1),
							const SizedBox(height: 12),
							Expanded(
								child: ListView.separated(
									itemCount: sampleEntries.length,
									separatorBuilder: (_, __) => const SizedBox(height: 12),
									itemBuilder: (context, index) {
										final e = sampleEntries[index];
										return DiaryCard(
											title: e['title']!,
											content: e['content']!,
											date: e['date']!,
										);
									},
								),
							),
							const SizedBox(height: 8),
							Center(
								child: OutlinedButton.icon(
									onPressed: () {},
									icon: const Icon(Icons.lock),
									label: const Text('Privasi Kamu Aman dan Terjaga'),
								),
							),
							const SizedBox(height: 8),
						],
					),
				),
			),
		);
	}
}

class DiaryCard extends StatelessWidget {
	final String title;
	final String content;
	final String date;

	const DiaryCard({Key? key, required this.title, required this.content, required this.date}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(12.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
						const SizedBox(height: 6),
						Text(content),
						const SizedBox(height: 8),
						Align(alignment: Alignment.centerRight, child: Text(date, style: const TextStyle(fontSize: 12))),
					],
				),
			),
		);
	}
}

