import 'package:flutter/material.dart';
import 'placeholder_screen.dart';
import 'kraepelin_exam_page.dart';
import 'spi/category_list_screen.dart'; // Direct import to new category list
import 'cab_gab/cab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF42A5F5), Color(0xFFF5F9FF)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(Icons.school, size: 64, color: Color(0xFF1565C0)),
                        const SizedBox(height: 16),
                        const Text(
                          '適性検査対策アプリ',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '就職活動で必要な適性検査の\n対策問題と解説を提供します',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  '検査を選択してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildNavButton(
                          context,
                          title: 'SPI3',
                          subtitle: '多くの企業が採用する適性検査',
                          icon: Icons.text_fields,
                          color: Colors.blue.shade50,
                          iconColor: Colors.blue,
                          route: 'SPI3',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildNavButton(
                          context,
                          title: 'CAB',
                          subtitle: 'IT企業や総合職向けの適性検査',
                          icon: Icons.calculate,
                          color: Colors.green.shade50,
                          iconColor: Colors.green,
                          route: 'CAB',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildNavButton(
                          context,
                          title: 'クレペリン検査',
                          subtitle: '作業能力と性格特性を測定',
                          icon: Icons.speed,
                          color: Colors.pink.shade50,
                          iconColor: Colors.pink,
                          route: 'KRAEPELIN',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String route,
  }) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (route == 'KRAEPELIN') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KraepelinExamPage(),
              ),
            );
          } else if (route == 'SPI3') {
            // Direct navigation to CategoryListScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoryListScreen(),
              ),
            );
          } else if (route == 'CAB') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CabScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceholderScreen(title: title),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 36),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
