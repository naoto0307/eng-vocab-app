import Dexie, { type EntityTable } from 'dexie';
import type { StudyLog, StudySession, Word } from './types';

export class AppDatabase extends Dexie {
  words!: EntityTable<Word, 'id'>;
  studySessions!: EntityTable<StudySession, 'id'>;
  studyLogs!: EntityTable<StudyLog, 'id'>;

  constructor() {
    super('eng_vocab_app');
    this.version(1).stores({
      words: 'id, &wordNormalized, status, createdAt',
      studySessions: 'id, startedAt',
      studyLogs: 'id, wordId, sessionId, studiedAt',
    });
  }
}

export const db = new AppDatabase();
