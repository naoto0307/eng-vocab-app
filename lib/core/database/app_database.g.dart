// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE COLLATE NOCASE',
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleEnMeta = const VerificationMeta(
    'exampleEn',
  );
  @override
  late final GeneratedColumn<String> exampleEn = GeneratedColumn<String>(
    'example_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleJaMeta = const VerificationMeta(
    'exampleJa',
  );
  @override
  late final GeneratedColumn<String> exampleJa = GeneratedColumn<String>(
    'example_ja',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> synonyms =
      GeneratedColumn<String>(
        'synonyms',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($WordsTable.$convertersynonyms);
  static const VerificationMeta _etymologyMeta = const VerificationMeta(
    'etymology',
  );
  @override
  late final GeneratedColumn<String> etymology = GeneratedColumn<String>(
    'etymology',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioWordUrlMeta = const VerificationMeta(
    'audioWordUrl',
  );
  @override
  late final GeneratedColumn<String> audioWordUrl = GeneratedColumn<String>(
    'audio_word_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioExampleUrlMeta = const VerificationMeta(
    'audioExampleUrl',
  );
  @override
  late final GeneratedColumn<String> audioExampleUrl = GeneratedColumn<String>(
    'audio_example_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($WordsTable.$convertertags);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WordSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WordSource>($WordsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<WordStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WordStatus>($WordsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    word,
    meaning,
    exampleEn,
    exampleJa,
    synonyms,
    etymology,
    audioWordUrl,
    audioExampleUrl,
    imageUrl,
    tags,
    createdAt,
    source,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('example_en')) {
      context.handle(
        _exampleEnMeta,
        exampleEn.isAcceptableOrUnknown(data['example_en']!, _exampleEnMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleEnMeta);
    }
    if (data.containsKey('example_ja')) {
      context.handle(
        _exampleJaMeta,
        exampleJa.isAcceptableOrUnknown(data['example_ja']!, _exampleJaMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleJaMeta);
    }
    if (data.containsKey('etymology')) {
      context.handle(
        _etymologyMeta,
        etymology.isAcceptableOrUnknown(data['etymology']!, _etymologyMeta),
      );
    }
    if (data.containsKey('audio_word_url')) {
      context.handle(
        _audioWordUrlMeta,
        audioWordUrl.isAcceptableOrUnknown(
          data['audio_word_url']!,
          _audioWordUrlMeta,
        ),
      );
    }
    if (data.containsKey('audio_example_url')) {
      context.handle(
        _audioExampleUrlMeta,
        audioExampleUrl.isAcceptableOrUnknown(
          data['audio_example_url']!,
          _audioExampleUrlMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
      exampleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_en'],
      )!,
      exampleJa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_ja'],
      )!,
      synonyms: $WordsTable.$convertersynonyms.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}synonyms'],
        )!,
      ),
      etymology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etymology'],
      ),
      audioWordUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_word_url'],
      ),
      audioExampleUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_example_url'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      tags: $WordsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      source: $WordsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      status: $WordsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertersynonyms =
      const StringListConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
  static JsonTypeConverter2<WordSource, String, String> $convertersource =
      const EnumNameConverter<WordSource>(WordSource.values);
  static JsonTypeConverter2<WordStatus, String, String> $converterstatus =
      const EnumNameConverter<WordStatus>(WordStatus.values);
}

class Word extends DataClass implements Insertable<Word> {
  final String id;
  final String word;
  final String meaning;
  final String exampleEn;
  final String exampleJa;
  final List<String> synonyms;
  final String? etymology;
  final String? audioWordUrl;
  final String? audioExampleUrl;
  final String? imageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final WordSource source;
  final WordStatus status;
  const Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleEn,
    required this.exampleJa,
    required this.synonyms,
    this.etymology,
    this.audioWordUrl,
    this.audioExampleUrl,
    this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.source,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word'] = Variable<String>(word);
    map['meaning'] = Variable<String>(meaning);
    map['example_en'] = Variable<String>(exampleEn);
    map['example_ja'] = Variable<String>(exampleJa);
    {
      map['synonyms'] = Variable<String>(
        $WordsTable.$convertersynonyms.toSql(synonyms),
      );
    }
    if (!nullToAbsent || etymology != null) {
      map['etymology'] = Variable<String>(etymology);
    }
    if (!nullToAbsent || audioWordUrl != null) {
      map['audio_word_url'] = Variable<String>(audioWordUrl);
    }
    if (!nullToAbsent || audioExampleUrl != null) {
      map['audio_example_url'] = Variable<String>(audioExampleUrl);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    {
      map['tags'] = Variable<String>($WordsTable.$convertertags.toSql(tags));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['source'] = Variable<String>(
        $WordsTable.$convertersource.toSql(source),
      );
    }
    {
      map['status'] = Variable<String>(
        $WordsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      word: Value(word),
      meaning: Value(meaning),
      exampleEn: Value(exampleEn),
      exampleJa: Value(exampleJa),
      synonyms: Value(synonyms),
      etymology: etymology == null && nullToAbsent
          ? const Value.absent()
          : Value(etymology),
      audioWordUrl: audioWordUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioWordUrl),
      audioExampleUrl: audioExampleUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioExampleUrl),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      tags: Value(tags),
      createdAt: Value(createdAt),
      source: Value(source),
      status: Value(status),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<String>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      meaning: serializer.fromJson<String>(json['meaning']),
      exampleEn: serializer.fromJson<String>(json['exampleEn']),
      exampleJa: serializer.fromJson<String>(json['exampleJa']),
      synonyms: serializer.fromJson<List<String>>(json['synonyms']),
      etymology: serializer.fromJson<String?>(json['etymology']),
      audioWordUrl: serializer.fromJson<String?>(json['audioWordUrl']),
      audioExampleUrl: serializer.fromJson<String?>(json['audioExampleUrl']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      source: $WordsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      status: $WordsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'word': serializer.toJson<String>(word),
      'meaning': serializer.toJson<String>(meaning),
      'exampleEn': serializer.toJson<String>(exampleEn),
      'exampleJa': serializer.toJson<String>(exampleJa),
      'synonyms': serializer.toJson<List<String>>(synonyms),
      'etymology': serializer.toJson<String?>(etymology),
      'audioWordUrl': serializer.toJson<String?>(audioWordUrl),
      'audioExampleUrl': serializer.toJson<String?>(audioExampleUrl),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'tags': serializer.toJson<List<String>>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'source': serializer.toJson<String>(
        $WordsTable.$convertersource.toJson(source),
      ),
      'status': serializer.toJson<String>(
        $WordsTable.$converterstatus.toJson(status),
      ),
    };
  }

  Word copyWith({
    String? id,
    String? word,
    String? meaning,
    String? exampleEn,
    String? exampleJa,
    List<String>? synonyms,
    Value<String?> etymology = const Value.absent(),
    Value<String?> audioWordUrl = const Value.absent(),
    Value<String?> audioExampleUrl = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    List<String>? tags,
    DateTime? createdAt,
    WordSource? source,
    WordStatus? status,
  }) => Word(
    id: id ?? this.id,
    word: word ?? this.word,
    meaning: meaning ?? this.meaning,
    exampleEn: exampleEn ?? this.exampleEn,
    exampleJa: exampleJa ?? this.exampleJa,
    synonyms: synonyms ?? this.synonyms,
    etymology: etymology.present ? etymology.value : this.etymology,
    audioWordUrl: audioWordUrl.present ? audioWordUrl.value : this.audioWordUrl,
    audioExampleUrl: audioExampleUrl.present
        ? audioExampleUrl.value
        : this.audioExampleUrl,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
    source: source ?? this.source,
    status: status ?? this.status,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      exampleEn: data.exampleEn.present ? data.exampleEn.value : this.exampleEn,
      exampleJa: data.exampleJa.present ? data.exampleJa.value : this.exampleJa,
      synonyms: data.synonyms.present ? data.synonyms.value : this.synonyms,
      etymology: data.etymology.present ? data.etymology.value : this.etymology,
      audioWordUrl: data.audioWordUrl.present
          ? data.audioWordUrl.value
          : this.audioWordUrl,
      audioExampleUrl: data.audioExampleUrl.present
          ? data.audioExampleUrl.value
          : this.audioExampleUrl,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('meaning: $meaning, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleJa: $exampleJa, ')
          ..write('synonyms: $synonyms, ')
          ..write('etymology: $etymology, ')
          ..write('audioWordUrl: $audioWordUrl, ')
          ..write('audioExampleUrl: $audioExampleUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('source: $source, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    word,
    meaning,
    exampleEn,
    exampleJa,
    synonyms,
    etymology,
    audioWordUrl,
    audioExampleUrl,
    imageUrl,
    tags,
    createdAt,
    source,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.word == this.word &&
          other.meaning == this.meaning &&
          other.exampleEn == this.exampleEn &&
          other.exampleJa == this.exampleJa &&
          other.synonyms == this.synonyms &&
          other.etymology == this.etymology &&
          other.audioWordUrl == this.audioWordUrl &&
          other.audioExampleUrl == this.audioExampleUrl &&
          other.imageUrl == this.imageUrl &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.source == this.source &&
          other.status == this.status);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<String> id;
  final Value<String> word;
  final Value<String> meaning;
  final Value<String> exampleEn;
  final Value<String> exampleJa;
  final Value<List<String>> synonyms;
  final Value<String?> etymology;
  final Value<String?> audioWordUrl;
  final Value<String?> audioExampleUrl;
  final Value<String?> imageUrl;
  final Value<List<String>> tags;
  final Value<DateTime> createdAt;
  final Value<WordSource> source;
  final Value<WordStatus> status;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.meaning = const Value.absent(),
    this.exampleEn = const Value.absent(),
    this.exampleJa = const Value.absent(),
    this.synonyms = const Value.absent(),
    this.etymology = const Value.absent(),
    this.audioWordUrl = const Value.absent(),
    this.audioExampleUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String word,
    required String meaning,
    required String exampleEn,
    required String exampleJa,
    this.synonyms = const Value.absent(),
    this.etymology = const Value.absent(),
    this.audioWordUrl = const Value.absent(),
    this.audioExampleUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    required WordSource source,
    required WordStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       word = Value(word),
       meaning = Value(meaning),
       exampleEn = Value(exampleEn),
       exampleJa = Value(exampleJa),
       source = Value(source),
       status = Value(status);
  static Insertable<Word> custom({
    Expression<String>? id,
    Expression<String>? word,
    Expression<String>? meaning,
    Expression<String>? exampleEn,
    Expression<String>? exampleJa,
    Expression<String>? synonyms,
    Expression<String>? etymology,
    Expression<String>? audioWordUrl,
    Expression<String>? audioExampleUrl,
    Expression<String>? imageUrl,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<String>? source,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (meaning != null) 'meaning': meaning,
      if (exampleEn != null) 'example_en': exampleEn,
      if (exampleJa != null) 'example_ja': exampleJa,
      if (synonyms != null) 'synonyms': synonyms,
      if (etymology != null) 'etymology': etymology,
      if (audioWordUrl != null) 'audio_word_url': audioWordUrl,
      if (audioExampleUrl != null) 'audio_example_url': audioExampleUrl,
      if (imageUrl != null) 'image_url': imageUrl,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith({
    Value<String>? id,
    Value<String>? word,
    Value<String>? meaning,
    Value<String>? exampleEn,
    Value<String>? exampleJa,
    Value<List<String>>? synonyms,
    Value<String?>? etymology,
    Value<String?>? audioWordUrl,
    Value<String?>? audioExampleUrl,
    Value<String?>? imageUrl,
    Value<List<String>>? tags,
    Value<DateTime>? createdAt,
    Value<WordSource>? source,
    Value<WordStatus>? status,
    Value<int>? rowid,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      exampleEn: exampleEn ?? this.exampleEn,
      exampleJa: exampleJa ?? this.exampleJa,
      synonyms: synonyms ?? this.synonyms,
      etymology: etymology ?? this.etymology,
      audioWordUrl: audioWordUrl ?? this.audioWordUrl,
      audioExampleUrl: audioExampleUrl ?? this.audioExampleUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      source: source ?? this.source,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (exampleEn.present) {
      map['example_en'] = Variable<String>(exampleEn.value);
    }
    if (exampleJa.present) {
      map['example_ja'] = Variable<String>(exampleJa.value);
    }
    if (synonyms.present) {
      map['synonyms'] = Variable<String>(
        $WordsTable.$convertersynonyms.toSql(synonyms.value),
      );
    }
    if (etymology.present) {
      map['etymology'] = Variable<String>(etymology.value);
    }
    if (audioWordUrl.present) {
      map['audio_word_url'] = Variable<String>(audioWordUrl.value);
    }
    if (audioExampleUrl.present) {
      map['audio_example_url'] = Variable<String>(audioExampleUrl.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $WordsTable.$convertertags.toSql(tags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $WordsTable.$convertersource.toSql(source.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WordsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('meaning: $meaning, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleJa: $exampleJa, ')
          ..write('synonyms: $synonyms, ')
          ..write('etymology: $etymology, ')
          ..write('audioWordUrl: $audioWordUrl, ')
          ..write('audioExampleUrl: $audioExampleUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudySessionsTable extends StudySessions
    with TableInfo<$StudySessionsTable, StudySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    wordCount,
    accuracy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      )!,
    );
  }

  @override
  $StudySessionsTable createAlias(String alias) {
    return $StudySessionsTable(attachedDatabase, alias);
  }
}

class StudySession extends DataClass implements Insertable<StudySession> {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int wordCount;
  final double accuracy;
  const StudySession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.wordCount,
    required this.accuracy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['word_count'] = Variable<int>(wordCount);
    map['accuracy'] = Variable<double>(accuracy);
    return map;
  }

  StudySessionsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      wordCount: Value(wordCount),
      accuracy: Value(accuracy),
    );
  }

  factory StudySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySession(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'wordCount': serializer.toJson<int>(wordCount),
      'accuracy': serializer.toJson<double>(accuracy),
    };
  }

  StudySession copyWith({
    String? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? wordCount,
    double? accuracy,
  }) => StudySession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    wordCount: wordCount ?? this.wordCount,
    accuracy: accuracy ?? this.accuracy,
  );
  StudySession copyWithCompanion(StudySessionsCompanion data) {
    return StudySession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('wordCount: $wordCount, ')
          ..write('accuracy: $accuracy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, wordCount, accuracy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.wordCount == this.wordCount &&
          other.accuracy == this.accuracy);
}

class StudySessionsCompanion extends UpdateCompanion<StudySession> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> wordCount;
  final Value<double> accuracy;
  final Value<int> rowid;
  const StudySessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionsCompanion.insert({
    required String id,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt);
  static Insertable<StudySession> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? wordCount,
    Expression<double>? accuracy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (wordCount != null) 'word_count': wordCount,
      if (accuracy != null) 'accuracy': accuracy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? wordCount,
    Value<double>? accuracy,
    Value<int>? rowid,
  }) {
    return StudySessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      wordCount: wordCount ?? this.wordCount,
      accuracy: accuracy ?? this.accuracy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('wordCount: $wordCount, ')
          ..write('accuracy: $accuracy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyLogsTable extends StudyLogs
    with TableInfo<$StudyLogsTable, StudyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _studiedAtMeta = const VerificationMeta(
    'studiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> studiedAt = GeneratedColumn<DateTime>(
    'studied_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StudyResult, String> result =
      GeneratedColumn<String>(
        'result',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StudyResult>($StudyLogsTable.$converterresult);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_sessions (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    studiedAt,
    result,
    sessionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('studied_at')) {
      context.handle(
        _studiedAtMeta,
        studiedAt.isAcceptableOrUnknown(data['studied_at']!, _studiedAtMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      studiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}studied_at'],
      )!,
      result: $StudyLogsTable.$converterresult.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}result'],
        )!,
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
    );
  }

  @override
  $StudyLogsTable createAlias(String alias) {
    return $StudyLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StudyResult, String, String> $converterresult =
      const EnumNameConverter<StudyResult>(StudyResult.values);
}

class StudyLog extends DataClass implements Insertable<StudyLog> {
  final String id;
  final String wordId;
  final DateTime studiedAt;
  final StudyResult result;
  final String sessionId;
  const StudyLog({
    required this.id,
    required this.wordId,
    required this.studiedAt,
    required this.result,
    required this.sessionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word_id'] = Variable<String>(wordId);
    map['studied_at'] = Variable<DateTime>(studiedAt);
    {
      map['result'] = Variable<String>(
        $StudyLogsTable.$converterresult.toSql(result),
      );
    }
    map['session_id'] = Variable<String>(sessionId);
    return map;
  }

  StudyLogsCompanion toCompanion(bool nullToAbsent) {
    return StudyLogsCompanion(
      id: Value(id),
      wordId: Value(wordId),
      studiedAt: Value(studiedAt),
      result: Value(result),
      sessionId: Value(sessionId),
    );
  }

  factory StudyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyLog(
      id: serializer.fromJson<String>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      studiedAt: serializer.fromJson<DateTime>(json['studiedAt']),
      result: $StudyLogsTable.$converterresult.fromJson(
        serializer.fromJson<String>(json['result']),
      ),
      sessionId: serializer.fromJson<String>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wordId': serializer.toJson<String>(wordId),
      'studiedAt': serializer.toJson<DateTime>(studiedAt),
      'result': serializer.toJson<String>(
        $StudyLogsTable.$converterresult.toJson(result),
      ),
      'sessionId': serializer.toJson<String>(sessionId),
    };
  }

  StudyLog copyWith({
    String? id,
    String? wordId,
    DateTime? studiedAt,
    StudyResult? result,
    String? sessionId,
  }) => StudyLog(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    studiedAt: studiedAt ?? this.studiedAt,
    result: result ?? this.result,
    sessionId: sessionId ?? this.sessionId,
  );
  StudyLog copyWithCompanion(StudyLogsCompanion data) {
    return StudyLog(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      studiedAt: data.studiedAt.present ? data.studiedAt.value : this.studiedAt,
      result: data.result.present ? data.result.value : this.result,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyLog(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('studiedAt: $studiedAt, ')
          ..write('result: $result, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, studiedAt, result, sessionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyLog &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.studiedAt == this.studiedAt &&
          other.result == this.result &&
          other.sessionId == this.sessionId);
}

class StudyLogsCompanion extends UpdateCompanion<StudyLog> {
  final Value<String> id;
  final Value<String> wordId;
  final Value<DateTime> studiedAt;
  final Value<StudyResult> result;
  final Value<String> sessionId;
  final Value<int> rowid;
  const StudyLogsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.studiedAt = const Value.absent(),
    this.result = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyLogsCompanion.insert({
    required String id,
    required String wordId,
    this.studiedAt = const Value.absent(),
    required StudyResult result,
    required String sessionId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wordId = Value(wordId),
       result = Value(result),
       sessionId = Value(sessionId);
  static Insertable<StudyLog> custom({
    Expression<String>? id,
    Expression<String>? wordId,
    Expression<DateTime>? studiedAt,
    Expression<String>? result,
    Expression<String>? sessionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (studiedAt != null) 'studied_at': studiedAt,
      if (result != null) 'result': result,
      if (sessionId != null) 'session_id': sessionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? wordId,
    Value<DateTime>? studiedAt,
    Value<StudyResult>? result,
    Value<String>? sessionId,
    Value<int>? rowid,
  }) {
    return StudyLogsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      studiedAt: studiedAt ?? this.studiedAt,
      result: result ?? this.result,
      sessionId: sessionId ?? this.sessionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (studiedAt.present) {
      map['studied_at'] = Variable<DateTime>(studiedAt.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(
        $StudyLogsTable.$converterresult.toSql(result.value),
      );
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyLogsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('studiedAt: $studiedAt, ')
          ..write('result: $result, ')
          ..write('sessionId: $sessionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  late final $StudySessionsTable studySessions = $StudySessionsTable(this);
  late final $StudyLogsTable studyLogs = $StudyLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    words,
    studySessions,
    studyLogs,
  ];
}

typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      required String id,
      required String word,
      required String meaning,
      required String exampleEn,
      required String exampleJa,
      Value<List<String>> synonyms,
      Value<String?> etymology,
      Value<String?> audioWordUrl,
      Value<String?> audioExampleUrl,
      Value<String?> imageUrl,
      Value<List<String>> tags,
      Value<DateTime> createdAt,
      required WordSource source,
      required WordStatus status,
      Value<int> rowid,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<String> id,
      Value<String> word,
      Value<String> meaning,
      Value<String> exampleEn,
      Value<String> exampleJa,
      Value<List<String>> synonyms,
      Value<String?> etymology,
      Value<String?> audioWordUrl,
      Value<String?> audioExampleUrl,
      Value<String?> imageUrl,
      Value<List<String>> tags,
      Value<DateTime> createdAt,
      Value<WordSource> source,
      Value<WordStatus> status,
      Value<int> rowid,
    });

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudyLogsTable, List<StudyLog>>
  _studyLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyLogs,
    aliasName: 'words__id__study_logs__word_id',
  );

  $$StudyLogsTableProcessedTableManager get studyLogsRefs {
    final manager = $$StudyLogsTableTableManager(
      $_db,
      $_db.studyLogs,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleEn => $composableBuilder(
    column: $table.exampleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleJa => $composableBuilder(
    column: $table.exampleJa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get synonyms => $composableBuilder(
    column: $table.synonyms,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get etymology => $composableBuilder(
    column: $table.etymology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioWordUrl => $composableBuilder(
    column: $table.audioWordUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioExampleUrl => $composableBuilder(
    column: $table.audioExampleUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WordSource, WordSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<WordStatus, WordStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> studyLogsRefs(
    Expression<bool> Function($$StudyLogsTableFilterComposer f) f,
  ) {
    final $$StudyLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyLogs,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyLogsTableFilterComposer(
            $db: $db,
            $table: $db.studyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleEn => $composableBuilder(
    column: $table.exampleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleJa => $composableBuilder(
    column: $table.exampleJa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get synonyms => $composableBuilder(
    column: $table.synonyms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etymology => $composableBuilder(
    column: $table.etymology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioWordUrl => $composableBuilder(
    column: $table.audioWordUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioExampleUrl => $composableBuilder(
    column: $table.audioExampleUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get exampleEn =>
      $composableBuilder(column: $table.exampleEn, builder: (column) => column);

  GeneratedColumn<String> get exampleJa =>
      $composableBuilder(column: $table.exampleJa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get synonyms =>
      $composableBuilder(column: $table.synonyms, builder: (column) => column);

  GeneratedColumn<String> get etymology =>
      $composableBuilder(column: $table.etymology, builder: (column) => column);

  GeneratedColumn<String> get audioWordUrl => $composableBuilder(
    column: $table.audioWordUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioExampleUrl => $composableBuilder(
    column: $table.audioExampleUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WordSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WordStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> studyLogsRefs<T extends Object>(
    Expression<T> Function($$StudyLogsTableAnnotationComposer a) f,
  ) {
    final $$StudyLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyLogs,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, $$WordsTableReferences),
          Word,
          PrefetchHooks Function({bool studyLogsRefs})
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> exampleEn = const Value.absent(),
                Value<String> exampleJa = const Value.absent(),
                Value<List<String>> synonyms = const Value.absent(),
                Value<String?> etymology = const Value.absent(),
                Value<String?> audioWordUrl = const Value.absent(),
                Value<String?> audioExampleUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<WordSource> source = const Value.absent(),
                Value<WordStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                word: word,
                meaning: meaning,
                exampleEn: exampleEn,
                exampleJa: exampleJa,
                synonyms: synonyms,
                etymology: etymology,
                audioWordUrl: audioWordUrl,
                audioExampleUrl: audioExampleUrl,
                imageUrl: imageUrl,
                tags: tags,
                createdAt: createdAt,
                source: source,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String word,
                required String meaning,
                required String exampleEn,
                required String exampleJa,
                Value<List<String>> synonyms = const Value.absent(),
                Value<String?> etymology = const Value.absent(),
                Value<String?> audioWordUrl = const Value.absent(),
                Value<String?> audioExampleUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required WordSource source,
                required WordStatus status,
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                word: word,
                meaning: meaning,
                exampleEn: exampleEn,
                exampleJa: exampleJa,
                synonyms: synonyms,
                etymology: etymology,
                audioWordUrl: audioWordUrl,
                audioExampleUrl: audioExampleUrl,
                imageUrl: imageUrl,
                tags: tags,
                createdAt: createdAt,
                source: source,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$WordsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({studyLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (studyLogsRefs) db.studyLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studyLogsRefs)
                    await $_getPrefetchedData<Word, $WordsTable, StudyLog>(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._studyLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WordsTableReferences(db, table, p0).studyLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, $$WordsTableReferences),
      Word,
      PrefetchHooks Function({bool studyLogsRefs})
    >;
typedef $$StudySessionsTableCreateCompanionBuilder =
    StudySessionsCompanion Function({
      required String id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> wordCount,
      Value<double> accuracy,
      Value<int> rowid,
    });
typedef $$StudySessionsTableUpdateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> wordCount,
      Value<double> accuracy,
      Value<int> rowid,
    });

final class $$StudySessionsTableReferences
    extends BaseReferences<_$AppDatabase, $StudySessionsTable, StudySession> {
  $$StudySessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$StudyLogsTable, List<StudyLog>>
  _studyLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyLogs,
    aliasName: 'study_sessions__id__study_logs__session_id',
  );

  $$StudyLogsTableProcessedTableManager get studyLogsRefs {
    final manager = $$StudyLogsTableTableManager(
      $_db,
      $_db.studyLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studyLogsRefs(
    Expression<bool> Function($$StudyLogsTableFilterComposer f) f,
  ) {
    final $$StudyLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyLogsTableFilterComposer(
            $db: $db,
            $table: $db.studyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  Expression<T> studyLogsRefs<T extends Object>(
    Expression<T> Function($$StudyLogsTableAnnotationComposer a) f,
  ) {
    final $$StudyLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionsTable,
          StudySession,
          $$StudySessionsTableFilterComposer,
          $$StudySessionsTableOrderingComposer,
          $$StudySessionsTableAnnotationComposer,
          $$StudySessionsTableCreateCompanionBuilder,
          $$StudySessionsTableUpdateCompanionBuilder,
          (StudySession, $$StudySessionsTableReferences),
          StudySession,
          PrefetchHooks Function({bool studyLogsRefs})
        > {
  $$StudySessionsTableTableManager(_$AppDatabase db, $StudySessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<double> accuracy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudySessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                wordCount: wordCount,
                accuracy: accuracy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<double> accuracy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudySessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                wordCount: wordCount,
                accuracy: accuracy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudySessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studyLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (studyLogsRefs) db.studyLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studyLogsRefs)
                    await $_getPrefetchedData<
                      StudySession,
                      $StudySessionsTable,
                      StudyLog
                    >(
                      currentTable: table,
                      referencedTable: $$StudySessionsTableReferences
                          ._studyLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StudySessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).studyLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StudySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionsTable,
      StudySession,
      $$StudySessionsTableFilterComposer,
      $$StudySessionsTableOrderingComposer,
      $$StudySessionsTableAnnotationComposer,
      $$StudySessionsTableCreateCompanionBuilder,
      $$StudySessionsTableUpdateCompanionBuilder,
      (StudySession, $$StudySessionsTableReferences),
      StudySession,
      PrefetchHooks Function({bool studyLogsRefs})
    >;
typedef $$StudyLogsTableCreateCompanionBuilder =
    StudyLogsCompanion Function({
      required String id,
      required String wordId,
      Value<DateTime> studiedAt,
      required StudyResult result,
      required String sessionId,
      Value<int> rowid,
    });
typedef $$StudyLogsTableUpdateCompanionBuilder =
    StudyLogsCompanion Function({
      Value<String> id,
      Value<String> wordId,
      Value<DateTime> studiedAt,
      Value<StudyResult> result,
      Value<String> sessionId,
      Value<int> rowid,
    });

final class $$StudyLogsTableReferences
    extends BaseReferences<_$AppDatabase, $StudyLogsTable, StudyLog> {
  $$StudyLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) =>
      db.words.createAlias('study_logs__word_id__words__id');

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StudySessionsTable _sessionIdTable(_$AppDatabase db) => db
      .studySessions
      .createAlias('study_logs__session_id__study_sessions__id');

  $$StudySessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$StudySessionsTableTableManager(
      $_db,
      $_db.studySessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyLogsTable> {
  $$StudyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get studiedAt => $composableBuilder(
    column: $table.studiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StudyResult, StudyResult, String> get result =>
      $composableBuilder(
        column: $table.result,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudySessionsTableFilterComposer get sessionId {
    final $$StudySessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableFilterComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyLogsTable> {
  $$StudyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get studiedAt => $composableBuilder(
    column: $table.studiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudySessionsTableOrderingComposer get sessionId {
    final $$StudySessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableOrderingComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyLogsTable> {
  $$StudyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get studiedAt =>
      $composableBuilder(column: $table.studiedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StudyResult, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudySessionsTableAnnotationComposer get sessionId {
    final $$StudySessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyLogsTable,
          StudyLog,
          $$StudyLogsTableFilterComposer,
          $$StudyLogsTableOrderingComposer,
          $$StudyLogsTableAnnotationComposer,
          $$StudyLogsTableCreateCompanionBuilder,
          $$StudyLogsTableUpdateCompanionBuilder,
          (StudyLog, $$StudyLogsTableReferences),
          StudyLog,
          PrefetchHooks Function({bool wordId, bool sessionId})
        > {
  $$StudyLogsTableTableManager(_$AppDatabase db, $StudyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<DateTime> studiedAt = const Value.absent(),
                Value<StudyResult> result = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyLogsCompanion(
                id: id,
                wordId: wordId,
                studiedAt: studiedAt,
                result: result,
                sessionId: sessionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wordId,
                Value<DateTime> studiedAt = const Value.absent(),
                required StudyResult result,
                required String sessionId,
                Value<int> rowid = const Value.absent(),
              }) => StudyLogsCompanion.insert(
                id: id,
                wordId: wordId,
                studiedAt: studiedAt,
                result: result,
                sessionId: sessionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false, sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.wordId,
                                referencedTable: $$StudyLogsTableReferences
                                    ._wordIdTable(db),
                                referencedColumn: $$StudyLogsTableReferences
                                    ._wordIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$StudyLogsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$StudyLogsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyLogsTable,
      StudyLog,
      $$StudyLogsTableFilterComposer,
      $$StudyLogsTableOrderingComposer,
      $$StudyLogsTableAnnotationComposer,
      $$StudyLogsTableCreateCompanionBuilder,
      $$StudyLogsTableUpdateCompanionBuilder,
      (StudyLog, $$StudyLogsTableReferences),
      StudyLog,
      PrefetchHooks Function({bool wordId, bool sessionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db, _db.studySessions);
  $$StudyLogsTableTableManager get studyLogs =>
      $$StudyLogsTableTableManager(_db, _db.studyLogs);
}
