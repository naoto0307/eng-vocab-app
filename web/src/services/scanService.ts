import { detectMarkerRegions, type MarkerRegion } from './markerDetector';
import { recognizeText } from './ocrService';
import { lookupWord, WordNotFoundError } from './dictionaryService';
import { findByWord } from '../db/wordRepository';

export interface ScanCandidate {
  /** OCRで認識された単語/フレーズ */
  text: string;
  /** 辞書に見つからず読み取り不完全の疑いがある場合true */
  needsReview: boolean;
  /** 既存単語帳に同じ単語が存在する場合true */
  isDuplicate: boolean;
}

/** ML Kit/Tesseractは極端に小さい画像だと精度が落ちるため、余白を付けつつ最小サイズを確保してクロップする */
const CROP_PADDING = 10;
const MIN_CROP_SIZE = 48;

function cropWithMinSize(source: HTMLCanvasElement, region: MarkerRegion): HTMLCanvasElement | null {
  let left = region.left - CROP_PADDING;
  let top = region.top - CROP_PADDING;
  let width = region.width + CROP_PADDING * 2;
  let height = region.height + CROP_PADDING * 2;

  if (width < MIN_CROP_SIZE) {
    left -= Math.floor((MIN_CROP_SIZE - width) / 2);
    width = MIN_CROP_SIZE;
  }
  if (height < MIN_CROP_SIZE) {
    top -= Math.floor((MIN_CROP_SIZE - height) / 2);
    height = MIN_CROP_SIZE;
  }

  left = Math.min(Math.max(left, 0), source.width - 1);
  top = Math.min(Math.max(top, 0), source.height - 1);
  width = Math.min(Math.max(width, 1), source.width - left);
  height = Math.min(Math.max(height, 1), source.height - top);

  if (width < MIN_CROP_SIZE || height < MIN_CROP_SIZE) return null;

  const cropped = document.createElement('canvas');
  cropped.width = width;
  cropped.height = height;
  const ctx = cropped.getContext('2d')!;
  ctx.drawImage(source, left, top, width, height, 0, 0, width, height);
  return cropped;
}

export type ScanProgress = { stage: 'detecting' | 'ocr' | 'lookup'; current: number; total: number };

/** 1枚の画像からマーカー領域を検出し、OCR・重複集約・辞書照合まで行う */
export async function scanImage(
  image: HTMLCanvasElement,
  onProgress?: (progress: ScanProgress) => void,
): Promise<ScanCandidate[]> {
  const regions = detectMarkerRegions(image);

  const texts: string[] = [];
  for (let i = 0; i < regions.length; i++) {
    onProgress?.({ stage: 'ocr', current: i + 1, total: regions.length });
    const cropped = cropWithMinSize(image, regions[i]);
    if (!cropped) continue;
    const text = await recognizeText(cropped);
    if (text) texts.push(text);
  }

  // 候補内重複の集約（正規化した完全一致・大小文字無視）
  const seenNormalized = new Set<string>();
  const uniqueTexts: string[] = [];
  for (const text of texts) {
    const trimmed = text.trim().replace(/\s+/g, ' ');
    const normalized = trimmed.toLowerCase();
    if (!trimmed || seenNormalized.has(normalized)) continue;
    seenNormalized.add(normalized);
    uniqueTexts.push(trimmed);
  }

  const candidates: ScanCandidate[] = [];
  for (let i = 0; i < uniqueTexts.length; i++) {
    onProgress?.({ stage: 'lookup', current: i + 1, total: uniqueTexts.length });
    const text = uniqueTexts[i];
    let needsReview = false;
    try {
      await lookupWord(text);
    } catch (e) {
      if (e instanceof WordNotFoundError) {
        needsReview = true;
      } else {
        // ネットワークエラー等、辞書照合そのものができない場合も要確認扱いにする
        needsReview = true;
      }
    }
    const existing = await findByWord(text);
    candidates.push({ text, needsReview, isDuplicate: !!existing });
  }
  return candidates;
}

/** 複数画像（PDFの各ページなど）をまとめてスキャンし、画像をまたいだ重複も除去する */
export async function scanImages(
  images: HTMLCanvasElement[],
  onProgress?: (imageIndex: number, imageTotal: number, progress: ScanProgress) => void,
): Promise<ScanCandidate[]> {
  const all: ScanCandidate[] = [];
  const seen = new Set<string>();
  for (let i = 0; i < images.length; i++) {
    const candidates = await scanImage(images[i], (p) => onProgress?.(i + 1, images.length, p));
    for (const c of candidates) {
      const key = c.text.toLowerCase();
      if (seen.has(key)) continue;
      seen.add(key);
      all.push(c);
    }
  }
  return all;
}
