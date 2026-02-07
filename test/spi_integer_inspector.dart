import '../lib/logic/spi_integer/integer_engine.dart';

void main() async {
  print("=== SPI Grammar & Logic Inspector (IntegerEngine) ===");
  final engine = IntegerEngine();
  int errorCount = 0;

  for (int i = 0; i < 100; i++) {
    try {
      final problems = await engine.generateProblems(10);
      for (var p in problems) {
        String qText = p.questionText;
        
        // 1. 単位重複
        if (qText.contains("個個") || qText.contains("人に") || qText.contains("円円")) {
           // "人に" は "1人に" などあり得るので除外すべきか？ -> "人に" は文脈による。"がが"等はNG。
           // ここでは明らかに異常な重複のみ
        }
        if (qText.contains("がが") || qText.contains("はは")) {
          print("[ERROR] Grammar: $qText");
          errorCount++;
        }

        // 2. 数値異常
        if (qText.contains("null") || qText.contains("NaN")) {
          print("[ERROR] Invalid Value: $qText");
          errorCount++;
        }

        // 3. 選択肢数 (5択)
        if (p.options.length != 5) {
          print("[ERROR] Options length is ${p.options.length}");
          errorCount++;
        }
        
        // 4. 正解包含チェック (Conditionタイプは除く)
        bool isCondition = p.options[0].startsWith("A ");
        if (!isCondition && !p.options.contains(p.correctAnswer)) {
           print("[ERROR] Correct Answer '${p.correctAnswer}' not in options ${p.options}");
           errorCount++;
        }
      }
    } catch (e) {
      print("[CRITICAL] $e");
      errorCount++;
    }
  }
  print("=== Integer Inspection Finished. Errors: $errorCount ===");
}
