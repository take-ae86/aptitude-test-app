import 'dart:math';

// =========================================================
// Speed Engine (For SPI)
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

class SpeedEngine {
  final Random _rand = Random();

  // 10 Scenarios
  static const List<String> _allScenarioIds = [
    'EX_1_WALK_AND_RUN',
    'EX_2_CATCH_UP',
    'EX_3_RIVER_UP',
    'PR_1_1_MEETING',
    'PR_1_2_LATE_DEPARTURE',
    'PR_1_3_WALK_RUN_TIME',
    'PR_2_1_ROUND_TRIP',
    'PR_2_2_TUNNEL',
    'PR_2_3_TRACK_DIFF',
    'PR_2_4_RIVER_DOWN',
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
      case 'EX_1_WALK_AND_RUN': return _genEx1WalkAndRun();
      case 'EX_2_CATCH_UP': return _genEx2CatchUp();
      case 'EX_3_RIVER_UP': return _genEx3RiverUp();
      case 'PR_1_1_MEETING': return _genPr1_1Meeting();
      case 'PR_1_2_LATE_DEPARTURE': return _genPr1_2LateDeparture();
      case 'PR_1_3_WALK_RUN_TIME': return _genPr1_3WalkRunTime();
      case 'PR_2_1_ROUND_TRIP': return _genPr2_1RoundTrip();
      case 'PR_2_2_TUNNEL': return _genPr2_2Tunnel();
      case 'PR_2_3_TRACK_DIFF': return _genPr2_3TrackDiff();
      case 'PR_2_4_RIVER_DOWN': return _genPr2_4RiverDown();
      default: return _genEx1WalkAndRun();
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
      double valA = double.tryParse(a.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      double valB = double.tryParse(b.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      return valA.compareTo(valB);
    });
    return list;
  }

  List<String> _makeDecimalOptions(double correct, {String unit = ""}) {
    Set<String> s = {};
    String correctStr = correct.toStringAsFixed(1);
    if (correctStr.endsWith('.0')) correctStr = correctStr.substring(0, correctStr.length - 2);
    s.add("$correctStr$unit");
    
    int safety = 0;
    while(s.length < 5) {
      safety++;
      if (safety > 50) {
        // Fallback
        double val = correct + 0.1;
        while (s.length < 5) {
          String str = val.toStringAsFixed(1);
          if (!s.contains("$str$unit")) s.add("$str$unit");
          val += 0.1;
        }
        break;
      }
      
      double diff = (1 + _rand.nextInt(20)) / 10; // 0.1 - 2.0
      if (_rand.nextBool()) diff = -diff;
      double val = correct + diff;
      if (val <= 0) continue;
      
      String strVal = val.toStringAsFixed(1);
      if (strVal.endsWith('.0')) strVal = strVal.substring(0, strVal.length - 2);
      s.add("$strVal$unit");
    }
    List<String> list = s.toList();
    list.sort((a, b) {
      double valA = double.tryParse(a.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      double valB = double.tryParse(b.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      return valA.compareTo(valB);
    });
    return list;
  }

  // 1. Ex1 Walk and Run (Pass Calculation)
  GeneratedProblem _genEx1WalkAndRun() {
    int v1 = 8; // km/h
    int v2 = 20; // km/h
    int timeH = 1; // 1 hour
    // Distance = 17km.
    // x/8 + (17-x)/20 = 1.
    // 5x + 2(17-x) = 40. 3x + 34 = 40. 3x=6. x=2.
    // Generate:
    // 3x = 40*v1/4 - 34.
    // Let's reverse.
    int x = 1 + _rand.nextInt(5); // 1-5km
    int dist = (x * 5 + 34) ~/ 2; // Rough calc? No.
    // Reconstruct:
    // x/v1 + (D-x)/v2 = T.
    // v2*x + v1*D - v1*x = T*v1*v2.
    // x(v2-v1) + v1*D = T*v1*v2.
    // D = (T*v1*v2 - x(v2-v1)) / v1.
    // Let T=1, v1=8, v2=20.
    // D = (160 - x(12)) / 8 = 20 - 1.5x.
    // If x=2, D = 20 - 3 = 17. Correct.
    // If x=4, D = 20 - 6 = 14.
    
    int totalDist = 20 - (x * 3) ~/ 2; // integer only if x is even logic?
    // Let's restrict x to even 2, 4, 6...
    x = (1 + _rand.nextInt(3)) * 2; // 2, 4, 6
    totalDist = 20 - (x * 3) ~/ 2;
    
    String q = "家から学校まで${totalDist}kmの道のりを行くのに、峠までは時速${v1}kmで自転車をこぎ、"
               "残りを時速${v2}kmでこいだところ、かかった時間は${timeH}時間だった。"
               "家から峠までの距離は□□kmである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(x, unit: "km"),
      correctAnswer: "${x}km",
      explanation: "峠までの距離をxとすると、\n"
                   "x/$v1 + (${totalDist}-x)/$v2 = $timeH\n"
                   "5x + 2(${totalDist}-x) = 40\n"
                   "3x = ${40 - 2*totalDist} → x = $x km。",
      scenarioId: 'EX_1_WALK_AND_RUN',
    );
  }

  // 2. Ex2 Catch Up
  GeneratedProblem _genEx2CatchUp() {
    int vQ = 70; // m/min
    int tWait = 10;
    int tChase = 18;
    // Q dist = 70 * 18 = 1260.
    // P time = 10 + 18 = 28.
    // P speed = 1260 / 28 = 45.
    
    // Generate tChase such that P speed is integer.
    // vQ * tChase / (tWait + tChase) = Integer.
    // Fix vQ=70, tWait=10.
    // 70 * t / (10+t) = Int.
    // t=18 -> 1260/28=45.
    // t=4 -> 280/14=20.
    // t=25 -> 1750/35=50.
    
    List<int> candidates = [4, 18, 25];
    tChase = candidates[_rand.nextInt(candidates.length)];
    int dist = vQ * tChase;
    int vP = dist ~/ (tWait + tChase);

    String q = "ある遊歩道をPが一定の速さで歩き始めてから${tWait}分後にQが${vQ}m/分の一定の速さ"
               "で追いかけたところ、Qは${tChase}分歩いたところでPに追いついた。このとき、Pの歩く"
               "速さは□□m/分だった。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(vP, unit: "m/分"),
      correctAnswer: "${vP}m/分",
      explanation: "Qが進んだ距離 = $vQ × $tChase = $dist m。\n"
                   "Pが進んだ時間 = $tWait + $tChase = ${tWait+tChase} 分。\n"
                   "Pの速さ = $dist ÷ ${tWait+tChase} = $vP m/分。",
      scenarioId: 'EX_2_CATCH_UP',
    );
  }

  // 3. Ex3 River Up
  GeneratedProblem _genEx3RiverUp() {
    // Boat 21.6 km/h -> 6 m/s.
    // River 2 m/s.
    // Up -> 4 m/s.
    // Time 60s. Dist 240m.
    
    int riverMs = 2;
    int timeS = 60;
    // Boat Km/h should convert to Integer m/s.
    // 21.6 -> 6. 18.0 -> 5. 25.2 -> 7.
    int boatMs = 5 + _rand.nextInt(4); // 5,6,7,8
    double boatKmh = boatMs * 3.6;
    
    int speedUp = boatMs - riverMs;
    int dist = speedUp * timeS;

    String q = "${boatKmh.toStringAsFixed(1)}km/時の速さで進むボートで川を上る。川が${riverMs}m/秒の速さで流れているとき、こ"
               "のボートは${timeS}秒間で□□m進む。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(dist, unit: "m"),
      correctAnswer: "${dist}m",
      explanation: "ボートの秒速 = ${boatKmh} ÷ 3.6 = ${boatMs}m/秒。\n"
                   "川を上る速さ = $boatMs - $riverMs = ${speedUp}m/秒。\n"
                   "距離 = $speedUp × $timeS = ${dist}m。",
      scenarioId: 'EX_3_RIVER_UP',
    );
  }

  // 4. Pr1-1 Meeting
  GeneratedProblem _genPr1_1Meeting() {
    int vWalk = 60;
    int vBike = 180;
    int late = 10;
    int early = 20; // Corrected to 20 based on formula logic (x-20)
    // 60(x+10) = 180(x-20).
    // x+10 = 3(x-20) = 3x - 60.
    // 2x = 70. x = 35.
    
    // Generalized:
    // vWalk(x+late) = vBike(x-early).
    // ratio = vBike/vWalk. (Assume integer, e.g. 3).
    // x+late = 3x - 3*early.
    // 2x = late + 3*early.
    // x = (late + 3*early)/2.
    
    // Choose early such that x is int.
    // late=10. 3*early must be even. early must be even.
    int eVal = (2 + _rand.nextInt(5)) * 2; // 4, 6... 20.
    // Avoid x becoming negative or too small.
    eVal += 10; 
    
    int x = (late + 3 * eVal) ~/ 2;

    String q = "家から市役所に向かう。${vWalk}m/分の速さで歩いていくと待ち合わせの時刻に${late}分遅れ"
               "るが、自転車に乗って${vBike}m/分の速さで行くと待ち合わせの時刻より${eVal}分早く着く。"
               "このとき、待ち合わせの時刻は今から□□分後である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(x, unit: "分後"),
      correctAnswer: "${x}分後",
      explanation: "待ち合わせまでx分とする。\n"
                   "$vWalk(x+$late) = $vBike(x-$eVal)\n"
                   "x+$late = 3x - ${3*eVal}\n"
                   "2x = ${late + 3*eVal} → x = $x 分後。",
      scenarioId: 'PR_1_1_MEETING',
    );
  }

  // 5. Pr1-2 Late Departure
  GeneratedProblem _genPr1_2LateDeparture() {
    double distKm = 3.4;
    int normalMin = 13;
    int lateMin = 5;
    // Remain 8 min.
    // Speed = 3.4 / (8/60) = 25.5 km/h.
    
    // Generate params
    // Time must be reduced.
    int nMin = 12 + _rand.nextInt(4); // 12-15
    int lMin = 2 + _rand.nextInt(3); // 2-4
    int rMin = nMin - lMin;
    // Dist such that speed is nice?
    // Speed = Dist * 60 / rMin.
    // Let Speed be .5 or .0
    double speed = (20 + _rand.nextInt(20)) / 2.0; // 10.0 - 20.0
    double distVal = speed * rMin / 60.0;
    // Format distVal nicely?
    // Let's fix Dist and calc Speed.
    double distFixed = 3.0 + _rand.nextInt(20)/10.0; // 3.0 - 5.0
    double speedCalc = distFixed * 60 / rMin;
    
    String ans = speedCalc.toStringAsFixed(1);
    if (ans.endsWith('.0')) ans = ans.substring(0, ans.length-2);

    String q = "家から駅の改札までは時速${(distFixed*60/nMin).toStringAsFixed(1)}km/時で歩いて${nMin}分かかる。"
               "家を出るのがいつもより${lMin}分遅れたとき、同じ時刻に駅の改札に着くためには時速□□km/時で向かえば"
               "よい（必要なときは、最後に小数点以下第2位を四捨五入すること）。";

    return GeneratedProblem(
      questionText: q,
      options: _makeDecimalOptions(double.parse(ans), unit: "km/時"),
      correctAnswer: "${ans}km/時",
      explanation: "距離 = ${(distFixed*60/nMin).toStringAsFixed(1)} × $nMin/60 ≒ $distFixed km。\n"
                   "残り時間 = $nMin - $lMin = $rMin 分。\n"
                   "時速 = $distFixed ÷ ($rMin/60) = $ans km/時。",
      scenarioId: 'PR_1_2_LATE_DEPARTURE',
    );
  }

  // 6. Pr1-3 Walk Run Time
  GeneratedProblem _genPr1_3WalkRunTime() {
    int vWalkKmh = 45; // 4.5 * 10
    int vRunKmh = 72; // 7.2 * 10
    // m/min: 4.5 -> 75. 7.2 -> 120.
    int vW = 75;
    int vR = 120;
    int totalTime = 36;
    int totalDist = 3600; // 3.6km
    
    // 120x + 75(36-x) = 3600.
    // 45x = 900. x=20.
    
    int ans = 20;

    String q = "家から${totalDist/1000}km離れた学校に行くのに、はじめは平均時速${vWalkKmh/10}km/時で歩いたが、途中"
               "から平均時速${vRunKmh/10}km/時で走ったので${totalTime}分かかった。このとき、走っていた時間は"
               "□□分である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "分"),
      correctAnswer: "${ans}分",
      explanation: "時速を分速に直すと、歩き${vW}m/分、走り${vR}m/分。\n"
                   "走った時間をx分とすると、\n"
                   "${vR}x + ${vW}($totalTime-x) = $totalDist\n"
                   "${vR-vW}x = ${totalDist - vW*totalTime}\n"
                   "45x = 900 → x = $ans 分。",
      scenarioId: 'PR_1_3_WALK_RUN_TIME',
    );
  }

  // 7. Pr2-1 Round Trip
  GeneratedProblem _genPr2_1RoundTrip() {
    double v1 = 9.5;
    double v2 = 3.8;
    int timeMin = 42; // 0.7h
    // x/9.5 + x/3.8 = 0.7.
    // x(1/9.5 + 2.5/9.5) = 0.7.
    // x(3.5/9.5) = 0.7.
    // x = 0.7 * 9.5 / 3.5 = 0.2 * 9.5 = 1.9.
    
    String ans = "1.9";

    String q = "家からプールまで行きは自転車に乗り、帰りは自転車を押して歩いた。行きは平"
               "均時速${v1}km/時で走り、帰りは平均時速${v2}km/時で歩いたので往復するのに${timeMin}分"
               "かかった。このとき、家からプールまでの距離は□□kmである。";

    return GeneratedProblem(
      questionText: q,
      options: _makeDecimalOptions(1.9, unit: "km"),
      correctAnswer: "${ans}km",
      explanation: "距離をxとすると x/$v1 + x/$v2 = $timeMin/60。\n"
                   "これを解くと x = $ans km。",
      scenarioId: 'PR_2_1_ROUND_TRIP',
    );
  }

  // 8. Pr2-2 Tunnel
  GeneratedProblem _genPr2_2Tunnel() {
    int speedKmh = 108; // 30m/s
    int tunnel = 1020;
    int train = 180;
    int speedMs = speedKmh * 1000 ~/ 3600; // 30
    int totalDist = tunnel + train;
    int ans = totalDist ~/ speedMs; // 40

    String q = "時速${speedKmh}km/時の特急電車がFトンネルを通過する。Fトンネルの長さは${tunnel}mで"
               "あり、電車の長さは${train}mである。この特急電車がFトンネルを通過するのに□□"
               "秒かかる。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(ans, unit: "秒"),
      correctAnswer: "${ans}秒",
      explanation: "時速${speedKmh}km = 秒速${speedMs}m。\n"
                   "進む距離 = $tunnel + $train = ${totalDist}m。\n"
                   "時間 = $totalDist ÷ $speedMs = $ans 秒。",
      scenarioId: 'PR_2_2_TUNNEL',
    );
  }

  // 9. Pr2-3 Track Diff
  GeneratedProblem _genPr2_3TrackDiff() {
    int lap = 400;
    int n = 12;
    int distK = 4800; // 4.8km
    
    // P time: 19m12s -> 19.2m -> 0.32h. Speed 15.
    // Q time: 16m -> 0.266h (4/15). Speed 18.
    
    int pM = 19, pS = 12;
    double pH = (pM + pS/60)/60;
    double pSpeed = (distK/1000) / pH;
    
    int qM = 16;
    double qH = qM/60;
    double qSpeed = (distK/1000) / qH;
    
    double diff = qSpeed - pSpeed;
    
    String ans = diff.toStringAsFixed(0); // 3

    String q = "1周${lap}mのトラックを${n}周するのにPは${pM}分${pS}秒、Qはちょうど${qM}分かかった。"
               "このとき、Qの平均時速はPの平均時速より□□km/時だけ速かった。";

    return GeneratedProblem(
      questionText: q,
      options: _makeOptions(int.parse(ans), unit: "km/時"),
      correctAnswer: "${ans}km/時",
      explanation: "総距離 ${distK/1000}km。\n"
                   "Pの時間 ${pH.toStringAsFixed(2)}時間 → 時速 ${pSpeed.toInt()}km。\n"
                   "Qの時間 ${qH.toStringAsFixed(3)}...時間 → 時速 ${qSpeed.toInt()}km。\n"
                   "差は $ans km/時。",
      scenarioId: 'PR_2_3_TRACK_DIFF',
    );
  }

  // 10. Pr2-4 River Down
  GeneratedProblem _genPr2_4RiverDown() {
    double flow = 1.5;
    int dist = 440;
    int time = 40;
    // Down speed = 11 m/s.
    // Boat speed = 11 - 1.5 = 9.5 m/s.
    // Kmh = 9.5 * 3.6 = 34.2.
    
    double downSpeed = dist / time;
    double boatMs = downSpeed - flow;
    double boatKmh = boatMs * 3.6;
    
    String ans = boatKmh.toStringAsFixed(1);

    String q = "${flow}m/秒の速さで流れている川をボートで下っている。${dist}m進むのに${time}秒かかっ"
               "たとき、ボート自体の速さは□□km/時である。";

    return GeneratedProblem(
      questionText: q,
      options: _makeDecimalOptions(boatKmh, unit: "km/時"),
      correctAnswer: "${ans}km/時",
      explanation: "下りの速さ = $dist ÷ $time = ${downSpeed}m/秒。\n"
                   "静水時の速さ = $downSpeed - $flow = ${boatMs}m/秒。\n"
                   "時速換算：$boatMs × 3.6 = $ans km/時。",
      scenarioId: 'PR_2_4_RIVER_DOWN',
    );
  }
}
