import 'package:flutter/material.dart';

class TutorialItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final double radius;
  final double bottomPadding;

  const TutorialItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.desc,
    this.radius = 18,
    this.bottomPadding = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: radius * 0.9,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
