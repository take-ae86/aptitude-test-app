import 'dart:math';

class OrderingProblem {
  final String title; // "例題1", "練習問題① [1]" etc
  final String questionPrefix; // "たとえ多くの情報を"
  final String questionSuffix; // "ことにもなりかねない。"
  final Map<String, String> options; // {"A": "...", "B": "...", ...}
  final List<String> correctOrder; // ["B", "A", "C", "D"]
  final String explanation;

  OrderingProblem({
    required this.title,
    required this.questionPrefix,
    required this.questionSuffix,
    required this.options,
    required this.correctOrder,
    required this.explanation,
  });
}

class OrderingEngine {
  final Random _rand = Random();

  final List<OrderingProblem> _allProblems = [
    // 1. 例題1
    OrderingProblem(
      title: "例題1",
      questionPrefix: "たとえ多くの情報を",
      questionSuffix: "ことにもなりかねない。",
      options: {
        "A": "その膨大な情報を自分自身で",
        "B": "集めることができたとしても",
        "C": "整理して利用できなければ",
        "D": "せっかくの情報に押しつぶされる",
      },
      correctOrder: ["B", "A", "C", "D"],
      explanation: "文頭の「たとえ」を受けるのはBの「〜としても」。文末「〜ことにも」につながるのはDの「〜押しつぶされる」。残るAとCでは、A「情報を自分自身で」→C「整理して」の流れが自然。",
    ),

    // 2. 例題2
    OrderingProblem(
      title: "例題2",
      questionPrefix: "部下のやる気を",
      questionSuffix: "大事です。",
      options: {
        "A": "成果を収めるためには",
        "B": "「何のために」という動機付けが",
        "C": "引き出して",
        "D": "「どのように」という方法論ではなく",
      },
      correctOrder: ["C", "A", "D", "B"],
      explanation: "「やる気を」に続くのはC「引き出して」。文末「大事です」の主語になるのはB「動機付けが」。残るAとDでは、「成果を収めるためには(A)」「方法論ではなく(D)」「動機付けが(B)」とつながる。",
    ),

    // 3. 練習問題① [1]
    OrderingProblem(
      title: "練習問題① [1]",
      questionPrefix: "初冠雪とは、その年の最高気温を",
      questionSuffix: "重要な指標となっている。",
      options: {
        "A": "積もった状態になることを指し",
        "B": "初めて山頂部に雪が",
        "C": "観測した日より後に",
        "D": "冬の訪れを推し量る",
      },
      correctOrder: ["C", "B", "A", "D"],
      explanation: "「最高気温を」に続くのはC「観測した日より後に」。その後、B「初めて〜雪が」→A「積もった状態〜指し」→D「冬の訪れを〜」とつながる。",
    ),

    // 4. 練習問題① [2]
    OrderingProblem(
      title: "練習問題① [2]",
      questionPrefix: "江戸時代の測量家である伊能忠敬が",
      questionSuffix: "われわれを大いに力づけてくれる。",
      options: {
        "A": "高齢化社会を生きる",
        "B": "50歳を超えてからだったことは",
        "C": "日本全図の作成に着手したのが",
        "D": "後世に残る偉業である",
      },
      correctOrder: ["D", "C", "B", "A"],
      explanation: "「伊能忠敬が」の直後に、D「偉業である」日本全図の〜と続けると修飾関係がおかしい。「伊能忠敬が(主語)」に対する述語部分はB「〜だったことは」。その「〜」の中身がC「作成に着手したのが」。Dは「日本全図」を修飾する「後世に残る偉業である(D)日本全図(C)」か？ いや、D→C→B→Aの順。「伊能忠敬が」→「後世に残る偉業である(D)」→「日本全図の作成に着手したのが(C)」→「50歳を超えてからだったことは(B)」→「高齢化社会を生きる(A)」われわれを...。",
    ),

    // 5. 練習問題① [3]
    OrderingProblem(
      title: "練習問題① [3]",
      questionPrefix: "天候デリバティブは",
      questionSuffix: "注目されている。",
      options: {
        "A": "金融派生商品のひとつで",
        "B": "企業の収益源を補償するものとして",
        "C": "天候に関して見込みが外れたときに",
        "D": "猛暑や冷夏など",
      },
      correctOrder: ["A", "D", "C", "B"],
      explanation: "「天候デリバティブは」→A「金融派生商品のひとつで」。D「猛暑や冷夏など」→C「天候に関して〜外れたときに」→B「企業の〜補償するものとして」注目されている。",
    ),

    // 6. 練習問題② [1]
    OrderingProblem(
      title: "練習問題② [1]",
      questionPrefix: "職場の朝礼や会議に出て聞いていると",
      questionSuffix: "長々と自説を展開する人もいる。",
      options: {
        "A": "その決まり文句自体の意味が",
        "B": "失われていることも多く",
        "C": "いろいろな決まり文句が登場するが",
        "D": "「要するに」と断言しながら",
      },
      correctOrder: ["C", "A", "B", "D"],
      explanation: "「聞いていると」→C「〜登場するが」。次にA「その決まり文句自体の意味が」→B「失われていることも多く」。最後にD「『要するに』と断言しながら」自説を展開する。",
    ),

    // 7. 練習問題② [2]
    OrderingProblem(
      title: "練習問題② [2]",
      questionPrefix: "自然環境を",
      questionSuffix: "必要がある。",
      options: {
        "A": "積極的な植林をする",
        "B": "管理を行うとともに",
        "C": "自然の法則に沿った",
        "D": "保全していくには",
      },
      correctOrder: ["D", "C", "B", "A"],
      explanation: "「自然環境を」→D「保全していくには」。C「自然の法則に沿った」→B「管理を行うとともに」→A「積極的な植林をする」必要がある。",
    ),

    // 8. 練習問題② [3]
    OrderingProblem(
      title: "練習問題② [3]",
      questionPrefix: "地球に存在する水のうち",
      questionSuffix: "利用しづらい海水だ。",
      options: {
        "A": "2.5%程度にすぎず",
        "B": "淡水は全体の",
        "C": "人間が利用しやすい",
        "D": "残りの97.5%は",
      },
      correctOrder: ["C", "B", "A", "D"],
      explanation: "「水のうち」→C「人間が利用しやすい」→B「淡水は全体の」→A「2.5%程度にすぎず」。D「残りの97.5%は」利用しづらい海水だ。",
    ),
  ];

  Future<List<OrderingProblem>> generateProblems(int count) async {
    List<OrderingProblem> shuffled = List.from(_allProblems)..shuffle(_rand);
    return shuffled.take(count).toList();
  }

  // 誤答パターンの生成 (正解以外のランダムな並び)
  List<List<String>> generateWrongOptions(List<String> correct, int count) {
    List<List<String>> wrongs = [];
    List<String> symbols = ["A", "B", "C", "D"];
    
    // 全順列を作成してシャッフルするのが安全だが、ランダム生成で十分
    while (wrongs.length < count) {
      List<String> wrong = List.from(symbols)..shuffle(_rand);
      
      // 正解と一致しないかチェック
      if (wrong.toString() == correct.toString()) continue;
      
      // 既存の誤答と重複しないかチェック
      bool isDuplicate = false;
      for (var w in wrongs) {
        if (w.toString() == wrong.toString()) {
          isDuplicate = true;
          break;
        }
      }
      if (!isDuplicate) wrongs.add(wrong);
    }
    return wrongs;
  }
}
