import '../lib/logic/profit_loss_engine.dart';

void main() async {
  print("Starting ProfitLossEngine Stress Test...");
  final engine = ProfitLossEngine();
  int errorCount = 0;

  for (int i = 0; i < 1000; i++) {
    try {
      await engine.generateProblems(5);
    } catch (e, stackTrace) {
      errorCount++;
      print("Error detected at iteration $i:");
      print("Exception: $e");
      print("StackTrace: $stackTrace");
      // Stop at first error to analyze
      break;
    }
  }

  if (errorCount == 0) {
    print("Success: No errors detected in 1000 iterations.");
  } else {
    print("Failure: $errorCount errors detected.");
  }
}
