import '../lib/logic/chart_engine.dart';

void main() async {
  print("=== SPI Grammar & Logic Inspector (ChartEngine) ===");
  final engine = ChartEngine();
  int errorCount = 0;

  for (int i = 0; i < 100; i++) {
    try {
      final quizSet = await engine.generateQuizSet();
      for (var bigQ in quizSet) {
        // Check Chart Data
        if (bigQ.chartData.title.isEmpty) {
          print("[ERROR] Title is empty");
          errorCount++;
        }

        // Check SubQuestions
        for (var subQ in bigQ.subQuestions) {
          String qText = subQ.questionText;
          String ans = subQ.correctAnswer;
          
          // 1. 単位重複チェック
          if (qText.contains("万円万円") || qText.contains("円円") || qText.contains("%%") || qText.contains("kgkg")) {
            print("[ERROR] Unit Duplication: $qText");
            errorCount++;
          }
          if (ans.contains("万円万円") || ans.contains("円円")) {
             print("[ERROR] Unit Duplication in Answer: $ans");
             errorCount++;
          }

          // 2. 助詞連続・文法チェック
          if (qText.contains("がが") || qText.contains("はは") || qText.contains("のを") || qText.contains("にに")) {
            print("[ERROR] Grammar(Particle): $qText");
            errorCount++;
          }

          // 3. 数値異常・プレースホルダー
          if (qText.contains("null") || qText.contains("NaN") || qText.contains("{}")) {
            print("[ERROR] Invalid Value/Placeholder: $qText");
            errorCount++;
          }
          if (ans.contains("null") || ans.contains("NaN")) {
            print("[ERROR] Invalid Answer: $ans");
            errorCount++;
          }

          // 4. 選択肢整合性
          if (subQ.options.length != 5 && subQ.options.length != 6) { 
             // 5択指示だが、グラフ選択など6択の名残があるかチェック
             print("[WARN] Options length is ${subQ.options.length} (Should be 5): ${subQ.options}");
             // errorCount++; // Warn for now
          }
          if (!subQ.options.contains(subQ.correctAnswer) && !subQ.isGraphSelection) {
             // Graph selection answer is "A", options are "A".."E". OK.
             // Numeric calculation answer must be in options.
             // But Wait, Answer is String "A", options are ["A",...].
             // Numeric answer "300" in ["200","300",...]
             print("[ERROR] Correct Answer '${subQ.correctAnswer}' not found in Options: ${subQ.options}");
             errorCount++;
          }
        }
      }
    } catch (e, stack) {
      print("[CRITICAL] Exception during generation: $e");
      print(stack);
      errorCount++;
    }
  }

  print("=== Inspection Finished. Total Errors: $errorCount ===");
}
