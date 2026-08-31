import { lookupWord } from './dictionaryService';

export interface GeneratedWordDraft {
  meaningJa: string;
  definitionEn: string;
  exampleEn: string;
  exampleJa: string;
  synonyms: string[];
  imageUrl?: string;
  /** True when the Japanese translation could not be produced (no DeepL API key configured). */
  translationUnavailable: boolean;
}

/**
 * DeepL and Unsplash both require paid/registered API keys that this environment does not have
 * configured, so translation and image search are left blank for the user to fill in manually.
 * The English definition, example sentence and synonyms come from the free, keyless Dictionary API.
 */
export async function generateWordDraft(word: string): Promise<GeneratedWordDraft> {
  const lookup = await lookupWord(word);
  return {
    meaningJa: '',
    definitionEn: lookup.definitionEn,
    exampleEn: lookup.exampleEn ?? '',
    exampleJa: '',
    synonyms: lookup.synonyms,
    imageUrl: undefined,
    translationUnavailable: true,
  };
}
