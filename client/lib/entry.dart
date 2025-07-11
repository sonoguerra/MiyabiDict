import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

//Maps JMdict simplified results according to documentation. Some attributes have been renamed for better semantic coherence.
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

  //word corresponds to the first kanji, if common, otherwise to the first kana reading.
  String get word => (kanjis.isNotEmpty && kanjis[0].common) ? kanjis[0].text : kana[0].text;
  String get mainReading => kana[0].text;

  //This method pairs kanji variants with corresponding readings (+ standalone kana)
  List<String> get forms {
    Set<String> res = {};
    for (int i = 0; i < kanjis.length; i++) {
      String variant = "${kanjis[i].text} (";
      List<String> readings = [];
      for (int j = 0; j < kana.length; j++) {
        if (kana[j].appliesToKanji.contains('*') || kana[j].appliesToKanji.contains(kanjis[i].text)) {
          readings.add(kana[j].text);
        }
        else if (kana[j].appliesToKanji.isEmpty) {
          res.add(kana[j].text);
        }
      }
      variant += "${readings.join(',')})";
      res.add(variant);
    }
    return res.toList();
  }

  //Gets all pieces of related information (tags)
  Set<String> get allTags {
    Set<String> res = {};
    for (int i = 0; i < kanjis.length; i++) {
      res.addAll(kanjis[i].tags);
    }
    for (int i = 0; i < kana.length; i++) {
      res.addAll(kana[i].tags);
    }
    for (int i = 0; i < senses.length; i++) {
      res.addAll(senses[i].tags);
    }
    return res;
  }

  //Compact view that exposes only the elements to be displayed in the dictionary results view.
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
  final List<String> info;

  @JsonKey(name: "field")
  final List<String> subject;

  @JsonKey(name: "gloss")
  final List<JGloss> meaning;
  
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

  List<String> get tags {
    List<String> elements = [];
    elements.addAll(partOfSpeech);
    elements.addAll(subject);
    elements.addAll(dialect);
    elements.addAll(misc);
    return elements;
  }

  JSense(this.antonym, this.appliesToKanji, this.appliesToKana, this.dialect, this.subject, this.meaning, this.info, this.languageSource, this.misc, this.partOfSpeech, this.related);

  factory JSense.fromJson(Map<String, dynamic> json) => _$JSenseFromJson(json);

  Map<String, dynamic> toJson() => _$JSenseToJson(this);
  
}
