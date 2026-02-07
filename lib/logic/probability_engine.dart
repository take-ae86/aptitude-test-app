import 'dart:math';

// =========================================================
// Probability Engine (For SPI)
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

class ProbabilityEngine {
  final Random _rand = Random();

  // 14 Scenarios
  static const List<String> _allScenarioIds = [
    'EX_1_CARDS_DIV',
    'EX_2_RESTAURANT',
    'EX_3_COINS_MIN',
    'PR_1_1_BALLS',
    'PR_1_2_CARDS_ODD',
    'PR_1_3_CARDS_EVEN_PROD',
    'PR_1_4_LUCKY_BAG',
    'PR_2_1_SEATS_PAIR',
    'PR_2_2_COINS_SUM',
    'PR_2_3_MELON',
    'PR_3_1_DICE_MULT',
    'PR_3_2_GOLD_SILVER',
    'PR_3_3_SEATS_ADJACENT',
    'PR_3_4_SWEETS_EXCHANGE',
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
      case 'EX_1_CARDS_DIV': return _genEx1CardsDiv();
      case 'EX_2_RESTAURANT': return _genEx2Restaurant();
      case 'EX_3_COINS_MIN': return _genEx3CoinsMin();
      case 'PR_1_1_BALLS': return _genPr1_1Balls();
      case 'PR_1_2_CARDS_ODD': return _genPr1_2CardsOdd();
      case 'PR_1_3_CARDS_EVEN_PROD': return _genPr1_3CardsEvenProd();
      case 'PR_1_4_LUCKY_BAG': return _genPr1_4LuckyBag();
      case 'PR_2_1_SEATS_PAIR': return _genPr2_1SeatsPair();
      case 'PR_2_2_COINS_SUM': return _genPr2_2CoinsSum();
      case 'PR_2_3_MELON': return _genPr2_3Melon();
      case 'PR_3_1_DICE_MULT': return _genPr3_1DiceMult();
      case 'PR_3_2_GOLD_SILVER': return _genPr3_2GoldSilver();
      case 'PR_3_3_SEATS_ADJACENT': return _genPr3_3SeatsAdjacent();
      case 'PR_3_4_SWEETS_EXCHANGE': return _genPr3_4SweetsExchange();
      default: return _genEx1CardsDiv();
    }
  }

  // Utilities
  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);
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
  int _fact(int n) => n <= 1 ? 1 : n * _fact(n - 1);

  List<String> _makeOptions(int num, int den, {String unit = ""}) {
    // Simplify answer first
    int g = _gcd(num, den);
    num ~/= g; den ~/= g;
    
    Set<String> s = {};
    s.add("$num/$den$unit");
    
    // Generate distractors (fractions)
    while(s.length < 5) {
      int dNum = num + (_rand.nextBool() ? 1 : -1) * (_rand.nextInt(3) + 1);
      int dDen = den + (_rand.nextBool() ? 1 : -1) * (_rand.nextInt(5) + 1);
      if (dNum > 0 && dDen > dNum) { // Probability usually < 1
         // Simplify distractor
         int dg = _gcd(dNum, dDen);
         dNum ~/= dg; dDen ~/= dg;
         s.add("$dNum/$dDen$unit");
      }
    }
    // Sort logic might fail for fractions, simple string sort
    List<String> list = s.toList();
    list.sort(); 
    return list;
  }

  // 1. Cards Divisible (Ex1)
  GeneratedProblem _genEx1CardsDiv() {
    int maxCard = 13 + _rand.nextInt(3); // 13-15
    int div = 3 + _rand.nextInt(2); // 3 or 4
    // Count multiples
    int count = maxCard ~/ div;
    // P(both div) = count C 2 / maxCard C 2
    int num = _nCr(count, 2);
    int den = _nCr(maxCard, 2);
    
    String q = "1から$maxCardまでの数字が1つずつ書かれた$maxCard枚のカードをよくきって2枚同時に取り出したとき、\n"
               "どちらのカードの数字も$divで割り切れる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "$maxCard枚のうち$divの倍数は$count枚。\n"
                   "すべての選び方は${maxCard}C2 = $den通り。\n"
                   "条件を満たす選び方は${count}C2 = $num通り。\n"
                   "確率は $num/$den。",
      scenarioId: 'EX_1_CARDS_DIV',
    );
  }

  // 2. Restaurant (Ex2)
  GeneratedProblem _genEx2Restaurant() {
    int mRatio = 50 + _rand.nextInt(20); // 50-70%
    int fRatio = 60 + _rand.nextInt(20); // 60-80%
    String drink = "紅茶";
    
    // Male(Drink) = mRatio/100. Male(Other) = (100-mRatio)/100.
    // Female(Drink) = fRatio/100.
    // P(Different) = P(M_D)*P(F_O) + P(M_O)*P(F_D)
    int md = mRatio; int mo = 100 - mRatio;
    int fd = fRatio; int fo = 100 - fRatio;
    
    int num = (md * fo) + (mo * fd);
    int den = 10000;

    String q = "あるレストランでは、統計的に男性客の$mRatio%、女性客の$fRatio%は$drinkを選ぶことがわかっている。\n"
               "セットメニューを注文した1組の男女が異なる飲み物を選ぶ確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "男性が$drink、女性が他：0.${md} × 0.${fo} = ${md*fo/10000}\n"
                   "男性が他、女性が$drink：0.${mo} × 0.${fd} = ${mo*fd/10000}\n"
                   "合計して ${num/10000}。",
      scenarioId: 'EX_2_RESTAURANT',
    );
  }

  // 3. Coins Min Sum (Ex3)
  GeneratedProblem _genEx3CoinsMin() {
    // 5yen*2, 10yen*2. Total 4.
    // Sum >= target.
    // Coins: A(5), B(5), C(10), D(10).
    int target = 25; 
    // Total 2^4 = 16.
    // < 25: 0, 5, 10, 15, 20.
    // 0: (0,0) - 1 way
    // 5: (1,0) - 2C1 * 1 = 2 ways
    // 10: (2,0), (0,1) - 1 + 2 = 3 ways
    // 15: (1,1) - 2 * 2 = 4 ways
    // 20: (2,1), (0,2) - 2 + 1 = 3 ways
    // Sum < 25: 1+2+3+4+3 = 13 ways.
    // >= 25: 16 - 13 = 3 ways.
    // (25: (1,2) 2*1=2. 30: (2,2) 1*1=1. Total 3.)
    int num = 3; 
    int den = 16;

    String q = "5円玉が2枚、10円玉が2枚ある。この4枚の硬貨を同時に投げ、表が出たものの金額を足す。\n"
               "金額の合計が${target}円以上になる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "全通りは2^4=16通り。\n"
                   "25円以上になるのは、\n"
                   "・25円(5円1枚,10円2枚)：2C1 × 1 = 2通り\n"
                   "・30円(5円2枚,10円2枚)：1 × 1 = 1通り\n"
                   "計3通り。確率は 3/16。",
      scenarioId: 'EX_3_COINS_MIN',
    );
  }

  // 4. Balls (Pr1-1)
  GeneratedProblem _genPr1_1Balls() {
    int r = 4 + _rand.nextInt(3); // 4-6
    int w = 3 + _rand.nextInt(3); // 3-5
    int total = r + w;
    // Both Red
    int num = _nCr(r, 2);
    int den = _nCr(total, 2);

    String q = "赤玉が$r個と白玉が$w個入った袋から玉を同時に2個取り出す。\n"
               "このとき、2個とも赤玉である確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "すべての取り出し方は${total}C2 = $den通り。\n"
                   "2個とも赤玉になるのは${r}C2 = $num通り。\n"
                   "確率は $num/$den。",
      scenarioId: 'PR_1_1_BALLS',
    );
  }

  // 5. Cards Odd Sum (Pr1-2)
  GeneratedProblem _genPr1_2CardsOdd() {
    int maxCard = 9; 
    // Odd: 1,3,5,7,9 (5). Even: 2,4,6,8 (4).
    int oddCount = 5; int evenCount = 4;
    int den = _nCr(maxCard, 2); // 36
    // Sum Odd = Odd + Even.
    int num = oddCount * evenCount; // 20

    String q = "1から$maxCardまでの数字が1つずつ書かれたカード$maxCard枚をよくきって2枚同時に取り出したとき、\n"
               "2枚のカードに書かれた数字の和が奇数になる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "和が奇数になるのは「奇数＋偶数」の組み合わせ。\n"
                   "奇数は$oddCount枚、偶数は$evenCount枚あるので、$oddCount × $evenCount = $num通り。\n"
                   "全体は${maxCard}C2 = $den通り。確率は $num/$den。",
      scenarioId: 'PR_1_2_CARDS_ODD',
    );
  }

  // 6. Cards Even Prod (Pr1-3)
  GeneratedProblem _genPr1_3CardsEvenProd() {
    int maxCard = 6; 
    // Even Prod = 1 - Odd Prod.
    // Odd Prod = Odd * Odd.
    int oddCount = 3; // 1,3,5
    int totalC2 = _nCr(maxCard, 2); // 15
    int oddC2 = _nCr(oddCount, 2); // 3
    int num = totalC2 - oddC2; // 12
    int den = totalC2;

    String q = "1から$maxCardまでの数字が1つずつ書かれたカード$maxCard枚をよくきって2枚同時に取り出したとき、\n"
               "2枚のカードに書かれた数字の積が偶数になる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "積が偶数になるのは「少なくとも1枚が偶数」の場合。\n"
                   "余事象「2枚とも奇数」を考える。\n"
                   "奇数は$oddCount枚なので、${oddCount}C2 = $oddC2通り。\n"
                   "全体は${maxCard}C2 = $den通り。\n"
                   "1 - ($oddC2/$den) = $num/$den。",
      scenarioId: 'PR_1_3_CARDS_EVEN_PROD',
    );
  }

  // 7. Lucky Bag (Pr1-4)
  GeneratedProblem _genPr1_4LuckyBag() {
    int r = 40, s = 60;
    int y = 20, z = 80;
    // R&Y or S&Z.
    int ry = r * y; // 800
    int sz = s * z; // 4800
    int num = ry + sz; // 5600
    int den = 100 * 100; // 10000

    String q = "100袋限定の福袋がある。1袋の中には商品RかSのどちらか1個と、商品YかZのどちらか1個が入っている。\n"
               "Rが$r個、Sが$s個、Yが$y個、Zが$z個である。\n"
               "商品RかZのどちらか一方だけが入っている確率は□□である。"; 
               // Wait, logic in my note was "R and Y" or "S and Z".
               // Re-read Image PR1-4: "R or Z only ONE is included" -> (R and not Z) or (not R and Z).
               // (R and Y) or (S and Z).
               // My note logic matches the image text "RかZのどちらか一方だけ".
               // R&Y (R, not Z) -> Yes.
               // S&Z (not R, Z) -> Yes.
               // R&Z (Both) -> No.
               // S&Y (Neither) -> No.
               // So (R&Y) + (S&Z). Correct.

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "RかZの一方だけが入っているのは、「RとY」または「SとZ」の組み合わせ。\n"
                   "RとY：$r/100 × $y/100 = $ry/10000\n"
                   "SとZ：$s/100 × $z/100 = $sz/10000\n"
                   "合計 $num/10000。",
      scenarioId: 'PR_1_4_LUCKY_BAG',
    );
  }

  // 8. Seats Pair (Pr2-1)
  GeneratedProblem _genPr2_1SeatsPair() {
    int m = 7, f = 4; // 11
    // Seats: 3, 3, 3, 2. (Total 11)
    // Pair seat gets Male & Female.
    // Total ways to choose 2 people for the pair seat: 11C2 = 55.
    // Ways to choose 1M 1F: 7C1 * 4C1 = 28.
    int num = 28;
    int den = 55;

    String q = "男性$m人、女性$f人の計11人が、3人席3つ、2人席1つに分かれて座ることになった。\n"
               "くじ引きで席を決める場合、2人席に男性と女性が座る確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "2人席に座る2人の選び方は11C2 = 55通り。\n"
                   "そのうち男女ペアになるのは、男性$m人から1人、女性$f人から1人選ぶ$m×$f = $num通り。\n"
                   "確率は $num/$den。",
      scenarioId: 'PR_2_1_SEATS_PAIR',
    );
  }

  // 9. Coins Sum 150 (Pr2-2)
  GeneratedProblem _genPr2_2CoinsSum() {
    // 100x1, 50x2, 10x5. (8 coins)
    // Sum 150.
    // Patterns from note:
    // 1. 100x1, 50x1 -> 1*2 = 2
    // 2. 100x1, 10x5 -> 1*1 = 1
    // 3. 50x2, 10x5 -> 1*1 = 1
    // Total 4.
    // Denom 2^8 = 256.
    int num = 4;
    int den = 256;

    String q = "100円玉が1枚、50円玉が2枚、10円玉が5枚ある。この8枚の硬貨を同時に投げ、表が出たものの金額を足す。\n"
               "金額の合計が150円になる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "合計150円になる組み合わせは以下の3パターン。\n"
                   "①100円1枚+50円1枚：1C1 × 2C1 = 2通り\n"
                   "②100円1枚+10円5枚：1C1 × 5C5 = 1通り\n"
                   "③50円2枚+10円5枚：2C2 × 5C5 = 1通り\n"
                   "合計4通り。全体は2^8=256通り。確率は 4/256。",
      scenarioId: 'PR_2_2_COINS_SUM',
    );
  }

  // 10. Melon (Pr2-3)
  GeneratedProblem _genPr2_3Melon() {
    // 4 melons. Sell & Replace. 4th customer.
    // Not sold out initial 4.
    // Comp Prob: Initial 4 sold out.
    // 1st: 4/4(init)
    // 2nd: 3/4(init)
    // 3rd: 2/4(init)
    // 4th: 1/4(init)
    // P(All Init) = 24/256 = 3/32.
    // P(Not All) = 1 - 3/32 = 29/32.
    int num = 29;
    int den = 32;

    String q = "店頭にメロンが4個並べてある。1個売れるたびに倉庫からメロンを1個出して並べる。\n"
               "4回目に店を訪れた人を並べたところで、最初に店頭にあった4個のうち1個でも残っている確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "4人とも「初期在庫」を選んでしまう確率を求める。\n"
                   "1人目:4/4、2人目:3/4、3人目:2/4、4人目:1/4。\n"
                   "積は 6/64 = 3/32。\n"
                   "余事象なので 1 - 3/32 = 29/32。",
      scenarioId: 'PR_2_3_MELON',
    );
  }

  // 11. Dice Mult 4 (Pr3-1)
  GeneratedProblem _genPr3_1DiceMult() {
    // Mult of 4.
    // Total 36.
    // Not Mult 4: (Odd, Odd)=9, (Odd, 2/6)=6, (2/6, Odd)=6. 
    // Total 21.
    // Mult 4 = 36 - 21 = 15.
    // Prob 15/36 = 5/12.
    // Wait, my manual note said 7/12. Let's re-calc.
    // Not Mult 4:
    // (1,3,5) x (1,3,5) = 9.
    // (1,3,5) x (2,6) = 3x2 = 6.
    // (2,6) x (1,3,5) = 2x3 = 6.
    // (2,2)=4(OK), (2,6)=12(OK), (6,2)=12(OK), (6,6)=36(OK).
    // So Not Mult 4 is 9+6+6=21.
    // Mult 4 is 36-21=15.
    // 15/36 = 5/12.
    // Image 3 says "Answer is (something)/12". 7/12?
    // Let's re-read image. "Pr3-1: Divisible by 4".
    // 4, 8, 12, 16, 20, 24, 28, 32, 36.
    // Pairs:
    // (1,4), (2,2), (2,4), (2,6), (3,4), (4,1)..(4,6), (5,4), (6,2), (6,4), (6,6).
    // 1: (1,4)
    // 2: (2,2), (2,4), (2,6)
    // 3: (3,4)
    // 4: (4,1)..(4,6) (6)
    // 5: (5,4)
    // 6: (6,2), (6,4), (6,6)
    // Total: 1 + 3 + 1 + 6 + 1 + 3 = 15.
    // Correct is 15. 15/36 = 5/12.
    // Why did I think 7/12? Maybe "Sum divisible by 4"? 
    // Image text: "出た目の積が4の倍数になる". Product.
    // Okay, 5/12.
    int num = 5;
    int den = 12;

    String q = "2個のサイコロを同時に振ったとき、出た目の積が4の倍数になる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "積が4の倍数にならないのは、(奇数,奇数)9通り、(奇数,2or6)6通り、(2or6,奇数)6通りの計21通り。\n"
                   "4の倍数になるのは 36 - 21 = 15通り。\n"
                   "確率は 15/36 = 5/12。",
      scenarioId: 'PR_3_1_DICE_MULT',
    );
  }

  // 12. Gold Silver (Pr3-2)
  GeneratedProblem _genPr3_2GoldSilver() {
    // 1 pick gold = 1/5 -> Gold=2, Silver=8 (Total 10).
    // 2 pick -> Gold=1.
    // Gold1 Silver1.
    // 2C1 * 8C1 = 16.
    // 10C2 = 45.
    // 16/45.
    int num = 16;
    int den = 45;

    String q = "箱の中に金と銀の玉が合わせて10個入っている。玉を1個取り出したときに金が出る確率が1/5だとすると、\n"
               "玉を同時に2個取り出したとき、金が1個だけ出る確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "金が出る確率1/5より、金2個、銀8個。\n"
                   "2個中1個が金(もう1個は銀)となるのは、2C1 × 8C1 = 16通り。\n"
                   "全体は10C2 = 45通り。確率は 16/45。",
      scenarioId: 'PR_3_2_GOLD_SILVER',
    );
  }

  // 13. Seats Adjacent (Pr3-3)
  GeneratedProblem _genPr3_3SeatsAdjacent() {
    // 6 seats. T and W adjacent.
    // 5! * 2 = 240.
    // 6! = 720.
    // 1/3.
    int num = 1;
    int den = 3;

    String q = "横一列に並んだ6つの席がある。T、U、V、W、X、Yの6人がくじ引きで座る席を決めるとき、\n"
               "TとWが隣り合わせの席になる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "TとWを1組として考えると、5つの要素の順列 5! = 120通り。\n"
                   "TとWの並び順が2通りあるので、120 × 2 = 240通り。\n"
                   "全体は 6! = 720通り。確率は 240/720 = 1/3。",
      scenarioId: 'PR_3_3_SEATS_ADJACENT',
    );
  }

  // 14. Sweets Exchange (Pr3-4)
  GeneratedProblem _genPr3_4SweetsExchange() {
    // Derangement D4 = 9.
    // Total 4! = 24.
    // 9/24 = 3/8.
    int num = 3;
    int den = 8;

    String q = "4人が1つずつ手作りの菓子を用意して交換する。くじで菓子を割り当てるとき、\n"
               "全員が自分以外が用意した菓子をもらえる確率は□□である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(num, den),
      correctAnswer: _fracStr(num, den),
      explanation: "4人の完全順列(全員が自分のものに当たらない)は9通り。\n"
                   "全体は4! = 24通り。\n"
                   "確率は 9/24 = 3/8。",
      scenarioId: 'PR_3_4_SWEETS_EXCHANGE',
    );
  }

  String _fracStr(int n, int d) {
    int g = _gcd(n, d);
    return "${n~/g}/${d~/g}";
  }
}
