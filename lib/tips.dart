import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
	const TipsPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final tips = [
			{
				'title': 'Kamu ngerasa sedih ya...',
				'content': 'Ceritakan apa yang membuatmu sedih, lalu coba tarik napas dalam-dalam dan tuliskan hal kecil yang membuatmu bersyukur saat ini.',
			},
			{
				'title': 'Lagi marah ya...',
				'content': 'Coba hitung sampai 10, beri jarak sejenak, lalu ungkapkan perasaanmu secara tenang atau tuliskan di buku diary.',
			},
			{
				'title': 'Hati kamu lagi tenang ya...',
				'content': 'Nikmati momen tenang: dengarkan musik lembut, catat perasaan positif, dan simpan rencana kecil untuk menjaga keseimbangan.',
			},
		];

		return Scaffold(
			appBar: AppBar(
				leading: IconButton(
					icon: const Icon(Icons.arrow_back),
					onPressed: () => Navigator.maybePop(context),
				),
				title: const Text('Q-Tips'),
				centerTitle: true,
			),
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					child: Column(
						children: [
							// Header area: large text on left, image/icon placeholder on right
							Row(
								children: [
									Expanded(
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: const [
												SizedBox(height: 8),
												Text(
													'HARUS\nNGAPAIN SIH\nKALAU LAGI\NGERASA...',
													style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
												),
											],
										),
									),
									// image placeholder (no styling)
									const Padding(
										padding: EdgeInsets.only(left: 8.0),
										child: Icon(Icons.emoji_emotions_outlined, size: 72),
									),
								],
							),
							const SizedBox(height: 16),

							// Expandable tips list (simple, no custom colors)
							Expanded(
								child: ListView.separated(
									itemCount: tips.length,
									separatorBuilder: (_, __) => const SizedBox(height: 12),
									itemBuilder: (context, index) {
										final t = tips[index];
										return Card(
											child: ExpansionTile(
												title: Text(t['title']!),
												children: [
													Padding(
														padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
														child: Text(t['content']!),
													),
												],
											),
										);
									},
								),
							),
						],
					),
				),
			),
		);
	}
}

