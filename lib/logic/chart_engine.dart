import 'dart:math';

// =========================================================
// Chart Logic Engine
// =========================================================

enum ChartType { meat, transport, land, coffee, export }

class ChartData {
  final ChartType type;
  final String title;
  final Map<String, dynamic> data; 

  ChartData({required this.type, required this.title, required this.data});
}

class SubQuestion {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final bool isGraphSelection; 
  final List<List<double>>? graphOptions;

  SubQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.isGraphSelection = false,
    this.graphOptions,
  });
}

class BigQuestion {
  final ChartData chartData;
  final List<SubQuestion> subQuestions;

  BigQuestion({required this.chartData, required this.subQuestions});
}

class ChartEngine {
  final Random _rand = Random();

  Future<List<BigQuestion>> generateQuizSet() async {
    List<ChartType> types = ChartType.values.toList()..shuffle(_rand);
    List<ChartType> selected = types.take(2).toList();
    
    List<BigQuestion> quizSet = [];
    for (var type in selected) {
      quizSet.add(_generateBigQuestion(type));
    }
    return quizSet;
  }

  BigQuestion _generateBigQuestion(ChartType type) {
    switch (type) {
      case ChartType.meat: return _genMeatScenario();
      case ChartType.transport: return _genTransportScenario();
      case ChartType.land: return _genLandScenario();
      case ChartType.coffee: return _genCoffeeScenario();
      case ChartType.export: return _genExportScenario();
    }
  }

  // 1. Meat
  BigQuestion _genMeatScenario() {
    List<String> countries = ['P', 'Q', 'R', 'S'];
    Map<String, double> totals = {};
    for (var c in countries) {
      totals[c] = (60 + _rand.nextInt(70)) + (_rand.nextInt(10) / 10);
    }

    Map<String, Map<String, double>> ratios = {};
    for (var c in countries) {
      int chick, pork, beef;
      if (c == 'Q') {
        chick = 50 + _rand.nextInt(10);
        pork = 15 + _rand.nextInt(10);
      } else {
        pork = 40 + _rand.nextInt(15);
        chick = 20 + _rand.nextInt(10);
      }
      beef = 100 - chick - pork;
      ratios[c] = {'鶏肉': chick.toDouble(), '豚肉': pork.toDouble(), '牛肉': beef.toDouble()};
    }

    double qChick = ratios['Q']!['鶏肉']!;
    double qPork = ratios['Q']!['豚肉']!;
    double ans1Val = qChick / qPork;
    String ans1 = ans1Val.toStringAsFixed(1);

    List<double> beefRealValues = [];
    for (var c in countries) {
      beefRealValues.add(totals[c]! * (ratios[c]!['牛肉']! / 100));
    }
    List<List<double>> graphOpts = [];
    int correctIndex = _rand.nextInt(5); 
    
    for (int i = 0; i < 5; i++) {
      if (i == correctIndex) {
        graphOpts.add(List.from(beefRealValues));
      } else {
        List<double> dummy = List.from(beefRealValues)..shuffle(_rand);
        if (dummy.toString() == beefRealValues.toString()) {
           dummy[0] = dummy[0] * 0.5;
        }
        graphOpts.add(dummy);
      }
    }
    String ans2 = String.fromCharCode(65 + correctIndex);

    return BigQuestion(
      chartData: ChartData(
        type: ChartType.meat,
        title: "4ヵ国の食肉供給量",
        data: {
          'countries': countries,
          'totals': totals,
          'ratios': ratios,
        },
      ),
      subQuestions: [
        SubQuestion(
          questionText: "1. 豚肉より鶏肉の供給量が上回っている国では、鶏肉は豚肉の約 □ 倍供給されている（必要なときは、最後に小数点以下第2位を四捨五入すること）。",
          options: _generateNumericOptions(ans1, step: 0.1),
          correctAnswer: ans1,
          explanation: "豚肉より鶏肉が多いのはQ国のみ。\n${qChick.toStringAsFixed(1)}% ÷ ${qPork.toStringAsFixed(1)}% = $ans1 倍。",
        ),
        SubQuestion(
          questionText: "2. 各国の牛肉の供給量を表したグラフは、次のAからEのうちどれに最も近いか。",
          options: ['A', 'B', 'C', 'D', 'E'],
          correctAnswer: ans2,
          explanation: "各国の合計供給量に牛肉の割合を掛けて計算し、比較します。",
          isGraphSelection: true,
          graphOptions: graphOpts,
        ),
      ],
    );
  }

  // 2. Transport
  BigQuestion _genTransportScenario() {
    int year1 = 1970 + _rand.nextInt(5);
    int year2 = 2005 + _rand.nextInt(5);
    int total1 = 3000 + _rand.nextInt(500);
    int total2 = 13000 + _rand.nextInt(1000);

    Map<String, double> r1 = {
      '鉄道': 60.0 + _rand.nextInt(5),
      '自動車': 35.0 + _rand.nextInt(3),
      '旅客船': 1.0 + _rand.nextDouble(),
      '航空': 0.5 + _rand.nextDouble(),
    };
    double sum1 = r1.values.reduce((a,b)=>a+b);
    r1.forEach((k,v) => r1[k] = double.parse((v/sum1*100).toStringAsFixed(1)));

    Map<String, double> r2 = {
      '鉄道': 30.0 + _rand.nextInt(5),
      '自動車': 55.0 + _rand.nextInt(5),
      '旅客船': 0.5 + _rand.nextDouble(),
      '航空': 5.0 + _rand.nextInt(3),
    };
    double sum2 = r2.values.reduce((a,b)=>a+b);
    r2.forEach((k,v) => r2[k] = double.parse((v/sum2*100).toStringAsFixed(1)));

    double q1Val = total1 * (r1['鉄道']! / 100);
    String ans1 = q1Val.round().toString();

    double ship1 = total1 * (r1['旅客船']!/100);
    double ship2 = total2 * (r2['旅客船']!/100);
    bool isShipDecreased = ship2 < ship1;

    double air1 = total1 * (r1['航空']!/100);
    double air2 = total2 * (r2['航空']!/100);
    bool isAir25x = air2 >= (air1 * 25);

    double rail2 = total2 * (r2['鉄道']!/100);
    double car1 = total1 * (r1['自動車']!/100);
    bool isSame = (rail2 - car1).abs() < 50;

    return BigQuestion(
      chartData: ChartData(
        type: ChartType.transport,
        title: "旅客輸送量と内訳",
        data: {
          'year1': year1, 'total1': total1, 'ratios1': r1,
          'year2': year2, 'total2': total2, 'ratios2': r2,
        },
      ),
      subQuestions: [
        SubQuestion(
          questionText: "1. $year1年の鉄道による旅客輸送量は約 □ 億人キロである（小数点以下四捨五入）。",
          options: _generateNumericOptions(ans1, range: 50),
          correctAnswer: ans1,
          explanation: "$total1 × ${r1['鉄道']}% ÷ 100 = ${q1Val.toStringAsFixed(1)} ≒ $ans1",
        ),
        SubQuestion(
          // HERE: Horizontal Layout (Space separated)
          questionText: "2. 次のア、イ、ウのうち正しいものはどれか。\nア 旅客船による輸送量は減っている  /  イ 航空による輸送量は25倍以上である  /  ウ ${year2}年の鉄道と${year1}年の自動車は同じである",
          options: ['アだけ', 'イだけ', 'ウだけ', 'アとウ', 'イとウ'],
          correctAnswer: _determineSetAnswer(isShipDecreased, isAir25x, isSame),
          explanation: "ア: $ship1→$ship2 (${isShipDecreased?'正':'誤'})\nイ: $air1→$air2 (${isAir25x?'正':'誤'})\nウ: $rail2 vs $car1 (${isSame?'正':'誤'})",
        ),
      ],
    );
  }

  // 3. Land
  BigQuestion _genLandScenario() {
    List<String> areas = ['P', 'Q', 'R', 'S'];
    Map<String, int> rice = {};
    Map<String, int> field = {};
    for (var a in areas) {
      rice[a] = 30 + _rand.nextInt(800);
      field[a] = 100 + _rand.nextInt(400);
    }
    int totalRiceSample = rice.values.reduce((a,b)=>a+b);
    int nationRiceTotal = totalRiceSample + 1000 + _rand.nextInt(500);

    double q1Val = (totalRiceSample / nationRiceTotal) * 100;
    String ans1 = q1Val.toStringAsFixed(0);

    List<MapEntry<String, double>> ratios = [];
    for (var a in areas) {
      double r = field[a]! / (rice[a]! + field[a]!);
      ratios.add(MapEntry(a, r));
    }
    ratios.sort((a, b) => b.value.compareTo(a.value));
    String order = ratios.map((e) => e.key).join(", ");
    
    List<String> q2Opts = [order];
    while (q2Opts.length < 5) {
      List<String> dummy = List.from(areas)..shuffle(_rand);
      String dStr = dummy.join(", ");
      if (!q2Opts.contains(dStr)) q2Opts.add(dStr);
    }
    q2Opts.sort();

    return BigQuestion(
      chartData: ChartData(
        type: ChartType.land,
        title: "地域別耕地面積",
        data: {
          'areas': areas,
          'rice': rice,
          'field': field,
          'nationTotal': nationRiceTotal,
        },
      ),
      subQuestions: [
        SubQuestion(
          questionText: "1. この年の全国の田面積合計は${nationRiceTotal}千haだった。4地域の田面積合計の割合は約 □ %である（小数点以下四捨五入）。",
          options: _generateNumericOptions(ans1, range: 5),
          correctAnswer: ans1,
          explanation: "4地域の合計: $totalRiceSample\n$totalRiceSample ÷ $nationRiceTotal × 100 = ${q1Val.toStringAsFixed(1)}...",
        ),
        SubQuestion(
          questionText: "2. 田畑合計面積に占める畑面積の割合が大きい順に並べたものはどれか。",
          options: q2Opts,
          correctAnswer: order,
          explanation: "各地域の「畑÷(田+畑)」を計算して比較します。",
        ),
      ],
    );
  }

  // 4. Coffee
  BigQuestion _genCoffeeScenario() {
    double v3 = 200 + _rand.nextInt(50).toDouble();
    double u3 = 600 + _rand.nextInt(200).toDouble();
    double s3 = v3 * u3 / 10; 

    double s4Rate = 1.1 + (_rand.nextInt(20)/100);
    double v4Rate = 1.0 + (_rand.nextInt(20)/100);
    double s4 = s3 * s4Rate;
    double v4 = v3 * v4Rate;
    double u4 = (s4 / v4) * 10;
    double u4Rate = u4 / u3;

    double s5Rate = 1.1 + (_rand.nextInt(20)/100);
    double v5Rate = 1.1 + (_rand.nextInt(20)/100);
    double s5 = s4 * s5Rate;
    double v5 = v4 * v5Rate;
    double u5 = (s5 / v5) * 10;
    double u5Rate = u5 / u4;

    double s3PrevRate = 1.5 + (_rand.nextInt(30)/100);
    double s2 = s3 / s3PrevRate;
    String ans1 = s2.toStringAsFixed(0);

    bool isUnitUp = u5 > u3;
    double growth3to5 = (s5 / s3) - 1.0;
    double totalV = v3 + v4 + v5;
    double v3Share = v3 / totalV;
    bool isShareOver25 = v3Share >= 0.25;

    return BigQuestion(
      chartData: ChartData(
        type: ChartType.coffee,
        title: "喫茶店チェーンの売上",
        data: {
          's3': s3, 's4': s4, 's5': s5, 's3Prev': s3PrevRate, 's4Rate': s4Rate, 's5Rate': s5Rate,
          'v3': v3, 'v4': v4, 'v5': v5, 'v3Rate': 1.0, 'v4Rate': v4Rate, 'v5Rate': v5Rate,
          'u3': u3, 'u4': u4, 'u5': u5, 'u3Rate': 1.0, 'u4Rate': u4Rate, 'u5Rate': u5Rate,
        },
      ),
      subQuestions: [
        SubQuestion(
          questionText: "1. このチェーンの2年目の売上高は約 □ 万円である（3年目の売上高前年比は${(s3PrevRate*100).toInt()}%とする。小数点以下四捨五入）。",
          options: _generateNumericOptions(ans1, range: 100),
          correctAnswer: ans1,
          explanation: "3年目売上(${s3.toInt()}) ÷ $s3PrevRate = $ans1",
        ),
        SubQuestion(
          // HERE: Horizontal Layout
          questionText: "2. 正しい記述の組み合わせを選べ。\nア 5年目の客単価は3年目より高い  /  イ 5年目の3年目に対する売上増加率は${(growth3to5*100 + 5).toInt()}%である  /  ウ 3年目の客数は3年間の合計の25%以上である",
          options: ['アだけ', 'B イだけ', 'C ウだけ', 'D アとウ', 'E イとウ'],
          correctAnswer: _determineSetAnswer(isUnitUp, false, isShareOver25),
          explanation: "ア: $isUnitUp\nイ: 実際は${(growth3to5*100).toStringAsFixed(1)}%なので誤\nウ: ${(v3Share*100).toStringAsFixed(1)}%なので$isShareOver25",
        ),
      ],
    );
  }

  // 5. Export
  BigQuestion _genExportScenario() {
    List<int> years = [2020, 2021, 2022];
    List<String> cats = ['自動車', '電子機器', '化学製品'];
    Map<int, Map<String, int>> data = {};
    for (var y in years) {
      data[y] = {
        '自動車': 100 + _rand.nextInt(50) + (y-2020)*20,
        '電子機器': 80 + _rand.nextInt(40),
        '化学製品': 50 + _rand.nextInt(30) + (y-2020)*10,
      };
    }

    int q1Ans = data[2021]!['電子機器']!;
    
    double val20 = data[2020]!['化学製品']!.toDouble();
    double val22 = data[2022]!['化学製品']!.toDouble();
    double rate = val22 / val20;
    String ans2 = rate.toStringAsFixed(1);

    return BigQuestion(
      chartData: ChartData(
        type: ChartType.export,
        title: "製品別輸出額の推移",
        data: {
          'years': years,
          'cats': cats,
          'values': data,
        },
      ),
      subQuestions: [
        SubQuestion(
          questionText: "1. 2021年の電子機器の輸出額は □ 億ドルである。",
          options: _generateNumericOptions(q1Ans.toString(), range: 10),
          correctAnswer: q1Ans.toString(),
          explanation: "グラフから読み取ります: $q1Ans",
        ),
        SubQuestion(
          questionText: "2. 2022年の化学製品の輸出額は、2020年の約 □ 倍である（小数第2位四捨五入）。",
          options: _generateNumericOptions(ans2, step: 0.1),
          correctAnswer: ans2,
          explanation: "$val22 ÷ $val20 = $rate",
        ),
      ],
    );
  }

  List<String> _generateNumericOptions(String correct, {double step = 1, int range = 5}) {
    Set<String> opts = {correct};
    double correctVal = double.parse(correct);
    bool isInt = !correct.contains('.');

    int safety = 0;
    while(opts.length < 5 && safety < 20) {
      safety++;
      double diff = (step * (_rand.nextInt(range) + 1)) * (_rand.nextBool() ? 1 : -1);
      double val = correctVal + diff;
      if (val < 0) continue;
      
      String strVal = isInt ? val.toInt().toString() : val.toStringAsFixed(1);
      opts.add(strVal);
    }
    List<String> res = opts.toList();
    res.sort((a,b) => double.parse(a).compareTo(double.parse(b)));
    return res;
  }

  String _determineSetAnswer(bool a, bool b, bool c) {
    List<String> trues = [];
    if(a) trues.add('ア');
    if(b) trues.add('イ');
    if(c) trues.add('ウ');
    
    if (trues.length == 1) {
      if (trues.contains('ア')) return 'アだけ';
      if (trues.contains('イ')) return 'イだけ';
      if (trues.contains('ウ')) return 'ウだけ';
    } else if (trues.length == 2) {
      if (trues.contains('ア') && trues.contains('ウ')) return 'アとウ';
      if (trues.contains('イ') && trues.contains('ウ')) return 'イとウ';
      if (trues.contains('ア') && trues.contains('イ')) return 'アとイ'; 
      return 'アとウ'; 
    }
    return 'ウだけ'; 
  }
}
