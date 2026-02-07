import 'package:flutter/material.dart';
import 'cab_gab_category_list_screen.dart';

class CabGabSelectionScreen extends StatelessWidget {
  const CabGabSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CAB・GAB 対策')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // SPI選択画面と同様に縦に大きく2分割
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildSelectionButton(
                  context,
                  title: 'CAB',
                  subtitle: '暗算・法則性 (2分野)',
                  icon: Icons.computer,
                  color: Colors.green.shade50,
                  iconColor: Colors.green,
                  type: CabGabType.cab,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _buildSelectionButton(
                  context,
                  title: 'GAB',
                  subtitle: '言語・計数 (2分野)',
                  icon: Icons.analytics,
                  color: Colors.teal.shade50,
                  iconColor: Colors.teal,
                  type: CabGabType.gab,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required CabGabType type,
  }) {
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CabGabCategoryListScreen(type: type),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: iconColor), // Giant Icon matches SPI selection
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900), // Giant Text
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
