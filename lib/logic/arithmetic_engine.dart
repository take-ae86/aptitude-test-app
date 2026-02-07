import 'dart:math';

class ArithmeticProblem {
  final String question; // 表示用の問題文 (例: "15 + ? = 30")
  final String answer; // 正解の文字列 (例: "15")
  final List<String> options; // 選択肢リスト (5択)
  final String explanation; // 解説 (計算式など)

  ArithmeticProblem({
    required this.question,
    required this.answer,
    required this.options,
    required this.explanation,
  });
}

class ArithmeticEngine {
  final Random _random = Random();

  /// 指定された数の問題を生成して返す
  List<ArithmeticProblem> generateProblems(int count) {
    List<ArithmeticProblem> problems = [];
    for (int i = 0; i < count; i++) {
      problems.add(_generateSingleProblem());
    }
    return problems;
  }

  /// 1問を生成する
  ArithmeticProblem _generateSingleProblem() {
    // 問題タイプをランダム決定
    // 0: A + B = ?
    // 1: A - B = ?
    // 2: A * B = ?
    // 3: A / B = ? (割り切れる数)
    // 4: A + ? = C
    // 5: A - ? = C
    // 6: ? + B = C
    // ...など、逆算形式を多めに
    
    // CABは逆算が多いため、逆算形式(穴埋め)を重視
    int type = _random.nextInt(4); // 0:足し算, 1:引き算, 2:掛け算, 3:割り算
    int blankPos = _random.nextInt(3); // 0: Aが空欄, 1: Bが空欄, 2: 答えが空欄

    int a, b, c;
    String operatorStr = '';
    
    // 基本的な数値範囲設定 (難易度調整)
    // 足し算・引き算は2桁〜3桁
    // 掛け算・割り算は2桁×1桁、または簡単な2桁×2桁
    
    switch (type) {
      case 0: // 足し算: A + B = C
        a = _random.nextInt(90) + 10; // 10-99
        b = _random.nextInt(90) + 10; // 10-99
        c = a + b;
        operatorStr = '+';
        break;
      case 1: // 引き算: A - B = C
        c = _random.nextInt(90) + 10; // 結果
        b = _random.nextInt(90) + 10; // 引く数
        a = c + b; // 引かれる数 (負にならないように逆算で生成)
        operatorStr = '-';
        break;
      case 2: // 掛け算: A * B = C
        a = _random.nextInt(20) + 2; // 2-21
        b = _random.nextInt(9) + 2;  // 2-10
        // 時々大きめの数を混ぜる
        if (_random.nextBool()) {
          a = _random.nextInt(80) + 10; // 10-89
        }
        c = a * b;
        operatorStr = '×';
        break;
      case 3: // 割り算: A / B = C (割り切れる前提)
        c = _random.nextInt(20) + 2; // 商
        b = _random.nextInt(15) + 2; // 割る数
        a = c * b; // 割られる数
        operatorStr = '÷';
        break;
      default:
        a = 1; b = 1; c = 2; operatorStr = '+';
    }

    String questionText = '';
    String answerText = '';
    String explanationText = '';
    
    // 空欄の位置に応じて問題文を作成
    if (blankPos == 0) {
      // ? [op] B = C
      questionText = '？ $operatorStr $b = $c';
      answerText = a.toString();
      explanationText = _generateExplanation(type, blankPos, a, b, c, operatorStr);
    } else if (blankPos == 1) {
      // A [op] ? = C
      questionText = '$a $operatorStr ？ = $c';
      answerText = b.toString();
      explanationText = _generateExplanation(type, blankPos, a, b, c, operatorStr);
    } else {
      // A [op] B = ?
      questionText = '$a $operatorStr $b = ？';
      answerText = c.toString();
      explanationText = '$a $operatorStr $b = $c';
    }

    // 選択肢の生成
    List<String> options = _generateOptions(int.parse(answerText));

    return ArithmeticProblem(
      question: questionText,
      answer: answerText,
      options: options,
      explanation: explanationText,
    );
  }

  String _generateExplanation(int type, int blankPos, int a, int b, int c, String op) {
    // 逆算の解説文生成
    if (type == 0) { // +
      if (blankPos == 0) return '$c - $b = $a'; // ? + B = C -> C - B
      if (blankPos == 1) return '$c - $a = $b'; // A + ? = C -> C - A
    } else if (type == 1) { // -
      if (blankPos == 0) return '$c + $b = $a'; // ? - B = C -> C + B
      if (blankPos == 1) return '$a - $c = $b'; // A - ? = C -> A - C
    } else if (type == 2) { // *
      if (blankPos == 0) return '$c ÷ $b = $a'; // ? * B = C -> C / B
      if (blankPos == 1) return '$c ÷ $a = $b'; // A * ? = C -> C / A
    } else if (type == 3) { // /
      if (blankPos == 0) return '$c × $b = $a'; // ? / B = C -> C * B
      if (blankPos == 1) return '$a ÷ $c = $b'; // A / ? = C -> A / C
    }
    return '計算して確かめましょう。';
  }

  List<String> _generateOptions(int answer) {
    Set<int> optionSet = {};
    optionSet.add(answer);

    // 誤答パターンの生成
    // 1. ±1, ±2 (計算ミス)
    // 2. ±10 (桁ミス)
    // 3. 一の位が同じ数 (よくある引っかけ)
    // 4. ランダムに近い数

    while (optionSet.length < 5) {
      int diff;
      int r = _random.nextInt(100);
      
      if (r < 30) {
        // 近似値 (±1 ~ ±3)
        diff = _random.nextInt(3) + 1; 
        if (_random.nextBool()) diff = -diff;
      } else if (r < 60) {
        // 10の位の間違い
        diff = 10;
        if (_random.nextBool()) diff = -diff;
      } else if (r < 80) {
        // 1の位が同じで10の位が違う数
        int wrong = answer + (_random.nextBool() ? 10 : -10) + (_random.nextBool() ? 20 : -20);
        if (wrong < 0) wrong = answer + 5;
        optionSet.add(wrong);
        continue;
      } else {
        // ランダムな近傍値
        diff = _random.nextInt(10) - 5;
        if (diff == 0) diff = 1;
      }

      int candidate = answer + diff;
      if (candidate < 0) candidate = 0; // 負数は避ける（CABでは一般的ではないため）
      optionSet.add(candidate);
    }

    List<String> options = optionSet.map((e) => e.toString()).toList();
    options.shuffle();
    return options;
  }
}
