import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@JsonSerializable(explicitToJson: true)
class Vocabulary {

  @JsonKey(required: true)
  final String id;

  @JsonKey(name: "kanji")
  final List<JKanji> kanjis;

  @JsonKey(name: "sense")
  final List<JSense> senses;
  final List<Reading> kana;

  Vocabulary(this.id, this.kanjis, this.senses, this.kana);

  String get word => (kanjis.isNotEmpty && kanjis[0].common) ? kanjis[0].text : kana[0].text;
  String get mainReading => kana[0].text;

  List<String> listViewElements() => [word, (word == mainReading ? "" : mainReading), _compactGlosses()];

  String _compactGlosses() {
    List elements = [];
    for (int i = 0; i < senses.length; i++) {
      elements.add(senses[i].meaning[0].text);
    }
    return elements.join('; ');
  }

  factory Vocabulary.fromJson(Map<String, dynamic> json) => _$VocabularyFromJson(json);
  
  Map<String, dynamic> toJson() => _$VocabularyToJson(this);

}


@JsonSerializable(explicitToJson: true)
class JKanji {
  final bool common;
  final List<String> tags;
  final String text;

  JKanji(this.common, this.tags, this.text);

  factory JKanji.fromJson(Map<String, dynamic> json) => _$JKanjiFromJson(json);
  
  Map<String, dynamic> toJson() => _$JKanjiToJson(this);

}

@JsonSerializable(explicitToJson: true)
class JGloss {
  @JsonKey(defaultValue: "")
  final String gender;
  final String text;
  final String lang;
  @JsonKey(defaultValue: "")
  final String type;

  JGloss(this.gender, this.text, this.lang, this.type);

  factory JGloss.fromJson(Map<String, dynamic> json) => _$JGlossFromJson(json);
  
  Map<String, dynamic> toJson() => _$JGlossToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Reading {
  final List<String> appliesToKanji;
  final String text;
  final bool common;
  final List<String> tags;

  Reading(this.appliesToKanji, this.text, this.common, this.tags);

  factory Reading.fromJson(Map<String, dynamic> json) => _$ReadingFromJson(json);
  
  Map<String, dynamic> toJson() => _$ReadingToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Language {
  @JsonKey(name: "wasei")
  final bool waseieigo;
  final bool full;
  final String lang;
  @JsonKey(defaultValue: "")
  final String text;

  Language(this.waseieigo, this.full, this.lang, this.text);

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
  
  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JSense {
  final List<dynamic> antonym;
  final List<String> appliesToKanji;
  final List<String> appliesToKana;
  final List<String> dialect;

  @JsonKey(name: "field")
  final List<String> subject;

  @JsonKey(name: "gloss")
  final List<JGloss> meaning;
  
  final List<String> info;
  final List<Language> languageSource;
  final List<String> misc;
  final List<String> partOfSpeech;
  final List<dynamic> related;

  String get glosses {
    List<String> elements = [];
    for (int i = 0; i < meaning.length; i++) {
      elements.add(meaning[i].text);
    }
    return elements.join(" | ");
  }

  JSense(this.antonym, this.appliesToKanji, this.appliesToKana, this.dialect, this.subject, this.meaning, this.info, this.languageSource, this.misc, this.partOfSpeech, this.related);

  factory JSense.fromJson(Map<String, dynamic> json) => _$JSenseFromJson(json);
  Map<String, dynamic> toJson() => _$JSenseToJson(this);
}
