import 'dart:math';

// =========================================================
// Condition Logic Engine v9.3 (Distance Logic Replacement)
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

class ConditionEngine {
  final Random _rand = Random();
  static final Set<String> _historyHashes = {};
  
  static const List<String> _conditionOptions = [
    "A アだけでわかるが、イだけではわからない",
    "B イだけでわかるが、アだけではわからない",
    "C アとイの両方でわかるが、片方だけではわからない",
    "D アだけでも、イだけでもわかる",
    "E アとイの両方があってもわからない",
  ];

  static const List<String> _allScenarioIds = [
    'LEAGUE_MATCH', 'AVG_AGE', 'TEST_SCORE', 
    'COIN_COUNT', 'VISITORS', 'TILES',
    'DISTANCE', 'PURCHASE', 'PROFIT',
    'ORDER', 'AGE_DIFF',
    'LEAGUE_LOSE', 'AVG_SUM', 'DIST_LINE', 'PURCHASE_ONLY'
  ];

  // Group definitions
  static const Map<String, List<String>> _scenarioGroups = {
    'LEAGUE': ['LEAGUE_MATCH', 'LEAGUE_LOSE'],
    'AVG': ['AVG_AGE', 'AVG_SUM'],
    'SCORE': ['TEST_SCORE'],
    'COIN': ['COIN_COUNT'],
    'VISIT': ['VISITORS'],
    'TILE': ['TILES'],
    'DIST': ['DISTANCE', 'DIST_LINE'],
    'PURCH': ['PURCHASE', 'PURCHASE_ONLY'],
    'PROFIT': ['PROFIT'],
    'ORDER': ['ORDER'],
    'AGE': ['AGE_DIFF'],
  };

  // =========================================================
  // Themes Definition
  // =========================================================

  // 1. League
  final List<LogicTheme> _themesLeague = [
    LogicTheme(intro: "野球のリーグ戦で、Pチーム、Qチーム、Rチーム、Sチームの4チームが", subjects: ['Pチーム', 'Qチーム', 'Rチーム', 'Sチーム'], action: "総当たり戦を行った。", target: "優勝チーム", unit: "", label: "Baseball"),
    LogicTheme(intro: "サッカーのリーグ戦で、Aチーム、Bチーム、Cチーム、Dチームの4チームが", subjects: ['Aチーム', 'Bチーム', 'Cチーム', 'Dチーム'], action: "総当たり戦を行った。", target: "優勝チーム", unit: "", label: "Soccer"),
  ];

  // 2. Avg Age
  final List<LogicTheme> _themesAvg = [
    LogicTheme(intro: "あるサークルに、", subjects: ['48歳の', '63歳の'], action: "9人が所属している。", target: "平均年齢", unit: "歳", label: "Circle"),
    LogicTheme(intro: "ある部署に、", subjects: ['40歳の', '55歳の'], action: "9人が所属している。", target: "平均年齢", unit: "歳", label: "Dept"),
  ];

  // 3. Test Score
  final List<LogicTheme> _themesScore = [
    LogicTheme(intro: "ある学生が、国語、社会、英語の3科目の", subjects: ['国語', '社会', '英語'], action: "試験を受けた。", target: "国語の点数", unit: "点", label: "Exam"),
    LogicTheme(intro: "ある学生が、数学、理科、物理の3科目の", subjects: ['数学', '理科', '物理'], action: "試験を受けた。", target: "数学の点数", unit: "点", label: "Science"),
  ];

  // 4. Coin Count
  final List<LogicTheme> _themesCoin = [
    LogicTheme(intro: "財布の中に、100円玉、50円玉、10円玉が", subjects: ['100円玉', '50円玉', '10円玉'], action: "入っている。", target: "100円玉の枚数", unit: "枚", label: "Wallet"),
  ];

  // 5. Visitors
  final List<LogicTheme> _themesVisitor = [
    LogicTheme(intro: "あるイベントの、3日間の", subjects: ['1日目', '2日目', '3日目'], action: "入場者数を調査した。", target: "最も少なかった日", unit: "日目", label: "Event"),
    LogicTheme(intro: "ある店の、金曜、土曜、日曜の3日間の", subjects: ['金曜', '土曜', '日曜'], action: "売上客数を調査した。", target: "最も少なかった曜日", unit: "", label: "Shop"),
  ];

  // 6. Tiles
  final List<LogicTheme> _themesTile = [
    LogicTheme(intro: "長方形のタイルを、正方形の枠内に、縦向きと横向きを組み合わせて", subjects: ['縦', '横'], action: "すき間なく敷き詰めた。", target: "タイルの枚数", unit: "枚", label: "Tile"),
    LogicTheme(intro: "長方形の画用紙を、正方形の台紙に、縦向きと横向きを組み合わせて", subjects: ['縦', '横'], action: "貼り付けた。", target: "画用紙の枚数", unit: "枚", label: "Paper"),
  ];

  // 7. Distance (Fixed Park -> Station)
  final List<LogicTheme> _themesDist = [
    LogicTheme(
      intro: "地図上で、自宅、図書館、駅の3地点の", 
      subjects: ['自宅', '図書館', '駅'], 
      action: "位置関係を調べた。", 
      target: "図書館から駅までの距離", 
      unit: "Km", 
      label: "Map"
    ),
    // Replaced Park with Station Logic as requested
    LogicTheme(
      intro: "A駅、B駅、C駅について", 
      subjects: ['A駅', 'B駅', 'C駅'], 
      action: "駅間の距離を調査した。", 
      target: "B駅とC駅間の距離", 
      unit: "Km", 
      label: "Stations"
    ),
  ];

  // 8. Purchase
  final List<LogicTheme> _themesBuy = [
    LogicTheme(intro: "来店客100人を対象に、食料品と雑貨の", subjects: ['食料品', '雑貨'], action: "購入状況を調査した。", target: "両方購入した人数", unit: "人", label: "Store"),
    LogicTheme(intro: "学生100人を対象に、犬派か猫派かの", subjects: ['犬派', '猫派'], action: "アンケートをとった。", target: "両方好きな人数", unit: "人", label: "Survey"),
  ];

  // 9. Profit
  final List<LogicTheme> _themesProfit = [
    LogicTheme(intro: "ある商品を、定価の2割引きで", subjects: ['定価', '売値'], action: "売った。", target: "仕入れ値", unit: "円", label: "Sale"),
    LogicTheme(intro: "ある製品を、定価の2割引きで", subjects: ['定価', '売値'], action: "売った。", target: "原価", unit: "円", label: "Product"),
  ];

  // 10. Order
  final List<LogicTheme> _themesOrder = [
    LogicTheme(intro: "発表会で、P、Q、R、S、Tの5人が", subjects: ['P', 'Q', 'R', 'S', 'T'], action: "順番に踊った。", target: "3番目の人", unit: "", label: "Dance"),
    LogicTheme(intro: "面接で、A、B、C、D、Eの5人が", subjects: ['A', 'B', 'C', 'D', 'E'], action: "順番に呼ばれた。", target: "3番目の人", unit: "", label: "Interview"),
  ];

  // 11. Age Diff
  final List<LogicTheme> _themesAgeDiff = [
    LogicTheme(intro: "ある兄弟の、兄と弟の", subjects: ['兄', '弟'], action: "年齢差は15歳である。", target: "兄の年齢", unit: "歳", label: "Brothers"),
    LogicTheme(intro: "ある親子の、父と子の", subjects: ['父', '子'], action: "年齢差は25歳である。", target: "父の年齢", unit: "歳", label: "Parent"),
  ];

  // =========================================================
  // Generator Logic
  // =========================================================

  Future<List<GeneratedProblem>> generateProblems(int count) async {
    List<GeneratedProblem> problems = [];
    
    List<String> groups = _scenarioGroups.keys.toList()..shuffle(_rand);
    List<String> selectedGroups = groups.take(count).toList();
    
    for (String group in selectedGroups) {
      List<String> scenarios = _scenarioGroups[group]!;
      String id = scenarios[_rand.nextInt(scenarios.length)];
      
      GeneratedProblem? problem;
      try {
        problem = _generateSpecificScenario(id);
      } catch (e) {
        problem = _genLeagueMatch(); 
      }
      problems.add(problem!);
    }
    return problems;
  }

  GeneratedProblem _generateSpecificScenario(String id) {
    switch (id) {
      case 'LEAGUE_MATCH': return _genLeagueMatch();
      case 'AVG_AGE': return _genAvgAge();
      case 'TEST_SCORE': return _genTestScore();
      case 'COIN_COUNT': return _genCoinCount();
      case 'VISITORS': return _genVisitors();
      case 'TILES': return _genTiles();
      case 'DISTANCE': return _genDistance();
      case 'PURCHASE': return _genPurchase();
      case 'PROFIT': return _genProfit();
      case 'ORDER': return _genOrder();
      case 'AGE_DIFF': return _genAgeDiff();
      case 'LEAGUE_LOSE': return _genLeagueLose();
      case 'AVG_SUM': return _genAvgSum();
      case 'DIST_LINE': return _genDistLine();
      case 'PURCHASE_ONLY': return _genPurchaseOnly();
      default: return _genLeagueMatch();
    }
  }

  // 1. League Match
  GeneratedProblem _genLeagueMatch() {
    LogicTheme t = _themesLeague[_rand.nextInt(_themesLeague.length)];
    List<String> s = List.from(t.subjects)..shuffle(_rand);
    
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}はどこか。\n"
               "ア：全勝したチームがある\n"
               "イ：${s[1]}は${s[0]}には負けたが、${s[2]}と${s[3]}には勝った";
               
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "アより全勝(3勝)がいる。イより${s[1]}は2勝1敗。全勝は${s[0]}しかあり得ない。",
      scenarioId: 'LEAGUE_MATCH',
      structureHash: 'LEAGUE_${t.label}_MAX_${s[0]}',
    );
  }

  GeneratedProblem _genLeagueLose() {
    LogicTheme t = _themesLeague[_rand.nextInt(_themesLeague.length)];
    List<String> s = List.from(t.subjects)..shuffle(_rand);
    
    String q = "${t.intro}${t.action}\n"
               "[問い] 全敗したチームはどこか。\n"
               "ア：全敗したチームがある\n"
               "イ：${s[1]}は${s[0]}には勝ったが、${s[2]}と${s[3]}には負けた";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "アより全敗(3敗)がいる。イより${s[1]}は1勝2敗。全敗は${s[0]}以外。組み合わせると特定可能。",
      scenarioId: 'LEAGUE_LOSE',
      structureHash: 'LEAGUE_${t.label}_LOSE_${s[0]}',
    );
  }

  // 2. Avg Age
  GeneratedProblem _genAvgAge() {
    LogicTheme t = _themesAvg[_rand.nextInt(_themesAvg.length)];
    String q = "${t.intro}${t.action}\n"
               "[問い] この9人の平均年齢は何歳か。\n"
               "ア：${t.subjects[0]}人が1人加わると、平均年齢は1.0歳下がる\n"
               "イ：${t.subjects[1]}人が1人加わると、平均年齢は58.5歳になる";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "D",
      explanation: "アもイも、平均年齢をxとした方程式が立てられ、解ける。",
      scenarioId: 'AVG_AGE',
      structureHash: 'AVG_${t.label}_AGE',
    );
  }

  // 2-EX. Avg Sum
  GeneratedProblem _genAvgSum() {
    LogicTheme t = _themesAvg[_rand.nextInt(_themesAvg.length)];
    String intro = "あるサークルに関して、メンバーの平均年齢について以下のことがわかっている。";
    if (t.label == 'Dept') intro = "ある部署に関して、社員の平均年齢について以下のことがわかっている。";
    
    String q = "$intro\n"
               "[問い] 全員の年齢の合計は何歳か。\n"
               "ア：全員の平均年齢は25歳である\n"
               "イ：メンバーは9人である";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "合計＝平均×人数。アとイの両方が必要。",
      scenarioId: 'AVG_SUM',
      structureHash: 'AVG_${t.label}_SUM',
    );
  }

  // 3. Test Score
  GeneratedProblem _genTestScore() {
    LogicTheme t = _themesScore[_rand.nextInt(_themesScore.length)];
    String sub1 = t.subjects[0];
    String sub3 = t.subjects[2];
    
    String q = "${t.intro}${t.action}\n"
               "[問い] $sub1の点数は何点か。\n"
               "ア：3科目の平均点は68点だった\n"
               "イ：$sub1の得点は、$sub3の得点より26点高かった";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "E",
      explanation: "未知数3つに対し、式が2つしか立たないため、特定できない。",
      scenarioId: 'TEST_SCORE',
      structureHash: 'TEST_${t.label}_E',
    );
  }

  // 4. Coin Count
  GeneratedProblem _genCoinCount() {
    LogicTheme t = _themesCoin[_rand.nextInt(_themesCoin.length)];
    int total = 7 + _rand.nextInt(3);
    int tVal = 300 + _rand.nextInt(3) * 100;
    
    String q = "${t.intro}合計${total}枚${t.action}\n"
               "[問い] ${t.target}は何か。\n"
               "ア：${t.subjects[2]}は3枚ある\n"
               "イ：合計金額は${tVal}円未満である";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "アで${t.subjects[2]}確定。残りで金額調整すると、組み合わせが1通りに絞られる。",
      scenarioId: 'COIN_COUNT',
      structureHash: 'COIN_${t.label}_C_$total',
    );
  }

  // 5. Visitors
  GeneratedProblem _genVisitors() {
    LogicTheme t = _themesVisitor[_rand.nextInt(_themesVisitor.length)];
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}はいつか。\n"
               "ア：${t.subjects[1]}は${t.subjects[0]}の1.5倍で、全体の45%だった\n"
               "イ：${t.subjects[1]}と${t.subjects[2]}で全体の7割だった";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "A",
      explanation: "アだけで全日の比率が出せるため、大小比較が可能。",
      scenarioId: 'VISITORS',
      structureHash: 'VISIT_${t.label}_A',
    );
  }

  // 6. Tiles
  GeneratedProblem _genTiles() {
    LogicTheme t = _themesTile[_rand.nextInt(_themesTile.length)];
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}は何か。\n"
               "ア：${t.subjects[1]}の枚数は${t.subjects[0]}の枚数の1.5倍である\n"
               "イ：${t.subjects[0]}、${t.subjects[1]}のいずれかの枚数は18枚である";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "E",
      explanation: "全体のサイズが不明なため、倍数関係だけでは枚数が確定しない。",
      scenarioId: 'TILES',
      structureHash: 'TILE_${t.label}_E',
    );
  }

  // 7. Distance
  GeneratedProblem _genDistance() {
    LogicTheme t = _themesDist[_rand.nextInt(_themesDist.length)];
    
    // Custom Logic for Stations theme
    if (t.label == 'Stations') {
      // Subjects: A駅, B駅, C駅
      String q = "${t.intro}${t.action}\n"
                 "A駅とB駅間、A駅とC駅間の距離はそれぞれ1Kmである。\n"
                 "[問い] ${t.target}は何Kmか。\n"
                 "ア：A駅から見るとB駅は真南、C駅は真東にある\n"
                 "イ：3地点を結ぶと直角三角形になる";
      return GeneratedProblem(
        questionText: q,
        options: _conditionOptions,
        correctAnswer: "D",
        explanation: "アなら直角二等辺三角形で√2。イも形状が固定されるため求まる。",
        scenarioId: 'DISTANCE',
        structureHash: 'DIST_STATION_D',
      );
    } else {
      // Map Theme
      String pA = t.subjects[0]; // 自宅
      String pB = t.subjects[1]; // 図書館
      String pC = t.subjects[2]; // 駅
      
      String q = "${t.intro}$pAから$pBまでと、$pAから$pCまでの距離は共に1Kmである。\n"
                 "[問い] $pBから$pCまでの距離は何Kmか。\n"
                 "ア：$pAから見ると$pBは真南、$pCは真東にある\n"
                 "イ：3地点を結ぶと直角三角形になる";
      return GeneratedProblem(
        questionText: q,
        options: _conditionOptions,
        correctAnswer: "D",
        explanation: "アなら直角二等辺三角形で√2。イも形状が固定されるため求まる。",
        scenarioId: 'DISTANCE',
        structureHash: 'DIST_MAP_D',
      );
    }
  }

  GeneratedProblem _genDistLine() {
    LogicTheme t = _themesDist[_rand.nextInt(_themesDist.length)];
    
    // Custom logic for station line
    if (t.label == 'Stations') {
        String q = "${t.intro}3地点の位置関係について調べた。\n"
                   "[問い] 3地点は一直線上に並んでいるか。\n"
                   "ア：A駅とB駅の距離は3Km\n"
                   "イ：B駅とC駅の距離は2Km, A駅とC駅の距離は5Km";
        return GeneratedProblem(
          questionText: q,
          options: _conditionOptions,
          correctAnswer: "C",
          explanation: "アとイを合わせると、3+2=5となり、一直線上に並ぶことが確定する。",
          scenarioId: 'DIST_LINE',
          structureHash: 'DIST_STATION_LINE',
        );
    } else {
        // Map Theme (Park Logic)
        String q = "公園内に、ベンチ、噴水、トイレがある。\n"
                   "[問い] 3地点は一直線上に並んでいるか。\n"
                   "ア：ベンチと噴水の距離は3m\n"
                   "イ：噴水とトイレの距離は2m, ベンチとトイレの距離は5m";
        return GeneratedProblem(
          questionText: q,
          options: _conditionOptions,
          correctAnswer: "C",
          explanation: "アとイを合わせると、3+2=5となり、一直線上に並ぶことが確定する。",
          scenarioId: 'DIST_LINE',
          structureHash: 'DIST_PARK_LINE',
        );
    }
  }

  // 8. Purchase
  GeneratedProblem _genPurchase() {
    LogicTheme t = _themesBuy[_rand.nextInt(_themesBuy.length)];
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}は何人か。\n"
               "ア：${t.subjects[0]}だけ${t.label == 'Store' ? '購入した' : '回答した'}人は48人だった\n"
               "イ：どちらも${t.label == 'Store' ? '購入しなかった' : '回答しなかった'}人は20人だった";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "D",
      explanation: "アでも集合算で求まる。イでも全体から引けば求まる。",
      scenarioId: 'PURCHASE',
      structureHash: 'PURCH_${t.label}_D',
    );
  }

  GeneratedProblem _genPurchaseOnly() {
    LogicTheme t = _themesBuy[_rand.nextInt(_themesBuy.length)];
    String actionNoun = t.label == 'Survey' ? '回答' : '購入';
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.subjects[0]}だけ${actionNoun}した人数は何人か。\n"
               "ア：全体は100人で、${t.subjects[1]}${actionNoun}者は30人、両方${actionNoun}は10人\n"
               "イ：${t.subjects[0]}${actionNoun}者は70人";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "A",
      explanation: "アの情報だけで、Aのみを逆算可能。",
      scenarioId: 'PURCHASE_ONLY',
      structureHash: 'PURCH_${t.label}_C_FIX',
    );
  }

  // 9. Profit
  GeneratedProblem _genProfit() {
    LogicTheme t = _themesProfit[_rand.nextInt(_themesProfit.length)];
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}はいくらか。\n"
               "ア：92円の利益が得られた\n"
               "イ：定価で売った時に比べ168円利益が減った";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "イで定価が判明し、それをアの式に代入すれば仕入れ値が出る。",
      scenarioId: 'PROFIT',
      structureHash: 'PROFIT_${t.label}_C',
    );
  }

  // 10. Order
  GeneratedProblem _genOrder() {
    LogicTheme t = _themesOrder[_rand.nextInt(_themesOrder.length)];
    List<String> s = List.from(t.subjects)..shuffle(_rand);
    
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}は誰か。\n"
               "ア：${s[0]}の3人後に${s[4]}が${t.label == 'Dance' ? '踊った' : '呼ばれた'}\n"
               "イ：${s[1]}の3人後に${s[2]}が${t.label == 'Dance' ? '踊った' : '呼ばれた'}";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "C",
      explanation: "アとイを組み合わせると、順序が1通りに固定されるため。",
      scenarioId: 'ORDER',
      structureHash: 'ORDER_${t.label}_C_${s[0]}',
    );
  }

  // 11. Age Diff
  GeneratedProblem _genAgeDiff() {
    LogicTheme t = _themesAgeDiff[_rand.nextInt(_themesAgeDiff.length)];
    int sum = 50 + _rand.nextInt(10);
    String q = "${t.intro}${t.action}\n"
               "[問い] ${t.target}は何歳か。\n"
               "ア：現在の2人の年齢を足すと${sum}歳である\n"
               "イ：5年後に${t.subjects[0]}は${t.subjects[1]}の1.6倍になる";
    return GeneratedProblem(
      questionText: q,
      options: _conditionOptions,
      correctAnswer: "B",
      explanation: "アだけではどっちが年上か不明で定まらない。イなら比率から確定できる。",
      scenarioId: 'AGE_DIFF',
      structureHash: 'DIFF_${t.label}_B',
    );
  }
}
