import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'spi_non_verbal_screen.dart';
import 'spi_verbal_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SPI3 対策',
          style: GoogleFonts.notoSansJp(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Non-Verbal Section (Card Style)
              Expanded(
                child: Card(
                  elevation: 4,
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SpiNonVerbalScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate, size: 80, color: Colors.blue[800]),
                        const SizedBox(height: 16),
                        Text(
                          '非言語分野',
                          style: GoogleFonts.notoSansJp(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '推論・計算など (全10種)',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24), // Spacing between cards
              
              // Verbal Section (Card Style)
              Expanded(
                child: Card(
                  elevation: 4,
                  color: Colors.orange[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SpiVerbalScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book, size: 80, color: Colors.orange[800]),
                        const SizedBox(height: 16),
                        Text(
                          '言語分野',
                          style: GoogleFonts.notoSansJp(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.orange[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '語句・読解など (全5種)',
                          style: TextStyle(fontSize: 16, color: Colors.orange[700], fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
