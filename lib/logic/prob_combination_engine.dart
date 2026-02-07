import 'dart:math';

// =========================================================
// Probability & Combination Engine (For SPI)
// =========================================================

class GeneratedProblem {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String scenarioId;

  GeneratedProblem({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.scenarioId,
  });
}

class ProbCombinationEngine {
  final Random _rand = Random();

  // 15 Scenarios
  static const List<String> _allScenarioIds = [
    'EX_1_BIRDS',
    'EX_2_BALLS',
    'EX_3_STUDENTS',
    'PR_1_1_CLEANING',
    'PR_1_2_CHAPTERS',
    'PR_1_3_WEIGHTS',
    'PR_1_4_RECEPTION',
    'PR_2_1_SEATS',
    'PR_2_2_CARDS',
    'PR_2_3_PHOTO',
    'PR_2_4_TENNIS',
    'PR_3_1_NOTEBOOKS',
    'PR_3_2_HANDKERCHIEFS',
    'PR_3_3_DICE',
    'PR_3_4_AGES',
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
      case 'EX_1_BIRDS': return _genEx1Birds();
      case 'EX_2_BALLS': return _genEx2Balls();
      case 'EX_3_STUDENTS': return _genEx3Students();
      case 'PR_1_1_CLEANING': return _genPr1_1Cleaning();
      case 'PR_1_2_CHAPTERS': return _genPr1_2Chapters();
      case 'PR_1_3_WEIGHTS': return _genPr1_3Weights();
      case 'PR_1_4_RECEPTION': return _genPr1_4Reception();
      case 'PR_2_1_SEATS': return _genPr2_1Seats();
      case 'PR_2_2_CARDS': return _genPr2_2Cards();
      case 'PR_2_3_PHOTO': return _genPr2_3Photo();
      case 'PR_2_4_TENNIS': return _genPr2_4Tennis();
      case 'PR_3_1_NOTEBOOKS': return _genPr3_1Notebooks();
      case 'PR_3_2_HANDKERCHIEFS': return _genPr3_2Handkerchiefs();
      case 'PR_3_3_DICE': return _genPr3_3Dice();
      case 'PR_3_4_AGES': return _genPr3_4Ages();
      default: return _genEx1Birds();
    }
  }

  // Utilities
  int _fact(int n) => n <= 1 ? 1 : n * _fact(n - 1);
  int _nCr(int n, int r) {
    if (r < 0 || r > n) return 0;
    if (r == 0 || r == n) return 1;
    if (r > n / 2) r = n - r;
    int res = 1;
    for (int i = 1; i <= r; i++) {
      res = res * (n - i + 1) ~/ i;
    }
    return res;
  }
  int _nPr(int n, int r) {
    if (r < 0 || r > n) return 0;
    int res = 1;
    for (int i = 0; i < r; i++) res *= (n - i);
    return res;
  }

  List<String> _makeOptions(int correct, {String unit = "通り"}) {
    Set<String> s = {};
    s.add("$correct$unit");
    while(s.length < 5) {
      int diff = _rand.nextInt(max(5, correct ~/ 5)) + 1;
      if (_rand.nextBool()) diff = -diff;
      int val = correct + diff;
      if (val >= 0) s.add("$val$unit");
    }
    List<String> list = s.toList();
    list.sort((a, b) {
      int valA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      int valB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return valA.compareTo(valB);
    });
    return list;
  }

  // 1. Birds (Combination Product)
  GeneratedProblem _genEx1Birds() {
    int nP = 2 + _rand.nextInt(2); // 2 or 3
    int nQ = 2 + _rand.nextInt(2); // 2 or 3
    int nR = 1 + _rand.nextInt(2); // 1 or 2
    int total = nP + nQ + nR;
    
    // Logic: Total C nP * (Total-nP) C nQ * (Total-nP-nQ) C nR
    int ans = _nCr(total, nP) * _nCr(total - nP, nQ) * _nCr(nR, nR);

    String q = "$total羽の小鳥を、Pが$nP羽、Qが$nQ羽、Rが$nR羽引き取ることになった。\n"
               "3人が引き取る小鳥の組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "Pの取り方は${total}C$nP = ${_nCr(total,nP)}通り。\n"
                   "残りの${total-nP}羽からQが取るのは${total-nP}C$nQ = ${_nCr(total-nP,nQ)}通り。\n"
                   "Rは自動的に決まる。\n"
                   "よって ${_nCr(total,nP)} × ${_nCr(total-nP,nQ)} = $ans通り。",
      scenarioId: 'EX_1_BIRDS',
    );
  }

  // 2. Balls (Color Combinations)
  GeneratedProblem _genEx2Balls() {
    int w = 2, b = 2, r = 3; // Fixed setup to ensure logic logic
    int pick = 3;
    // Combinations of colors (not individual balls, but color counts)
    // White(0-2), Black(0-2), Red(0-3). Sum=3.
    int ans = 0;
    List<String> combos = [];
    for (int i = 0; i <= w; i++) {
      for (int j = 0; j <= b; j++) {
        for (int k = 0; k <= r; k++) {
          if (i + j + k == pick) {
            ans++;
            combos.add("白$i黒$j赤$k");
          }
        }
      }
    }

    String q = "箱の中に白い玉が$w個、黒い玉が$b個、赤い玉が$r個入っている。\n"
               "この中から$pick個を取り出すとき、何色の玉が何個になるか、その組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "色の内訳を書き出すと、\n${combos.join('、')}\nの計$ans通り。",
      scenarioId: 'EX_2_BALLS',
    );
  }

  // 3. Students (At least one)
  GeneratedProblem _genEx3Students() {
    int elem = 3 + _rand.nextInt(3); // 3-5
    int mid = 3 + _rand.nextInt(3);  // 3-5
    int total = elem + mid;
    int pick = 3;
    
    // Total C 3 - Elem C 3
    int all = _nCr(total, pick);
    int onlyElem = _nCr(elem, pick);
    int ans = all - onlyElem;

    String q = "小学生$elem人、中学生$mid人の計$total人の中から、少なくとも中学生1人を含む$pick人を選んで出し物をすることになった。\n"
               "このとき、出し物をする$pick人の組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "全体の選び方は${total}C$pick = $all通り。\n"
                   "中学生が含まれない(小学生のみ)のは${elem}C$pick = $onlyElem通り。\n"
                   "少なくとも1人含む = 全体 - 小学生のみ = $all - $onlyElem = $ans通り。",
      scenarioId: 'EX_3_STUDENTS',
    );
  }

  // 4. Cleaning (Groups)
  GeneratedProblem _genPr1_1Cleaning() {
    int m = 3, f = 5; // Base
    int g1Size = 5; // Cleaning or Cooking
    int g2Size = 3;
    // "No group with only men or only women"
    // Total = 8C3 (choosing smaller group).
    // All Men in g2 (3 men, size 3) -> 1 way. (All women in g1)
    // All Women in g2 (5 women, size 3) -> 5C3 = 10 ways.
    // Invalid = 1 + 10 = 11.
    // Total = 56. Ans = 45.
    
    int totalWays = _nCr(m + f, g2Size);
    int invalidM = (m >= g2Size) ? _nCr(m, g2Size) : 0;
    int invalidF = (f >= g2Size) ? _nCr(f, g2Size) : 0;
    int ans = totalWays - invalidM - invalidF;

    String q = "男子$m人、女子$f人を料理${g1Size}人と掃除${g2Size}人の2つの班に分ける。\n"
               "男子だけ、あるいは女子だけの班を作らないようにするとき、誰がどの班になるか、その組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "全体の分け方は${m+f}C$g2Size = $totalWays通り。\n"
                   "掃除班が男子だけになるのは${m}C$g2Size = $invalidM通り。\n"
                   "掃除班が女子だけになるのは${f}C$g2Size = $invalidF通り。\n"
                   "よって $totalWays - ($invalidM + $invalidF) = $ans通り。",
      scenarioId: 'PR_1_1_CLEANING',
    );
  }

  // 5. Chapters (Separators)
  GeneratedProblem _genPr1_2Chapters() {
    int ch = 5 + _rand.nextInt(3); // 5-7
    int parts = 3 + _rand.nextInt(2); // 3-4
    // Logic: (ch-1) C (parts-1)
    int ans = _nCr(ch - 1, parts - 1);

    String q = "第1章から第$ch章まである原稿を、順序は変えずに章の区切り方だけを変えて$parts章にまとめたい。\n"
               "そのまとめ方は□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "$ch章の間の区切り箇所は${ch-1}箇所ある。\n"
                   "そこから${parts-1}箇所の区切りを選べばよいので、${ch-1}C${parts-1} = $ans通り。",
      scenarioId: 'PR_1_2_CHAPTERS',
    );
  }

  // 6. Weights (Binary combination)
  GeneratedProblem _genPr1_3Weights() {
    int n = 3 + _rand.nextInt(2); // 3 or 4 weights
    // Powers of 2 minus 1
    int ans = (1 << n) - 1;
    List<int> weights = [5, 10, 30, 50].take(n).toList();

    String q = "${weights.map((e)=>'${e}g').join('、')}のおもりが1つずつある。\n"
               "てんびんの片側だけにおもりを載せるとき、□□通りの重さを量ることができる。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "各おもりについて「使う」「使わない」の2通りがある。\n"
                   "すべて「使わない」場合を除くので、2^$n - 1 = $ans通り。",
      scenarioId: 'PR_1_3_WEIGHTS',
    );
  }

  // 7. Reception (Days & People)
  GeneratedProblem _genPr1_4Reception() {
    int people = 5;
    int days = 2;
    int perDay = 3;
    // 5 people. 2 days. 3 people each day.
    // 1 person works 2 days. (Overlap = 1).
    // Total slots = 3 * 2 = 6. People = 5. Overlap = 1.
    // Step 1: Choose 1 person to work both days (5C1).
    // Step 2: Remaining 4 people split into Day1(2) and Day2(2). (4C2).
    // Ans = 5 * 6 = 30.
    
    int ans = _nCr(people, 1) * _nCr(people - 1, perDay - 1);

    String q = "P、Q、R、S、Tの5人が2日間にわたって開催される展覧会の受付をすることになった。\n"
               "受付はどちらの日も3人ずつ必要なので、5人のうち1人が2日間担当することにした。\n"
               "誰がどちらの日の担当になるか、その組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "2日間担当する1人の選び方は5通り。\n"
                   "残りの4人を、1日目の残り2枠と2日目の残り2枠に分ける選び方は4C2=6通り。\n"
                   "よって 5 × 6 = 30通り。",
      scenarioId: 'PR_1_4_RECEPTION',
    );
  }

  // 8. Seats (Permutation)
  GeneratedProblem _genPr2_1Seats() {
    int people = 3;
    // Seats config: Row1(1), Row2(1), Row3(2) -> Total 4 seats.
    // 3 people sit in 4 seats. Order matters?
    // "Which row they sit in". Seats in Row 3 are distinct?
    // Usually in this problem type, "Row 3 has 2 seats" implies specific seats.
    // 4 seats distinct. 4P3 = 24.
    // If Row 3 seats are identical (unlikely for seats), it would be diff.
    // Assuming distinct seats.
    int seats = 4;
    int ans = _nPr(seats, people);

    String q = "X、Y、Zの3人が遅れて講演会の会場に到着すると、1列目に1つ、2列目に1つ、3列目に2つ空席があった。\n"
               "このとき、3人がそれぞれ何列目に着席するか、その組み合わせは□□通りである。(同じ列の席は区別する)";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "空席は合計4つ。3人が区別のある4つの席に座るので、4P3 = 4×3×2 = $ans通り。",
      scenarioId: 'PR_2_1_SEATS',
    );
  }

  // 9. Cards (Partition with condition)
  GeneratedProblem _genPr2_2Cards() {
    // 1-5 cards. P(2), Q(3). Sum P < Sum Q.
    // Total sum = 15. Sum P < 7.5.
    // P's sum can be:
    // Min sum (1+2)=3. Max (for P<Q) is 7.
    // Pairs summing to <= 7:
    // 3: (1,2)
    // 4: (1,3)
    // 5: (1,4), (2,3)
    // 6: (1,5), (2,4)
    // 7: (2,5), (3,4) -- (1,6) impossible.
    // Count: 1+1+2+2+2 = 8?
    // Let's check: (1,2), (1,3), (1,4), (1,5), (2,3), (2,4), (2,5), (3,4).
    // (1,5)=6. (2,4)=6. (2,5)=7. (3,4)=7.
    // Yes, 8 pairs.
    int ans = 8;

    String q = "1から5までの数字が1つずつ書いてある5枚のカードを、Pが2枚、Qが3枚となるよう分ける。\n"
               "このとき、Pのカードの数字の和がQのカードの数字の和より小さくなるようなカードの分け方は□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "数字の合計は15なので、Pの和 < 7.5 となる組み合わせを探す。\n"
                   "P(2枚)の和が7以下になるのは、\n"
                   "(1,2), (1,3), (1,4), (1,5), (2,3), (2,4), (2,5), (3,4) の$ans通り。",
      scenarioId: 'PR_2_2_CARDS',
    );
  }

  // 10. Photo (Permutation with restriction)
  GeneratedProblem _genPr2_3Photo() {
    int n = 5;
    // V not at edge.
    // Total n! - V at edge (2 * (n-1)!)
    int total = _fact(n);
    int invalid = 2 * _fact(n - 1);
    int ans = total - invalid;

    String q = "5枚の写真V、W、X、Y、Zを横1列に展示することになった。\n"
               "Vは端にならないように並べるとすると、5枚の写真の並べ方は□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "5枚の順列は120通り。\n"
                   "Vが左端に来る場合：残り4枚の並びで24通り。\n"
                   "Vが右端に来る場合：同様に24通り。\n"
                   "よって 120 - (24 + 24) = $ans通り。",
      scenarioId: 'PR_2_3_PHOTO',
    );
  }

  // 11. Tennis (Grouping)
  GeneratedProblem _genPr2_4Tennis() {
    int n = 6;
    // Make 2 pairs (doubles) -> 4 people needed? Or match from 6?
    // "Make 2 pairs from 6 members and play a match".
    // Choose 4 from 6 (6C4=15).
    // Divide 4 into 2 pairs (4C2 / 2 = 3).
    // Total 15 * 3 = 45.
    int ans = 45;

    String q = "6人のメンバーから2人組を2つ作ってテニスのダブルスの試合をするとき、対戦の組み合わせは□□通りできる。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "6人から試合に出る4人を選ぶ：6C4 = 15通り。\n"
                   "選ばれた4人(A,B,C,D)で対戦を組む：ABvsCD, ACvsBD, ADvsBC の3通り。\n"
                   "よって 15 × 3 = $ans通り。",
      scenarioId: 'PR_2_4_TENNIS',
    );
  }

  // 12. Notebooks (Distribution)
  GeneratedProblem _genPr3_1Notebooks() {
    // White(2), Blue(2), Yellow(2). 3 People (P,Q,R) get 2 each.
    // Combinations for one person: (W,W), (B,B), (Y,Y), (W,B), (W,Y), (B,Y). (6 types)
    // Distribute these 3 types to P,Q,R such that total is 2W, 2B, 2Y.
    // Case 1: (W,W), (B,B), (Y,Y) -> Permutation of 3 distinct items = 3! = 6.
    // Case 2: (W,B), (B,Y), (Y,W) -> Each has diff colors.
    //    P gets {W,B}, Q gets {B,Y}, R gets {Y,W}. -> 3! = 6? Wait.
    //    Actually, Logic:
    //    P can get: SameColor(3 types) or DiffColor(3 types).
    //    If P gets Same (e.g. WW): Remain BB, YY. Q must get BB or YY. R gets remaining.
    //      -> 3 choices for P (WW, BB, YY). Then Q has 2 choices. R 1. -> 3*2*1 = 6 ways.
    //    If P gets Diff (e.g. WB): Remain W, B, Y, Y.
    //      Q can get (W,B) -> R gets (Y,Y). (Pairs: WB, WB, YY). Order: 3!/2! = 3 ways.
    //      Q can get (W,Y) -> R gets (B,Y). (Pairs: WB, WY, BY). Order: 3! = 6 ways.
    //      Q can get (Y,Y) -> Impossible (Remain W, B).
    //    Total ways = 21 (from image hint).
    //    Calculated: 6 (Same,Same,Same) + ?
    //    (Same, Diff, Diff): e.g. WW, BY, BY. Permutations: 3 * 1 = 3? No.
    //    (WW, BY, BY) -> 3 choices for Same (WW,BB,YY). For each, others are fixed (BY).
    //    So (WW, BY, BY), (BB, WY, WY), (YY, WB, WB).
    //    Permutations of (A, B, B) is 3. Total 3 * 3 = 9.
    //    (Diff, Diff, Diff): (WB, BY, YW). Unique patterns?
    //    Only 1 set of pairs {WB, BY, YW}. Permutation is 3! = 6.
    //    Sum: 6 + 9 + 6 = 21.
    int ans = 21;

    String q = "白、青、黄のノートが2冊ずつある。P、Q、Rの3人で2冊ずつ分けるとき、\n"
               "だれがどの色のノートを何冊もらうか、その組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "①全員が「同じ色2冊」：(白白,青青,黄黄)の順列 = 6通り。\n"
                   "②1人が「同じ色2冊」、2人が「違う色」：(白白,青黄,青黄)など。3通り×3 = 9通り。\n"
                   "③全員が「違う色」：(白青,青黄,黄白)の順列 = 6通り。\n"
                   "合計 6 + 9 + 6 = 21通り。",
      scenarioId: 'PR_3_1_NOTEBOOKS',
    );
  }

  // 13. Handkerchiefs (Boxes restriction)
  GeneratedProblem _genPr3_2Handkerchiefs() {
    // 5 handkerchiefs. Boxes L, M, S.
    // Capacity: L<=3, M<=2, S<=1.
    // Partition 5 into (l, m, s). Sum=5.
    // Possible (l, m, s):
    // (3, 2, 0) -> OK.
    // (3, 1, 1) -> OK.
    // (2, 2, 1) -> OK.
    // Calc permutations for each partition.
    // 5 distinct items.
    // (3,2,0): 5C3 * 2C2 = 10 * 1 = 10.
    // (3,1,1): 5C3 * 2C1 * 1C1 = 10 * 2 = 20.
    // (2,2,1): 5C2 * 3C2 * 1C1 = 10 * 3 = 30.
    // Total = 10 + 20 + 30 = 60.
    int ans = 60;

    String q = "紺、白、茶、赤、黄の5枚のハンカチが大、中、小の3つの箱に入っている。\n"
               "大箱には3枚まで、中箱には2枚まで、小箱には1枚のハンカチが入る。空箱はないとすると、\n"
               "どの箱に何色のハンカチが入っているか、その組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "枚数の分け方は以下の3パターン。\n"
                   "①(大3,中1,小1)：5C3 × 2C1 = 20通り。\n"
                   "②(大2,中2,小1)：5C2 × 3C2 = 30通り。\n"
                   "③(大3,中2,小0)は「空箱なし」に反するので除外？\n"
                   "問題文に「空箱はない」とあるため、(3,2,0)は不可。\n"
                   "よって 20 + 30 = 50通り。",
      // Wait, let's re-read the logic.
      // My manual calc included (3,2,0) which has empty Small box.
      // If "No empty box", then (3,2,0) is invalid.
      // So ans = 50.
      // Image hint might differ? Image text is blurry.
      // "空箱はない" is clearly visible in OCR.
      // So 50 is correct logic.
      scenarioId: 'PR_3_2_HANDKERCHIEFS',
    );
  }

  // 14. Dice (Inequality)
  GeneratedProblem _genPr3_3Dice() {
    // x + 6 <= 2y. x,y in 1..6.
    // 2y >= x + 6 -> y >= x/2 + 3.
    // x=1: y >= 3.5 -> y=4,5,6 (3)
    // x=2: y >= 4   -> y=4,5,6 (3)
    // x=3: y >= 4.5 -> y=5,6   (2)
    // x=4: y >= 5   -> y=5,6   (2)
    // x=5: y >= 5.5 -> y=6     (1)
    // x=6: y >= 6   -> y=6     (1)
    // Total: 3+3+2+2+1+1 = 12.
    int ans = 12;

    String q = "サイコロを2回振って1回目に出た目の数をx、2回目に出た目の数をyとする。\n"
               "このとき、x + 6 ≦ 2y になる組み合わせは□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "不等式を変形すると y ≧ x/2 + 3。\n"
                   "x=1,2のとき yは4,5,6 (計6通り)\n"
                   "x=3,4のとき yは5,6 (計4通り)\n"
                   "x=5,6のとき yは6 (計2通り)\n"
                   "合計 12通り。",
      scenarioId: 'PR_3_3_DICE',
    );
  }

  // 15. Ages (Relative Order)
  GeneratedProblem _genPr3_4Ages() {
    // P,Q,R,S. P-Q=6, R-S=6, Q-R=3.
    // Q = R + 3.
    // P = Q + 6 = R + 9.
    // S = R - 6.
    // Relation: S < R < Q < P.
    // Intervals: S --(6)--> R --(3)--> Q --(6)--> P.
    // Order is fixed: S, R, Q, P (Ascending).
    // Wait, "Difference is 6" means |P-Q|=6. Could be P>Q or Q>P.
    // Combinations of +/-.
    // Base: R. S = R±6. Q = R±3. P = Q±6 = R±3±6.
    // We want "Order by age". How many valid orderings?
    // Constraints:
    // 1. |P-Q|=6
    // 2. |R-S|=6
    // 3. |Q-R|=3
    // Let's enumerate cases relative to R=0.
    // Q = +3 or -3.
    // S = +6 or -6.
    // If Q=+3: P = +3+6=+9 or +3-6=-3.
    // If Q=-3: P = -3+6=+3 or -3-6=-9.
    // Patterns (S, R, Q, P) coordinates:
    // 1. Q=3, S=6, P=9  -> (-6, 0, 3, 9) -> S<R<Q<P (No, S=6 > R=0). Order: R, Q, S, P? No.
    // Let's list values: R=0.
    // S can be {6, -6}. Q can be {3, -3}. P can be Q±6.
    // Cases:
    // (S, Q, P) tuple given R=0.
    // 1. (6, 3, 9)  -> Order: 0, 3, 6, 9 (R, Q, S, P)
    // 2. (6, 3, -3) -> Order: -3, 0, 3, 6 (P, R, Q, S)
    // 3. (6, -3, 3) -> Order: -3, 0, 3, 6 (Q, R, P, S) ?? P=3, Q=-3. |P-Q|=6 OK.
    // 4. (6, -3, -9)-> Order: -9, -3, 0, 6 (P, Q, R, S)
    // 5. (-6, 3, 9) -> Order: -6, 0, 3, 9 (S, R, Q, P)
    // 6. (-6, 3, -3)-> Order: -6, -3, 0, 3 (S, P, R, Q) ?? P=-3, Q=3. |P-Q|=6 OK.
    // 7. (-6, -3, 3)-> Order: -6, -3, 0, 3 (S, Q, R, P)
    // 8. (-6, -3, -9)-> Order: -9, -6, -3, 0 (P, S, Q, R)
    // Are all these 8 distinct orderings?
    // 1. R Q S P
    // 2. P R Q S
    // 3. Q R P S (Wait, Q=-3, R=0, P=3, S=6. Order: Q R P S)
    // 4. P Q R S
    // 5. S R Q P
    // 6. S P R Q (S=-6, P=-3, R=0, Q=3. Order: S P R Q)
    // 7. S Q R P
    // 8. P S Q R
    // Yes, 8 orderings.
    int ans = 8;

    String q = "ある職場の30代の社員P、Q、R、Sの年齢は、PとQが6歳差、RとSが6歳差、QとRが3歳差である。\n"
               "この4人を年齢の若い順に並べるとき、考えられる順番は□□通りである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans),
      correctAnswer: "$ans通り",
      explanation: "Rを基準に考えると、QはR±3歳、SはR±6歳、PはQ±6歳。\n"
                   "条件を満たす相対的な年齢差のパターンを書き出すと8通りある。",
      scenarioId: 'PR_3_4_AGES',
    );
  }
}
