import 'dart:math';

// =========================================================
// Profit & Loss Engine (For SPI) - FIXED
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

class ProfitLossEngine {
  final Random _rand = Random();

  // 17 Scenarios
  static const List<String> _allScenarioIds = [
    'EX_1_DISCOUNT_DIFF',
    'EX_2_PAYMENT_SHARE',
    'EX_3_PROFIT_CALC',
    'EX_4_HOLIDAY_CHARGE',
    'PR_1_1_SET_UNIT_PRICE',
    'PR_1_2_GRAM_UNIT_PRICE',
    'PR_1_3_DISCOUNT_AMOUNT',
    'PR_1_4_BULK_DISCOUNT_RATE',
    'PR_1_5_SUBSCRIPTION',
    'PR_2_1_PAYMENT_ADJUST',
    'PR_2_2_PROFIT_DIFF',
    'PR_2_3_TOTAL_PROFIT_RATE',
    'PR_2_4_COST_FROM_PROFIT_RATIO',
    'PR_3_1_DISCOUNT_RATE_FROM_PROFIT',
    'PR_3_2_LOSS_CALC',
    'PR_3_3_MIXED_SALES_PROFIT',
    'PR_3_4_BANANA_SALES',
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
      case 'EX_1_DISCOUNT_DIFF': return _genEx1DiscountDiff();
      case 'EX_2_PAYMENT_SHARE': return _genEx2PaymentShare();
      case 'EX_3_PROFIT_CALC': return _genEx3ProfitCalc();
      case 'EX_4_HOLIDAY_CHARGE': return _genEx4HolidayCharge();
      case 'PR_1_1_SET_UNIT_PRICE': return _genPr1_1SetUnitPrice();
      case 'PR_1_2_GRAM_UNIT_PRICE': return _genPr1_2GramUnitPrice();
      case 'PR_1_3_DISCOUNT_AMOUNT': return _genPr1_3DiscountAmount();
      case 'PR_1_4_BULK_DISCOUNT_RATE': return _genPr1_4BulkDiscountRate();
      case 'PR_1_5_SUBSCRIPTION': return _genPr1_5Subscription();
      case 'PR_2_1_PAYMENT_ADJUST': return _genPr2_1PaymentAdjust();
      case 'PR_2_2_PROFIT_DIFF': return _genPr2_2ProfitDiff();
      case 'PR_2_3_TOTAL_PROFIT_RATE': return _genPr2_3TotalProfitRate();
      case 'PR_2_4_COST_FROM_PROFIT_RATIO': return _genPr2_4CostFromProfitRatio();
      case 'PR_3_1_DISCOUNT_RATE_FROM_PROFIT': return _genPr3_1DiscountRateFromProfit();
      case 'PR_3_2_LOSS_CALC': return _genPr3_2LossCalc();
      case 'PR_3_3_MIXED_SALES_PROFIT': return _genPr3_3MixedSalesProfit();
      case 'PR_3_4_BANANA_SALES': return _genPr3_4BananaSales();
      default: return _genEx1DiscountDiff();
    }
  }

  // Utilities
  List<String> _makeOptions(int correct, {String unit = "円"}) {
    Set<String> s = {};
    s.add("$correct$unit");
    int safety = 0;
    while(s.length < 5) {
      safety++;
      if (safety > 50) {
        // Fallback: Generate sequential options to ensure 5 items
        int val = correct + 1;
        while (s.length < 5) {
          if (!s.contains("$val$unit")) s.add("$val$unit");
          val++;
        }
        break;
      }
      
      int diff = _rand.nextInt(5) + 1; 
      if (_rand.nextBool()) diff = -diff;
      int val = correct + diff;
      
      if (val > 0) s.add("$val$unit");
    }
    List<String> list = s.toList();
    list.sort((a, b) {
      int valA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      int valB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return valA.compareTo(valB);
    });
    return list;
  }

  // 1. Ex1 Discount Diff
  GeneratedProblem _genEx1DiscountDiff() {
    int disc1 = 20; 
    int disc2 = 60; 
    int diff = 40;
    int base = 50 + _rand.nextInt(50);
    int diffAmount = base * diff; 
    int price = diffAmount * 100 ~/ diff;

    String q = "Pはセール初日に定価の${disc1}%引きで服を買い、Qは同じ服をセール最終日に定価の${disc2}%引きで、"
               "Pより$diffAmount円安く買った。この服の定価は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(price),
      correctAnswer: "$price円",
      explanation: "割引率の差は$disc2% - $disc1% = $diff%。\n"
                   "これが$diffAmount円に相当する。\n"
                   "定価 × 0.${diff} = $diffAmount\n"
                   "定価 = $diffAmount ÷ 0.${diff} = $price円。",
      scenarioId: 'EX_1_DISCOUNT_DIFF',
    );
  }

  // 2. Ex2 Payment Share
  GeneratedProblem _genEx2PaymentShare() {
    int refund = (5 + _rand.nextInt(10)) * 100 + 50; 
    int qPay = refund * 2;
    int total = qPay * 3;
    int meal = (total * 0.6).toInt();
    meal = (meal ~/ 100) * 100;
    int flower = total - meal;

    String q = "P、Q、Rの3人で食事をした。Qの手持ちのお金が足りなかったので、ひとまず、"
               "食事代の総額をPが、花束代の総額をRが支払った。後日、3等分になるように、"
               "QがPとRに${refund}円ずつ返して精算したとすると、食事代と花束代の総額は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(total),
      correctAnswer: "$total円",
      explanation: "Qが支払ったのは2人への返済合計${refund*2}円。\n"
                   "これが1人あたりの負担額。\n"
                   "総額は3人分なので、${refund*2} × 3 = $total円。",
      scenarioId: 'EX_2_PAYMENT_SHARE',
    );
  }

  // 3. Ex3 Profit Calc - FIXED INFINITE LOOP
  GeneratedProblem _genEx3ProfitCalc() {
    int profitRate = 5 + _rand.nextInt(10); // 5-15%
    int disc = 20; // 20%
    
    // Reverse Logic: Decide Price first
    // Price must be such that (Price * 0.8) / (1 + rate/100) is an integer (Cost).
    // Sell = Price * 0.8. Cost = Sell / (1 + rate/100) = Sell * 100 / (100+rate).
    // Price * 80 * 100 / (100 * (100+rate)) = Integer.
    // Price * 80 / (100+rate) = Integer.
    // Price must be divisible by (100+rate)/gcd(80, 100+rate).
    
    int denominator = 100 + profitRate;
    // We want cost to be like 1000, 1500, etc.
    // Let's set Cost directly.
    int costBase = (10 + _rand.nextInt(20)) * 100; // 1000..3000
    
    // Calculate Profit & Sell
    int profit = (costBase * profitRate) ~/ 100;
    int sell = costBase + profit;
    
    // Check if Sell can be 80% of an integer Price
    // Sell = Price * 0.8 = Price * 4/5 -> Price = Sell * 5/4.
    // Sell must be divisible by 4.
    // If not, adjust Cost.
    // Cost * (1 + rate/100) = Sell.
    // (Cost * (100+rate))/100 = Sell.
    // We need Sell % 4 == 0.
    // (Cost * (100+rate)) % 400 == 0.
    
    // Simplest fix: Just pick a Cost that works.
    // 100+rate is e.g. 105..115.
    // Just try a few Costs until one works, with a limit.
    // Or just construct it:
    // Price = K * 100. Sell = K * 80.
    // Cost = Sell * 100 / (100+rate) = 8000*K / (100+rate).
    // We need 8000*K divisible by (100+rate).
    // K = (100+rate). Price = (100+rate)*100.
    // Then Cost = 8000. Profit = (100+rate)*80 - 8000 = 80*rate.
    // Profit Rate = 80*rate / 8000 = rate/100. Correct.
    
    // So:
    int price = (100 + profitRate) * 20; // Scale to reasonable price e.g. 105*20=2100
    int cost = 20 * 80; // 1600
    profit = (cost * profitRate) ~/ 100;
    
    String q = "ある商品は定価の${disc}％引きで売っても、仕入れ値の${profitRate}％にあたる${profit}円の利益が得られる。"
               "この商品の定価は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(price),
      correctAnswer: "$price円",
      explanation: "利益が${profit}円で仕入れ値の${profitRate}%なので、\n"
                   "仕入れ値 = $profit ÷ 0.${profitRate.toString().padLeft(2,'0')} = $cost円。\n"
                   "売値 = $cost + $profit = ${cost+profit}円。\n"
                   "これは定価の${100-disc}%なので、定価 = ${cost+profit} ÷ 0.${100-disc} = $price円。",
      scenarioId: 'EX_3_PROFIT_CALC',
    );
  }

  // 4. Ex4 Holiday Charge
  GeneratedProblem _genEx4HolidayCharge() {
    int up1 = 20 + _rand.nextInt(3) * 10; 
    int down2 = 10 + _rand.nextInt(2) * 10; 
    double rate1 = 1.0 + up1 / 100.0;
    double rate2 = 1.0 - down2 / 100.0;
    double finalRate = rate1 * rate2;
    int ans = ((finalRate - 1.0) * 100).round();

    String q = "あるボウリング場の休日のゲーム料金は平日の${up1}割増しの料金であるが、"
               "休日の早朝に限り、その${down2}割引きになる。\n"
               "休日の早朝のゲーム料金は平日より□□％増しの料金である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "%"),
      correctAnswer: "$ans%",
      explanation: "平日の料金を1とすると、休日は$rate1。\n"
                   "早朝はその$rate2倍なので、$rate1 × $rate2 = ${finalRate.toStringAsFixed(2)}。\n"
                   "平日(1)より ${finalRate - 1.0}、つまり$ans%増し。",
      scenarioId: 'EX_4_HOLIDAY_CHARGE',
    );
  }

  // 5. Pr1-1 Set Unit Price
  GeneratedProblem _genPr1_1SetUnitPrice() {
    int unitPrice = (10 + _rand.nextInt(20)) * 100; 
    int setNum = 3;
    int discount = 100 + _rand.nextInt(5) * 100; 
    int setPrice = unitPrice * setNum - discount;
    int total = setPrice + unitPrice * 2;
    int avg = total ~/ 5;

    String q = "1個$unitPrice円で、$setNum個セットなら$setPrice円になる商品がある。"
               "この商品を最も安くなるようにして5個購入した。このとき、1個あたりの購入価格は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(avg),
      correctAnswer: "$avg円",
      explanation: "$setNum個セット1つ($setPrice円)と、単品2個(${unitPrice*2}円)で買うのが最安。\n"
                   "合計 $setPrice + ${unitPrice*2} = $total円。\n"
                   "平均は $total ÷ 5 = $avg円。",
      scenarioId: 'PR_1_1_SET_UNIT_PRICE',
    );
  }

  // 6. Pr1-2 Gram Unit Price - FIXED
  GeneratedProblem _genPr1_2GramUnitPrice() {
    int smallG = 160;
    int largeG = 500;
    // 16 * 40 = 640.
    int smallP = (40 + _rand.nextInt(10)) * 16; 
    int unitP1 = (smallP / 1.6).round();
    
    int diff = 20 + _rand.nextInt(40); 
    int unitP2 = unitP1 - diff;
    int largeP = unitP2 * 5;

    String q = "ある食品は${smallG}g入りの袋が$smallP円だが、${largeG}g入りの袋なら100gあたり$diff円安くなる。"
               "このとき、${largeG}g入りの袋は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(largeP),
      correctAnswer: "$largeP円",
      explanation: "${smallG}g入りは100gあたり $smallP ÷ ${smallG/100} = $unitP1円。\n"
                   "${largeG}g入りはそれより$diff円安いので、$unitP1 - $diff = $unitP2円。\n"
                   "${largeG}gでは $unitP2 × ${largeG/100} = $largeP円。",
      scenarioId: 'PR_1_2_GRAM_UNIT_PRICE',
    );
  }

  // 7. Pr1-3 Discount Amount
  GeneratedProblem _genPr1_3DiscountAmount() {
    int d1 = 3; 
    int d2 = 10; 
    int diffRate = d2 - d1; 
    int price = (20 + _rand.nextInt(30)) * 100; 
    int diffAmount = (price * diffRate) ~/ 100;

    String q = "ある商品を2個購入すると定価の${d1}％引き、6個購入すると定価の${d2}％引きになる。"
               "この商品を2個購入するときと6個購入するときに比べ、1個につき${diffAmount}円安くなる。"
               "このとき、この商品の定価は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(price),
      correctAnswer: "$price円",
      explanation: "割引率の差は$d2 - $d1 = $diffRate%。\n"
                   "これが${diffAmount}円にあたるので、\n"
                   "定価 = $diffAmount ÷ 0.${diffRate.toString().padLeft(2,'0')} = $price円。",
      scenarioId: 'PR_1_3_DISCOUNT_AMOUNT',
    );
  }

  // 8. Pr1-4 Bulk Discount Rate
  GeneratedProblem _genPr1_4BulkDiscountRate() {
    int price = 2500;
    int num1 = 2;
    int d1 = 3; 
    int num2 = 5;
    int d2 = 8 + _rand.nextInt(5); 
    int sum1 = (price * num1 * (100 - d1)) ~/ 100;
    int sum2 = (price * num2 * (100 - d2)) ~/ 100;

    String q = "ある商品は2個以上まとめて購入すると割引価格になり、2個で$sum1円、5個で$sum2円である。"
               "この商品は2個購入すると定価の${d1}％引きになっているとすると、5個購入すると定価の□□％引きになる。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(d2, unit: "%"),
      correctAnswer: "$d2%",
      explanation: "2個の定価合計は $sum1 ÷ (1-0.${d1.toString().padLeft(2,'0')}) = ${price*2}円。\n"
                   "よって1個の定価は${price}円。\n"
                   "5個の定価合計は${price*5}円。\n"
                   "5個の売値は$sum2円なので、割引額は${price*5 - sum2}円。\n"
                   "割引率は ${price*5 - sum2} ÷ ${price*5} = 0.${d2.toString().padLeft(2,'0')} → $d2%。",
      scenarioId: 'PR_1_4_BULK_DISCOUNT_RATE',
    );
  }

  // 9. Pr1-5 Subscription
  GeneratedProblem _genPr1_5Subscription() {
    int price = 1200;
    int n1 = 60; 
    int d1 = 35; 
    int n2 = 15; 
    int d2 = 10; 
    int diffD = d1 - d2; 
    int cost1 = (price * n1 * (100 - d1)) ~/ 100;
    int cost2 = (price * n2 * (100 - d2)) ~/ 100;

    String q = "ある専門誌を定期購読した場合、2年契約(${n1}冊)は${cost1}円、半年契約(${n2}冊)は${cost2}円である。"
               "定価に対する1冊あたりの割引率は、2年契約の方が半年契約より${diffD}％大きいとすると、"
               "この専門誌の1冊の定価は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(price),
      correctAnswer: "$price円",
      explanation: "2年契約の1冊単価：$cost1 ÷ $n1 = ${cost1~/n1}円。\n"
                   "半年契約の1冊単価：$cost2 ÷ $n2 = ${cost2~/n2}円。\n"
                   "差額は ${cost2~/n2 - cost1~/n1}円。\n"
                   "これが定価の$diffD%にあたるので、定価 = ${cost2~/n2 - cost1~/n1} ÷ 0.$diffD = $price円。",
      scenarioId: 'PR_1_5_SUBSCRIPTION',
    );
  }

  // 10. Pr2-1 Payment Adjust
  GeneratedProblem _genPr2_1PaymentAdjust() {
    int pPay = (30 + _rand.nextInt(20)) * 100; 
    int total = pPay * 3;
    int meal = (total * 0.6).toInt();
    meal = (meal ~/ 100) * 100;
    int flower = total - meal;
    int share = total ~/ 3;
    int zToX = meal - share; 
    
    String q = "X、Y、Zの3人でPの卒業祝いをすることにした。Xが食事代の総額${meal}円を、Yが花束代の総額を支払った。"
               "食事代と花束代を3人が同額ずつ負担することにし、ZがXに${zToX}円、Yにいくらか支払って精算した。"
               "このとき、花束代の総額は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(flower),
      correctAnswer: "$flower円",
      explanation: "Xは食事代${meal}円を立て替えた。精算で${zToX}円受け取ったので、実質負担は${meal - zToX}円。\n"
                   "これが1人あたりの負担額。\n"
                   "総額は3人分なので ${meal - zToX} × 3 = $total円。\n"
                   "花束代 = 総額 - 食事代 = $total - $meal = $flower円。",
      scenarioId: 'PR_2_1_PAYMENT_ADJUST',
    );
  }

  // 11. Pr2-2 Profit Diff
  GeneratedProblem _genPr2_2ProfitDiff() {
    int d1 = 15;
    int d2 = 10;
    int diffD = 5;
    int price = (20 + _rand.nextInt(20)) * 100;
    int diffAmount = (price * diffD) ~/ 100;

    String q = "ある商品を定価の${d1}％引きで売ると、定価の${d2}％引きで売るときに比べて、"
               "利益が${diffAmount}円少なくなる。この商品の定価は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(price),
      correctAnswer: "$price円",
      explanation: "割引率の差は$diffD%。これが${diffAmount}円に相当する。\n"
                   "定価 = $diffAmount ÷ 0.05 = $price円。",
      scenarioId: 'PR_2_2_PROFIT_DIFF',
    );
  }

  // 12. Pr2-3 Total Profit Rate
  GeneratedProblem _genPr2_3TotalProfitRate() {
    int stock = 75;
    int rate = 40; 
    int sold = 60;
    
    String q = "ある商品を${stock}個仕入れ、仕入れ値の${rate}％増しの価格で売った。"
               "いくつか売れ残ったので廃棄したところ、1個あたりの利益は仕入れ値の12％になった。"
               "このとき、売れた個数は□□個である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(sold, unit: "個"),
      correctAnswer: "${sold}個",
      explanation: "仕入れ値を100円とすると、総仕入れは${stock*100}円。\n"
                   "総利益が12%なので、総売上は${stock*100} × 1.12 = ${stock*112}円。\n"
                   "売値は140円。売れた個数 = ${stock*112} ÷ 140 = ${sold}個。",
      scenarioId: 'PR_2_3_TOTAL_PROFIT_RATIO',
    );
  }

  // 13. Pr2-4 Cost From Profit Ratio - FIXED
  GeneratedProblem _genPr2_4CostFromProfitRatio() {
    int price = (30 + _rand.nextInt(20)) * 80; // Divisible by 8 (e.g. 2400)
    int cost = (price * 5) ~/ 8;

    String q = "定価${price}円の商品を定価の25％引きで売ったときに得られる利益は、"
               "定価で売ったときの利益の1/3になる。この商品の仕入れ値は□□円である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(cost),
      correctAnswer: "$cost円",
      explanation: "方程式を解くと、仕入れ値は定価の5/8になる。\n"
                   "$price × 5/8 = $cost円。",
      scenarioId: 'PR_2_4_COST_FROM_PROFIT_RATIO',
    );
  }

  // 14. Pr3-1 Discount Rate From Profit
  GeneratedProblem _genPr3_1DiscountRateFromProfit() {
    int cost = 4250;
    int profitRate = 26;
    int profit = (cost * profitRate) ~/ 100;
    int sell = cost + profit;
    int price = (sell * 100) ~/ 90; 
    int diff = price - sell;

    String q = "定価${price}円の商品をいくらか割引をして売ったところ、仕入れ値の${profitRate}％にあたる"
               "${profit}円の利益を得た。このとき、この商品の割引率は定価の□□％である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(10, unit: "%"),
      correctAnswer: "10%",
      explanation: "利益が${profit}円なので、仕入れ値は$cost円。\n"
                   "売値は $cost + $profit = $sell円。\n"
                   "割引額は $price - $sell = $diff円。\n"
                   "割引率 = $diff ÷ $price = 0.1 → 10%。",
      scenarioId: 'PR_3_1_DISCOUNT_RATE_FROM_PROFIT',
    );
  }

  // 15. Pr3-2 Loss Calc
  GeneratedProblem _genPr3_2LossCalc() {
    int price = 4800;
    int profit1 = 180; 
    int sell1 = (price * 75) ~/ 100; 
    int cost = sell1 - profit1; 
    int sell2 = (price * 70) ~/ 100; 
    int loss = cost - sell2; 

    String q = "ある商品を定価の25％引きで売っても、仕入れ値に対して${profit1}円の利益が得られる。"
               "この商品を定価の30％引きで売ると□□円の損失が出る。(定価は${price}円とする)";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(loss),
      correctAnswer: "$loss円",
      explanation: "25%引き売値 = $sell1円。利益$profit1円より仕入れ値 = $cost円。\n"
                   "30%引き売値 = $sell2円。\n"
                   "損失 = 仕入れ - 売値 = $cost - $sell2 = $loss円。",
      scenarioId: 'PR_3_2_LOSS_CALC',
    );
  }

  // 16. Pr3-3 Mixed Sales Profit
  GeneratedProblem _genPr3_3MixedSalesProfit() {
    int n = 50;
    int n1 = 40;
    int n2 = 10;
    int markup = 30; 
    int disc = 20; 
    double profitRate = 24.8; 

    String q = "ある商品を${n}個仕入れ、仕入れ値の${markup}％の利益をのせて定価をつけた。"
               "${n1}個を定価で売り、残りの${n2}個は定価の${disc}％引きにして完売した。"
               "このとき、1個あたりの利益は仕入れ値の□□％である。";

    return GeneratedProblem(
      questionText: q,
      options: ["24.8%", "25.0%", "24.0%", "25.2%", "23.5%"],
      correctAnswer: "$profitRate%",
      explanation: "仕入れ値を100とする。定価130。\n"
                   "売上 = $n1×130 + $n2×(130×0.8) = 5200 + 1040 = 6240。\n"
                   "総利益 = 6240 - 5000 = 1240。\n"
                   "利益率 = 1240 ÷ 5000 = 0.248 → 24.8%。",
      scenarioId: 'PR_3_3_MIXED_SALES_PROFIT',
    );
  }

  // 17. Pr3-4 Banana Sales
  GeneratedProblem _genPr3_4BananaSales() {
    int stock = 40;
    int costPerBunch = 80;
    int profit = 4120;
    int sellBunch = 150;
    int sellOne = 30; 
    int ans = 18;

    String q = "1房に7本ついたバナナを1房${costPerBunch}円で${stock}房仕入れた。"
               "1房単位の売価は${sellBunch}円で、1本単位の売価は${sellOne}円である。"
               "バナナがすべて売り切れ、利益が${profit}円であったとすると、房単位で売れたバナナは□□房である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "房"),
      correctAnswer: "${ans}房",
      explanation: "仕入れ総額 = $costPerBunch × $stock = 3200円。\n"
                   "総売上 = 3200 + $profit = 7320円。\n"
                   "房売りをxとすると、バラ売りは($stock-x)房分。\n"
                   "バラ売りの1房分価格は $sellOne × 7 = 210円。\n"
                   "${sellBunch}x + 210($stock-x) = 7320。\n"
                   "これを解いて x=$ans。",
      scenarioId: 'PR_3_4_BANANA_SALES',
    );
  }
}
