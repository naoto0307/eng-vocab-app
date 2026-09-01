import { useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { FocusedLayout } from '../components/FocusedLayout';
import { addWord, DuplicateWordError } from '../db/wordRepository';
import { generateWordDraft } from '../services/wordGenerationService';
import type { ScanCandidate } from '../services/scanService';
import { AlertIcon, CheckIcon } from '../components/icons';

export function ScanPreviewScreen() {
  const navigate = useNavigate();
  const location = useLocation();
  const candidates = ((location.state as { candidates?: ScanCandidate[] } | null)?.candidates ?? []);

  const [included, setIncluded] = useState<boolean[]>(() => candidates.map((c) => !c.isDuplicate));
  const [texts, setTexts] = useState<string[]>(() => candidates.map((c) => c.text));
  const [saving, setSaving] = useState(false);

  if (candidates.length === 0) {
    navigate('/add/scan', { replace: true });
    return null;
  }

  const includedCount = included.filter(Boolean).length;

  const handleRegister = async () => {
    setSaving(true);
    let added = 0;
    for (let i = 0; i < candidates.length; i++) {
      if (!included[i]) continue;
      const text = texts[i].trim();
      if (!text) continue;
      const needsReview = candidates[i].needsReview;

      let meaning = '';
      let exampleEn = '';
      let exampleJa = '';
      let synonyms: string[] = [];
      let imageUrl: string | undefined;

      if (!needsReview) {
        try {
          const draft = await generateWordDraft(text);
          meaning = draft.meaningJa || draft.definitionEn;
          exampleEn = draft.exampleEn;
          exampleJa = draft.exampleJa;
          synonyms = draft.synonyms;
          imageUrl = draft.imageUrl;
        } catch {
          // 自動生成に失敗しても登録は続行し、空欄のまま後で編集してもらう
        }
      }

      try {
        await addWord({
          word: text,
          meaning,
          exampleEn,
          exampleJa,
          synonyms,
          imageUrl,
          source: 'marker_scan',
          status: needsReview ? 'pending_review' : 'unstudied',
        });
        added++;
      } catch (e) {
        if (!(e instanceof DuplicateWordError)) throw e;
      }
    }
    navigate('/', { state: { toast: `${added} 件の単語を追加しました` } });
  };

  return (
    <FocusedLayout
      title={`スキャン結果（${candidates.length}件）`}
      onBack={() => navigate('/add/scan')}
      actions={
        <button className="btn-primary" onClick={handleRegister} disabled={saving || includedCount === 0}>
          {saving ? '登録中…' : `${includedCount}件を登録する`}
        </button>
      }
    >
      <div style={{ padding: '28px 0 40px', display: 'flex', justifyContent: 'center' }}>
        <div style={{ width: 820, maxWidth: '100%', padding: '0 20px' }}>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 10,
              fontSize: 13,
              color: 'var(--ink-muted)',
              marginBottom: 16,
              padding: '0 2px',
            }}
          >
            <AlertIcon size={16} style={{ color: 'var(--accent)', flex: '0 0 auto' }} />
            テキストを修正できます。「登録済み」は既存の単語帳と重複しています。
          </div>

          <div className="card">
            {candidates.map((c, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 16,
                  padding: '16px 20px',
                  borderBottom: i < candidates.length - 1 ? '1px solid var(--border)' : undefined,
                  background: c.isDuplicate ? 'var(--gray-soft)' : undefined,
                }}
              >
                <button
                  onClick={() =>
                    !c.isDuplicate && setIncluded((prev) => prev.map((v, idx) => (idx === i ? !v : v)))
                  }
                  disabled={c.isDuplicate}
                  style={{
                    width: 20,
                    height: 20,
                    borderRadius: 6,
                    border: `1.5px solid ${included[i] ? 'var(--accent)' : 'var(--border)'}`,
                    background: included[i] ? 'var(--accent)' : 'transparent',
                    flex: '0 0 20px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: 'white',
                    cursor: c.isDuplicate ? 'not-allowed' : 'pointer',
                    opacity: c.isDuplicate ? 0.5 : 1,
                  }}
                >
                  {included[i] && <CheckIcon size={13} />}
                </button>
                <input
                  value={texts[i]}
                  disabled={c.isDuplicate}
                  onChange={(e) => setTexts((prev) => prev.map((v, idx) => (idx === i ? e.target.value : v)))}
                  style={{
                    flex: 1,
                    border: 'none',
                    background: 'transparent',
                    fontFamily: "'Source Serif 4', serif",
                    fontSize: 15.5,
                    fontWeight: 600,
                    color: c.isDuplicate ? 'var(--ink-faint)' : 'var(--ink)',
                    outline: 'none',
                  }}
                />
                {c.isDuplicate && (
                  <span className="badge" style={{ background: 'var(--bg-elevated)', color: 'var(--ink-faint)', border: '1px solid var(--border)', flex: '0 0 auto' }}>
                    登録済み
                  </span>
                )}
                {!c.isDuplicate && c.needsReview && (
                  <span className="badge" style={{ background: 'var(--rose-soft)', color: 'var(--rose-ink)', flex: '0 0 auto' }}>
                    要確認
                  </span>
                )}
              </div>
            ))}
          </div>
          <div style={{ fontSize: 12, color: 'var(--ink-faint)', marginTop: 14, padding: '0 2px' }}>
            チェックを外すと登録対象から除外されます
          </div>
        </div>
      </div>
    </FocusedLayout>
  );
}
