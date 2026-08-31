import { v4 as uuid } from 'uuid';
import { db } from './db';
import type { StudyResult } from './types';

export async function startSession(): Promise<string> {
  const id = uuid();
  await db.studySessions.add({
    id,
    startedAt: Date.now(),
    wordCount: 0,
    accuracy: 0,
  });
  return id;
}

export async function endSession(
  sessionId: string,
  wordCount: number,
  accuracy: number,
): Promise<void> {
  await db.studySessions.update(sessionId, {
    endedAt: Date.now(),
    wordCount,
    accuracy,
  });
}

export async function recordResult(
  wordId: string,
  sessionId: string,
  result: StudyResult,
): Promise<string> {
  const id = uuid();
  await db.studyLogs.add({
    id,
    wordId,
    studiedAt: Date.now(),
    result,
    sessionId,
  });
  return id;
}

export async function deleteLog(logId: string): Promise<void> {
  await db.studyLogs.delete(logId);
}

export interface DailyStudyRecord {
  day: string; // yyyy-mm-dd (local)
  durationMs: number;
}

/** Approximates daily study duration from session start/end timestamps, bucketed by session start day. */
export async function getMonthlyStudyRecords(year: number, month: number): Promise<DailyStudyRecord[]> {
  const monthStart = new Date(year, month, 1).getTime();
  const monthEnd = new Date(year, month + 1, 1).getTime();
  const sessions = await db.studySessions
    .where('startedAt')
    .between(monthStart, monthEnd, true, false)
    .toArray();

  const byDay = new Map<string, number>();
  for (const session of sessions) {
    if (!session.endedAt) continue;
    const date = new Date(session.startedAt);
    const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(
      date.getDate(),
    ).padStart(2, '0')}`;
    const duration = session.endedAt - session.startedAt;
    byDay.set(key, (byDay.get(key) ?? 0) + duration);
  }
  return Array.from(byDay.entries()).map(([day, durationMs]) => ({ day, durationMs }));
}

export async function getTodayStudyMinutes(): Promise<number> {
  const start = new Date();
  start.setHours(0, 0, 0, 0);
  const sessions = await db.studySessions.where('startedAt').aboveOrEqual(start.getTime()).toArray();
  const ms = sessions
    .filter((s) => s.endedAt)
    .reduce((sum, s) => sum + (s.endedAt! - s.startedAt), 0);
  return Math.round(ms / 60000);
}

export async function getCurrentStreak(): Promise<number> {
  const sessions = await db.studySessions.orderBy('startedAt').reverse().toArray();
  const days = new Set(
    sessions
      .filter((s) => s.endedAt)
      .map((s) => {
        const d = new Date(s.startedAt);
        return `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`;
      }),
  );
  let streak = 0;
  const cursor = new Date();
  cursor.setHours(0, 0, 0, 0);
  for (;;) {
    const key = `${cursor.getFullYear()}-${cursor.getMonth()}-${cursor.getDate()}`;
    if (!days.has(key)) break;
    streak += 1;
    cursor.setDate(cursor.getDate() - 1);
  }
  return streak;
}
