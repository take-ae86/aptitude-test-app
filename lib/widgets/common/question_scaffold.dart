import 'dart:async';
import 'package:flutter/material.dart';

class QuestionScaffold extends StatefulWidget {
  final String categoryName;
  final Widget problemContent; // The question text
  final Widget? chartContent; // Optional chart/image
  final List<Widget> answerButtons; // The 4 buttons
  final VoidCallback? onTimeUp;
  final VoidCallback? onBack; // Custom back action

  const QuestionScaffold({
    super.key,
    required this.categoryName,
    required this.problemContent,
    this.chartContent,
    required this.answerButtons,
    this.onTimeUp,
    this.onBack,
  });

  @override
  State<QuestionScaffold> createState() => _QuestionScaffoldState();
}

class _QuestionScaffoldState extends State<QuestionScaffold> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use custom back action if provided, otherwise default pop
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: Text(widget.categoryName, style: const TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_elapsedSeconds),
                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Problem Text
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.5),
                        child: widget.problemContent,
                      ),
                    ),
                    
                    // Chart Area - Only show if chartContent is NOT null
                    if (widget.chartContent != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: widget.chartContent),
                      ),
                    ],

                    const SizedBox(height: 24), // Reasonable gap, not too large

                    // Buttons placed immediately after content
                    ...widget.answerButtons.map((btn) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: btn,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
