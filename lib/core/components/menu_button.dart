import 'package:flutter/material.dart';

Widget menuButton(BuildContext context, {String? assetPath, required String label, required Widget page}) {
  return Column(
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
            child: Center(child: Image.asset(assetPath!, width: 44, height: 44, errorBuilder: (c, e, s) => const Icon(Icons.extension))),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(label),
    ],
  );
}
