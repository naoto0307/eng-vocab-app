import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../word/data/word_repository.dart';

final studyRecordRepositoryProvider = Provider<StudyRecordRepository>((ref) {
  return StudyRecordRepository(ref.watch(appDatabaseProvider));
});

/// monthは月内の任意の日時でよい（年月だけを使用する）
final monthlyStudyRecordsProvider =
    FutureProvider.family<List<DailyStudyRecord>, DateTime>((ref, month) {
  return ref.watch(studyRecordRepositoryProvider).getDailyRecordsForMonth(month);
});

final currentStreakProvider = FutureProvider<int>((ref) {
  return ref.watch(studyRecordRepositoryProvider).getCurrentStreakDays();
});

class DailyStudyRecord {
  const DailyStudyRecord({required this.day, required this.duration});

  /// 時刻を切り捨てた日付
  final DateTime day;
  final Duration duration;
}

class StudyRecordRepository {
  StudyRecordRepository(this._db);

  final AppDatabase _db;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// 指定月の日別学習時間（完了済みセッションの合計）
  Future<List<DailyStudyRecord>> getDailyRecordsForMonth(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final firstDayNextMonth = DateTime(month.year, month.month + 1, 1);

    final sessions = await (_db.select(_db.studySessions)
          ..where(
            (s) =>
                s.endedAt.isNotNull() &
                s.startedAt.isBiggerOrEqualValue(firstDay) &
                s.startedAt.isSmallerThanValue(firstDayNextMonth),
          ))
        .get();

    final byDay = <DateTime, Duration>{};
    for (final session in sessions) {
      final day = _dateOnly(session.startedAt);
      final duration = session.endedAt!.difference(session.startedAt);
      byDay[day] = (byDay[day] ?? Duration.zero) + duration;
    }

    return byDay.entries.map((e) => DailyStudyRecord(day: e.key, duration: e.value)).toList();
  }

  /// 今日から遡って連続で学習した日数
  Future<int> getCurrentStreakDays() async {
    final sessions =
        await (_db.select(_db.studySessions)..where((s) => s.endedAt.isNotNull())).get();
    final studyDays = sessions.map((s) => _dateOnly(s.startedAt)).toSet();

    var streak = 0;
    var cursor = _dateOnly(DateTime.now());
    while (studyDays.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
