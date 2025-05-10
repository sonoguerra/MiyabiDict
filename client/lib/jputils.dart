class JPUtils {

  //There might be a better way to do this but for now we'll keep this hardcoded. Added obsolete kana too because you never know.

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

  static String toRomaji(String kanaword) {
    String romaji = '';
    bool sokuon = false;
    //TODO parole che contengono le vocali piccole
    for (int i = 0; i < kanaword.length; i++) {
      //Pronunciation of this character depends on what follows so we can't know beforehand.
      if (kanaword[i] != 'っ' && kanaword[i] != 'ッ') {
        var reading = romajiMapping[kanaword[i]]!;
        if (sokuon) {
          romaji += reading[0];
        }
        romaji += reading;  
      } else {
        sokuon = true;
      }
    }
    return romaji;
  }
}