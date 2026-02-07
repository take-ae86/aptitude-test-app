import 'package:flutter/material.dart';
import '../widgets/common/question_scaffold.dart';
import '../widgets/common/answer_button.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Demo content to verify UI
    return QuestionScaffold(
      categoryName: title,
      problemContent: const Text(
        'ここに問題文が表示されます。\n'
        '例：次の数列の規則性を考え、( )に入る数字を選びなさい。\n'
        '2, 5, 11, 23, ( ? )',
        style: TextStyle(fontSize: 16),
      ),
      chartContent: Container(
        height: 150,
        color: Colors.grey.shade200,
        child: const Center(child: Text('図表エリア (CustomPaint)')),
      ),
      answerButtons: [
        AnswerButton(text: '45', onTap: () {}),
        AnswerButton(text: '46', onTap: () {}),
        AnswerButton(text: '47', onTap: () {}),
        AnswerButton(text: '48', onTap: () {}),
      ],
    );
  }
}
