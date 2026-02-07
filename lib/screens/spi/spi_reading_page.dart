import 'dart:async';
import 'package:flutter/material.dart';
import '../../logic/reading_engine.dart';

class SpiReadingPage extends StatefulWidget {
  const SpiReadingPage({super.key});

  @override
  State<SpiReadingPage> createState() => _SpiReadingPageState();
}

class _SpiReadingPageState extends State<SpiReadingPage> {
  final ReadingEngine _engine = ReadingEngine();
  late ReadingProblem _problem;
  bool _isLoading = true;
  
  // モード管理: true=本文表示, false=設問表示
  bool _isTextMode = true;
  
  // 現在の小問インデックス (0~2)
  int _currentQuestionIndex = 0;
  
  // ユーザーの回答 (小問3つ分)
  List<String?> _userAnswers = [null, null, null];
  
  // 完了フラグ
  bool _isFinished = false;

  // Timer
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadProblem();
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

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _loadProblem() {
    setState(() {
      _isLoading = true;
      _problem = _engine.getRandomProblem();
      _isLoading = false;
      _isTextMode = true; // 最初は本文から
      _currentQuestionIndex = 0;
      _userAnswers = [null, null, null];
      _isFinished = false;
    });
    _startTimer();
  }

  void _handleOptionSelected(String selectedOption) {
    if (_isFinished) return;
    
    setState(() {
      _userAnswers[_currentQuestionIndex] = selectedOption;
    });

    // 少し待ってから次へ
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      if (_currentQuestionIndex < _problem.questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        // 全問終了 -> 結果画面へ
        _finishQuiz();
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
    if (_isFinished) {
      Navigator.of(context).pop();
      return;
    }

    if (_isTextMode) {
      // 本文モードなら画面を閉じる
      Navigator.of(context).pop();
    } else {
      // 設問モード
      if (_currentQuestionIndex > 0) {
        setState(() {
          _currentQuestionIndex--;
        });
      } else {
        // 最初の設問なら本文に戻る
        setState(() {
          _isTextMode = true;
        });
      }
    }
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
          title: const Text('長文読解', style: TextStyle(fontSize: 16)),
          centerTitle: true,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          toolbarHeight: 44,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
          actions: [
            // 設問モード中のみ表示するボタン類
            if (!_isLoading && !_isFinished && !_isTextMode) ...[
              // 本文へ戻るボタン (白抜き)
              InkWell(
                onTap: () {
                  setState(() {
                    _isTextMode = true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!)
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.description, size: 14, color: Colors.black87),
                      SizedBox(width: 4),
                      Text("本文へ戻る", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              // タイマー (白抜き)
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.black54),
                    SizedBox(width: 4),
                    Text(_formatTime(_elapsedSeconds), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ]
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isFinished
                ? _buildResultView()
                : _isTextMode
                    ? _buildTextModeView()
                    : _buildQuestionModeView(),
      ),
    );
  }

  // 本文モード画面
  Widget _buildTextModeView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 大問表示
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                  child: const Text('大問1', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                
                Text(
                  _problem.text,
                  style: const TextStyle(fontSize: 15, height: 1.8, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "出典: ${_problem.source}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isTextMode = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("設問へ進む", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // 設問モード画面
  Widget _buildQuestionModeView() {
    final question = _problem.questions[_currentQuestionIndex];
    
    return Column(
      children: [
        // 進捗バー
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _problem.questions.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12), // 詰め詰め仕様
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                  child: Text('小問 ${_currentQuestionIndex + 1} / 3', style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(height: 8),
                
                // 設問文
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[300]!)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0), // 詰め詰め仕様
                    child: Text(
                      question.text,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.4),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 選択肢ボタン
                ...question.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2), // 詰め詰め仕様
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleOptionSelected(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 1,
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 詰め詰め仕様
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size(double.infinity, 40), // 詰め詰め仕様
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), // 詰め詰め仕様
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 結果画面
  Widget _buildResultView() {
    int correctCount = 0;
    for (int i = 0; i < _problem.questions.length; i++) {
      if (_userAnswers[i] == _problem.questions[i].answer) {
        correctCount++;
      }
    }
    
    // 正答率: 0%, 33%, 66%, 100%
    int percentage = ((correctCount / 3) * 100).round();
    if (correctCount == 1) percentage = 33;
    if (correctCount == 2) percentage = 66;
    
    Color gaugeColor;
    if (percentage == 100) gaugeColor = Colors.purple;
    else if (percentage >= 66) gaugeColor = Colors.green;
    else if (percentage >= 33) gaugeColor = Colors.orange;
    else gaugeColor = Colors.red;

    return SingleChildScrollView(
      child: Column(
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
                          Text('$correctCount / 3 問正解', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
                    onPressed: _loadProblem,
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
          
          const SizedBox(height: 8),
          
          // 解説リスト
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              final q = _problem.questions[index];
              final uAns = _userAnswers[index];
              final isCorrect = uAns == q.answer;
              
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
                      Text("小問 ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                          Text(q.text, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('あなたの回答: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text("${uAns ?? '-'}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('正解: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text("${q.answer}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(4)),
                            child: Text(q.explanation, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
