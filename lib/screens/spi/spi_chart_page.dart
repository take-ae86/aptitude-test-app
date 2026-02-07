import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../logic/chart_engine.dart';

class SpiChartPage extends StatefulWidget {
  const SpiChartPage({super.key});

  @override
  State<SpiChartPage> createState() => _SpiChartPageState();
}

class _SpiChartPageState extends State<SpiChartPage> {
  final ChartEngine _engine = ChartEngine();
  List<BigQuestion> _quizSet = [];
  bool _isLoading = true;
  int _currentBigIndex = 0; 
  int _currentSubIndex = 0; 
  final Map<String, String> _userAnswers = {};
  bool _isFinished = false;
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startQuiz();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_isFinished) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  Future<void> _startQuiz() async {
    setState(() => _isLoading = true);
    final set = await _engine.generateQuizSet();
    if (mounted) {
      setState(() {
        _quizSet = set;
        _isLoading = false;
        _currentBigIndex = 0;
        _currentSubIndex = 0;
        _userAnswers.clear();
        _isFinished = false;
      });
      _startTimer();
    }
  }

  void _handleOption(String option) {
    if (_isFinished) return;
    String key = "${_currentBigIndex}_$_currentSubIndex";
    setState(() {
      if (option.contains(' ')) {
        _userAnswers[key] = option.split(' ')[0];
      } else {
        _userAnswers[key] = option;
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_currentSubIndex == 0) {
        setState(() => _currentSubIndex = 1);
      } else {
        if (_currentBigIndex == 0) {
          setState(() {
            _currentBigIndex = 1;
            _currentSubIndex = 0;
          });
        } else {
          _finishQuiz();
        }
      }
    });
  }

  void _handleBack() {
    if (_isFinished) {
      Navigator.pop(context);
      return;
    }
    if (_currentSubIndex == 1) {
      setState(() => _currentSubIndex = 0);
    } else {
      if (_currentBigIndex == 1) {
        setState(() {
          _currentBigIndex = 0;
          _currentSubIndex = 1;
        });
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    setState(() => _isFinished = true);
  }

  String _formatTime(int sec) {
    return '${(sec ~/ 60).toString().padLeft(2,'0')}:${(sec % 60).toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 44,
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
          title: const Text('図表の読み取り', style: TextStyle(fontSize: 16)),
          actions: [
            if (!_isLoading)
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
                child: Text(_formatTime(_elapsedSeconds), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
              )
          ],
        ),
        body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : _isFinished ? _buildResultView() : _buildQuestionView(),
      ),
    );
  }

  Widget _buildQuestionView() {
    final bigQ = _quizSet[_currentBigIndex];
    final subQ = bigQ.subQuestions[_currentSubIndex];
    int totalQ = 4;
    int currentGlobalIndex = _currentBigIndex * 2 + _currentSubIndex;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (currentGlobalIndex + 1) / totalQ,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        
        // Flexible Chart Area (Flex 40)
        Expanded(
          flex: 40,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(bigQ.chartData.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                Expanded(
                  child: CustomPaint(
                    painter: _getPainter(bigQ.chartData, subQ),
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const Divider(height: 1, thickness: 1),

        // Flexible Question Area (Flex 60)
        Expanded(
          flex: 60,
          child: Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                  child: Text('問${_currentSubIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 11)),
                ),
                const SizedBox(height: 4),
                
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: Text(
                      subQ.questionText, 
                      style: const TextStyle(fontSize: 13, height: 1.3),
                      maxLines: 6, 
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Column(
                  children: subQ.options.map((opt) => _buildSingleButton(opt)).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleButton(String opt) {
    return Container(
      width: double.infinity,
      height: 48, 
      margin: const EdgeInsets.only(bottom: 6), 
      child: ElevatedButton(
        onPressed: () => _handleOption(opt),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8), 
          alignment: Alignment.centerLeft, 
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            opt, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }

  CustomPainter _getPainter(ChartData data, SubQuestion subQ) {
    switch (data.type) {
      case ChartType.meat:
        if (subQ.isGraphSelection && subQ.graphOptions != null) {
          return GraphOptionsPainter(subQ.graphOptions!, ['A','B','C','D','E']);
        }
        return TablePainter(data.data);
      case ChartType.transport:
        return PieChartPainter(data.data);
      case ChartType.land:
        return TablePainter(data.data, isLand: true);
      case ChartType.coffee:
        return TablePainter(data.data, isCoffee: true);
      case ChartType.export:
        return StackedBarPainter(data.data);
    }
  }

  Widget _buildResultView() {
    int correctCount = 0;
    int total = 4;
    for (int i=0; i<2; i++) {
      for (int j=0; j<2; j++) {
        String key = "${i}_$j";
        String uAns = _userAnswers[key] ?? "";
        String cAns = _quizSet[i].subQuestions[j].correctAnswer;
        if (cAns.contains(' ')) cAns = cAns.split(' ')[0];
        if (uAns == cAns) correctCount++;
      }
    }
    double percentage = (correctCount / total);
    int percentageInt = (percentage * 100).toInt();
    
    Color gaugeColor;
    if (percentageInt == 100) gaugeColor = Colors.purple;
    else if (percentageInt >= 75) gaugeColor = Colors.indigo;
    else if (percentageInt >= 50) gaugeColor = Colors.green;
    else if (percentageInt >= 25) gaugeColor = Colors.pink;
    else gaugeColor = Colors.red;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          if (percentageInt == 0)
                             const Icon(Icons.psychology_outlined, size: 100, color: Colors.grey)
                          else 
                             const Icon(Icons.psychology, size: 100, color: Color(0xFFEEEEEE)),
                          
                          if (percentageInt > 0)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: percentage,
                                  child: Icon(Icons.psychology, size: 100, color: gaugeColor),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('$percentageInt', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: percentageInt == 0 ? Colors.grey : gaugeColor)),
                            Text('%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: percentageInt == 0 ? Colors.grey : gaugeColor)),
                          ],
                        ),
                        const Text('正解率', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('$correctCount / $total 問正解', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('タイム: ${_formatTime(_elapsedSeconds)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                  onPressed: _startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('新しい問題に挑戦', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            itemCount: total,
            itemBuilder: (context, index) {
              int bigIdx = index ~/ 2;
              int subIdx = index % 2;
              final problem = _quizSet[bigIdx].subQuestions[subIdx];
              String key = "${bigIdx}_$subIdx";
              final userAnswer = _userAnswers[key] ?? "-";
              String correctAns = problem.correctAnswer;
              if (correctAns.contains(' ')) correctAns = correctAns.split(' ')[0];
              final isCorrect = userAnswer == correctAns;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 4),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ExpansionTile(
                  dense: true, 
                  visualDensity: VisualDensity.compact,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  title: Row(
                    children: [
                      Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text('問${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  subtitle: Text(isCorrect ? '正解' : '不正解', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 12),
                          Text(problem.questionText, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 6),
                          Text('正解: ${problem.correctAnswer}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                          const SizedBox(height: 6),
                          Text(problem.explanation, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =========================================================
// Custom Painters
// =========================================================

class TablePainter extends CustomPainter {
  final Map<String, dynamic> data;
  final bool isLand;
  final bool isCoffee;

  TablePainter(this.data, {this.isLand = false, this.isCoffee = false});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final textStyle = const TextStyle(color: Colors.black, fontSize: 13);
    final headerStyle = const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold);

    double w = size.width;
    double h = size.height;
    
    if (isLand) {
      _drawLandTable(canvas, w, h, linePaint, textStyle, headerStyle);
    } else if (isCoffee) {
      _drawCoffeeTable(canvas, w, h, linePaint, textStyle, headerStyle);
    } else {
      _drawMeatTable(canvas, w, h, linePaint, textStyle, headerStyle);
    }
  }

  void _drawMeatTable(Canvas canvas, double w, double h, Paint linePaint, TextStyle body, TextStyle head) {
    double rowH = h / 5.5; 
    double colW = w / 5;
    List<String> rows = ["", "合計(kg)", "鶏肉(%)", "豚肉(%)", "牛肉(%)"];
    List<String> cols = ["", "P", "Q", "R", "S"];
    Map<String, double> totals = data['totals'];
    Map<String, Map<String, double>> ratios = data['ratios'];

    for (int r=0; r<=5; r++) canvas.drawLine(Offset(0, r*rowH), Offset(w, r*rowH), linePaint);
    for (int c=0; c<=5; c++) canvas.drawLine(Offset(c*colW, 0), Offset(c*colW, 5*rowH), linePaint);

    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < 5; c++) {
        Rect rect = Rect.fromLTWH(c * colW, r * rowH, colW, rowH);
        String text = "";
        if (r == 0) text = cols[c];
        else if (c == 0) text = rows[r];
        else {
          String country = cols[c];
          if (r == 1) text = totals[country]!.toStringAsFixed(1);
          if (r == 2) text = ratios[country]!['鶏肉']!.toStringAsFixed(1);
          if (r == 3) text = ratios[country]!['豚肉']!.toStringAsFixed(1);
          if (r == 4) text = ratios[country]!['牛肉']!.toStringAsFixed(1);
        }
        _drawText(canvas, text, rect, (r==0||c==0) ? head : body);
      }
    }
  }

  void _drawLandTable(Canvas canvas, double w, double h, Paint linePaint, TextStyle body, TextStyle head) {
    double rowH = h / 3.5;
    double colW = w / 5;
    List<String> rows = ["", "田(千ha)", "畑(千ha)"];
    List<String> cols = ["", "P", "Q", "R", "S"];
    Map<String, int> rice = data['rice'];
    Map<String, int> field = data['field'];

    for (int r=0; r<=3; r++) canvas.drawLine(Offset(0, r*rowH), Offset(w, r*rowH), linePaint);
    for (int c=0; c<=5; c++) canvas.drawLine(Offset(c*colW, 0), Offset(c*colW, 3*rowH), linePaint);

    for (int r=0; r<3; r++) {
      for (int c=0; c<5; c++) {
        Rect rect = Rect.fromLTWH(c*colW, r*rowH, colW, rowH);
        String text = "";
        if (r==0) text = cols[c];
        else if (c==0) text = rows[r];
        else {
          String area = cols[c];
          if (r==1) text = rice[area].toString();
          if (r==2) text = field[area].toString();
        }
        _drawText(canvas, text, rect, (r==0||c==0)?head:body);
      }
    }
  }

  void _drawCoffeeTable(Canvas canvas, double w, double h, Paint linePaint, TextStyle body, TextStyle head) {
    double colW = w / 4;
    double rowH = h / 7.5;
    List<String> headers = ["", "3年目", "4年目", "5年目"];
    List<String> rowLabels = ["売上(万)", "前年比", "客数(千)", "前年比", "単価(円)", "前年比"];
    
    for (int r=0; r<=7; r++) canvas.drawLine(Offset(0, r*rowH), Offset(w, r*rowH), linePaint);
    for (int c=0; c<=4; c++) canvas.drawLine(Offset(c*colW, 0), Offset(c*colW, 7*rowH), linePaint);

    for (int r=0; r<7; r++) { 
      for (int c=0; c<4; c++) {
        Rect rect = Rect.fromLTWH(c*colW, r*rowH, colW, rowH);
        String text = "";
        if (r==0) text = headers[c];
        else if (c==0) text = rowLabels[r-1];
        else {
          int yrIdx = c; 
          if (r==1) { 
             if (yrIdx==1) text = (data['s3'] as double).toStringAsFixed(0);
             if (yrIdx==2) text = (data['s4'] as double).toStringAsFixed(0);
             if (yrIdx==3) text = "□"; 
          }
          if (r==2) { 
             if (yrIdx==1) text = "${(data['s3Prev']*100).toInt()}%";
             if (yrIdx==2) text = "${(data['s4Rate']*100).toInt()}%";
             if (yrIdx==3) text = "${(data['s5Rate']*100).toInt()}%";
          }
          if (r==3) { 
             if (yrIdx==1) text = (data['v3'] as double).toStringAsFixed(0);
             if (yrIdx==2) text = (data['v4'] as double).toStringAsFixed(0);
             if (yrIdx==3) text = (data['v5'] as double).toStringAsFixed(0);
          }
          if (r==4) { 
             if (yrIdx==1) text = "-";
             if (yrIdx==2) text = "${(data['v4Rate']*100).toInt()}%";
             if (yrIdx==3) text = "${(data['v5Rate']*100).toInt()}%";
          }
          if (r==5) { 
             if (yrIdx==1) text = (data['u3'] as double).toStringAsFixed(0);
             if (yrIdx==2) text = (data['u4'] as double).toStringAsFixed(0);
             if (yrIdx==3) text = "□";
          }
          if (r==6) { 
             if (yrIdx==1) text = "-";
             if (yrIdx==2) text = "${(data['u4Rate']*100).toInt()}%";
             if (yrIdx==3) text = "${(data['u5Rate']*100).toInt()}%";
          }
        }
        _drawText(canvas, text, rect, (r==0||c==0)?head:body);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Rect rect, TextStyle style) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout(minWidth: rect.width, maxWidth: rect.width);
    tp.paint(canvas, Offset(rect.left, rect.top + (rect.height - tp.height)/2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PieChartPainter extends CustomPainter {
  final Map<String, dynamic> data;
  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    double r = size.shortestSide * 0.28; 
    
    Offset c1 = Offset(w * 0.28, h * 0.5); 
    Offset c2 = Offset(w * 0.72, h * 0.5);
    
    _drawPie(canvas, c1, r, data['ratios1'], data['year1'], data['total1']);
    _drawPie(canvas, c2, r, data['ratios2'], data['year2'], data['total2']);
  }

  void _drawPie(Canvas canvas, Offset c, double r, Map<String, double> ratios, int year, int total) {
    List<Color> colors = [Colors.grey[400]!, Colors.grey[500]!, Colors.grey[600]!, Colors.grey[700]!];
    
    double start = -pi/2;
    int i = 0;
    
    ratios.forEach((key, val) {
      double sweep = 2 * pi * (val / 100);
      Paint p = Paint()..color = colors[i % colors.length]..style = PaintingStyle.fill;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, true, p);
      Paint border = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.0;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, true, border);
      start += sweep;
      i++;
    });
    
    Paint holeP = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(c, r * 0.45, holeP);
    
    _drawText(canvas, "$year年\n$total\n億人キロ", c, bold: true, fontSize: 9);

    start = -pi/2;
    i = 0;
    ratios.forEach((key, val) {
      double sweep = 2 * pi * (val / 100);
      double mid = start + sweep/2;
      
      bool isLarge = val >= 10.0;
      
      if (isLarge) {
        double innerR = r * 0.7;
        double lx = c.dx + innerR * cos(mid);
        double ly = c.dy + innerR * sin(mid);
        _drawText(canvas, "$key\n$val%", Offset(lx, ly), color: Colors.black, fontSize: 9);
      } else {
        double lineLen = 15.0;
        double hLen = 20.0;
        double angle;
        bool goRight;

        if (key == '航空') {
           angle = -pi/2 + (30 * pi / 180); 
           goRight = true;
        } else if (key == '旅客船') {
           angle = -pi/2 - (10 * pi / 180); // -100度 (Revised)
           goRight = false;
           
           // Extremely short
           lineLen = 2.0; 
           hLen = 5.0;
        } else {
           angle = mid;
           goRight = cos(mid) >= 0;
        }

        double edgeX = c.dx + r * cos(mid);
        double edgeY = c.dy + r * sin(mid);

        double elbowX = edgeX + lineLen * cos(angle);
        double elbowY = edgeY + lineLen * sin(angle);

        if (key == '航空') {
           elbowY -= 5; 
           elbowX += 2;
        }

        Paint lineP = Paint()..color=Colors.black..strokeWidth=1.0;
        canvas.drawLine(Offset(edgeX, edgeY), Offset(elbowX, elbowY), lineP);

        double endX = goRight ? elbowX + hLen : elbowX - hLen; 
        canvas.drawLine(Offset(elbowX, elbowY), Offset(endX, elbowY), lineP);

        _drawText(canvas, "$key\n$val%", Offset(goRight ? endX + 2 : endX - 2, elbowY), 
          color: Colors.black, 
          fontSize: 11, 
          alignLeft: goRight, 
          alignRight: !goRight
        );
      }
      
      start += sweep;
      i++;
    });
  }

  void _drawText(Canvas canvas, String text, Offset center, {bool bold=false, Color color=Colors.black, bool alignLeft=false, bool alignRight=false, double fontSize=10}) {
    final span = TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: bold?FontWeight.bold:FontWeight.normal)); 
    final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    
    double dx = center.dx - tp.width/2;
    double dy = center.dy - tp.height/2;
    
    if (alignLeft) dx = center.dx; // centerが左端(右に描画)
    if (alignRight) dx = center.dx - tp.width; // centerが右端(左に描画)
    
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StackedBarPainter extends CustomPainter {
  final Map<String, dynamic> data;
  StackedBarPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    double bottom = h - 30;
    double left = 40;
    
    Paint lineP = Paint()..color = Colors.black..strokeWidth = 1;
    canvas.drawLine(Offset(left, 10), Offset(left, bottom), lineP);
    canvas.drawLine(Offset(left, bottom), Offset(w-10, bottom), lineP);
    
    List<int> years = data['years'];
    List<String> cats = data['cats'];
    Map<int, Map<String, int>> values = data['values'];
    
    double chartW = w - left - 20; 
    double spacing = chartW / years.length;
    double barW = spacing * 0.6; 
    
    double maxVal = 0;
    for(var y in years) {
      double sum = 0;
      values[y]!.forEach((k,v) => sum += v);
      if (sum > maxVal) maxVal = sum;
    }
    double scale = (bottom - 20) / maxVal;
    
    List<Color> colors = [Colors.grey[800]!, Colors.grey[600]!, Colors.grey[400]!];

    for (int i=0; i<years.length; i++) {
      int y = years[i];
      double cx = left + (i * spacing) + (spacing/2);
      double currentY = bottom;
      
      int ci = 0;
      for (var cat in cats) {
        int v = values[y]![cat]!;
        double hBar = v * scale;
        
        Paint p = Paint()..color = colors[ci];
        Rect r = Rect.fromLTWH(cx - barW/2, currentY - hBar, barW, hBar);
        canvas.drawRect(r, p);
        
        Paint border = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.0;
        canvas.drawRect(r, border);
        
        if (hBar > 15) {
           _drawText(canvas, v.toString(), Offset(cx, currentY - hBar/2), color: Colors.white);
        }
        currentY -= hBar;
        ci++;
      }
      _drawText(canvas, y.toString(), Offset(cx, bottom + 15));
    }
    
    for(int i=0; i<cats.length; i++) {
      double lx = left + i * 80;
      double ly = 0;
      Paint p = Paint()..color = colors[i];
      canvas.drawRect(Rect.fromLTWH(lx, ly, 10, 10), p);
      _drawText(canvas, cats[i], Offset(lx + 35, ly + 5));
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, {Color color = Colors.black}) {
    final span = TextSpan(text: text, style: TextStyle(color: color, fontSize: 11));
    final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GraphOptionsPainter extends CustomPainter {
  final List<List<double>> options;
  final List<String> labels;
  
  GraphOptionsPainter(this.options, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width / 3; 
    double h = size.height / 2;
    
    for (int i=0; i<5; i++) {
      double ox = (i % 3) * w;
      double oy = (i ~/ 3) * h;
      _drawMiniChart(canvas, Offset(ox, oy), Size(w, h), options[i], labels[i]);
    }
  }

  void _drawMiniChart(Canvas canvas, Offset offset, Size size, List<double> vals, String label) {
    TextPainter(text: TextSpan(text: label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)
      ..layout()..paint(canvas, Offset(offset.dx + 5, offset.dy));
      
    double bottom = offset.dy + size.height - 15;
    double left = offset.dx + 15;
    double gw = size.width - 20;
    double gh = size.height - 30;
    double maxV = 50; 
    double scale = gh / maxV;
    double barW = gw / 4 / 2;
    
    Paint p = Paint()..color = Colors.grey[700]!;
    for(int j=0; j<4; j++) {
      double val = vals[j];
      double bh = val * scale;
      if (bh > gh) bh = gh;
      canvas.drawRect(Rect.fromLTWH(left + j*(barW*2) + 5, bottom - bh, barW, bh), p);
    }
    canvas.drawLine(Offset(left, bottom), Offset(left + gw, bottom), Paint()..color=Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
