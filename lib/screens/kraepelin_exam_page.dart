import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class KraepelinExamPage extends StatefulWidget {
  const KraepelinExamPage({super.key});

  @override
  State<KraepelinExamPage> createState() => _KraepelinExamPageState();
}

class _KraepelinExamPageState extends State<KraepelinExamPage> {
  // Game State
  List<Map<String, dynamic>> _questions = [];
  
  // Stats
  int _correctCount = 0;
  int _currentQuestionIndex = 0; 
  Timer? _timer;
  int _elapsedSeconds = 0;
  
  // History for Result Screen
  final List<Map<String, dynamic>> _history = [];

  bool _isFinished = false;
  static const int _targetQuestionCount = 5;

  @override
  void initState() {
    super.initState();
    _startTest();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTest() {
    _correctCount = 0;
    _currentQuestionIndex = 0;
    _elapsedSeconds = 0;
    _history.clear();
    _questions.clear();
    _isFinished = false;
    
    // 事前に5問生成する（戻るボタン対応のため）
    final random = Random();
    for (int i = 0; i < _targetQuestionCount; i++) {
      int n1 = random.nextInt(10);
      int n2 = random.nextInt(10);
      int ans = (n1 + n2) % 10;
      
      Set<int> opts = {ans};
      while (opts.length < 5) {
        opts.add(random.nextInt(10));
      }
      List<int> optList = opts.toList()..shuffle();
      
      _questions.add({
        'num1': n1,
        'num2': n2,
        'answer': ans,
        'options': optList,
      });
    }
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_isFinished) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _handleAnswer(int selectedValue) {
    if (_isFinished) return;

    final question = _questions[_currentQuestionIndex];
    int answer = question['answer'];
    bool isCorrect = (selectedValue == answer);

    if (isCorrect) {
      _correctCount++;
    }
    
    // Save history
    _history.add({
      'q': '${question['num1']} + ${question['num2']}',
      'u': selectedValue,
      'a': answer,
      'correct': isCorrect,
    });
    
    if (_currentQuestionIndex < _targetQuestionCount - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    _timer?.cancel();
    setState(() {
      _isFinished = true;
    });
  }
  
  void _handleBack() {
    // 完了カテゴリ（SPI確率）と同様の挙動：
    // 問題の途中なら一つ前の問題に戻る。
    // 最初なら画面を閉じる。
    if (_currentQuestionIndex > 0 && !_isFinished) {
      // 直前の回答履歴を消して状態を戻す
      if (_history.isNotEmpty) {
        final last = _history.removeLast();
        if (last['correct'] == true) {
          _correctCount--;
        }
      }
      setState(() {
        _currentQuestionIndex--;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クレペリン検査', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink[50], // 薄いピンク
        foregroundColor: Colors.pink[900], // 濃いピンク (文字)
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
        iconTheme: IconThemeData(color: Colors.pink[900]),
        actions: [
          // Timer (右上)
          if (!_isFinished)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
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
      body: _isFinished ? _buildResultScreen() : _buildQuestionScreen(),
    );
  }

  Widget _buildQuestionScreen() {
    if (_questions.isEmpty) return const SizedBox.shrink();
    
    final question = _questions[_currentQuestionIndex];
    final int num1 = question['num1'];
    final int num2 = question['num2'];
    final List<int> options = question['options'];

    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _targetQuestionCount,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
        ),
        
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('第${_currentQuestionIndex + 1}問', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(height: 32),
                
                // Question: 5 + 7 (No =)
                Text(
                  '$num1 + $num2',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 4.0),
                ),
                const SizedBox(height: 16),
                const Text('一の位を答えよ', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        
        // 5 Choices Buttons (Bottom)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: options.map((opt) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleAnswer(opt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 1,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(opt.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    int percentage = ((_correctCount / _targetQuestionCount) * 100).toInt();
    
    Color gaugeColor;
    if (percentage == 100) gaugeColor = Colors.purple;
    else if (percentage >= 80) gaugeColor = Colors.indigo;
    else if (percentage >= 60) gaugeColor = Colors.green;
    else if (percentage >= 40) gaugeColor = Colors.pink; 
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
                          if (percentage == 0)
                             const Icon(Icons.psychology_outlined, size: 100, color: Colors.grey)
                          else 
                             const Icon(Icons.psychology, size: 100, color: Color(0xFFEEEEEE)),
                          
                          if (percentage > 0)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: percentage / 100,
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
                            Text('$percentage', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: percentage == 0 ? Colors.grey : gaugeColor)),
                            Text('%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: percentage == 0 ? Colors.grey : gaugeColor)),
                          ],
                        ),
                        const Text('正解率', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('$_correctCount / $_targetQuestionCount 問正解', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
                  onPressed: _startTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, 
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
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              final bool isCorrect = item['correct'];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 4),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  leading: Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red, size: 18),
                  title: Text('第${index + 1}問:  ${item['q']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("正解: ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("${item['a']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text("(${item['u']})", style: TextStyle(fontSize: 12, color: isCorrect ? Colors.green : Colors.red, decoration: isCorrect ? null : TextDecoration.lineThrough)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
