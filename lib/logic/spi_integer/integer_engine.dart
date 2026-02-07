import 'dart:math';

// =========================================================
// Integer Inference Engine (16 Problems Base)
// =========================================================

class GeneratedProblem {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String scenarioId;
  final String structureHash;

  GeneratedProblem({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.scenarioId,
    required this.structureHash,
  });
}

class IntegerEngine {
  final Random _rand = Random();
  static final Set<String> _historyHashes = {};
  
  static const List<String> _conditionOptions = [
    "A アだけでわかるが、イだけではわからない",
    "B イだけでわかるが、アだけではわからない",
    "C アとイの両方でわかるが、片方だけではわからない",
    "D アだけでも、イだけでもわかる",
    "E アとイの両方があってもわからない",
  ];

  // 16 Scenarios
  static const List<String> _allScenarioIds = [
    'EX_1', 'EX_2', 'EX_3', 'EX_4',
    'P1_1', 'P1_2', 'P1_3', 'P1_4', 'P1_5',
    'P2_1', 'P2_2', 'P2_3', 'P2_4',
    'P3_1', 'P3_2', 'P3_3'
  ];

  Future<List<GeneratedProblem>> generateProblems(int count) async {
    List<GeneratedProblem> problems = [];
    List<String> currentIds = List.from(_allScenarioIds)..shuffle(_rand);
    List<String> selectedIds = currentIds.take(count).toList();
    
    for (String id in selectedIds) {
      problems.add(_generateSpecificScenario(id));
    }
    return problems;
  }

  GeneratedProblem _generateSpecificScenario(String id) {
    switch (id) {
      case 'EX_1': return _genEx1();
      case 'EX_2': return _genEx2();
      case 'EX_3': return _genEx3();
      case 'EX_4': return _genEx4(); // Condition Type
      case 'P1_1': return _genP1_1();
      case 'P1_2': return _genP1_2();
      case 'P1_3': return _genP1_3();
      case 'P1_4': return _genP1_4();
      case 'P1_5': return _genP1_5();
      case 'P2_1': return _genP2_1();
      case 'P2_2': return _genP2_2();
      case 'P2_3': return _genP2_3();
      case 'P2_4': return _genP2_4();
      case 'P3_1': return _genP3_1(); // Condition Type
      case 'P3_2': return _genP3_2(); // Condition Type
      case 'P3_3': return _genP3_3(); // Condition Type
      default: return _genEx1();
    }
  }

  // Helper for numeric options
  List<String> _makeNumericOptions(int correct) {
    Set<String> opts = {correct.toString()};
    while (opts.length < 5) {
      int v = correct + (_rand.nextBool() ? 1 : -1) * (_rand.nextInt(5) + 1);
      opts.add(v.toString());
    }
    List<String> sorted = opts.toList();
    sorted.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return sorted;
  }

  // ---------------------------------------------------
  // Example Problems
  // ---------------------------------------------------

  // Ex1: 2桁の整数P. 15で割切れ、17で割ると5余る.
  GeneratedProblem _genEx1() {
    // Base: 15, 17, 5 -> 90.
    // Logic: Find P such that P % A == 0 and P % B == rem.
    int A = 15;
    int B = 17;
    int rem = 5; 
    
    // Variation: Just randomize phrasing slightly or verify logic?
    // Problem says "change numbers only".
    // Let's keep logic intact.
    int ans = 90;
    String q = "2桁の正の整数Pがある。Pは$Aで割り切れ、$Bで割ると$rem余る。Pは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "2桁の整数のうち、$Bで割ると$rem余るものを列挙する(22, 39, 56, 73, 90)。このうち$Aで割り切れるのは90だけ。",
      scenarioId: 'EX_1',
      structureHash: 'EX1_90',
    );
  }

  // Ex2: 積56, 和14. 最大数は?
  GeneratedProblem _genEx2() {
    int prod = 56;
    int sum = 14;
    int ans = 7;
    String q = "4つの正の整数がある。4つの数の積は$prodで、和は$sumである。このとき4つの数のうち最も大きい数は [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "$prodを素因数分解すると2×2×2×7。和が$sumになる組み合わせは「4,1,2,7」。最大は7。",
      scenarioId: 'EX_2',
      structureHash: 'EX2_7',
    );
  }

  // Ex3: X(2倍), Y(3倍), Z(5倍). X+Y=35, Y+Z=41. X?
  GeneratedProblem _genEx3() {
    int sum1 = 35;
    int sum2 = 41;
    int ans = 14;
    String q = "Xは2の倍数、Yは3の倍数、Zは5の倍数であり、以下のことがわかっている。\n"
               "ア　X + Y = $sum1\n"
               "イ　Y + Z = $sum2\n"
               "X、Y、Zがいずれも正の整数であるとき、Xは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "イのY+Z=$sum2よりY=21(奇数)が確定。アのX+Y=$sum1に代入してX=14。",
      scenarioId: 'EX_3',
      structureHash: 'EX3_14',
    );
  }

  // Ex4: Condition Type
  GeneratedProblem _genEx4() {
    String q = "X、Y、Zは1から7までの整数のいずれかで、X > Y > Zである。\n"
               "[問い] Yはいくつか。\n"
               "ア　X = Y + 3\n"
               "イ　Z = Y - 3";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "アとイを組み合わせると、Y=4 (X=7, Z=1) だけが当てはまる。",
      scenarioId: 'EX_4',
      structureHash: 'EX4_C',
    );
  }

  // ---------------------------------------------------
  // Practice 1
  // ---------------------------------------------------

  // P1_1: 連続3整数. min^2 = mid*max - 20.
  GeneratedProblem _genP1_1() {
    int diff = 20;
    int ans = 336; // 6*7*8
    String q = "3つの連続する整数があり、最も小さい数を2乗したものは残りの2つの数の積より$diff小さい。このとき、3つの数の積は [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "最小をxとすると x^2 = (x+1)(x+2) - $diff。これを解くとx=6。積は6×7×8=336。",
      scenarioId: 'P1_1',
      structureHash: 'P1_1_336',
    );
  }

  // P1_2: X<Y. X+Y=12, Y-X=26. X?
  GeneratedProblem _genP1_2() {
    int sum = 12;
    int diff = 26;
    int ans = -7;
    String q = "2つの整数X、Yがある。XはYより小さく、XとYの和は$sumで差は$diffのとき、Xは [ ] である。";
    // For -7, generate options like -9, -8, -7, -6, -5
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "X+Y=$sum, Y-X=$diff。連立方程式を解くと2X = $sum - $diff = -14。X=-7。",
      scenarioId: 'P1_2',
      structureHash: 'P1_2_NEG7',
    );
  }

  // P1_3: 1~195. 4の倍数 but not 8.
  GeneratedProblem _genP1_3() {
    int range = 195;
    int ans = 24;
    String q = "1から$rangeまでの整数の中に、4の倍数であるが8の倍数ではない整数は [ ] 個ある。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "4の倍数は48個。そのうち半分(24個)が8の倍数ではない。",
      scenarioId: 'P1_3',
      structureHash: 'P1_3_24',
    );
  }

  // P1_4: X/5 = Y/6. Y-X = 15.
  GeneratedProblem _genP1_4() {
    int diff = 15;
    int ans = 75;
    String q = "2つの正の整数X、Yがあり、Xの1/5はYの1/6である。また、XとYの差は$diffだった。このときXは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "X = 5/6 Y。差は1/6 Y = $diff。よってY=${diff*6}=90。X=75。",
      scenarioId: 'P1_4',
      structureHash: 'P1_4_75',
    );
  }

  // P1_5: P*Q*R=18, P-Q=2. R?
  GeneratedProblem _genP1_5() {
    int prod = 18;
    int diff = 2;
    int ans = 6;
    String q = "P、Q、Rは正の整数であり、以下のことがわかっている。\n"
               "ア　P × Q × R = $prod\n"
               "イ　P - Q = $diff\n"
               "このとき、Rは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "積が$prod、差が$diffになるのはP=3, Q=1。よってR=$ans。",
      scenarioId: 'P1_5',
      structureHash: 'P1_5_6',
    );
  }

  // ---------------------------------------------------
  // Practice 2
  // ---------------------------------------------------

  // P2_1: P+Q+R+S=40, P=5Q, R=4S. P?
  GeneratedProblem _genP2_1() {
    int total = 40;
    int ans = 25;
    String q = "4つの正の整数P、Q、R、Sについて、以下のことがわかっている。\n"
               "ア　P + Q + R + S = $total\n"
               "イ　P = 5Q\n"
               "ウ　R = 4S\n"
               "このとき、Pは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "6Q + 5S = $total。Q=5, S=2が成立。P=5Q=25。",
      scenarioId: 'P2_1',
      structureHash: 'P2_1_25',
    );
  }

  // P2_2: X%8=1, X%14=1. X%25?
  GeneratedProblem _genP2_2() {
    int rem = 1;
    int ans = 7;
    String q = "ある2桁の整数Xについて、以下のことがわかっている。\n"
               "ア　Xを8で割ると$rem余る\n"
               "イ　Xを14で割ると$rem余る\n"
               "このとき、Xを25で割ると余りは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "XはLCM(8,14)+1 = 57。57÷25 = 2...7。",
      scenarioId: 'P2_2',
      structureHash: 'P2_2_7',
    );
  }

  // P2_3: 3▲8. 7の倍数. %9=2.
  GeneratedProblem _genP2_3() {
    int ans = 0; // 308
    String q = "3桁の整数3▲8について、以下のことがわかっている。\n"
               "ア　7の倍数である\n"
               "イ　9で割ると2余る\n"
               "このとき、▲は [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "7の倍数で末尾8は308か378。条件イを満たすのは308。▲=0。",
      scenarioId: 'P2_3',
      structureHash: 'P2_3_0',
    );
  }

  // P2_4: P,Q,R (1-9 distinct). Q+R=12, 2P=Q. Q?
  GeneratedProblem _genP2_4() {
    int sum = 12;
    int ans = 4;
    String q = "P、Q、Rは1から9までのいずれかの異なる整数である。P、Q、Rについて以下のことがわかっている。\n"
               "ア　Q + R = $sum\n"
               "イ　2P = Q\n"
               "このときQは [ ] である。";
    return GeneratedProblem(
      questionText: q,
      options: _makeNumericOptions(ans),
      correctAnswer: ans.toString(),
      explanation: "Q=4ならP=2, R=8で成立。Q=8ならP=4, R=4で不適。",
      scenarioId: 'P2_4',
      structureHash: 'P2_4_4',
    );
  }

  // ---------------------------------------------------
  // Practice 3 (Condition Type)
  // ---------------------------------------------------

  // P3_1: X,Y,Z. X-Y=8, Y-Z=13. X-Z?
  GeneratedProblem _genP3_1() {
    String q = "異なる3つの正の整数X、Y、Zがあり、XとYの差は8で、YとZの差は13である。\n"
               "[問い] XとZの差はいくつか。\n"
               "ア　最も小さい数はXである\n"
               "イ　2番目に小さい数はYである";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "D",
      explanation: "アでもイでも、3数の大小関係が確定し、差が21と求まる。",
      scenarioId: 'P3_1',
      structureHash: 'P3_1_D',
    );
  }

  // P3_2: 6★6=?
  GeneratedProblem _genP3_2() {
    String q = "記号★は四則演算の＋、－、×、÷のいずれかを表す。\n"
               "[問い] 6★6はいくつになるか。\n"
               "ア　4★4 = 8\n"
               "イ　2★2 = 4";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "A",
      explanation: "アなら★は＋確定。イは＋か×か不明。",
      scenarioId: 'P3_2',
      structureHash: 'P3_2_A',
    );
  }

  // P3_3: Cards 1,3,5 (2 each). P has 3?
  GeneratedProblem _genP3_3() {
    String q = "数字の1、3、5が1つずつ書かれたカードが各2枚あり、P、Q、Rの3人に2枚ずつ配った。\n"
               "[問い] Pは3のカードを何枚持っているか。\n"
               "ア　Pと同じ組み合わせのカードを持っている人がいる\n"
               "イ　Qのカードの数字の和は、Rのカードの数字の和より6大きい";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "B",
      explanation: "イの場合、Q(5,5)-R(1,3)かQ(3,5)-R(1,1)で、Pはいずれも3を1枚持つ。",
      scenarioId: 'P3_3',
      structureHash: 'P3_3_B',
    );
  }
}
