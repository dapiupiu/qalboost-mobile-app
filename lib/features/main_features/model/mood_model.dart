class MoodModel {
  final String userEmail;
  final String dateKey; // Format: YYYY-MM-DD
  final String emoji;
  final String note;

  MoodModel({
    required this.userEmail,
    required this.dateKey,
    required this.emoji,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'userEmail': userEmail,
        'dateKey': dateKey,
        'emoji': emoji,
        'note': note,
      };

  factory MoodModel.fromJson(Map<String, dynamic> json) => MoodModel(
        userEmail: json['userEmail'] ?? '',
        dateKey: json['dateKey'] ?? '',
        emoji: json['emoji'] ?? '',
        note: json['note'] ?? '',
      );
}