/**
 * HSV色検出でマーカー（蛍光ペン）による強調領域を検出する。
 * lib/core/vision/marker_detector.dart のアルゴリズムを移植したもの（しきい値・手順は同一）。
 */

export interface MarkerRegion {
  left: number;
  top: number;
  width: number;
  height: number;
}

const MAX_WORKING_DIMENSION = 900;
const MIN_BLOB_AREA = 30;
const SATURATION_THRESHOLD = 0.28;
const VALUE_THRESHOLD = 0.45;
const DILATE_RADIUS = 4;

export function detectMarkerRegions(source: HTMLCanvasElement): MarkerRegion[] {
  const longSide = Math.max(source.width, source.height);
  const scale = longSide > MAX_WORKING_DIMENSION ? MAX_WORKING_DIMENSION / longSide : 1;
  const w = Math.round(source.width * scale);
  const h = Math.round(source.height * scale);

  const work = document.createElement('canvas');
  work.width = w;
  work.height = h;
  const ctx = work.getContext('2d', { willReadFrequently: true })!;
  ctx.drawImage(source, 0, 0, w, h);
  const { data } = ctx.getImageData(0, 0, w, h);

  const mask = new Uint8Array(w * h);
  for (let i = 0, p = 0; i < mask.length; i++, p += 4) {
    const r = data[p] / 255;
    const g = data[p + 1] / 255;
    const b = data[p + 2] / 255;
    const v = Math.max(r, g, b);
    const minc = Math.min(r, g, b);
    const s = v === 0 ? 0 : (v - minc) / v;
    // 蛍光ペンは彩度・明度がともに高いパステル系の色になりやすい一方、
    // 黒文字(明度低)や白紙(彩度が低い)は除外したいので彩度を主な判定基準にする。
    if (s > SATURATION_THRESHOLD && v > VALUE_THRESHOLD) {
      mask[i] = 1;
    }
  }

  // マーカー内の黒文字部分は彩度・明度が低くマスクの穴になり、1つの単語が
  // 複数領域に分裂してしまうため、膨張処理で文字の隙間を埋めてから連結成分を取る
  const dilated = dilate(mask, w, h, DILATE_RADIUS);
  const blobs = connectedComponents(dilated, w, h).filter((b) => b.width * b.height >= MIN_BLOB_AREA);

  const scaleBack = 1 / scale;
  const regions: MarkerRegion[] = blobs.map((b) => ({
    left: Math.round(b.left * scaleBack),
    top: Math.round(b.top * scaleBack),
    width: Math.round(b.width * scaleBack),
    height: Math.round(b.height * scaleBack),
  }));

  // 1文字ずつのブロブが隣り合っているだけのケースを1つの単語/フレーズにまとめる
  return mergeNearby(mergeNearby(regions));
}

/** 水平・垂直の2パスによるボックス膨張（半径radius px） */
function dilate(mask: Uint8Array, w: number, h: number, radius: number): Uint8Array {
  const horizontal = new Uint8Array(w * h);
  for (let y = 0; y < h; y++) {
    let count = 0;
    const rowStart = y * w;
    for (let x = -radius; x < w; x++) {
      const addIdx = x + radius;
      if (addIdx < w && addIdx >= 0 && mask[rowStart + addIdx]) count++;
      const removeIdx = x - radius - 1;
      if (removeIdx >= 0 && removeIdx < w && mask[rowStart + removeIdx]) count--;
      if (x >= 0) horizontal[rowStart + x] = count > 0 ? 1 : 0;
    }
  }

  const result = new Uint8Array(w * h);
  for (let x = 0; x < w; x++) {
    let count = 0;
    for (let y = -radius; y < h; y++) {
      const addIdx = y + radius;
      if (addIdx < h && addIdx >= 0 && horizontal[addIdx * w + x]) count++;
      const removeIdx = y - radius - 1;
      if (removeIdx >= 0 && removeIdx < h && horizontal[removeIdx * w + x]) count--;
      if (y >= 0) result[y * w + x] = count > 0 ? 1 : 0;
    }
  }
  return result;
}

interface Blob {
  left: number;
  top: number;
  width: number;
  height: number;
}

function connectedComponents(mask: Uint8Array, w: number, h: number): Blob[] {
  const visited = new Uint8Array(w * h);
  const blobs: Blob[] = [];
  const queue = new Int32Array(w * h);

  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const start = y * w + x;
      if (!mask[start] || visited[start]) continue;

      let minX = x;
      let maxX = x;
      let minY = y;
      let maxY = y;
      let qHead = 0;
      let qTail = 0;
      queue[qTail++] = start;
      visited[start] = 1;

      while (qHead < qTail) {
        const idx = queue[qHead++];
        const cx = idx % w;
        const cy = (idx - cx) / w;
        if (cx < minX) minX = cx;
        if (cx > maxX) maxX = cx;
        if (cy < minY) minY = cy;
        if (cy > maxY) maxY = cy;

        if (cx + 1 < w && mask[idx + 1] && !visited[idx + 1]) {
          visited[idx + 1] = 1;
          queue[qTail++] = idx + 1;
        }
        if (cx - 1 >= 0 && mask[idx - 1] && !visited[idx - 1]) {
          visited[idx - 1] = 1;
          queue[qTail++] = idx - 1;
        }
        if (cy + 1 < h && mask[idx + w] && !visited[idx + w]) {
          visited[idx + w] = 1;
          queue[qTail++] = idx + w;
        }
        if (cy - 1 >= 0 && mask[idx - w] && !visited[idx - w]) {
          visited[idx - w] = 1;
          queue[qTail++] = idx - w;
        }
      }
      blobs.push({ left: minX, top: minY, width: maxX - minX + 1, height: maxY - minY + 1 });
    }
  }
  return blobs;
}

function mergeNearby(regions: MarkerRegion[]): MarkerRegion[] {
  if (regions.length <= 1) return regions;
  const sorted = [...regions].sort((a, b) => a.top - b.top);
  const merged: MarkerRegion[] = [];

  for (const r of sorted) {
    const idx = merged.findIndex((m) => {
      const overlapTop = Math.max(m.top, r.top);
      const overlapBottom = Math.min(m.top + m.height, r.top + r.height);
      const verticalOverlap = overlapBottom - overlapTop;
      const avgHeight = (m.height + r.height) / 2;
      if (verticalOverlap < avgHeight * 0.35) return false;
      const gap = Math.max(m.left, r.left) - Math.min(m.left + m.width, r.left + r.width);
      return gap < avgHeight * 1.8;
    });

    if (idx === -1) {
      merged.push(r);
    } else {
      const m = merged[idx];
      const left = Math.min(m.left, r.left);
      const top = Math.min(m.top, r.top);
      const right = Math.max(m.left + m.width, r.left + r.width);
      const bottom = Math.max(m.top + m.height, r.top + r.height);
      merged[idx] = { left, top, width: right - left, height: bottom - top };
    }
  }
  return merged;
}
