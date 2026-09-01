import { createWorker, type Worker } from 'tesseract.js';

let workerPromise: Promise<Worker> | null = null;

function getWorker(): Promise<Worker> {
  if (!workerPromise) {
    workerPromise = createWorker('eng');
  }
  return workerPromise;
}

/** テキスト認識（Tesseract.js・クライアントサイド） */
export async function recognizeText(source: HTMLCanvasElement): Promise<string> {
  const worker = await getWorker();
  const {
    data: { text },
  } = await worker.recognize(source);
  return text.trim();
}

export async function disposeOcrWorker(): Promise<void> {
  if (!workerPromise) return;
  const worker = await workerPromise;
  workerPromise = null;
  await worker.terminate();
}
