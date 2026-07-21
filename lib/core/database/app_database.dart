import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

enum WordSource { manual, markerScan }

enum WordStatus { remembered, notYet, unstudied, pendingReview }

enum StudyResult { remembered, notYet }

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    return (jsonDecode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

class Words extends Table {
  TextColumn get id => text()();
  // 大小文字を無視した一意制約（前後スペースの除去はリポジトリ層で正規化）
  TextColumn get word => text().customConstraint('NOT NULL UNIQUE COLLATE NOCASE')();
  TextColumn get meaning => text()();
  TextColumn get exampleEn => text()();
  TextColumn get exampleJa => text()();
  TextColumn get synonyms => text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get etymology => text().nullable()();
  TextColumn get audioWordUrl => text().nullable()();
  TextColumn get audioExampleUrl => text().nullable()();
  // Phase1は手動入力のみでUnsplash連携(Phase2)未実装のためnullable
  TextColumn get imageUrl => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get source => textEnum<WordSource>()();
  TextColumn get status => textEnum<WordStatus>()();

  @override
  Set<Column> get primaryKey => {id};
}

class StudySessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  RealColumn get accuracy => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class StudyLogs extends Table {
  TextColumn get id => text()();
  TextColumn get wordId => text().references(Words, #id)();
  DateTimeColumn get studiedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get result => textEnum<StudyResult>()();
  TextColumn get sessionId => text().references(StudySessions, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Words, StudySessions, StudyLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'eng_vocab_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
