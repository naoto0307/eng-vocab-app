import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../word/data/word_repository.dart';

final studyRepositoryProvider = Provider<StudyRepository>((ref) {
  return StudyRepository(ref.watch(appDatabaseProvider));
});

class StudyRepository {
  StudyRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<String> startSession() async {
    final id = _uuid.v4();
    await _db.into(_db.studySessions).insert(
          StudySessionsCompanion.insert(
            id: id,
            startedAt: DateTime.now(),
          ),
        );
    return id;
  }

  Future<void> endSession({
    required String sessionId,
    required int wordCount,
    required double accuracy,
  }) {
    return (_db.update(_db.studySessions)..where((s) => s.id.equals(sessionId)))
        .write(
      StudySessionsCompanion(
        endedAt: Value(DateTime.now()),
        wordCount: Value(wordCount),
        accuracy: Value(accuracy),
      ),
    );
  }

  /// 判定結果をStudyLogに記録し、対象単語のstatusを更新する。生成したログIDを返す（undo用）
  Future<String> recordResult({
    required String wordId,
    required String sessionId,
    required StudyResult result,
  }) async {
    final logId = _uuid.v4();
    await _db.into(_db.studyLogs).insert(
          StudyLogsCompanion.insert(
            id: logId,
            wordId: wordId,
            result: result,
            sessionId: sessionId,
          ),
        );
    final status = result == StudyResult.remembered
        ? WordStatus.remembered
        : WordStatus.notYet;
    await (_db.update(_db.words)..where((w) => w.id.equals(wordId)))
        .write(WordsCompanion(status: Value(status)));
    return logId;
  }

  Future<void> deleteLog(String logId) {
    return (_db.delete(_db.studyLogs)..where((l) => l.id.equals(logId))).go();
  }
}
