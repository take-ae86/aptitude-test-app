import 'dart:math';

// =========================================================
// Set Logic Engine (For SPI Sets Category)
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

class SetEngine {
  final Random _rand = Random();

  // 13 Scenarios
  static const List<String> _allScenarioIds = [
    'EX_1_TEA_CAKE',
    'EX_2_COFFEE_MILK',
    'EX_3_CAT_DOG',
    'PR_1_1_LESSON',
    'PR_1_2_PARK',
    'PR_1_3_SPORTS_CULTURE',
    'PR_2_1_HISTORY',
    'PR_2_2_BOOKS_3',
    'PR_2_3_CANS',
    'PR_2_4_LECTURE_3',
    'PR_3_1_LIBRARY',
    'PR_3_2_MUSEUM',
    'PR_3_3_SNACKS_3',
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
      case 'EX_1_TEA_CAKE': return _genEx1TeaCake();
      case 'EX_2_COFFEE_MILK': return _genEx2CoffeeMilk();
      case 'EX_3_CAT_DOG': return _genEx3CatDog();
      case 'PR_1_1_LESSON': return _genPr1_1Lesson();
      case 'PR_1_2_PARK': return _genPr1_2Park();
      case 'PR_1_3_SPORTS_CULTURE': return _genPr1_3SportsCulture();
      case 'PR_2_1_HISTORY': return _genPr2_1History();
      case 'PR_2_2_BOOKS_3': return _genPr2_2Books3();
      case 'PR_2_3_CANS': return _genPr2_3Cans();
      case 'PR_2_4_LECTURE_3': return _genPr2_4Lecture3();
      case 'PR_3_1_LIBRARY': return _genPr3_1Library();
      case 'PR_3_2_MUSEUM': return _genPr3_2Museum();
      case 'PR_3_3_SNACKS_3': return _genPr3_3Snacks3();
      default: return _genEx1TeaCake();
    }
  }

  // Helper to make 5 options
  List<String> _makeOptions(int correct, {String unit = ""}) {
    Set<String> s = {};
    s.add("$correct$unit");
    while(s.length < 5) {
      int diff = _rand.nextInt(5) + 1; 
      if (_rand.nextBool()) diff = -diff;
      int val = correct + diff;
      if (val >= 0) { 
         s.add("$val$unit");
      }
    }
    List<String> list = s.toList();
    list.sort((a, b) {
      int valA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      int valB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return valA.compareTo(valB);
    });
    return list;
  }

  GeneratedProblem _genEx1TeaCake() {
    int ratioInv = 4; 
    int tea = (15 + _rand.nextInt(10)) * ratioInv;
    int both = tea ~/ ratioInv;
    int cake = both + 10 + _rand.nextInt(30);
    int onlyTea = tea - both;
    int onlyCake = cake - both;
    int ans = onlyTea + onlyCake;

    String q = "ある喫茶店の客のうち、紅茶を注文した人は$tea人、ケーキを注文した人は$cake人であり、"
               "紅茶を注文した人のうち1/$ratioInvがケーキも注文した。\n"
               "このとき、紅茶かケーキのどちらか一方だけを注文した人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "両方注文した人は紅茶の1/$ratioInvなので、$tea÷$ratioInv=$both人。\n"
                   "紅茶だけ=$tea-$both=$onlyTea人。\n"
                   "ケーキだけ=$cake-$both=$onlyCake人。\n"
                   "一方だけ=$onlyTea+$onlyCake=$ans人。",
      scenarioId: 'EX_1_TEA_CAKE',
    );
  }

  GeneratedProblem _genEx2CoffeeMilk() {
    int total = (2 + _rand.nextInt(3)) * 100;
    int mPer = 40 + _rand.nextInt(20);
    int sPer = 30 + _rand.nextInt(20);
    int nPer = 20 + _rand.nextInt(10);
    int bPer = nPer - 100 + mPer + sPer;
    while (bPer <= 0 || bPer >= mPer || bPer >= sPer) {
       mPer = 50 + _rand.nextInt(10);
       sPer = 40 + _rand.nextInt(10);
       nPer = 25 + _rand.nextInt(5);
       bPer = nPer - 100 + mPer + sPer;
    }
    int ans = (total * bPer) ~/ 100;

    String q = "あるレストランでコーヒーを注文した客$total人のうち、ミルクを入れた人は$mPer%、"
               "砂糖を入れた人は$sPer%、どちらも入れなかった人は$nPer%だった。\n"
               "このとき、ミルクと砂糖の両方を入れた人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "少なくとも一方を入れた人は100-$nPer=${100-nPer}%。\n"
                   "$mPer + $sPer - (両方) = ${100-nPer}。\n"
                   "両方 = ${mPer+sPer} - ${100-nPer} = $bPer%。\n"
                   "$total × 0.${bPer.toString().padLeft(2,'0')} = $ans人。",
      scenarioId: 'EX_2_COFFEE_MILK',
    );
  }

  GeneratedProblem _genEx3CatDog() {
    int total = 50 + _rand.nextInt(50);
    int cat = 20 + _rand.nextInt(20);
    int dog = 20 + _rand.nextInt(20);
    int both = 1 + _rand.nextInt(min(cat, dog));
    int onlyOne = (cat - both) + (dog - both);
    int union = cat + dog - both;
    int neither = total - union;
    while (neither < 0) {
      total += 10;
      neither = total - union;
    }

    String q = "ある町の世帯数は$total世帯で、ネコを飼っている世帯は$cat世帯、イヌを飼っている世帯は$dog世帯である。\n"
               "どちらか片方だけ飼っている世帯が$onlyOne世帯のとき、どちらも飼っていない世帯は□□世帯である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(neither, unit: "世帯"),
      correctAnswer: "$neither世帯",
      explanation: "片方だけ = (ネコ+イヌ) - 2×両方。\n"
                   "$onlyOne = ${cat+dog} - 2×両方。\n"
                   "両方 = (${cat+dog} - $onlyOne) ÷ 2 = $both世帯。\n"
                   "飼っている = $cat + $dog - $both = $union。\n"
                   "どちらもなし = $total - $union = $neither世帯。",
      scenarioId: 'EX_3_CAT_DOG',
    );
  }

  GeneratedProblem _genPr1_1Lesson() {
    int ePer = 40 + _rand.nextInt(10);
    int cPer = 20 + _rand.nextInt(20);
    while (ePer + cPer >= 98) {
      ePer = 40 + _rand.nextInt(10);
      cPer = 20 + _rand.nextInt(20);
    }
    int bPer = 2 * (1 + _rand.nextInt(5));
    int sumEC = (100 - 0.5 * bPer).toInt();
    ePer = (sumEC / 2).toInt() + _rand.nextInt(10);
    cPer = sumEC - ePer;
    if (ePer <= bPer || cPer <= bPer) {
       ePer = 51; cPer = 35; 
       bPer = 28; // Derived
    }
    int ans = ePer - bPer;

    String q = "習い事について調査したところ、英会話を習っている人は$ePer%、書道を習っている人は$cPer%いた。\n"
               "またどちらも習っていない人は両方とも習っている人の1.5倍だった。\n"
               "英会話を習っているが書道は習っていない人は、回答者全体の□□%である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "%"),
      correctAnswer: "$ans%",
      explanation: "両方をx%とすると、どちらもなしは1.5x%。\n"
                   "100 = $ePer + $cPer - x + 1.5x\n"
                   "0.5x = 100 - ${ePer+cPer} = ${100-(ePer+cPer)}\n"
                   "x = ${(100-(ePer+cPer))*2}%\n"
                   "英会話だけ = $ePer - $bPer = $ans%。",
      scenarioId: 'PR_1_1_LESSON',
    );
  }

  GeneratedProblem _genPr1_2Park() {
    int c = 80 + _rand.nextInt(20);
    if (c % 2 != 0) c++;
    int gardenOnly = c ~/ 2; 
    int b = 10 + _rand.nextInt(20);
    int g = gardenOnly + b;
    int ans = b;

    String q = "ある公園には城と庭園がある。公園に来た人のうち、城に行った人は$c人、庭園に行った人は$g人だった。\n"
               "また城に行った人数が庭園だけに行った人数の2倍だったとき、城と庭園の両方に行った人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "庭園だけ=xとすると、城=2x。\n"
                   "2x = $c → x = ${c~/2}人。\n"
                   "庭園($g) = 庭園だけ + 両方。\n"
                   "両方 = $g - ${c~/2} = $ans人。",
      scenarioId: 'PR_1_2_PARK',
    );
  }

  GeneratedProblem _genPr1_3SportsCulture() {
    int totalPeople = (2 + _rand.nextInt(3)) * 100;
    int soPer = 30 + _rand.nextInt(10);
    int nPer = 10 + _rand.nextInt(15);
    int remain = 100 - soPer - nPer;
    while (remain % 5 != 0 || remain <= 0) {
      soPer = 30 + _rand.nextInt(10);
      nPer = 10 + _rand.nextInt(15);
      remain = 100 - soPer - nPer;
    }
    int bPer = (remain ~/ 5) * 2;
    int ans = (totalPeople * bPer) ~/ 100;

    String q = "高校生$totalPeople人に運動部、文化部への参加状況を尋ねた。\n"
               "運動部だけに参加している人は$soPer%、運動部と文化部の両方に参加している人と、"
               "文化部だけに参加している人の比率は2：3、どちらにも参加していない人は$nPer%だった。\n"
               "このとき、運動部と文化部の両方に参加している人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "両方+文化部だけ = 100 - $soPer - $nPer = $remain%。\n"
                   "これを2:3に分けるので、両方 = $remain × 2/5 = $bPer%。\n"
                   "$totalPeople × 0.${bPer.toString().padLeft(2,'0')} = $ans人。",
      scenarioId: 'PR_1_3_SPORTS_CULTURE',
    );
  }

  GeneratedProblem _genPr2_1History() {
    int ratioM = 4, ratioF = 3;
    int unit = 10 + _rand.nextInt(20);
    int total = unit * (ratioM + ratioF);
    int male = unit * ratioM;
    int female = unit * ratioF;
    int geog = male ~/ 2 + _rand.nextInt(20);
    int hist = total - geog;
    int ans = hist - female;
    if (ans < 0) ans = 0;

    String q = "ある学年の生徒数は$total人で、その男女比は$ratioM：$ratioFであり、"
               "地理もしくは日本史を選択科目として選択する必要がある(重複なし)。\n"
               "その学年の生徒たちのうち、$geog人が地理を、$hist人が日本史を選択したとき、"
               "男子で日本史を選択したのは最も少なくて□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "男子$male人、女子$female人。\n"
                   "男子の日本史を最小にするには、女子が可能な限り日本史を選択すればよい。\n"
                   "女子全員($female人)が日本史を選択すると、残りの日本史枠は\n"
                   "$hist - $female = $ans人。",
      scenarioId: 'PR_2_1_HISTORY',
    );
  }

  GeneratedProblem _genPr2_2Books3() {
    int total = 100;
    int l = 25 + _rand.nextInt(10);
    int m = 20 + _rand.nextInt(10);
    int n = 40 + _rand.nextInt(10);
    int mn = 5 + _rand.nextInt(5);
    int nl = 10 + _rand.nextInt(5);
    int union = l + m + n - (nl + mn + 0) + 0;
    int ans = total - union;

    String q = "$total人を対象に、書籍L、M、Nについて調査したところ、"
               "Lは$l人、Mは$m人、Nは$n人が読んでいた。\n"
               "また、LとNの両方を読んだ人は$nl人、MとNの両方を読んだ人は$mn人、"
               "LとMの両方を読んだ人はいなかった。このとき、L、M、Nのいずれも読んでいない人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "全体 = L + M + N - (LN + MN + LM) + LMN\n"
                   "= $l + $m + $n - ($nl + $mn + 0) + 0\n"
                   "= $union人。\n"
                   "いずれもなし = $total - $union = $ans人。",
      scenarioId: 'PR_2_2_BOOKS_3',
    );
  }

  GeneratedProblem _genPr2_3Cans() {
    int total = 50 + _rand.nextInt(20);
    int tCount = total - 10 - _rand.nextInt(10);
    int sCount = total - 10 - _rand.nextInt(10);
    if (tCount + sCount <= total) {
       tCount = total - 5; sCount = total - 5;
    }
    int ans = tCount + sCount - total;

    String q = "あるイベントの参加者$total人に、ツナ、サバ、カニの3種類の缶詰のうち、種類の異なる2缶が配られた。\n"
               "ツナをもらった人は$tCount人、サバをもらった人は$sCount人だったとすると、"
               "ツナとサバをもらった人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "全員が必ず「ツナかサバの少なくとも一方」をもらっている(カニ・カニは無いため)。\n"
                   "よって和集合は全員。\n"
                   "共通部分 = $tCount + $sCount - $total = $ans人。",
      scenarioId: 'PR_2_3_CANS',
    );
  }

  GeneratedProblem _genPr2_4Lecture3() {
    int total = 300 + _rand.nextInt(50);
    int p = 150 + _rand.nextInt(50);
    int q = 150 + _rand.nextInt(50);
    int r = 100 + _rand.nextInt(50);
    int sum = p + q + r;
    if (sum <= total) {
      p += 50; q += 50; sum = p+q+r;
    }
    int ans = sum - total;

    String qText = "ある大学では、3つの講義P、Q、Rのうち1つ以上を受講することになっている。\n"
                   "対象となる大学生は$total人で、各講義の受講人数はPが$p人、Qが$q人、Rが$r人だった。\n"
                   "3つとも受講した人がいなかったとき、2つの講義を受講した人は□□人である。";

    return GeneratedProblem(
      questionText: qText,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "延べ人数 = $p + $q + $r = $sum人。\n"
                   "3つ受講が0人なので、延べ人数の超過分はすべて「2つ受講」による重複。\n"
                   "2つ受講 = $sum - $total = $ans人。",
      scenarioId: 'PR_2_4_LECTURE_3',
    );
  }

  GeneratedProblem _genPr3_1Library() {
    int p3 = 10 + _rand.nextInt(5);
    int books = 80 + _rand.nextInt(20);
    if (books - 3*p3 < 5) {
      books = 100; p3 = 10;
    }
    int maxP1 = (books - 3 * p3) ~/ 5;
    int ans = maxP1 * 2;

    String q = "ある図書室では現在$books冊の本が貸し出し中である。\n"
               "本を借りている人のうち1冊借りている人と2冊借りている人の比率が1：2で、"
               "3冊以上借りている人が${p3}人のとき、2冊借りている人は最も多くて□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "1冊=x、2冊=2x。3冊以上は最低3冊借りているとすると、残りが最大化される。\n"
                   "5x ≦ $books - 3×$p3 = ${books - 3*p3}。\n"
                   "x ≦ ${(books - 3*p3)/5}。\n"
                   "最大x=$maxP1。2冊の人(2x)は$ans人。",
      scenarioId: 'PR_3_1_LIBRARY',
    );
  }

  GeneratedProblem _genPr3_2Museum() {
    int smVal = (10 + _rand.nextInt(20)) * 4;
    int specialTotal = (smVal * 7) ~/ 4;
    int p = specialTotal;
    int ans = smVal;

    String q = "ある日、博物館を訪れた人のうち特別展を見学した人は$p人で、そのうち4/7は常設展も見学した。\n"
               "また、常設展を見学した人のうち1/3は特別展も見学した。\n"
               "このとき、常設展と特別展の両方を見学した人は□□人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "特別展を見学した人は$p人。\n"
                   "両方見学したのはその4/7なので、$p × 4/7 = $ans人。",
      scenarioId: 'PR_3_2_MUSEUM',
    );
  }

  GeneratedProblem _genPr3_3Snacks3() {
    int total = 80 + _rand.nextInt(20);
    int only1 = 50 + _rand.nextInt(10);
    int others = total - only1;
    int only3 = 1 + _rand.nextInt(others ~/ 2);
    int only2 = others - only3;
    int sum = only1 + 2 * only2 + 3 * only3;
    int g = sum ~/ 3;
    int a = sum ~/ 3;
    int c = sum - g - a;
    g += 5; a -= 5;
    int ans = only3;

    String q = "ガム、アメ、クッキーの3種類の中から1〜3種類が入った詰め合わせが$total袋ある。\n"
               "ガム入りが$g袋、アメ入りが$a袋、クッキー入りが$c袋で、1種類だけ入ったものは$only1袋だった。\n"
               "このとき、3種類とも入った袋は□□袋である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "袋"),
      correctAnswer: "$ans袋",
      explanation: "延べ個数 = $g + $a + $c = $sum個。\n"
                   "$sum = $only1 + 2×(2種類) + 3×(3種類)。\n"
                   "全体$total = $only1 + (2種類) + (3種類)。\n"
                   "差をとって、3種類 = $sum - 2×$total + $only1 = $ans袋。",
      scenarioId: 'PR_3_3_SNACKS_3',
    );
  }
}
