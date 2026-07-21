// ignore_for_file: prefer_initializing_formals
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_service.dart';
import '../database/app_database.dart';
import '../../features/word/data/word_repository.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// ログイン中のみ利用可能なSyncService。未ログイン時はnull。
final syncServiceProvider = Provider<SyncService?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return SyncService(
    db: ref.watch(appDatabaseProvider),
    firestore: ref.watch(firestoreProvider),
    uid: user.uid,
  );
});

/// ローカル(drift)とクラウド(Firestore)間の単語データ同期。
/// シンプルな「双方向マージ + 全件アップロード」方式（リアルタイム同期ではない）。
class SyncService {
  SyncService({required AppDatabase db, required FirebaseFirestore firestore, required String uid})
      : _db = db,
        _firestore = firestore,
        _uid = uid;

  final AppDatabase _db;
  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _wordsCol =>
      _firestore.collection('users').doc(_uid).collection('words');
  CollectionReference<Map<String, dynamic>> get _sessionsCol =>
      _firestore.collection('users').doc(_uid).collection('studySessions');
  CollectionReference<Map<String, dynamic>> get _logsCol =>
      _firestore.collection('users').doc(_uid).collection('studyLogs');

  Future<void> syncAll() async {
    await _mergeWords();
    await _mergeSessions();
    await _mergeLogs();
  }

  Future<void> _mergeWords() async {
    final remote = await _wordsCol.get();
    final remoteIds = remote.docs.map((d) => d.id).toSet();

    for (final doc in remote.docs) {
      final existing =
          await (_db.select(_db.words)..where((w) => w.id.equals(doc.id))).getSingleOrNull();
      if (existing == null) {
        await _db.into(_db.words).insert(_wordFromMap(doc.id, doc.data()), mode: InsertMode.insertOrIgnore);
      }
    }

    final localWords = await _db.select(_db.words).get();
    for (final word in localWords) {
      if (!remoteIds.contains(word.id)) {
        await _wordsCol.doc(word.id).set(_wordToMap(word));
      }
    }
  }

  Future<void> _mergeSessions() async {
    final remote = await _sessionsCol.get();
    final remoteIds = remote.docs.map((d) => d.id).toSet();

    for (final doc in remote.docs) {
      final existing = await (_db.select(_db.studySessions)..where((s) => s.id.equals(doc.id)))
          .getSingleOrNull();
      if (existing == null) {
        await _db.into(_db.studySessions).insert(
              _sessionFromMap(doc.id, doc.data()),
              mode: InsertMode.insertOrIgnore,
            );
      }
    }

    final localSessions = await _db.select(_db.studySessions).get();
    for (final session in localSessions) {
      if (!remoteIds.contains(session.id)) {
        await _sessionsCol.doc(session.id).set(_sessionToMap(session));
      }
    }
  }

  Future<void> _mergeLogs() async {
    final remote = await _logsCol.get();
    final remoteIds = remote.docs.map((d) => d.id).toSet();

    for (final doc in remote.docs) {
      final existing =
          await (_db.select(_db.studyLogs)..where((l) => l.id.equals(doc.id))).getSingleOrNull();
      if (existing == null) {
        await _db.into(_db.studyLogs).insert(_logFromMap(doc.id, doc.data()), mode: InsertMode.insertOrIgnore);
      }
    }

    final localLogs = await _db.select(_db.studyLogs).get();
    for (final log in localLogs) {
      if (!remoteIds.contains(log.id)) {
        await _logsCol.doc(log.id).set(_logToMap(log));
      }
    }
  }

  Map<String, dynamic> _wordToMap(Word w) => {
        'word': w.word,
        'meaning': w.meaning,
        'exampleEn': w.exampleEn,
        'exampleJa': w.exampleJa,
        'synonyms': w.synonyms,
        'etymology': w.etymology,
        'audioWordUrl': w.audioWordUrl,
        'audioExampleUrl': w.audioExampleUrl,
        'imageUrl': w.imageUrl,
        'tags': w.tags,
        'createdAt': w.createdAt,
        'source': w.source.name,
        'status': w.status.name,
      };

  WordsCompanion _wordFromMap(String id, Map<String, dynamic> m) => WordsCompanion.insert(
        id: id,
        word: m['word'] as String,
        meaning: m['meaning'] as String,
        exampleEn: m['exampleEn'] as String,
        exampleJa: m['exampleJa'] as String,
        synonyms: Value(List<String>.from(m['synonyms'] as List? ?? [])),
        etymology: Value(m['etymology'] as String?),
        audioWordUrl: Value(m['audioWordUrl'] as String?),
        audioExampleUrl: Value(m['audioExampleUrl'] as String?),
        imageUrl: Value(m['imageUrl'] as String?),
        tags: Value(List<String>.from(m['tags'] as List? ?? [])),
        createdAt: Value(_toDateTime(m['createdAt'])),
        source: WordSource.values.byName(m['source'] as String),
        status: WordStatus.values.byName(m['status'] as String),
      );

  Map<String, dynamic> _sessionToMap(StudySession s) => {
        'startedAt': s.startedAt,
        'endedAt': s.endedAt,
        'wordCount': s.wordCount,
        'accuracy': s.accuracy,
      };

  StudySessionsCompanion _sessionFromMap(String id, Map<String, dynamic> m) => StudySessionsCompanion.insert(
        id: id,
        startedAt: _toDateTime(m['startedAt']),
        endedAt: Value(_toDateTimeOrNull(m['endedAt'])),
        wordCount: Value(m['wordCount'] as int? ?? 0),
        accuracy: Value((m['accuracy'] as num?)?.toDouble() ?? 0),
      );

  Map<String, dynamic> _logToMap(StudyLog l) => {
        'wordId': l.wordId,
        'studiedAt': l.studiedAt,
        'result': l.result.name,
        'sessionId': l.sessionId,
      };

  StudyLogsCompanion _logFromMap(String id, Map<String, dynamic> m) => StudyLogsCompanion.insert(
        id: id,
        wordId: m['wordId'] as String,
        studiedAt: Value(_toDateTime(m['studiedAt'])),
        result: StudyResult.values.byName(m['result'] as String),
        sessionId: m['sessionId'] as String,
      );

  DateTime _toDateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    throw ArgumentError('Unexpected date value: $value');
  }

  DateTime? _toDateTimeOrNull(Object? value) {
    if (value == null) return null;
    return _toDateTime(value);
  }
}
