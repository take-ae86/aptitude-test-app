import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../placeholder_screen.dart';
import 'cab_law_page.dart';
import 'cab_arithmetic_page.dart';

class CabScreen extends StatelessWidget {
  const CabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAB対策', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 法則性は実装済み
          _buildItem(context, '法則性', true, const CabLawPage()),
          // 四則演算も実装済み
          _buildItem(context, '四則演算', true, const CabArithmeticPage()),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, bool isDone, Widget? page) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
          color: isDone ? Colors.white : Colors.grey[100],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page ?? PlaceholderScreen(title: title),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.lock,
                  color: isDone ? Colors.green : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.notoSansJp(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDone ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: isDone ? Colors.green : Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
