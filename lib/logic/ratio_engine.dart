import 'dart:math';

// =========================================================
// Ratio, Proportion, Payment, Work Engine (For SPI)
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

class RatioEngine {
  final Random _rand = Random();

  // 12 Scenarios
  static const List<String> _allScenarioIds = [
    'PR_1_1_BUS',
    'PR_1_2_SHOPPING_DIFF',
    'PR_1_3_AGE_RATIO',
    'PR_1_4_POTATO_ONION',
    'PR_2_1_LIQUID_MIX',
    'PR_2_2_GARDEN_AREA',
    'PR_2_3_CIRCLE_RATIO',
    'PR_2_4_EMPLOYEE_RATIO',
    'PR_3_1_BUS_COMMUTE',
    'PR_3_2_AGE_FUTURE',
    'PR_3_3_CAKE_CUT',
    'PR_3_4_DATA_INPUT',
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
      case 'PR_1_1_BUS': return _genPr1_1Bus();
      case 'PR_1_2_SHOPPING_DIFF': return _genPr1_2ShoppingDiff();
      case 'PR_1_3_AGE_RATIO': return _genPr1_3AgeRatio();
      case 'PR_1_4_POTATO_ONION': return _genPr1_4PotatoOnion();
      case 'PR_2_1_LIQUID_MIX': return _genPr2_1LiquidMix();
      case 'PR_2_2_GARDEN_AREA': return _genPr2_2GardenArea();
      case 'PR_2_3_CIRCLE_RATIO': return _genPr2_3CircleRatio();
      case 'PR_2_4_EMPLOYEE_RATIO': return _genPr2_4EmployeeRatio();
      case 'PR_3_1_BUS_COMMUTE': return _genPr3_1BusCommute();
      case 'PR_3_2_AGE_FUTURE': return _genPr3_2AgeFuture();
      case 'PR_3_3_CAKE_CUT': return _genPr3_3CakeCut();
      case 'PR_3_4_DATA_INPUT': return _genPr3_4DataInput();
      default: return _genPr1_1Bus();
    }
  }

  // Utilities
  List<String> _makeOptions(int correct, {String unit = ""}) {
    Set<String> s = {};
    s.add("$correct$unit");
    int safety = 0;
    while(s.length < 5) {
      safety++;
      if (safety > 50) {
        int val = correct + 1;
        while (s.length < 5) {
          if (!s.contains("$val$unit")) s.add("$val$unit");
          val++;
        }
        break;
      }
      double range = correct * 0.2; 
      if (range < 5) range = 5;
      int diff = _rand.nextInt(range.toInt()) + 1;
      if (_rand.nextBool()) diff = -diff;
      int val = correct + diff;
      if (val > 0) s.add("$val$unit");
    }
    List<String> list = s.toList();
    list.sort((a, b) {
      // numeric sort
      double valA = double.tryParse(a.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      double valB = double.tryParse(b.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      return valA.compareTo(valB);
    });
    return list;
  }

  // 1. Bus (Pr1-1)
  GeneratedProblem _genPr1_1Bus() {
    // Adult A, Child C.
    // A_bus1 = A * 3/5 = 18 -> A = 30.
    // A : C = 5 : 6 -> 30 : C = 5 : 6 -> C = 36.
    
    // Logic: A must be divisible by 5 (or denominator).
    int ratioA_num = 3;
    int ratioA_den = 5;
    int a_bus1 = (2 + _rand.nextInt(4)) * ratioA_num; // e.g. 6, 9, 12... * mult.
    // a_bus1 = A * num / den. -> A = a_bus1 * den / num.
    // Ensure a_bus1 is divisible by num.
    while (a_bus1 % ratioA_num != 0) a_bus1++;
    
    int adult = (a_bus1 * ratioA_den) ~/ ratioA_num;
    
    int rA = 5;
    int rC = 6;
    // adult : child = rA : rC.
    // adult * rC = child * rA. Child = adult * rC / rA.
    // adult must be divisible by rA?
    // rA is 5. adult is (a_bus1 * 5 / 3). It is divisible by 5.
    
    int child = (adult * rC) ~/ rA;
    
    String q = "ある地区の大人と子どもが2台のバスで旅行にでかけた。大人の参加者の$ratioA_num/$ratioA_denにあたる"
               "${a_bus1}人は1台目のバスに乗った。参加した大人と子どもの人数の割合が$rA：$rCだった"
               "とすると、参加した子どもは□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(child, unit: "人"),
      correctAnswer: "$child人",
      explanation: "大人の人数 = $a_bus1 ÷ ($ratioA_num/$ratioA_den) = $adult人。\n"
                   "大人：子ども = $rA：$rC なので、\n"
                   "子ども = $adult × $rC ÷ $rA = $child人。",
      scenarioId: 'PR_1_1_BUS',
    );
  }

  // 2. Shopping Diff (Pr1-2)
  GeneratedProblem _genPr1_2ShoppingDiff() {
    int diffMoney = 17500;
    int diffPay = 6300;
    // diffPay = diffMoney * x. x = diffPay / diffMoney.
    // 6300 / 17500 = 0.36.
    // Generate numbers such that ratio is integer %.
    
    int ratio = 20 + _rand.nextInt(30); // 20-50%
    int diffM = (10 + _rand.nextInt(20)) * 1000; // 10000-30000
    int diffP = (diffM * ratio) ~/ 100;
    
    String q = "PとQが買い物に出かけた。持参したお金はPがQより$diffM円多く、どちらも持"
               "参したお金の□□％ずつ使って買い物をしたので、買い物代はPがQより$diffP"
               "円多くなった（必要なときは、最後に小数点以下第1位を四捨五入すること）。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ratio, unit: "%"),
      correctAnswer: "$ratio%",
      explanation: "買い物代の差($diffP円) = 持参金の差($diffM円) × 使った割合。\n"
                   "割合 = $diffP ÷ $diffM = ${ratio/100} → $ratio%。",
      scenarioId: 'PR_1_2_SHOPPING_DIFF',
    );
  }

  // 3. Age Ratio (Pr1-3)
  GeneratedProblem _genPr1_3AgeRatio() {
    int diff = 12;
    // P = Q - 12. P = 5/8 Q.
    // Q - 12 = 5/8 Q -> 3/8 Q = 12 -> Q = 32. P=20.
    // Generalized: P = n/d Q. Q - diff = n/d Q.
    // (1 - n/d) Q = diff. ((d-n)/d) Q = diff.
    // Q = diff * d / (d-n).
    // Need d-n to divide diff * d.
    
    int n = 5;
    int d = 8;
    int gap = d - n; // 3
    // diff must be divisible by gap? Or Q must be integer.
    // Q = diff * 8 / 3.
    int diffVal = (1 + _rand.nextInt(10)) * gap; // 3, 6, 9...
    int qVal = (diffVal * d) ~/ gap;
    int pVal = qVal - diffVal;

    String q = "Pの年齢はQより${diffVal}歳若く、またQの年齢の$n/$dである。このとき、Pは□□歳"
               "である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(pVal, unit: "歳"),
      correctAnswer: "$pVal歳",
      explanation: "Qの年齢をxとすると、Pは$n/$d x。\n"
                   "その差(1 - $n/$d)x = $diffVal。\n"
                   "$gap/$d x = $diffVal → x = $qVal。\n"
                   "P = $qVal - $diffVal = $pVal歳。",
      scenarioId: 'PR_1_3_AGE_RATIO',
    );
  }

  // 4. Potato Onion (Pr1-4)
  GeneratedProblem _genPr1_4PotatoOnion() {
    int total = 56;
    int r1n = 2, r1d = 3; // Potato 2/3
    int r2n = 1, r2d = 4; // Onion 1/4
    int got = 24;
    
    // x(2/3) + (Total-x)(1/4) = Got.
    // 8x + 3(Total-x) = 12*Got.
    // 5x + 3*Total = 12*Got.
    // 5x = 12*Got - 3*Total.
    // x = (12*Got - 3*Total) / 5.
    
    // Generate valid numbers.
    // x must be divisible by 3 (since 2/3 x is integer items? usually).
    // (Total-x) divisible by 4.
    // Let's reverse.
    int x = (1 + _rand.nextInt(10)) * 3 * 4; // 12, 24, 36...
    int y = (1 + _rand.nextInt(10)) * 4; // 4, 8, 12...
    total = x + y;
    
    int gotPotato = (x * r1n) ~/ r1d;
    int gotOnion = (y * r2n) ~/ r2d;
    got = gotPotato + gotOnion;
    
    // Question asks for "P got Potato count" (gotPotato).
    
    String q = "いもと玉ねぎが合わせて${total}個あった。この中からPはいもの$r1n/$r1dと玉ねぎの$r2n/$r2d、合"
               "わせて${got}個もらった。このとき、Pはいもを□□個もらった。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(gotPotato, unit: "個"),
      correctAnswer: "$gotPotato個",
      explanation: "いもをx個とすると、玉ねぎは(${total}-x)個。\n"
                   "$r1n/$r1d x + $r2n/$r2d (${total}-x) = $got\n"
                   "これを解くと x=$x。\n"
                   "もらったいもは $x × $r1n/$r1d = $gotPotato個。",
      scenarioId: 'PR_1_4_POTATO_ONION',
    );
  }

  // 5. Liquid Mix (Pr2-1)
  GeneratedProblem _genPr2_1LiquidMix() {
    int r1a = 3, r1b = 1; // 3:1 -> 1/4 Red
    int r2a = 3, r2b = 2; // 3:2 -> 2/5 Red
    // Mix equal amount. LCM(4,5) = 20.
    // Liq1(20): Blue 15, Red 5.
    // Liq2(20): Blue 12, Red 8.
    // Mix(40): Blue 27, Red 13.
    // Red Ratio = 13/40 = 32.5%.
    
    // Generate Ratios
    int total1 = r1a + r1b;
    int total2 = r2a + r2b;
    // To allow nice percentage, (Red1/T1 + Red2/T2)/2 should be terminating decimal.
    // Let's stick to the image problem values or similar simple ones.
    
    double ans = 32.5;
    
    String q = "青い液体と赤い液体を$r1a：$r1bの割合で混ぜたものと、$r2a：$r2bの割合で混ぜたものを同量"
               "ずつとって混ぜると、この液体に含まれる赤い液体の割合は□□％である（必要"
               "なときは、最後に小数点以下第2位を四捨五入すること）。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions((ans*10).toInt(), unit: "").map((e)=>(double.parse(e)/10).toString()+"%").toList(),
      correctAnswer: "$ans%",
      explanation: "全体の量を${total1*total2}とおく。\n"
                   "液1の赤：${total1*total2} × $r1b/${total1} = ${total2*r1b}\n"
                   "液2の赤：${total1*total2} × $r2b/${total2} = ${total1*r2b}\n"
                   "合計赤：${total2*r1b + total1*r2b}、全体：${total1*total2*2}。\n"
                   "割合：${total2*r1b + total1*r2b} ÷ ${total1*total2*2} = 0.325 → 32.5%。",
      scenarioId: 'PR_2_1_LIQUID_MIX',
    );
  }

  // 6. Garden Area (Pr2-2)
  GeneratedProblem _genPr2_2GardenArea() {
    double h = 2.4;
    double w = 1.5;
    double area = h * w; // 3.6
    int r1n = 3, r1d = 5; // 3/5
    int r2n = 1, r2d = 3; // 1/3
    
    double kabu = area * r1n / r1d;
    double remain = area - kabu;
    double negi = remain * r2n / r2d;
    double diff = kabu - negi;
    
    // Round to 2 decimals
    String ans = diff.toStringAsFixed(2);

    String q = "縦${h}m、横${w}mの長方形の菜園がある。その面積の$r1n/$r1dでカブを、残りの面積"
               "の$r2n/$r2dでネギを栽培する。このとき、カブの栽培面積はネギの栽培面積より"
               "□□㎡広い（必要なときは、最後に小数点以下第3位を四捨五入すること）。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions((diff*100).toInt(), unit: "").map((e)=>(double.parse(e)/100).toStringAsFixed(2)+"㎡").toList(),
      correctAnswer: "${ans}㎡",
      explanation: "菜園面積 = $area ㎡。\n"
                   "カブ = $area × $r1n/$r1d = ${kabu.toStringAsFixed(2)} ㎡。\n"
                   "残り = ${remain.toStringAsFixed(2)} ㎡。ネギ = $remain × $r2n/$r2d = ${negi.toStringAsFixed(2)} ㎡。\n"
                   "差 = $kabu - $negi = $ans ㎡。",
      scenarioId: 'PR_2_2_GARDEN_AREA',
    );
  }

  // 7. Circle Ratio (Pr2-3)
  GeneratedProblem _genPr2_3CircleRatio() {
    int m = 3, f = 1; // 3:1
    int addF = 7;
    int m2 = 2, f2 = 1; // 2:1
    // m*k : 1*k.
    // m*k : (1*k + addF) = m2 : f2.
    // m*k * f2 = (k + addF) * m2.
    // k * (m*f2 - m2) = addF * m2.
    // k = addF * m2 / (m*f2 - m2).
    
    int num = addF * m2;
    int den = m * f2 - m2; // 3*1 - 2 = 1.
    int k = num ~/ den;
    int current = m * k + k + addF;

    String q = "あるサークルの男性と女性の比率は$m：$fだったが、女性${addF}人が加入したので$m2：$f2にな"
               "った。このサークルの所属している男性は□□人である。"; 
               // Wait, question asks for "Total" or "Male"?
               // Image says "current total members". "所属している男性" -> No "所属している男女"?
               // Image text: "このサークルに所属している男性は[ ]人である。"
               // Solution in note says "Total 63". But image text says "Male".
               // Let's verify image text closely. "所属している男性は" visible.
               // Ah, solution in note (Pr2-3) calculated total.
               // If question asks Male: 3*k = 3*14 = 42.
               // Image solution says "42人".
               // OK, I will ask for Male count.
               
    int ans = m * k;

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "当初の人数を男性${m}x、女性${f}xとする。\n"
                   "${m}x : ${f}x + $addF = $m2 : $f2。\n"
                   "内項の積＝外項の積より $m2(x+$addF) = $f2(${m}x)。\n"
                   "これを解くと x=$k。男性は $m × $k = $ans人。",
      scenarioId: 'PR_2_3_CIRCLE_RATIO',
    );
  }

  // 8. Employee Ratio (Pr2-4)
  GeneratedProblem _genPr2_4EmployeeRatio() {
    int total = 90;
    int leave = 15;
    double upRate = 6.0; // 6.0%
    // w/75 - w/90 = 0.06.
    // w (1/75 - 1/90) = 0.06.
    // w (6/450 - 5/450) = 0.06.
    // w / 450 = 0.06 -> w = 27.
    
    int ans = 27;

    String q = "ある会社では社員が$total人いたが、男性社員${leave}人が退職したところ、女性社員の占め"
               "る割合は${upRate}％上がった。女性社員の人数は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "女性の人数をxとする。\n"
                   "現在の割合(x/${total-leave}) - 以前の割合(x/$total) = ${upRate/100}。\n"
                   "これを解くと x=$ans。",
      scenarioId: 'PR_2_4_EMPLOYEE_RATIO',
    );
  }

  // 9. Bus Commute (Pr3-1)
  GeneratedProblem _genPr3_1BusCommute() {
    int r1 = 35; // 35%
    int r2 = 80; // 80%
    int pUsers = 168;
    // Total * 0.35 * 0.8 = 168.
    // Total * 0.28 = 168.
    // Total = 600.
    
    int total = (pUsers * 10000) ~/ (r1 * r2);

    String q = "ある高校の生徒のうち${r1}％がバスで通学しており、このうちの${r2}％はP交通のバス"
               "を利用している。通学にP交通のバスを利用している生徒が${pUsers}人のとき、この高校"
               "の生徒は全部で□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(total, unit: "人"),
      correctAnswer: "$total人",
      explanation: "全校生徒の $r1% × $r2% = ${(r1*r2)/100}% がP交通利用者。\n"
                   "その人数が$pUsers人なので、全体 = $pUsers ÷ ${(r1*r2)/10000} = $total人。",
      scenarioId: 'PR_3_1_BUS_COMMUTE',
    );
  }

  // 10. Age Future (Pr3-2)
  GeneratedProblem _genPr3_2AgeFuture() {
    int diff = 19;
    int after = 7;
    // P = Q/2. Q-P=diff.
    // 2P = Q. 2P - P = diff -> P = diff. (At that time)
    // Current P = diff - after.
    
    int pFuture = diff; // Since Q = 2P, Q-P = P = diff.
    int pCurrent = pFuture - after;

    String q = "現在PはQよりも${diff}歳若く、${after}年後にはPの年齢はQの年齢の半分になる。現在、P"
               "は□□歳である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(pCurrent, unit: "歳"),
      correctAnswer: "$pCurrent歳",
      explanation: "年齢差は変わらないので${after}年後も${diff}歳。\n"
                   "${after}年後、P:Q = 1:2 なので、その差1が${diff}歳にあたる。\n"
                   "よって${after}年後のPは${diff}歳。\n"
                   "現在は $diff - $after = $pCurrent歳。",
      scenarioId: 'PR_3_2_AGE_FUTURE',
    );
  }

  // 11. Cake Cut (Pr3-3)
  GeneratedProblem _genPr3_3CakeCut() {
    int n1 = 3;
    int n2 = 4;
    // 1/3 -> 1/4.
    // Diff = 1/12.
    // Rate = (1/12) / (1/3) = 1/4 = 25%.
    
    int ans = 25;

    String q = "ケーキを${n1}等分するはずが、間違えて${n2}等分してしまった。ケーキ1切れの大きさは$n1"
               "等分したときに比べ□□％小さくなった（必要なときは、最後に小数点以下第1"
               "位を四捨五入すること）。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "%"),
      correctAnswer: "$ans%",
      explanation: "当初の大きさ1/$n1、実際の大きさ1/$n2。\n"
                   "差は 1/$n1 - 1/$n2 = 1/${n1*n2}。\n"
                   "減少率は (1/${n1*n2}) ÷ (1/$n1) = $n1/${n1*n2} = 1/$n2 = 0.25 → 25%。",
      scenarioId: 'PR_3_3_CAKE_CUT',
    );
  }

  // 12. Data Input (Pr3-4)
  GeneratedProblem _genPr3_4DataInput() {
    double rQ = 0.7;
    double rR = 0.9;
    // P=1. Total = 1 + 0.7 + 0.9 = 2.6.
    // P share = 1 / 2.6 = 10 / 26 = 5 / 13.
    
    int den = 13;

    String q = "データ入力の仕事をP、Q、Rの3人で分担した。QはPの0.7倍の量を、RはPの0.9"
               "倍の量を担当した。このときPが担当した量は、全体の5/□□だった（分数の分"
               "母を答えなさい）。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(den, unit: ""),
      correctAnswer: "$den",
      explanation: "Pを1とすると、Q=0.7、R=0.9。\n"
                   "全体 = 1 + 0.7 + 0.9 = 2.6。\n"
                   "Pの割合 = 1 ÷ 2.6 = 10/26 = 5/13。",
      scenarioId: 'PR_3_4_DATA_INPUT',
    );
  }
}
