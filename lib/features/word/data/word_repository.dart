import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final wordRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepository(ref.watch(appDatabaseProvider));
});

/// pending_review を除く全単語を新しい順で監視する
final wordListProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(wordRepositoryProvider).watchStudyableWords();
});

/// pending_review を含む全単語を新しい順で監視する（単語帳一覧用）
final allWordListProvider = StreamProvider<List<Word>>((ref) {
  return ref.watch(wordRepositoryProvider).watchAllWords();
});

class DuplicateWordException implements Exception {
  DuplicateWordException(this.word);
  final String word;
}

class WordRepository {
  WordRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// 前後スペース除去のみ行う（大小文字の同一視はDB側のCOLLATE NOCASEで担保）
  String _normalize(String word) => word.trim();

  Stream<List<Word>> watchStudyableWords() {
    final query = _db.select(_db.words)
      ..where((w) => w.status.equalsValue(WordStatus.pendingReview).not())
      ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]);
    return query.watch();
  }

  /// 学習セッション開始時に一度だけ取得するスナップショット（ライブ更新は不要）
  Future<List<Word>> getStudyableWords() {
    final query = _db.select(_db.words)
      ..where((w) => w.status.equalsValue(WordStatus.pendingReview).not())
      ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]);
    return query.get();
  }

  Stream<List<Word>> watchAllWords() {
    final query = _db.select(_db.words)
      ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]);
    return query.watch();
  }

  Future<Word?> findByWord(String word) {
    final normalized = _normalize(word);
    return (_db.select(_db.words)..where((w) => w.word.equals(normalized)))
        .getSingleOrNull();
  }

  Future<Word> addWord({
    required String word,
    required String meaning,
    required String exampleEn,
    required String exampleJa,
    List<String> synonyms = const [],
    String? etymology,
    String? imageUrl,
    List<String> tags = const [],
    WordSource source = WordSource.manual,
    WordStatus status = WordStatus.unstudied,
  }) async {
    final normalized = _normalize(word);
    final existing = await findByWord(normalized);
    if (existing != null) {
      throw DuplicateWordException(normalized);
    }

    final entry = WordsCompanion.insert(
      id: _uuid.v4(),
      word: normalized,
      meaning: meaning,
      exampleEn: exampleEn,
      exampleJa: exampleJa,
      synonyms: Value(synonyms),
      etymology: Value(etymology),
      imageUrl: Value(imageUrl),
      tags: Value(tags),
      source: source,
      status: status,
    );
    await _db.into(_db.words).insert(entry);
    return findByWord(normalized).then((w) => w!);
  }

  Future<void> updateStatus(String id, WordStatus status) {
    return (_db.update(_db.words)..where((w) => w.id.equals(id)))
        .write(WordsCompanion(status: Value(status)));
  }

  Future<void> deleteWord(String id) {
    return (_db.delete(_db.words)..where((w) => w.id.equals(id))).go();
  }
}
