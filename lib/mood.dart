import 'package:flutter/material.dart';

class MoodPage extends StatelessWidget {
	const MoodPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		// Sample month grid (5 rows x 7 cols = 35 cells)
		final days = List.generate(35, (i) {
			// put some sample moods on some days
			if (i == 8 || i == 9 || i == 10 || i == 11) return {'day': i - 3, 'mood': '😢', 'label': 'Sedih'};
			if (i == 6 || i == 13) return {'day': i - 1, 'mood': null, 'label': 'Kosong'};
			if (i >= 0 && i < 7) return {'day': i + 1, 'mood': null, 'label': ''};
			return {'day': i - 6, 'mood': null, 'label': ''};
		});

		return Scaffold(
			appBar: AppBar(
				leading: IconButton(
					icon: const Icon(Icons.arrow_back),
					onPressed: () => Navigator.maybePop(context),
				),
				title: Column(
					children: const [
						Text('Kalender Mood', style: TextStyle(fontSize: 16)),
						SizedBox(height: 2),
						Text('Maret, 2026', style: TextStyle(fontSize: 12)),
					],
				),
				centerTitle: true,
				actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today))],
			),
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
					child: Column(
						children: [
							// Weekday headers
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: const [
									Expanded(child: Center(child: Text('Senin', style: TextStyle(fontSize: 12)))),
									Expanded(child: Center(child: Text('Selasa', style: TextStyle(fontSize: 12)))),
									Expanded(child: Center(child: Text('Rabu', style: TextStyle(fontSize: 12)))),
									Expanded(child: Center(child: Text('Kamis', style: TextStyle(fontSize: 12)))),
									Expanded(child: Center(child: Text('Jumat', style: TextStyle(fontSize: 12)))),
									Expanded(child: Center(child: Text('Sabtu', style: TextStyle(fontSize: 12)))),
									Expanded(child: Center(child: Text('Minggu', style: TextStyle(fontSize: 12)))),
								],
							),
							const SizedBox(height: 8),

							// Calendar grid (fixed height)
							SizedBox(
								height: 320,
								child: GridView.count(
									crossAxisCount: 7,
									childAspectRatio: 1.1,
									physics: const NeverScrollableScrollPhysics(),
									children: days.map((d) {
										final dayNum = d['day'] as int;
										final mood = d['mood'] as String?;
										final label = d['label'] as String;
										return DayCell(day: dayNum > 0 ? dayNum.toString() : '', mood: mood, label: label);
									}).toList(),
								),
							),

							const SizedBox(height: 16),

							// Recap card
							Card(
								child: Padding(
									padding: const EdgeInsets.all(16.0),
									child: Row(
										children: [
											// Text area
											Expanded(
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: const [
														Text('Recap Bulanan Perasaan Kamu', style: TextStyle(fontSize: 14)),
														SizedBox(height: 8),
														Text('Sedih', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
													],
												),
											),
											// Icon placeholder
											const Padding(
												padding: EdgeInsets.only(left: 8.0),
												child: Icon(Icons.mood_bad, size: 56),
											),
										],
									),
								),
							),
						],
					),
				),
			),
		);
	}
}

class DayCell extends StatelessWidget {
	final String day;
	final String? mood;
	final String label;

	const DayCell({Key? key, required this.day, this.mood, this.label = ''}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.all(4.0),
			child: Card(
				child: Padding(
					padding: const EdgeInsets.all(6.0),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Align(alignment: Alignment.topLeft, child: Text(day, style: const TextStyle(fontSize: 12))),
							const Spacer(),
							if (mood != null) Align(alignment: Alignment.center, child: Text(mood!, style: const TextStyle(fontSize: 20))),
							if (label.isNotEmpty) Align(alignment: Alignment.center, child: Text(label, style: const TextStyle(fontSize: 10))),
						],
					),
				),
			),
		);
	}
}

