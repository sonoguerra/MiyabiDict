class JPUtils {

  //Added obsolete kana too because you never know.

  static Map<String, String> romajiMapping = {
    'あ': 'a', 'ア': 'a', 'い': 'i', 'う': 'u', 'え': 'e', 'ウ': 'u', 'エ': 'e', 'お': 'o', 'オ': 'o', 'イ': 'i',
    'か': 'ka', 'カ': 'ka', 'き': 'ki', 'キ': 'ki', 'く': 'ku', 'ク': 'ku', 'け': 'ke', 'ケ': 'ke', 'こ': 'ko', 'コ': 'ko',
    'さ': 'sa', 'サ': 'sa', 'し': 'shi', 'シ': 'shi', 'す': 'su', 'ス': 'su', 'せ': 'se', 'セ': 'se', 'そ': 'so', 'ソ': 'so',
    'な': 'na', 'ナ': 'na', 'に': 'ni', 'ニ': 'ni', 'ぬ': 'nu', 'ヌ': 'nu', 'ね': 'ne', 'ネ': 'ne', 'の': 'no', 'ノ': 'no',
    'ま': 'ma', 'マ': 'ma', 'み': 'mi', 'ミ': 'mi', 'む': 'mu', 'ム': 'mu', 'め': 'me', 'メ': 'me', 'も': 'mo', 'モ': 'mo',
    'や': 'ya', 'ヤ': 'ya', 'ゆ': 'yu', 'ユ': 'yu', 'よ': 'yo', 'ヨ': 'yo',
    'ち': 'chi', 'チ': 'chi', 'た': 'ta', 'タ': 'ta', 'つ': 'tsu', 'ツ': 'tsu', 'て': 'te', 'テ': 'te', 'と': 'to', 'ト': 'to',
    'は': 'ha', 'ひ': 'hi', 'へ': 'he', 'ほ': 'ho',  'ふ': 'fu', 'ハ': 'ha', 'ヒ': 'hi', 'ヘ': 'he', 'ホ': 'ho',  'フ': 'fu',
    'ら': 'ra', 'ラ': 'ra', 'り': 'ri', 'リ': 'ri', 'る': 'ru', 'ル': 'ru', 'れ': 're', 'レ': 're', 'ろ': 'ro', 'ロ': 'ro',
    'わ': 'wa', 'ワ': 'wa', 'ゐ': 'wi', 'ヰ': 'wi', 'ゑ': 'we', 'ヱ': 'we', 'を': 'wo', 'ヲ': 'wo', 'ん': 'n', 'ン': 'n',
    'ぢ': 'dji', 'ヂ': 'dji', 'だ': 'da', 'ダ': 'da', 'づ': 'dzu', 'で': 'de', 'ど': 'do', 'ヅ': 'dzu', 'デ': 'de', 'ド': 'do',
    'が': 'ga', 'ぎ': 'gi', 'ぐ': 'gu', 'げ': 'ge', 'ご': 'go', 'ガ': 'ga', 'ギ': 'gi', 'グ': 'gu', 'ゲ': 'ge', 'ゴ': 'go',
    'ば': 'ba', 'び': 'bi', 'ぶ': 'bu', 'べ': 'be', 'ぼ': 'bo', 'バ': 'ba', 'ビ': 'bi', 'ブ': 'bu', 'ベ': 'be', 'ボ': 'bo',
    'ぱ': 'pa', 'ぴ': 'pi', 'ぷ': 'pu', 'ぺ': 'pe', 'ぽ': 'po', 'パ': 'pa', 'ピ': 'pi', 'プ': 'pu', 'ペ': 'pe', 'ポ': 'po',
    'ざ': 'za', 'じ': 'ji', 'ず': 'zu', 'ぜ': 'ze', 'ぞ': 'zo', 'ザ': 'za', 'ジ': 'ji', 'ズ': 'zu', 'ゼ': 'ze', 'ゾ': 'zo',
  };

  static Map<String, String> sentences = {
    "Nice weather today": "今日はいい天気ですね",
    "Going to far to turn back": "乗り掛かった舟",
    "Prevention is better than curing": "転ばぬ先の杖",
    "Like father, like son": "カエルの子はカエル",
    "Some things are better left unsaid": "言わぬが花",
    "Hard to see what is under your nose": "灯台もと暗し"
  };

}