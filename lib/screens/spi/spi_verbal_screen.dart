import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../placeholder_screen.dart';
import 'spi_idiom_page.dart';
import 'spi_ordering_page.dart';
import 'spi_fill_in_page.dart';
import 'spi_three_sentence_completion_page.dart';
import 'spi_reading_page.dart';

class SpiVerbalScreen extends StatelessWidget {
  const SpiVerbalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('言語分野', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildItem(context, '熟語の成り立ち', true, const SpiIdiomPage()),
          _buildItem(context, '文の並び換え', true, const SpiOrderingPage()),
          _buildItem(context, '空欄補充（適文・適語）', true, const SpiFillInPage()),
          _buildItem(context, '空欄補充（三文完成）', true, const SpiThreeSentenceCompletionPage()),
          _buildItem(context, '長文読解', true, const SpiReadingPage()),
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
                      fontSize: 20, // Bigger font for 5 items
                      fontWeight: FontWeight.bold,
                      color: isDone ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: isDone ? Colors.orange : Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
