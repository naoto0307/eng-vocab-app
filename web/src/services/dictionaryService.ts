export class WordNotFoundError extends Error {
  constructor(word: string) {
    super(`"${word}" was not found in the dictionary`);
    this.name = 'WordNotFoundError';
  }
}

export interface DictionaryLookup {
  definitionEn: string;
  exampleEn?: string;
  synonyms: string[];
}

interface DictionaryApiEntry {
  meanings: {
    definitions: { definition: string; example?: string; synonyms?: string[] }[];
    synonyms?: string[];
  }[];
}

/** Free Dictionary API — public, no API key required. */
export async function lookupWord(word: string): Promise<DictionaryLookup> {
  const res = await fetch(`https://api.dictionaryapi.dev/api/v2/entries/en/${encodeURIComponent(word.trim())}`);
  if (res.status === 404) {
    throw new WordNotFoundError(word);
  }
  if (!res.ok) {
    throw new Error(`Dictionary lookup failed: ${res.status}`);
  }
  const data = (await res.json()) as DictionaryApiEntry[];
  const meanings = data[0]?.meanings ?? [];

  let definitionEn = '';
  let exampleEn: string | undefined;
  const synonyms = new Set<string>();

  for (const meaning of meanings) {
    for (const syn of meaning.synonyms ?? []) synonyms.add(syn);
    for (const def of meaning.definitions) {
      if (!definitionEn) definitionEn = def.definition;
      if (!exampleEn && def.example) exampleEn = def.example;
      for (const syn of def.synonyms ?? []) synonyms.add(syn);
      if (synonyms.size >= 5) break;
    }
  }

  if (!definitionEn) throw new WordNotFoundError(word);

  return { definitionEn, exampleEn, synonyms: Array.from(synonyms).slice(0, 5) };
}
