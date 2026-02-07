import 'dart:async';
import 'package:flutter/material.dart';
import '../../logic/fill_in_engine.dart';

class SpiFillInPage extends StatefulWidget {
  const SpiFillInPage({super.key});

  @override
  State<SpiFillInPage> createState() => _SpiFillInPageState();
}

class _SpiFillInPageState extends State<SpiFillInPage> {
  final FillInEngine _engine = FillInEngine();
  List<FillInProblem> _problems = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  List<String?> _userAnswers = [];
  bool _isFinished = false;
  Timer? _timer;
  int _elapsedSeconds = 0;

  // For MultiBlank: Store options (Correct + Wrongs)
  List<List<OptionSet>> _multiOptionsList = [];

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
    setState(() {
      _isLoading = true;
      _isFinished = false;
      _currentIndex = 0;
      _userAnswers = [];
      _multiOptionsList = [];
    });

    try {
      final problems = await _engine.generateProblems(5);
      
      List<List<OptionSet>> multiOptions = [];
      for (var p in problems) {
        if (p.type == FillInType.multiBlank) {
          List<OptionSet> options = [];
          // 正解
          List<String> correct = p.correctAnswer as List<String>;
          options.add(OptionSet(answers: correct, isCorrect: true, label: ""));
          
          // 誤答
          List<List<String>> wrongs = _engine.generateWrongOptionsMulti(correct, 4);
          for (var w in wrongs) {
            options.add(OptionSet(answers: w, isCorrect: false, label: ""));
          }
          options.shuffle();
          
          List<String> labels = ["ア", "イ", "ウ", "エ", "オ"];
          for (int i = 0; i < options.length; i++) {
            options[i].label = labels[i];
          }
          multiOptions.add(options);
        } else {
          // Single blank doesn't need complex option sets, just placeholders
          multiOptions.add([]);
        }
      }

      if (mounted) {
        setState(() {
          _problems = problems;
          _multiOptionsList = multiOptions;
          _userAnswers = List.filled(problems.length, null);
          _isLoading = false;
        });
        _startTimer();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handleOptionSelected(String selectedValue) {
    if (_isFinished) return;
    setState(() {
      _userAnswers[_currentIndex] = selectedValue;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        if (_currentIndex < _problems.length - 1) {
          setState(() {
            _currentIndex++;
          });
        } else {
          _finishQuiz();
        }
      }
    });
  }

  void _finishQuiz() {
    _timer?.cancel();
    setState(() {
      _isFinished = true;
    });
  }
  
  void _handleBack() {
    if (_currentIndex > 0 && !_isFinished) {
      setState(() {
        _currentIndex--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatOrderString(List<String> order) {
    // ["B", "C", "A"] -> "アB イC ウA"
    List<String> slots = ["ア", "イ", "ウ"];
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < order.length; i++) {
      if (i < slots.length) {
        sb.write("${slots[i]}${order[i]} ");
      }
    }
    return sb.toString().trim();
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
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          toolbarHeight: 44,
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
          title: const Text('空欄補充（適文・適語）', style: TextStyle(fontSize: 16)),
          actions: [
            if (!_isLoading)
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(_formatTime(_elapsedSeconds), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isFinished
                ? _buildResultView()
                : _buildQuestionView(),
      ),
    );
  }

  Widget _buildQuestionView() {
    final problem = _problems[_currentIndex];
    
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _problems.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12), // 16 -> 12
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // 6 -> 4
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                  child: Text('第${_currentIndex + 1}問', style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold, fontSize: 13)), // 14 -> 13
                ),
                const SizedBox(height: 8), // 12 -> 8
                
                // 問題文
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[300]!)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0), // 12 -> 10
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.type == FillInType.singleBlank
                              ? "文中の空欄に入る最も適切な語句をAからDの中から1つ選びなさい。"
                              : "文中のア、イ、ウの空欄に入る最も適切な語をAからCの中から1つずつ選びなさい。",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8), // 12 -> 8
                        
                        // 問題文本体 (RichText/WidgetSpanを廃止し、非言語分野と同じTextのみの実装に変更)
                        // 正規表現で [ア] -> (ア) に置換。中身が空なら (　　) とする。
                        Text(
                          problem.question.replaceAllMapped(RegExp(r"\[(.*?)\]"), (match) {
                            String content = match.group(1) ?? "";
                            return content.trim().isEmpty ? "(　　)" : "($content)";
                          }),
                          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4, fontWeight: FontWeight.w500), // 15, 1.6 -> 14, 1.4
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // 12 -> 8
                
                // 選択肢定義
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8), // 8 -> 6, 8
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: problem.options.entries.map((entry) {
                      return _buildDefinitionRow(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 12), // 12 -> 12(そのまま) or 12
                
                // 回答ボタン (Typeによって分岐)
                if (problem.type == FillInType.singleBlank)
                  _buildSingleBlankButtons()
                else
                  _buildMultiBlankButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // _buildHighlightedQuestionText は不要になるため削除
  // WidgetSpanを使わずTextのみで描画することで、句読点の浮き（ベースラインずれ）を根本解決する

  Widget _buildSingleBlankButtons() {
    // 4 buttons A, B, C, D
    return Column(
      children: ["A", "B", "C", "D"].map((label) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2), // 8 -> 2
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleOptionSelected(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 8), // 12 -> 8
                minimumSize: const Size(double.infinity, 40), // 統一
              ),
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 16 -> 14
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiBlankButtons() {
    // 5 buttons (Correct + 4 Wrongs)
    final options = _multiOptionsList[_currentIndex];
    
    return Column(
      children: options.map((opt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2), // 6 -> 2
          child: SizedBox(
            width: double.infinity,
            // 高さ固定をやめ、内容に応じて伸縮するように変更（ただし最小高さを確保）
            child: ElevatedButton(
              onPressed: () => _handleOptionSelected(opt.label),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 垂直パディングを確保
                alignment: Alignment.centerLeft,
                minimumSize: const Size(double.infinity, 40), // 44 -> 40
              ),
              child: Row(
                children: [
                  Text("${opt.label} ", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
                  Expanded(
                    child: Text(
                      _formatOrderString(opt.answers),
                      style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500), // 12 -> 13? User said "コンパクトに"
                      // 12 -> 13
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // _buildSlot は不要になるため削除

  Widget _buildDefinitionRow(String label, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2), // 4 -> 2
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 13)), // 14 -> 13
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.3))),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    int correctCount = 0;
    for (int i = 0; i < _problems.length; i++) {
      final p = _problems[i];
      final uAns = _userAnswers[i];
      
      bool isCorrect = false;
      if (p.type == FillInType.singleBlank) {
        // uAns: "A", Correct: "A"
        isCorrect = (uAns == p.correctAnswer);
      } else {
        // uAns: "ア", Correct: ["A", "B", "C"]
        // Need to find the option set for "ア"
        OptionSet? selected = _multiOptionsList[i].firstWhere((o) => o.label == uAns, orElse: () => OptionSet(answers: [], isCorrect: false, label: "-"));
        isCorrect = selected.isCorrect;
      }
      
      if (isCorrect) correctCount++;
    }
    
    double percentage = (correctCount / _problems.length);
    int percentageInt = (percentage * 100).toInt();
    
    Color gaugeColor;
    if (percentageInt == 100) gaugeColor = Colors.purple;
    else if (percentageInt >= 80) gaugeColor = Colors.indigo;
    else if (percentageInt >= 60) gaugeColor = Colors.green;
    else if (percentageInt >= 40) gaugeColor = Colors.pink;
    else if (percentageInt >= 20) gaugeColor = Colors.red;
    else gaugeColor = Colors.grey;

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
                        Text('$correctCount / 5 問正解', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
                    backgroundColor: Colors.orange, 
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
            itemCount: _problems.length,
            itemBuilder: (context, index) {
              final problem = _problems[index];
              final uAns = _userAnswers[index];
              
              bool isCorrect = false;
              String displayUserAns = "";
              String displayCorrectAns = "";
              
              if (problem.type == FillInType.singleBlank) {
                isCorrect = (uAns == problem.correctAnswer);
                displayUserAns = uAns ?? "-";
                displayCorrectAns = problem.correctAnswer;
              } else {
                OptionSet? selected = _multiOptionsList[index].firstWhere((o) => o.label == uAns, orElse: () => OptionSet(answers: [], isCorrect: false, label: "-"));
                isCorrect = selected.isCorrect;
                
                // Find correct option label
                OptionSet? correctOpt = _multiOptionsList[index].firstWhere((o) => o.isCorrect, orElse: () => OptionSet(answers: [], isCorrect: false, label: "?"));
                
                displayUserAns = "${selected.label} ${_formatOrderString(selected.answers)}";
                displayCorrectAns = "${correctOpt.label} ${_formatOrderString(correctOpt.answers)}";
              }

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
                      Text('第${index + 1}問', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                          // 問題文 (短縮はしないが、空欄埋める前の形)
                          Text(problem.question, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          
                          Row(
                            children: [
                              const Text('あなたの回答: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Expanded(child: Text(displayUserAns, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('正解: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Expanded(child: Text(displayCorrectAns, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          const Text('【解説】', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(4)),
                            child: Text(problem.explanation, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          ),
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

class OptionSet {
  final List<String> answers;
  final bool isCorrect;
  String label;

  OptionSet({required this.answers, required this.isCorrect, required this.label});
}
