import 'dart:math';

// =========================================================
// Numerical Logic Engine v7.7 (Grammar Hard-Fix Final)
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

class LogicTheme {
  final String intro;      
  final List<String> subjects; 
  final String action;     
  final String target;     
  final String unit;       
  final String label;

  const LogicTheme({
    required this.intro,
    required this.subjects,
    required this.action,
    required this.target,
    required this.unit,
    required this.label,
  });
}

class NumericalEngine {
  final Random _rand = Random();
  static final Set<String> _historyHashes = {};
  
  static const List<String> _allScenarioIds = [
    'SWIM_RANK', 'APARTMENT', 'COINS', 'BASKETBALL', 
    'COLORED_BOXES', 'PARTICIPANTS', 'PEN_PRICE', 
    'MARK_DIST', 'STRAWBERRY', 'CALENDAR', 'RICE_BALL', 'ROUND_TABLE'
  ];

  // Themes (Simplified for Logic use, Text is Hardcoded)
  final List<LogicTheme> _themesSwim = [
    LogicTheme(intro: "水泳大会", subjects: ['Aさん', 'Bさん', 'Cさん', 'Dさん'], action: "", target: "順位", unit: "位", label: 'Swim'),
    LogicTheme(intro: "運動会", subjects: ['A選手', 'B選手', 'C選手', 'D選手'], action: "", target: "順位", unit: "位", label: 'Run'),
  ];

  final List<LogicTheme> _themesApartment = [
    LogicTheme(intro: "アパート", subjects: ['Pさん', 'Qさん', 'Rさん'], action: "", target: "部屋番号", unit: "号室", label: 'Apt'),
    LogicTheme(intro: "ロッカー", subjects: ['Aさん', 'Bさん', 'Cさん'], action: "", target: "ロッカー番号", unit: "番", label: 'Locker'),
  ];

  final List<LogicTheme> _themesCoins = [
    LogicTheme(intro: "レジ", subjects: ['100円硬貨', '500円硬貨'], action: "", target: "枚数", unit: "枚", label: 'Coins'),
    LogicTheme(intro: "郵便局", subjects: ['50円切手', '80円切手'], action: "", target: "枚数", unit: "枚", label: 'Stamps'),
  ];

  final List<LogicTheme> _themesBasket = [
    LogicTheme(intro: "バスケットボール", subjects: ['Aさん', 'Bさん', 'Cさん'], action: "", target: "ゴールを決めた回数", unit: "回", label: 'Basket'),
    LogicTheme(intro: "サッカー", subjects: ['X選手', 'Y選手', 'Z選手'], action: "", target: "ゴールを決めた回数", unit: "回", label: 'Soccer'),
  ];

  final List<LogicTheme> _themesBoxes = [
    LogicTheme(intro: "倉庫", subjects: ['赤い箱', '黄色い箱', '青い箱'], action: "", target: "箱の数", unit: "個", label: 'Boxes'),
    LogicTheme(intro: "花壇", subjects: ['バラ', 'ユリ', 'ヒマワリ'], action: "", target: "花の数", unit: "本", label: 'Flowers'),
  ];

  final List<LogicTheme> _themesParticipants = [
    LogicTheme(intro: "地域交流会", subjects: ['北地区', '南地区'], action: "", target: "参加人数", unit: "人", label: 'SportsDay'),
    LogicTheme(intro: "社内研修", subjects: ['営業部', '開発部'], action: "", target: "参加人数", unit: "人", label: 'Seminar'),
  ];

  final List<LogicTheme> _themesPens = [
    LogicTheme(intro: "文房具店", subjects: ['ボールペン'], action: "", target: "本数", unit: "本", label: 'Pens'),
    LogicTheme(intro: "駄菓子屋", subjects: ['ガム'], action: "", target: "個数", unit: "個", label: 'Snacks'),
  ];

  final List<LogicTheme> _themesDist = [
    LogicTheme(intro: "実験", subjects: ['赤', '黒', '茶', '黄'], action: "", target: "印の間の距離", unit: "cm", label: 'Marks'),
    LogicTheme(intro: "鉄道", subjects: ['A駅', 'B駅', 'C駅', 'D駅'], action: "", target: "駅間の距離", unit: "Km", label: 'Stations'),
  ];

  final List<LogicTheme> _themesHarvest = [
    LogicTheme(intro: "家庭菜園", subjects: ['イチゴ'], action: "", target: "収穫数", unit: "個", label: 'Strawberry'),
    LogicTheme(intro: "読書", subjects: ['小説'], action: "", target: "ページ数", unit: "ページ", label: 'Reading'),
  ];

  final List<LogicTheme> _themesCalendar = [
    LogicTheme(intro: "会議", subjects: ['会議'], action: "", target: "日付", unit: "日", label: 'Meeting'),
    LogicTheme(intro: "特売", subjects: ['特売セール'], action: "", target: "日付", unit: "日", label: 'Sale'),
  ];

  final List<LogicTheme> _themesRice = [
    LogicTheme(intro: "おにぎり", subjects: ['梅', 'サケ'], action: "", target: "個数", unit: "個", label: 'RiceBall'),
    LogicTheme(intro: "サンドイッチ", subjects: ['ハム', 'タマゴ'], action: "", target: "個数", unit: "個", label: 'Sandwich'),
  ];

  final List<LogicTheme> _themesRound = [
    LogicTheme(intro: "円卓", subjects: ['Aさん', 'Bさん', 'Cさん', 'Xさん', 'Yさん', 'Zさん'], action: "", target: "カードの番号", unit: "番", label: 'Table'),
  ];

  Future<List<GeneratedProblem>> generateProblems(int count) async {
    List<GeneratedProblem> problems = [];
    List<String> currentIds = List.from(_allScenarioIds)..shuffle(_rand);
    List<String> selectedIds = currentIds.take(count).toList();
    
    for (String id in selectedIds) {
      GeneratedProblem? problem;
      int retries = 0;
      while (retries < 20) {
        try {
          problem = _generateSpecificScenario(id);
          if (_isValid(problem)) {
             if (!_historyHashes.contains(problem.structureHash)) {
               _historyHashes.add(problem.structureHash);
               break; 
             }
          }
        } catch (e) {
          // retry
        }
        retries++;
      }
      if (problem != null) {
        problems.add(problem);
      } else {
        problems.add(_genSwimRank());
      }
    }
    return problems;
  }

  GeneratedProblem _generateSpecificScenario(String id) {
    switch (id) {
      case 'SWIM_RANK': return _genSwimRank();
      case 'APARTMENT': return _genApartment();
      case 'COINS': return _genCoins();
      case 'BASKETBALL': return _genBasketball();
      case 'COLORED_BOXES': return _genColoredBoxes();
      case 'PARTICIPANTS': return _genParticipants();
      case 'PEN_PRICE': return _genPenPrice();
      case 'MARK_DIST': return _genMarkDistance();
      case 'STRAWBERRY': return _genStrawberry();
      case 'CALENDAR': return _genCalendar();
      case 'RICE_BALL': return _genRiceBall();
      case 'ROUND_TABLE': return _genRoundTable();
      default: return _genSwimRank();
    }
  }

  // 1. Swim Rank
  GeneratedProblem _genSwimRank() {
    LogicTheme t = _themesSwim[_rand.nextInt(_themesSwim.length)];
    List<String> p = List.from(t.subjects);
    List<String> s = List.from(t.subjects)..shuffle(_rand);
    
    // Hardcoded Grammar
    String q = "";
    if (t.label == 'Swim') {
      q = "水泳大会で、${p.join('、')}の4人が50m自由形を2回泳いだ。2回の順位について以下のことがわかっている。\n";
    } else {
      q = "運動会で、${p.join('、')}の4人が100m走を2回走った。2回の順位について以下のことがわかっている。\n";
    }
    q += "ア：1回目に4位だった${s[0]}は、2回目は2位だった\n";
    q += "イ：2回目に${s[1]}と${s[2]}は1回目より1つずつ順位が下がった\n";
    q += "このとき、1回目の${s[3]}の順位は [   ] 位である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(1, unit: t.unit),
      correctAnswer: "1${t.unit}",
      explanation: "${s[1]}と${s[2]}は順位が1つ下がったので、「1→2」「2→3」「3→4」のいずれか。2回目の2位は${s[0]}なので「1→2」は不可。よって「2→3」「3→4」のペア。残る${s[3]}が1位。",
      scenarioId: 'SWIM_RANK',
      structureHash: 'SWIM_${t.label}_${s.join()}',
    );
  }

  // 2. Apartment (Fixed Grammar)
  GeneratedProblem _genApartment() {
    LogicTheme t = _themesApartment[_rand.nextInt(_themesApartment.length)];
    List<String> p = List.from(t.subjects); 
    List<String> s = List.from(t.subjects)..shuffle(_rand); 
    
    int diff = 5 + _rand.nextInt(4);
    int qVal = 15 + _rand.nextInt(3); 
    int pVal = qVal - diff;
    int rVal = 1 + _rand.nextInt(18);
    // ensure logic...
    List<int> empty = [6, 10, 14];
    while(empty.contains(qVal) || empty.contains(pVal)) { qVal = 12 + _rand.nextInt(6); pVal = qVal - diff; }
    while(empty.contains(rVal) || rVal == pVal || rVal == qVal) { rVal = 1 + _rand.nextInt(18); }
    int total = pVal + qVal + rVal;

    String q = "";
    if (t.label == 'Apt') {
      q = "1号室から18号室までの部屋があるアパートに、${p.join('、')}が住んでいる。ただし、6号室、10号室、14号室は空室である。3人の部屋番号について、以下のことがわかっている。\n";
    } else {
      q = "駅に1番から18番までのロッカーがある。${p.join('、')}がそれぞれロッカーを使用している。ただし、6番、10番、14番は空いている。3人のロッカー番号について、以下のことがわかっている。\n";
    }
    q += "ア：3人の${t.target}の合計は$totalである\n";
    q += "イ：${s[0]}の${t.target}は${s[1]}の${t.target}より$diff小さい\n";
    q += "このとき、${s[2]}の${t.target}は [   ] である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(rVal, unit: ""),
      correctAnswer: "$rVal",
      explanation: "${s[0]}=${s[1]}-$diff、合計$total。空きを除外して計算すると、${s[1]}=$qVal、${s[0]}=$pValとなる。よって${s[2]}は$rVal。",
      scenarioId: 'APARTMENT',
      structureHash: 'APT_${t.label}_${total}_${s.join()}',
    );
  }

  // 3. Coins (Fixed Grammar)
  GeneratedProblem _genCoins() {
    LogicTheme t = _themesCoins[_rand.nextInt(_themesCoins.length)];
    int val1 = 100, val2 = 500;
    if (t.label == 'Stamps') { val1 = 50; val2 = 80; }
    
    int c2 = 30 + _rand.nextInt(20);
    int c1 = 40 + _rand.nextInt(20);
    int amount = c1 * val1 + c2 * val2;
    int maxCount = c1 + c2 + _rand.nextInt(5);
    int allLow = maxCount * val1;
    int diff = val2 - val1;
    int shortage = amount - allLow;
    int ans = (shortage / diff).ceil();

    String q = "";
    if (t.label == 'Coins') {
      q = "レジで、合計$amount円分の100円硬貨と500円硬貨を釣銭として用意した。その枚数について以下のことがわかっている。\n";
    } else {
      q = "郵便局で、合計$amount円分の50円切手と80円切手を購入した。その枚数について以下のことがわかっている。\n";
    }
    q += "ア：2種類の合計枚数は${maxCount}枚以下だった\n";
    q += "このとき、${t.subjects[1]}は最も少なくて [   ] 枚である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: t.unit),
      correctAnswer: "$ans${t.unit}",
      explanation: "枚数を最大${maxCount}枚とし、すべて${t.subjects[0]}とすると$allLow円。不足分${amount-allLow}円を補うため、1枚交換するごとに${diff}円増える。${amount-allLow}÷$diff=$ans。",
      scenarioId: 'COINS',
      structureHash: 'COIN_${t.label}_${amount}_${maxCount}',
    );
  }

  // 4. Basketball (Fixed Grammar)
  GeneratedProblem _genBasketball() {
    LogicTheme t = _themesBasket[_rand.nextInt(_themesBasket.length)];
    List<String> p = List.from(t.subjects); 
    List<String> s = List.from(t.subjects)..shuffle(_rand); 
    
    int total = 6 + _rand.nextInt(3);
    int ans = 3;
    
    String q = "";
    if (t.label == 'Basket') {
      q = "バスケットボールの練習で、${p.join('、')}の3人がそれぞれ${total}回ずつフリースローを行った。ゴールを決めた回数について以下のことがわかった。(同点はない)\n";
    } else {
      q = "サッカーの練習で、${p.join('、')}の3人がそれぞれ${total}回ずつPK練習を行った。ゴールを決めた回数について以下のことがわかった。(同点はない)\n";
    }
    q += "ア：${s[0]}の回数は${s[2]}の2倍だった\n";
    q += "イ：3人とも2回以上成功した\n";
    q += "ウ：${s[1]}の回数は最も少なかった\n";
    q += "このとき、${s[2]}の回数は [   ] 回である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: t.unit),
      correctAnswer: "$ans${t.unit}",
      explanation: "イより全員2以上。ウより${s[1]}は2。${s[0]}=2×${s[2]}。${s[2]}=3なら${s[0]}=6で成立。",
      scenarioId: 'BASKETBALL',
      structureHash: 'BSKT_${t.label}_${s.join()}',
    );
  }

  // 5. Colored Boxes (Fixed Grammar)
  GeneratedProblem _genColoredBoxes() {
    LogicTheme t = _themesBoxes[_rand.nextInt(_themesBoxes.length)];
    List<String> items = List.from(t.subjects); 
    List<String> s = List.from(t.subjects)..shuffle(_rand);
    String iA = s[0], iB = s[1], iSep = s[2]; 

    int total = 12 + _rand.nextInt(2) * 2; 
    int sepCount = total ~/ 2;
    int diff = 2;
    int aCount = sepCount - diff;
    int bCount = (total - sepCount) - aCount; 
    
    String q = "";
    if (t.label == 'Boxes') {
      q = "倉庫の整理で、${items.join('、')}の3種類を、同じ種類が隣り合わないように横一列に合計$total個並べた。\n";
    } else {
      q = "花壇に、${items.join('、')}の3種類を、同じ種類が隣り合わないように横一列に合計$total本植えた。\n";
    }
    q += "ア：$iSepは$iAより$diff${t.unit}多い\n";
    q += "イ：$iAと$iBが隣り合っているところはない\n";
    q += "このとき、$iBは [   ] ${t.unit}である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(bCount, unit: t.unit),
      correctAnswer: "$bCount${t.unit}",
      explanation: "$iAと$iBは隣り合わないので、$iSepが間に挟まる。$iSepは全体の半分の$sepCount。アより$iAは${sepCount-diff}。残りが$iB。",
      scenarioId: 'COLORED_BOXES',
      structureHash: 'BOX_${t.label}_${total}_${s.join()}',
    );
  }

  // 6. Participants (Fixed Grammar)
  GeneratedProblem _genParticipants() {
    LogicTheme t = _themesParticipants[_rand.nextInt(_themesParticipants.length)];
    String g1 = t.subjects[0];
    String g2 = t.subjects[1];

    int total = 81 + _rand.nextInt(5) * 2; 
    int diffTotal = 5 + _rand.nextInt(3) * 2; 
    int diffGroup = 7 + _rand.nextInt(3) * 2; 
    int cand1 = (total - diffTotal) ~/ 2;
    int cand2 = (total + diffTotal) ~/ 2;
    int targetTotal = (cand2 % 2 != 0) ? cand2 : cand1;
    if ((targetTotal + diffGroup) % 2 != 0) targetTotal = (targetTotal == cand1) ? cand2 : cand1;
    int ans = (targetTotal + diffGroup) ~/ 2;

    String type1 = t.label == 'Seminar' ? "社会人" : "大人";
    String type2 = t.label == 'Seminar' ? "学生" : "子ども";

    String q = "";
    if (t.label == 'SportsDay') {
      q = "地域交流会で、北地区と南地区が合同で運動会を開催し、合わせて$total人が参加した。$type1と$type2の人数について以下のことがわかっている。\n";
    } else {
      q = "社内研修で、営業部と開発部が合同でセミナーを開催し、合わせて$total人が参加した。$type1と$type2の人数について以下のことがわかっている。\n";
    }
    q += "ア：$type1と$type2の差は$diffTotal人だった\n";
    q += "イ：$type1の人数は、$g1が$g2より$diffGroup人多かった\n";
    q += "このとき、$g1から参加した$type1の人数は [   ] 人である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "人"),
      correctAnswer: "$ans人",
      explanation: "全体の$type1は$targetTotal人(計算により特定)。$g1の$type1は($targetTotal+$diffGroup)÷2=$ans人。",
      scenarioId: 'PARTICIPANTS',
      structureHash: 'PART_${t.label}_${total}_${diffTotal}_${diffGroup}',
    );
  }

  // 7. Pen Price (Fixed Grammar)
  GeneratedProblem _genPenPrice() {
    LogicTheme t = _themesPens[_rand.nextInt(_themesPens.length)];
    List<int> prices = [50, 80, 120];
    if (t.label == 'Snacks') prices = [30, 60, 90];
    
    int cMax = 4 + _rand.nextInt(2);
    int cMin = 2 + _rand.nextInt(2);
    int cHigh = 1; 
    int totalMoney = prices[0]*cMin + prices[1]*cMax + prices[2]*cHigh;
    int totalCount = cMin + cMax + cHigh;
    
    String q = "";
    if (t.label == 'Pens') {
      q = "文房具店で、50円、80円、120円のボールペンを購入した。以下のことがわかっている。\n";
    } else {
      q = "駄菓子屋で、30円、60円、90円のガムを購入した。以下のことがわかっている。\n";
    }
    q += "ア：合計は$totalMoney円\n";
    q += "イ：${prices[1]}円の${t.subjects[0]}が最も多い\n";
    q += "このとき、全部で [   ] ${t.unit}である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(totalCount, unit: t.unit),
      correctAnswer: "$totalCount${t.unit}",
      explanation: "イより${prices[1]}円が最多。シミュレーションすると、${prices[0]}円$cMin、${prices[1]}円$cMax、${prices[2]}円$cHighの組み合わせが見つかる。",
      scenarioId: 'PEN_PRICE',
      structureHash: 'PEN_${t.label}_${totalMoney}',
    );
  }

  // 8. Mark Distance (Fixed Grammar)
  GeneratedProblem _genMarkDistance() {
    LogicTheme t = _themesDist[_rand.nextInt(_themesDist.length)];
    List<String> m = List.from(t.subjects)..shuffle(_rand);
    String end1 = m[0], end2 = m[1], target = m[2], other = m[3];
    if (t.label == 'Stations') { m.sort(); end1 = m[0]; end2 = m[3]; target = m[1]; other = m[2]; }

    int d1 = 20 + _rand.nextInt(3)*10;
    int d2 = 40 + _rand.nextInt(3)*10;
    int dTargetFromEnd2 = 15 + _rand.nextInt(2)*5;
    int ans = d1 + (d2 - dTargetFromEnd2);

    String q = "";
    if (t.label == 'Marks') {
      q = "1本の棒に、赤、黒、茶、黄の4色の印をつけた。その間隔について以下がわかっている。\n";
    } else {
      q = "A駅、B駅、C駅、D駅の4つの駅が一直線に並んでいる。駅間の距離について以下がわかっている。\n";
    }
    q += "ア：$targetと$end2の間は$dTargetFromEnd2${t.unit}、$end2と$otherの間は$d2${t.unit}、$otherと$end1の間は$d1${t.unit}\n";
    q += "イ：$end1と$end2の間が最も長い\n";
    q += "このとき、$end1と$targetの間は [   ] ${t.unit}である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: t.unit),
      correctAnswer: "$ans${t.unit}",
      explanation: "$end1と$end2が両端。配置は$end1 - $other - $target - $end2 となる（$targetは$other-$end2間）。計算により$ans。",
      scenarioId: 'MARK_DIST',
      structureHash: 'DIST_${t.label}_${m.join()}_$d1',
    );
  }

  // 9. Strawberry (Fixed Grammar)
  GeneratedProblem _genStrawberry() {
    LogicTheme t = _themesHarvest[_rand.nextInt(_themesHarvest.length)];
    int d1 = 4 + _rand.nextInt(4);
    int d3 = d1 * 2;
    int diff = 10 + _rand.nextInt(3);
    int d2 = d1 + diff; 
    int total = d1 + d2 + d3;
    
    String q = "";
    if (t.label == 'Strawberry') {
      q = "家庭菜園で、イチゴを3日間収穫した。合計$total個だった。\n";
    } else {
      q = "読書週間で、小説を3日間読んだ。合計$totalページだった。\n";
    }
    q += "ア：3日目は1日目の2倍だった\n";
    q += "イ：最も多い日は最も少ない日より$diff${t.unit}多かった\n";
    q += "このとき、2日目は [   ] ${t.unit}である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(d2, unit: t.unit),
      correctAnswer: "$d2${t.unit}",
      explanation: "1日目=$d1、3日目=$d3と仮定すると、差が$diffになるのは2日目=$d2のとき。",
      scenarioId: 'STRAWBERRY',
      structureHash: 'STRW_${t.label}_${total}_$diff',
    );
  }

  // 10. Calendar (Fixed Grammar)
  GeneratedProblem _genCalendar() {
    LogicTheme t = _themesCalendar[_rand.nextInt(_themesCalendar.length)];
    String d1 = "月曜", d2 = "金曜";
    int ans = 14;

    String q = "";
    if (t.label == 'Meeting') {
      q = "ある月、会議の開催日程が決まっている。以下のことがわかっている。\n";
    } else {
      q = "ある月、特売セールの開催日程が決まっている。以下のことがわかっている。\n";
    }
    q += "ア：この月には第5$d1日がある\n";
    q += "イ：第3$d2日は3の倍数にあたる日である\n";
    q += "このとき、第2$d2日の日付は [   ] 日である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "日"),
      correctAnswer: "${ans}日",
      explanation: "第3$d2日は21日と特定できる。第2$d2日はその7日前。",
      scenarioId: 'CALENDAR',
      structureHash: 'CAL_${t.label}_${ans}',
    );
  }

  // 11. Rice Ball (Fixed Grammar)
  GeneratedProblem _genRiceBall() {
    LogicTheme t = _themesRice[_rand.nextInt(_themesRice.length)];
    String i1 = t.subjects[0];
    String i2 = t.subjects[1];
    int total = 20;
    int ans = 6; 

    String q = "";
    if (t.label == 'RiceBall') {
      q = "お弁当の準備で、梅とサケのおにぎりを合わせて$total個用意した。個数について以下の条件があった。\n";
    } else {
      q = "ランチの準備で、ハムとタマゴのサンドイッチを合わせて$total個作った。個数について以下の条件があった。\n";
    }
    q += "ア：$i1は$i2の1.5倍以下\n";
    q += "イ：$i2は$i1の2倍以下\n";
    q += "このとき、${t.target}の組み合わせは [   ] 通りある。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "通り"),
      correctAnswer: "${ans}通り",
      explanation: "$i2の個数は8〜13個の範囲で条件を満たす。よって${ans}通り。",
      scenarioId: 'RICE_BALL',
      structureHash: 'RICE_${t.label}_$total',
    );
  }

  // 12. Round Table (Fixed Grammar)
  GeneratedProblem _genRoundTable() {
    LogicTheme t = _themesRound[_rand.nextInt(_themesRound.length)];
    List<String> p = List.from(t.subjects); 
    String wR = p[0], wS = p[1], wT = p[2];
    String mX = p[3], mY = p[4], mZ = p[5];
    
    String q = "パーティー会場で、${p.join('、')}の6人が円卓に座っている。それぞれ2から7の異なる数字のカードを持っている。\n";
    q += "ア：両隣が異性なのは$wTだけである\n";
    q += "イ：$wRと$mXだけがペアで向かい合っている\n";
    q += "このとき、$wSの向かいの人のカード番号は [   ] である。($wTのカードは4)";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(4, unit: ""),
      correctAnswer: "4",
      explanation: "$wSの向かいは$wTになる配置しかない。",
      scenarioId: 'ROUND_TABLE',
      structureHash: 'RND_${t.label}_4',
    );
  }

  List<String> _makeOptions(int correct, {String unit = ""}) {
    Set<String> s = {};
    s.add("$correct$unit");
    while(s.length < 5) {
      int v = correct + (_rand.nextBool() ? 1 : -1) * (_rand.nextInt(5)+1);
      if (v > 0) s.add("$v$unit");
    }
    List<String> l = s.toList();
    l.sort(); 
    return l;
  }
  
  bool _isValid(GeneratedProblem? p) {
    if (p == null) return false;
    if (p.options.length != 5) return false;
    if (p.questionText.contains('null')) return false;
    if (p.questionText.contains('Instance of')) return false;
    return true;
  }
}
