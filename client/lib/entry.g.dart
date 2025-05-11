// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vocabulary _$VocabularyFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id']);
  return Vocabulary(
    json['id'] as String,
    (json['kanji'] as List<dynamic>)
        .map((e) => JKanji.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['sense'] as List<dynamic>)
        .map((e) => JSense.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['kana'] as List<dynamic>)
        .map((e) => Reading.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$VocabularyToJson(Vocabulary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kanji': instance.kanjis.map((e) => e.toJson()).toList(),
      'sense': instance.senses.map((e) => e.toJson()).toList(),
      'kana': instance.kana.map((e) => e.toJson()).toList(),
    };

JKanji _$JKanjiFromJson(Map<String, dynamic> json) => JKanji(
  json['common'] as bool,
  (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  json['text'] as String,
);

Map<String, dynamic> _$JKanjiToJson(JKanji instance) => <String, dynamic>{
  'common': instance.common,
  'tags': instance.tags,
  'text': instance.text,
};

JGloss _$JGlossFromJson(Map<String, dynamic> json) => JGloss(
  json['gender'] as String? ?? '',
  json['text'] as String,
  json['lang'] as String,
  json['type'] as String? ?? '',
);

Map<String, dynamic> _$JGlossToJson(JGloss instance) => <String, dynamic>{
  'gender': instance.gender,
  'text': instance.text,
  'lang': instance.lang,
  'type': instance.type,
};

Reading _$ReadingFromJson(Map<String, dynamic> json) => Reading(
  (json['appliesToKanji'] as List<dynamic>).map((e) => e as String).toList(),
  json['text'] as String,
  json['common'] as bool,
  (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ReadingToJson(Reading instance) => <String, dynamic>{
  'appliesToKanji': instance.appliesToKanji,
  'text': instance.text,
  'common': instance.common,
  'tags': instance.tags,
};

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
  json['wasei'] as bool,
  json['full'] as bool,
  json['lang'] as String,
  json['text'] as String? ?? '',
);

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
  'wasei': instance.waseieigo,
  'full': instance.full,
  'lang': instance.lang,
  'text': instance.text,
};

JSense _$JSenseFromJson(Map<String, dynamic> json) => JSense(
  json['antonym'] as List<dynamic>,
  (json['appliesToKanji'] as List<dynamic>).map((e) => e as String).toList(),
  (json['appliesToKana'] as List<dynamic>).map((e) => e as String).toList(),
  (json['dialect'] as List<dynamic>).map((e) => e as String).toList(),
  (json['field'] as List<dynamic>).map((e) => e as String).toList(),
  (json['gloss'] as List<dynamic>)
      .map((e) => JGloss.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['info'] as List<dynamic>).map((e) => e as String).toList(),
  (json['languageSource'] as List<dynamic>)
      .map((e) => Language.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['misc'] as List<dynamic>).map((e) => e as String).toList(),
  (json['partOfSpeech'] as List<dynamic>).map((e) => e as String).toList(),
  json['related'] as List<dynamic>,
);

Map<String, dynamic> _$JSenseToJson(JSense instance) => <String, dynamic>{
  'antonym': instance.antonym,
  'appliesToKanji': instance.appliesToKanji,
  'appliesToKana': instance.appliesToKana,
  'dialect': instance.dialect,
  'field': instance.subject,
  'gloss': instance.meaning.map((e) => e.toJson()).toList(),
  'info': instance.info,
  'languageSource': instance.languageSource.map((e) => e.toJson()).toList(),
  'misc': instance.misc,
  'partOfSpeech': instance.partOfSpeech,
  'related': instance.related,
};
