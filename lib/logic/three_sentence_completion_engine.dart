import 'dart:math';

class ThreeSentenceProblem {
  final String id;
  final List<String> sentences; // 3 sentences, placeholders already handled or raw?
  // Let's use raw text with "[ ]" or similar, but since we reconstructed it, 
  // we can just put "( )" directly in the text.
  final Map<String, String> options; // A-E
  final List<String> correctOrder; // ["D", "B", "E"] for (1),(2),(3)
  final String explanation;

  ThreeSentenceProblem({
    required this.id,
    required this.sentences,
    required this.options,
    required this.correctOrder,
    required this.explanation,
  });
}

class ThreeSentenceCompletionEngine {
  final Random _rand = Random();

  final List<ThreeSentenceProblem> _allProblems = [
    // 1. 例題1
    ThreeSentenceProblem(
      id: "例題1",
      sentences: [
        "(1) (　　)、なんといっても企画の良さにあります。",
        "(2) (　　)、1冊の新しい本を書き下ろすようなものです。",
        "(3) (　　)、ある彫刻家の作品を集めた展示室に来たときでした。",
      ],
      options: {
        "A": "ルネサンス期のイタリアの美術は",
        "B": "展覧会を作り上げることは",
        "C": "彫刻の多様性とその移り変わりは",
        "D": "この彫刻展の成功要因は",
        "E": "圧倒されるような思いがしたのは",
      },
      correctOrder: ["D", "B", "E"],
      explanation: "「企画の良さ」につながるのはD。「書き下ろすようなもの」は比喩なのでB。「展示室に来たとき」にどうなったか、Eが自然。",
    ),

    // 2. 例題2
    ThreeSentenceProblem(
      id: "例題2",
      sentences: [
        "(1) 山野は秋になると紅葉で色づき、(　　)。",
        "(2) 白銀とは名のとおり、(　　)。",
        "(3) 春になると雪はとけて水となり、(　　)。",
      ],
      options: {
        "A": "冬には多くの雪が降り積もって美しい景観を作り出す",
        "B": "しろがね色に輝く雪のことを指している",
        "C": "環境に負荷がかかりにくい地下水の利用方法といえる",
        "D": "落葉樹の雑木林が広がっている",
        "E": "地表を下って川に流れ込み海にまで届く",
      },
      correctOrder: ["A", "B", "E"],
      explanation: "秋の紅葉から冬の雪へ(A)。白銀の意味(B)。雪解け水が海へ(E)の流れ。",
    ),

    // 3. 練習問題①-1
    ThreeSentenceProblem(
      id: "練習問題①-1",
      sentences: [
        "(1) (　　)、できないと心身のバランスを崩してしまう。",
        "(2) (　　)、バラつきのある手仕事を現場から追いやってしまった。",
        "(3) (　　)、とにかく時間だけはかかる手仕事がまだまだ多い。",
      ],
      options: {
        "A": "手仕事ならではの達成感を覚えながら",
        "B": "特別な技能や資格も、集中力や創造力もいらないが",
        "C": "高精度で同質な仕上がりを要求する現代社会が",
        "D": "見守りが必要な状態でも人は誰かの役に立つことがしたいし",
        "E": "それまで培ってきた技能や創造力を生かして",
      },
      correctOrder: ["D", "C", "B"],
      explanation: "「できないと〜崩してしまう」のは「役に立つこと(D)」。手仕事を追いやったのは「現代社会(C)」。時間がかかる手仕事の修飾は「技能もいらないが(B)」。",
    ),

    // 4. 練習問題①-2
    ThreeSentenceProblem(
      id: "練習問題①-2",
      sentences: [
        "(1) (　　)、録音したものを聞くとまるで別人の声のように聞こえる。",
        "(2) (　　)、昔の合戦では法螺貝や太鼓の音が合図の音として使われた。",
        "(3) (　　)、音漏れで聞こえるのは高音が強調された耳障りな音なのである。",
      ],
      options: {
        "A": "防音工事を施した無音のスタジオでは圧迫感があるため",
        "B": "気温が上昇すると音が伝わる速度が上がるので",
        "C": "イヤホンは広い空間に波長の長い低音を送り出すには小さすぎるため",
        "D": "自分の声は声帯などの振動が頭蓋骨を伝わって聞こえるため",
        "E": "障害物に遮られやすい高音よりも低い音の方が遠くまで届くので",
      },
      correctOrder: ["D", "E", "C"],
      explanation: "別人の声に聞こえる理由はD。合図に使われた理由は遠くまで届くE。音漏れが高音ばかりなのは低音が出ないから(C)。",
    ),

    // 5. 練習問題②-1
    ThreeSentenceProblem(
      id: "練習問題②-1",
      sentences: [
        "(1) 商標やロゴマークは言うまでもないが、ポスター、書籍のデザインも、(　　)。",
        "(2) デザインは要求の多い注文主と移り気な大衆のどちらの要請にも対応しつつ、(　　)。",
        "(3) 展覧会などでは発注者が不在の、つまり目的がないデザイン作品も見られるが、(　　)。",
      ],
      options: {
        "A": "未来の理解者を夢見て現世を孤独な創作活動に捧げる生き方もあり得る",
        "B": "芸術を志向する作品として日常からかけ離れた別世界を形成する",
        "C": "発注者が意図する目的とそれに基づいた役割を前提としている",
        "D": "それは技術を磨くための習作であって本来のデザイン活動とはいえない",
        "E": "安易な妥協に逃げずに自分の存在を主張しなければならない",
      },
      correctOrder: ["C", "E", "D"],
      explanation: "デザインの前提はC。注文主と大衆に対応しつつ「主張する(E)」。目的がない作品は「本来のデザインではない(D)」。",
    ),

    // 6. 練習問題②-2
    ThreeSentenceProblem(
      id: "練習問題②-2",
      sentences: [
        "(1) 高齢者の健康で大事なのは単に持病の有無ではなく、(　　)。",
        "(2) 健康的な生活を送る高齢者は平均寿命の延びとともに増えており、(　　)。",
        "(3) 老化がさらに進行すると、運動機能などが低下していくことは避けられないが、(　　)。",
      ],
      options: {
        "A": "自立して生活を送ることができる心身の能力があるかどうかだ",
        "B": "ややもすると「社会から活力が失われた」とネガティブな見方をする人もいる",
        "C": "このような人は高齢者に望ましい健康状態は何かを理解していない",
        "D": "それでもなお適切な支援を得て自立した生活を送る人は多い",
        "E": "今後は自立した日常生活を送れる人が社会の大部分を占めることになる",
      },
      correctOrder: ["A", "E", "D"],
      explanation: "大事なのはA。高齢者が増えて「大部分を占める(E)」。低下しても「自立を送る人は多い(D)」。",
    ),
  ];

  Future<List<ThreeSentenceProblem>> generateProblems(int count) async {
    List<ThreeSentenceProblem> shuffled = List.from(_allProblems)..shuffle(_rand);
    return shuffled.take(count).toList();
  }

  // 誤答パターンの生成
  // 条件: 選択肢A-Eから3つ選ぶ。重複なし。正解と同じ並びはNG。
  List<List<String>> generateWrongOptions(List<String> correct, int count) {
    List<List<String>> wrongs = [];
    List<String> symbols = ["A", "B", "C", "D", "E"];
    
    // 全順列 (5P3 = 60通り) から選ぶのが理想だが、ランダム生成で十分
    while (wrongs.length < count) {
      List<String> wrong = List.from(symbols)..shuffle(_rand);
      wrong = wrong.take(3).toList(); // 3つ選ぶ
      
      // 正解と一致しないかチェック
      if (wrong.toString() == correct.toString()) continue;
      
      // 重複チェック
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
