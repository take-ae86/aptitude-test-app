import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../placeholder_screen.dart';
import 'spi_inference_numerical_page.dart';
import 'spi_inference_condition_page.dart';
import 'spi_integer_page.dart';
import 'spi_chart_page.dart';
import 'spi_set_page.dart';
import 'spi_prob_combination_page.dart';
import 'spi_probability_page.dart';
import 'spi_profit_loss_page.dart';
import 'spi_ratio_page.dart';
import 'spi_speed_page.dart';

class SpiNonVerbalScreen extends StatelessWidget {
  const SpiNonVerbalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('非言語分野', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildItem(context, '推論（数値算出）', true, const SpiInferenceNumericalPage()),
          _buildItem(context, '推論（答えが決まる条件）', true, const SpiInferenceConditionPage()),
          _buildItem(context, '整数の推測', true, const SpiIntegerPage()),
          _buildItem(context, '図表の読み取り', true, const SpiChartPage()),
          _buildItem(context, '集合', true, const SpiSetPage()),
          _buildItem(context, '順列・組み合わせ', true, const SpiProbCombinationPage()),
          _buildItem(context, '確率', true, const SpiProbabilityPage()),
          _buildItem(context, '損益算・料金の割引・代金の精算', true, const SpiProfitLossPage()),
          _buildItem(context, '割合・比・分割払い・仕事算', true, const SpiRatioPage()),
          _buildItem(context, '速さ', true, SpiSpeedPage()),
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
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.notoSansJp(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDone ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: isDone ? Colors.blue : Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
