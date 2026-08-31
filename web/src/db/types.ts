export type WordSource = 'manual' | 'marker_scan';
export type WordStatus = 'remembered' | 'not_yet' | 'unstudied' | 'pending_review';
export type StudyResult = 'remembered' | 'not_yet';

export interface Word {
  id: string;
  word: string;
  wordNormalized: string;
  meaning: string;
  exampleEn: string;
  exampleJa: string;
  synonyms: string[];
  etymology?: string;
  audioWordUrl?: string;
  audioExampleUrl?: string;
  imageUrl?: string;
  tags: string[];
  createdAt: number;
  source: WordSource;
  status: WordStatus;
}

export interface StudySession {
  id: string;
  startedAt: number;
  endedAt?: number;
  wordCount: number;
  accuracy: number;
}

export interface StudyLog {
  id: string;
  wordId: string;
  studiedAt: number;
  result: StudyResult;
  sessionId: string;
}

export interface NewWordInput {
  word: string;
  meaning: string;
  exampleEn: string;
  exampleJa: string;
  synonyms?: string[];
  etymology?: string;
  imageUrl?: string;
  tags?: string[];
  source?: WordSource;
  status?: WordStatus;
}
