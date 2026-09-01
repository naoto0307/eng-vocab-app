import { useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { FocusedLayout } from '../components/FocusedLayout';
import { imageFileToCanvas, pdfFileToCanvases } from '../services/imageInput';
import { scanImages, type ScanCandidate, type ScanProgress } from '../services/scanService';
import { addWord, DuplicateWordError } from '../db/wordRepository';
import { generateWordDraft } from '../services/wordGenerationService';
import { useSettings } from '../store/settingsStore';
import { CameraIcon, FileIcon, ImageIcon, UploadIcon } from '../components/icons';

export function AddScanScreen() {
  const navigate = useNavigate();
  const { skipScanPreview } = useSettings();
  const [processing, setProcessing] = useState(false);
  const [statusText, setStatusText] = useState('解析中...');
  const [message, setMessage] = useState<string | null>(null);
  const cameraInputRef = useRef<HTMLInputElement>(null);
  const imageInputRef = useRef<HTMLInputElement>(null);
  const pdfInputRef = useRef<HTMLInputElement>(null);

  const onProgress = (imageIndex: number, imageTotal: number, p: ScanProgress) => {
    const stageLabel = p.stage === 'ocr' ? '文字認識' : '辞書照合';
    const pagePrefix = imageTotal > 1 ? `${imageIndex}/${imageTotal}ページ・` : '';
    setStatusText(`解析中... (${pagePrefix}${stageLabel} ${p.current}/${p.total})`);
  };

  const process = async (canvases: HTMLCanvasElement[]) => {
    setProcessing(true);
    setMessage(null);
    try {
      const candidates = await scanImages(canvases, onProgress);
      if (candidates.length === 0) {
        setMessage('マーカーで強調された単語が見つかりませんでした');
        return;
      }
      if (skipScanPreview) {
        await registerDirectly(candidates);
      } else {
        navigate('/add/scan/preview', { state: { candidates } });
      }
    } catch (e) {
      setMessage(`スキャンに失敗しました: ${e instanceof Error ? e.message : String(e)}`);
    } finally {
      setProcessing(false);
    }
  };

  const registerDirectly = async (candidates: ScanCandidate[]) => {
    let added = 0;
    for (const c of candidates) {
      if (c.isDuplicate) continue;
      let meaning = '';
      let exampleEn = '';
      let exampleJa = '';
      let synonyms: string[] = [];
      let imageUrl: string | undefined;

      if (!c.needsReview) {
        try {
          const draft = await generateWordDraft(c.text);
          meaning = draft.meaningJa || draft.definitionEn;
          exampleEn = draft.exampleEn;
          exampleJa = draft.exampleJa;
          synonyms = draft.synonyms;
          imageUrl = draft.imageUrl;
        } catch {
          // 自動生成失敗時も登録は続行する
        }
      }

      try {
        await addWord({
          word: c.text,
          meaning,
          exampleEn,
          exampleJa,
          synonyms,
          imageUrl,
          source: 'marker_scan',
          status: c.needsReview ? 'pending_review' : 'unstudied',
        });
        added++;
      } catch (e) {
        if (!(e instanceof DuplicateWordError)) throw e;
      }
    }
    navigate('/', { state: { toast: `${added} 件の単語を追加しました` } });
  };

  const handleImagePicked = async (file: File) => {
    const canvas = await imageFileToCanvas(file);
    await process([canvas]);
  };

  const handlePdfPicked = async (file: File) => {
    setProcessing(true);
    setStatusText('PDFを読み込み中...');
    try {
      const canvases = await pdfFileToCanvases(file);
      if (canvases.length === 0) {
        setMessage('PDFのページを読み込めませんでした');
        setProcessing(false);
        return;
      }
      await process(canvases);
    } catch (e) {
      setMessage(`PDFの読み込みに失敗しました: ${e instanceof Error ? e.message : String(e)}`);
      setProcessing(false);
    }
  };

  return (
    <FocusedLayout title="マーカースキャンで追加" onBack={() => navigate('/add')}>
      <div
        style={{
          minHeight: '100%',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 36,
          padding: '40px 20px',
        }}
      >
        {processing ? (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 16 }}>
            <div className="spinner" />
            <div style={{ fontSize: 14, color: 'var(--ink-muted)' }}>{statusText}</div>
          </div>
        ) : (
          <>
            <div
              style={{
                width: 760,
                maxWidth: '100%',
                border: '2px dashed var(--border)',
                borderRadius: 24,
                padding: '52px 40px',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: 22,
                background: 'var(--bg-elevated)',
              }}
            >
              <div
                style={{
                  width: 60,
                  height: 60,
                  borderRadius: 18,
                  background: 'var(--accent-soft)',
                  color: 'var(--accent)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <UploadIcon size={30} />
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 16, fontWeight: 800, marginBottom: 6 }}>画像・PDFを選択</div>
                <div style={{ fontSize: 13, color: 'var(--ink-muted)' }}>
                  マーカーで強調した単語を自動で検出し、まとめて候補に追加します
                </div>
              </div>
              {message && (
                <div style={{ fontSize: 12.5, color: 'var(--rose-ink)', textAlign: 'center' }}>{message}</div>
              )}
              <div style={{ display: 'flex', gap: 14, flexWrap: 'wrap', justifyContent: 'center' }}>
                <UploadButton icon={<CameraIcon size={22} />} label="カメラで撮影" onClick={() => cameraInputRef.current?.click()} />
                <UploadButton icon={<ImageIcon size={22} />} label="画像を選択" onClick={() => imageInputRef.current?.click()} />
                <UploadButton icon={<FileIcon size={22} />} label="PDFを選択" onClick={() => pdfInputRef.current?.click()} />
              </div>
            </div>

            <div
              style={{
                width: 760,
                maxWidth: '100%',
                display: 'flex',
                alignItems: 'center',
                gap: 18,
                padding: '16px 22px',
                background: 'var(--accent-soft)',
                borderRadius: 14,
              }}
            >
              <div
                style={{
                  flex: '0 0 auto',
                  background: 'var(--bg-elevated)',
                  borderRadius: 10,
                  padding: '10px 14px',
                  fontFamily: "'Source Serif 4', serif",
                  fontSize: 14,
                  lineHeight: 1.7,
                  boxShadow: 'var(--shadow)',
                }}
              >
                ...found this{' '}
                <span style={{ background: 'oklch(85% 0.16 105 / .55)', borderRadius: 3, padding: '0 2px' }}>
                  serendipity
                </span>{' '}
                while reading...
              </div>
              <div style={{ fontSize: 12.5, color: 'var(--ink-muted)', lineHeight: 1.6 }}>
                こんな風にマーカーで囲んだ単語を読み取ります。蛍光ペンの色は問いません。
              </div>
            </div>
          </>
        )}

        <input
          ref={cameraInputRef}
          type="file"
          accept="image/*"
          capture="environment"
          style={{ display: 'none' }}
          onChange={(e) => {
            const file = e.target.files?.[0];
            e.target.value = '';
            if (file) void handleImagePicked(file);
          }}
        />
        <input
          ref={imageInputRef}
          type="file"
          accept="image/*"
          style={{ display: 'none' }}
          onChange={(e) => {
            const file = e.target.files?.[0];
            e.target.value = '';
            if (file) void handleImagePicked(file);
          }}
        />
        <input
          ref={pdfInputRef}
          type="file"
          accept="application/pdf"
          style={{ display: 'none' }}
          onChange={(e) => {
            const file = e.target.files?.[0];
            e.target.value = '';
            if (file) void handlePdfPicked(file);
          }}
        />
      </div>
    </FocusedLayout>
  );
}

function UploadButton({ icon, label, onClick }: { icon: React.ReactNode; label: string; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: 10,
        background: 'var(--bg-elevated)',
        border: '1px solid var(--border)',
        borderRadius: 14,
        padding: '20px 28px',
        fontSize: 13.5,
        fontWeight: 700,
        color: 'var(--ink)',
        cursor: 'pointer',
      }}
    >
      {icon}
      {label}
    </button>
  );
}
