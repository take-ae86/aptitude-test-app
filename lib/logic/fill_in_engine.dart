import 'dart:math';

enum FillInType { singleBlank, multiBlank }

class FillInProblem {
  final String title; // e.g., "例題1"
  final FillInType type;
  final String question; // Question text with [ ] or [ア] [イ] [ウ] placeholders
  final Map<String, String> options; // {"A": "...", "B": "...", ...}
  
  // For singleBlank: correct answer key (e.g., "B")
  // For multiBlank: correct answer list in order (e.g., ["B", "C", "A"]) for ア, イ, ウ
  final dynamic correctAnswer; 
  
  final String explanation;

  FillInProblem({
    required this.title,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

class FillInEngine {
  final Random _rand = Random();

  final List<FillInProblem> _allProblems = [
    // 1. 例題1 (Single)
    FillInProblem(
      title: "例題1",
      type: FillInType.singleBlank,
      question: "コーチングとは、目標達成のために必要な能力や行動をコミュニケーションで引き出す能力開発法である。コーチングでは、何かを教え込んでやらせる指導とは異なり、自発的な行動を促す方法が取られる。人が自分から行動を起こすのは、 [　　] ときであり、「こうしろ」と押しつけられると自主性を失ってしまうものである。",
      options: {
        "A": "「誰もそんなことはしない」と叱責される",
        "B": "「あなたならどうするか」と問いかけられる",
        "C": "「他の人と同じようにしなさい」と指導される",
        "D": "「ああするな、こうするな」と禁止される",
      },
      correctAnswer: "B",
      explanation: "空欄の後に「押しつけられると自主性を失ってしまう」とあるため、空欄には「押しつけとは反対の内容（自主性を促す内容）」が入る。Bの「あなたならどうするか」と問いかけることは、相手に考えさせ自主的な行動を促すアプローチであるため適切。",
    ),

    // 2. 例題2 (Multi)
    FillInProblem(
      title: "例題2",
      type: FillInType.multiBlank,
      question: "イースター島にあるモアイ像は、人面を模した石像彫刻だ。島で産出される凝灰岩で作られており、海に面した高台に建てられていることもあって風や雨による [ア] が激しい。中には波が足元の土壌をえぐり、 [イ] したモアイ像もあり、放っておくと近い将来 [ウ] する恐れもあるという。",
      options: {
        "A": "消滅",
        "B": "風化",
        "C": "倒壊",
      },
      correctAnswer: ["B", "C", "A"], // ア:風化, イ:倒壊, ウ:消滅
      explanation: "ア：風や雨による影響で徐々に壊れていくことなので「風化」。\nイ：波に土壌をえぐられて倒れてしまうことなので「倒壊」。\nウ：放っておくと最終的になくなってしまうことなので「消滅」。",
    ),

    // 3. 練習問題①-1 (Single)
    FillInProblem(
      title: "練習問題① [1]",
      type: FillInType.singleBlank,
      question: "試験や評価という言葉を明確に区別していない者が多いようだ。試験は規格に対する合否の判断をすることだ。一方、評価は将来を予測することだ。つまり、メーカーの信頼性試験で得られた結果はあくまである瞬間のデータでしかなく、 [　　] 。",
      options: {
        "A": "将来を自然界に存在しないものに導くのだ",
        "B": "将来を彩るものなのだ",
        "C": "将来を創り出すものではないのだ",
        "D": "将来を予測するものではないのだ",
      },
      correctAnswer: "D",
      explanation: "「試験」は合否判定、「評価」は将来予測。メーカーの「信頼性試験」はあくまで「試験」なので、将来予測（評価）とは異なる。よって「将来を予測するものではないのだ」となるDが適切。",
    ),

    // 4. 練習問題①-2 (Single)
    FillInProblem(
      title: "練習問題① [2]",
      type: FillInType.singleBlank,
      question: "人間は、温度や明るさ、味などについて、 [　　] 。例えば、真夏に気温が15度の日があれば寒いと感じるが、真冬に15度の日があれば暖かいと感じるといったことだ。こうしたことは触覚や視覚、味覚などだけでなく、お金や物に対する評価も同じで、何らかの基準との比較で行われる。",
      options: {
        "A": "現状が最適であると判断することはほとんどない",
        "B": "環境に左右されない絶対的な感覚を持っている",
        "C": "絶対値ではなく相対的な変化に反応しがちである",
        "D": "金銭や物のよしあしを見極めるときとは異なった価値判断をする",
      },
      correctAnswer: "C",
      explanation: "同じ15度でも夏は寒く冬は暖かいと感じる＝基準との比較で感じる（相対的）。よって「絶対値ではなく相対的な変化に反応しがちである」Cが適切。",
    ),

    // 5. 練習問題①-3 (Single)
    FillInProblem(
      title: "練習問題① [3]",
      type: FillInType.singleBlank,
      question: "目的地に着くための道順は知っているはずなのに、目印にしていた木や建物がなくなって風景が変わってしまったために迷うことがある。頭の中に変化がなくても、知識が知識として機能しなくなるのだ。結局、私たちが知識として持っている多くの部分が [　　] ということである。",
      options: {
        "A": "主観にすぎない",
        "B": "環境などの外的要因に支えられている",
        "C": "記憶するだけでは役に立たない",
        "D": "命題化が簡単",
      },
      correctAnswer: "B",
      explanation: "風景（外的要因）が変わると道順がわからなくなる＝知識は外的要因（目印など）に依存している。よってBが適切。",
    ),

    // 6. 練習問題②-1 (Multi)
    FillInProblem(
      title: "練習問題② [1]",
      type: FillInType.multiBlank,
      question: "グーテンベルクが鋳造活字による印刷技術を完成させたことはよく知られている。メディアの発展の歴史で印刷技術の影響がいかに大きかったかは、すでに多くの研究で [ア] されているが、このように技術の [イ] によって人々の生活が変わり、ひいては社会も [ウ] した例は、いくらでもあげられる。",
      options: {
        "A": "浸透",
        "B": "変容",
        "C": "検証",
      },
      correctAnswer: ["C", "A", "B"], // ア:検証, イ:浸透, ウ:変容
      explanation: "ア：多くの研究ですでに確かめられているので「検証」。\nイ：技術が社会に行き渡ることなので「浸透」。\nウ：社会のありさまが変わることなので「変容」。",
    ),

    // 7. 練習問題②-2 (Multi)
    FillInProblem(
      title: "練習問題② [2]",
      type: FillInType.multiBlank,
      question: "アメリカ合衆国の国旗は、赤と白の横縞と、左上に白い星の [ア] が多数浮かぶ四角い青地が配置された [イ] である。この「赤と白の横縞」「白い星が浮かぶ青地」はアメリカ合衆国の [ウ] としてさまざまなところで使われている。",
      options: {
        "A": "デザイン",
        "B": "マーク",
        "C": "シンボル",
      },
      correctAnswer: ["B", "A", "C"], // ア:マーク, イ:デザイン, ウ:シンボル
      explanation: "ア：星の印なので「マーク」。\nイ：国旗全体の図案のことなので「デザイン」。\nウ：国を象徴するものとして使われるので「シンボル」。",
    ),

    // 8. 練習問題②-3 (Multi)
    FillInProblem(
      title: "練習問題② [3]",
      type: FillInType.multiBlank,
      question: "「海は広い」と発したことばの解釈はさまざまである。 [ア] を表している場合もあるだろうし、たんに [イ] を述べただけという場合もあるだろう。言語の規則を厳密に決めることができない理由は、ことばが多様な [ウ] を持っているからだ。",
      options: {
        "A": "感動",
        "B": "意味",
        "C": "事実",
      },
      correctAnswer: ["A", "C", "B"], // ア:感動, イ:事実, ウ:意味
      explanation: "ア：「広い！」という心の動きなので「感動」。\nイ：広いという客観的なことなので「事実」。\nウ：多様な解釈ができる＝多様な「意味」を持っている。",
    ),
  ];

  Future<List<FillInProblem>> generateProblems(int count) async {
    List<FillInProblem> shuffled = List.from(_allProblems)..shuffle(_rand);
    return shuffled.take(count).toList();
  }

  // 誤答パターンの生成 (MultiBlank用)
  List<List<String>> generateWrongOptionsMulti(List<String> correctOrder, int count) {
    List<List<String>> wrongs = [];
    List<String> symbols = ["A", "B", "C"]; // MultiBlank usually has 3 options A,B,C
    
    // 全順列 (3! = 6通り) から正解を除いたものを候補とする
    List<List<String>> allPermutations = [
      ["A", "B", "C"],
      ["A", "C", "B"],
      ["B", "A", "C"],
      ["B", "C", "A"],
      ["C", "A", "B"],
      ["C", "B", "A"],
    ];

    // 正解パターンと同じものを除外
    allPermutations.removeWhere((p) => p.toString() == correctOrder.toString());
    
    // シャッフルして必要な数だけ取得
    allPermutations.shuffle(_rand);
    return allPermutations.take(count).toList();
  }
}
