import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:eng_vocab_app/core/database/app_database.dart';
import 'package:eng_vocab_app/features/record/data/study_record_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late StudyRecordRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = StudyRecordRepository(db);
  });

  tearDown(() => db.close());

  Future<void> insertSession(DateTime startedAt, Duration duration) async {
    const uuid = Uuid();
    await db.into(db.studySessions).insert(
          StudySessionsCompanion.insert(
            id: uuid.v4(),
            startedAt: startedAt,
            endedAt: Value(startedAt.add(duration)),
          ),
        );
  }

  test('同じ日の複数セッションの学習時間が合算される', () async {
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day, 10);
    await insertSession(day, const Duration(minutes: 10));
    await insertSession(day.add(const Duration(hours: 2)), const Duration(minutes: 15));

    final records = await repo.getDailyRecordsForMonth(today);

    expect(records.length, 1);
    expect(records.first.duration.inMinutes, 25);
  });

  test('月をまたいだセッションは含まれない', () async {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 15);
    final lastMonth = DateTime(now.year, now.month - 1, 15);
    await insertSession(thisMonth, const Duration(minutes: 20));
    await insertSession(lastMonth, const Duration(minutes: 30));

    final records = await repo.getDailyRecordsForMonth(thisMonth);

    expect(records.length, 1);
    expect(records.first.duration.inMinutes, 20);
  });

  test('未完了セッション(endedAtがnull)は集計に含まれない', () async {
    const uuid = Uuid();
    final now = DateTime.now();
    await db.into(db.studySessions).insert(
          StudySessionsCompanion.insert(id: uuid.v4(), startedAt: now),
        );

    final records = await repo.getDailyRecordsForMonth(now);

    expect(records, isEmpty);
  });

  test('連続学習日数: 今日と昨日学習していれば2日', () async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    await insertSession(today, const Duration(minutes: 5));
    await insertSession(yesterday, const Duration(minutes: 5));

    final streak = await repo.getCurrentStreakDays();

    expect(streak, greaterThanOrEqualTo(2));
  });

  test('連続学習日数: 今日学習していなければ0日', () async {
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
    await insertSession(threeDaysAgo, const Duration(minutes: 5));

    final streak = await repo.getCurrentStreakDays();

    expect(streak, 0);
  });
}
