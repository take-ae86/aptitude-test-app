import 'package:flutter/material.dart';
import '../placeholder_screen.dart';
import 'cab_law_page.dart';
import 'cab_arithmetic_page.dart';

enum CabGabType { cab, gab }

class CabGabCategoryListScreen extends StatelessWidget {
  final CabGabType type;

  const CabGabCategoryListScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final categories = type == CabGabType.cab
        ? _getCabCategories()
        : _getGabCategories();

    return Scaffold(
      appBar: AppBar(
        title: Text(type == CabGabType.cab ? 'CAB 分野' : 'GAB 分野'),
        backgroundColor: type == CabGabType.cab ? Colors.green : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Using Column with Expanded to fill vertical space and center items
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildCategoryButton(context, categories[0])),
                    const SizedBox(width: 24),
                    Expanded(child: _buildCategoryButton(context, categories[1])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, _CategoryItem item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => item.page ?? PlaceholderScreen(title: item.title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 100, color: Colors.green), // Huge Icon
            const SizedBox(height: 32),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900), // Huge Text
            ),
          ],
        ),
      ),
    );
  }

  List<_CategoryItem> _getCabCategories() {
    return [
      _CategoryItem('暗算', Icons.calculate, const CabArithmeticPage()),
      _CategoryItem('法則性', Icons.grid_on, const CabLawPage()),
    ];
  }

  List<_CategoryItem> _getGabCategories() {
    return [
      _CategoryItem('言語', Icons.text_fields, null),
      _CategoryItem('計数', Icons.bar_chart, null),
    ];
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final Widget? page;

  _CategoryItem(this.title, this.icon, this.page);
}
