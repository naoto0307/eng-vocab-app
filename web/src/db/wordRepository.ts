import { v4 as uuid } from 'uuid';
import { db } from './db';
import type { NewWordInput, Word } from './types';

export class DuplicateWordError extends Error {
  word: string;
  constructor(word: string) {
    super(`"${word}" is already registered`);
    this.name = 'DuplicateWordError';
    this.word = word;
  }
}

function normalize(word: string): string {
  return word.trim().toLowerCase();
}

export async function findByWord(word: string): Promise<Word | undefined> {
  return db.words.where('wordNormalized').equals(normalize(word)).first();
}

export async function addWord(input: NewWordInput): Promise<Word> {
  const trimmed = input.word.trim();
  const wordNormalized = normalize(trimmed);
  const existing = await findByWord(trimmed);
  if (existing) {
    throw new DuplicateWordError(trimmed);
  }

  const record: Word = {
    id: uuid(),
    word: trimmed,
    wordNormalized,
    meaning: input.meaning,
    exampleEn: input.exampleEn,
    exampleJa: input.exampleJa,
    synonyms: input.synonyms ?? [],
    etymology: input.etymology,
    imageUrl: input.imageUrl,
    tags: input.tags ?? [],
    createdAt: Date.now(),
    source: input.source ?? 'manual',
    status: input.status ?? 'unstudied',
  };
  await db.words.add(record);
  return record;
}

export async function updateWord(id: string, changes: Partial<Word>): Promise<void> {
  await db.words.update(id, changes);
}

export async function updateStatus(id: string, status: Word['status']): Promise<void> {
  await db.words.update(id, { status });
}

export async function deleteWord(id: string): Promise<void> {
  await db.words.delete(id);
}

export async function getStudyableWords(): Promise<Word[]> {
  const all = await db.words.where('status').notEqual('pending_review').sortBy('createdAt');
  return all.reverse();
}

export async function getAllWords(): Promise<Word[]> {
  const all = await db.words.orderBy('createdAt').toArray();
  return all.reverse();
}
