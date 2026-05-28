import 'package:flutter/material.dart';
import '../../../../core/components/app_drawer.dart';

class ConsulPage extends StatelessWidget {
  const ConsulPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: const CustomAppDrawer(),
      drawerEdgeDragWidth: 100.0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: colorScheme.onBackground),
        title: Text('Q-Konsul', style: TextStyle(color: colorScheme.onBackground, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Text('Halaman Konsultasi akan segera hadir!', style: TextStyle(color: colorScheme.onBackground.withOpacity(0.6))),
      ),
    );
  }
}
