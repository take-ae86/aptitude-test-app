import 'dart:math';

class LawProblem {
  final String id;
  final String questionImagePath;
  final String optionsImagePath;
  final List<String> explanationImagePaths; 
  final String correctAnswer;
  final String explanation; 

  LawProblem({
    required this.id,
    required this.questionImagePath,
    required this.optionsImagePath,
    required this.explanationImagePaths,
    required this.correctAnswer,
    this.explanation = "解説画像を参照してください。",
  });
}

class LawEngine {
  final List<LawProblem> _allProblems = [
    LawProblem(
      id: 'law_01',
      questionImagePath: 'assets/cab/law/law_q_01.png',
      optionsImagePath: 'assets/cab/law/law_opt_01.png',
      explanationImagePaths: [
        'assets/cab/law/law_exp_01.png',
      ],
      correctAnswer: 'A', // 1A
    ),
    LawProblem(
      id: 'law_02',
      questionImagePath: 'assets/cab/law/law_q_02.png',
      optionsImagePath: 'assets/cab/law/law_opt_02.png',
      explanationImagePaths: [
        'assets/cab/law/law_exp_02.png',
      ],
      correctAnswer: 'D', // 2D
    ),
    LawProblem(
      id: 'law_03',
      questionImagePath: 'assets/cab/law/law_q_03.png',
      optionsImagePath: 'assets/cab/law/law_opt_03.png',
      explanationImagePaths: [
        'assets/cab/law/law_exp_03.png',
      ],
      correctAnswer: 'D', // 3D
    ),
    LawProblem(
      id: 'law_04',
      questionImagePath: 'assets/cab/law/law_q_04.png',
      optionsImagePath: 'assets/cab/law/law_opt_04.png',
      explanationImagePaths: [
        'assets/cab/law/law_exp_04.png',
      ],
      correctAnswer: 'E', // 4E
    ),
    LawProblem(
      id: 'law_05',
      questionImagePath: 'assets/cab/law/law_q_05.png',
      optionsImagePath: 'assets/cab/law/law_opt_05.png',
      explanationImagePaths: [
        'assets/cab/law/law_exp_05.png',
      ],
      correctAnswer: 'B', // 5B
    ),
    LawProblem(
      id: 'law_06',
      questionImagePath: 'assets/cab/law/law_q_06.png',
      optionsImagePath: 'assets/cab/law/law_opt_06.png',
      explanationImagePaths: [
        'assets/cab/law/law_exp_06.png',
      ],
      correctAnswer: 'D', // 6D (From image text: "線が6本なのはD")
    ),
  ];

  Future<List<LawProblem>> generateProblems(int count) async {
    if (_allProblems.isEmpty) return [];
    
    final random = Random();
    final List<LawProblem> problems = List.from(_allProblems);
    problems.shuffle(random);
    
    return problems.take(min(count, problems.length)).toList();
  }
}
