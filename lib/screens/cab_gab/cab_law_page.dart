import 'dart:async';
import 'package:flutter/material.dart';
import '../../logic/law_engine.dart';

class CabLawPage extends StatefulWidget {
  const CabLawPage({super.key});

  @override
  State<CabLawPage> createState() => _CabLawPageState();
}

class _CabLawPageState extends State<CabLawPage> {
  final LawEngine _engine = LawEngine();
  List<LawProblem> _problems = [];
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
    setState(() { _isLoading = true; });
    try {
      final problems = await _engine.generateProblems(5);
      if (mounted) {
        setState(() {
          _problems = problems;
          _userAnswers = List.filled(problems.length, null);
          _isLoading = false;
          _isFinished = false;
          _currentIndex = 0;
        });
        _startTimer();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handleOptionSelected(String label) {
    if (_isFinished) return;
    setState(() {
      _userAnswers[_currentIndex] = label;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        if (_currentIndex < _problems.length - 1) {
          setState(() { _currentIndex++; });
        } else {
          _finishQuiz();
        }
      }
    });
  }

  void _finishQuiz() {
    _timer?.cancel();
    setState(() { _isFinished = true; });
  }

  void _handleBack() {
    if (_currentIndex > 0 && !_isFinished) {
      setState(() { _currentIndex--; });
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
        title: const Text('法則性', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
        actions: [
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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _isFinished ? _buildResultView() : _buildQuestionView(),
    );
  }

  Widget _buildQuestionView() {
    final problem = _problems[_currentIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: (_currentIndex + 1) / _problems.length, color: Colors.green),
          const SizedBox(height: 16),
          Text('第${_currentIndex + 1}問', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 8),
          const Text('法則に従って「？」に当てはまる図形を選べ。'),
          const SizedBox(height: 16),
          
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: Image.asset(problem.questionImagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: Image.asset(problem.optionsImagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 32),
          
          Column(
            children: ["A","B","C","D","E"].map((label) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _handleOptionSelected(label),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    int correctCount = 0;
    for(int i=0; i<_problems.length; i++) {
      if(_userAnswers[i] == _problems[i].correctAnswer) correctCount++;
    }
    
    double percentage = _problems.isEmpty ? 0.0 : (correctCount / _problems.length);
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
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                Row(
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
                        Text('$correctCount / ${_problems.length} 問正解', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('タイム: ${_formatTime(_elapsedSeconds)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 180,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
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
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            itemCount: _problems.length,
            itemBuilder: (context, index) {
              final p = _problems[index];
              final ans = _userAnswers[index];
              final isCorrect = ans == p.correctAnswer;
              
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
                      Text('第${index+1}問', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  subtitle: Text(isCorrect ? '正解 (回答: $ans)' : '不正解 (回答: $ans, 正解: ${p.correctAnswer})', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (p.explanationImagePaths.isNotEmpty)
                            ...p.explanationImagePaths.map((path) => 
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                                  child: Image.asset(path, fit: BoxFit.contain),
                                ),
                              )
                            ).toList()
                          else
                            const Text("解説画像はありません"),
                          
                          const SizedBox(height: 12),
                          const Text("問題図:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Container(
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(p.questionImagePath, fit: BoxFit.contain),
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
