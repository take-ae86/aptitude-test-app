import 'dart:async';
import 'package:flutter/material.dart';
import '../../logic/speed_engine.dart';

class SpiSpeedPage extends StatefulWidget {
  const SpiSpeedPage({super.key});

  @override
  State<SpiSpeedPage> createState() => _SpiSpeedPageState();
}

class _SpiSpeedPageState extends State<SpiSpeedPage> {
  final SpeedEngine _engine = SpeedEngine();
  List<GeneratedProblem> _problems = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  List<String?> _userAnswers = [];
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
    setState(() {
      _isLoading = true;
      _isFinished = false;
      _currentIndex = 0;
      _userAnswers = [];
    });

    try {
      // 5問生成（確率と同じ仕様に統一）
      final problems = await _engine.generateProblems(5);
      if (mounted) {
        setState(() {
          _problems = problems;
          _userAnswers = List.filled(problems.length, null);
          _isLoading = false;
        });
        _startTimer();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handleOptionSelected(String selectedOption) {
    if (_isFinished) return;
    setState(() {
      _userAnswers[_currentIndex] = selectedOption;
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
          title: const Text('速さ', style: TextStyle(fontSize: 16)),
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
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                  child: Text('第${_currentIndex + 1}問', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(height: 12),
                Text(problem.questionText, style: const TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                ...problem.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _handleOptionSelected(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 1,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    int correctCount = 0;
    for (int i = 0; i < _problems.length; i++) {
      if (_userAnswers[i] == _problems[i].correctAnswer) correctCount++;
    }
    double percentage = (correctCount / _problems.length);
    int percentageInt = (percentage * 100).toInt();
    
    Color gaugeColor;
    if (percentageInt == 100) {
      gaugeColor = Colors.purple;
    } else if (percentageInt >= 80) {
      gaugeColor = Colors.indigo;
    } else if (percentageInt >= 60) {
      gaugeColor = Colors.green;
    } else if (percentageInt >= 40) {
      gaugeColor = Colors.pink;
    } else if (percentageInt >= 20) {
      gaugeColor = Colors.red;
    } else {
      gaugeColor = Colors.grey; 
    }

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
            itemCount: _problems.length,
            itemBuilder: (context, index) {
              final problem = _problems[index];
              final userAnswer = _userAnswers[index];
              final isCorrect = userAnswer == problem.correctAnswer;
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
