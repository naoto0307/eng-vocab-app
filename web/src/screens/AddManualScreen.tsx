import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { FocusedLayout } from '../components/FocusedLayout';
import { addWord, DuplicateWordError } from '../db/wordRepository';
import { generateWordDraft } from '../services/wordGenerationService';
import { WordNotFoundError } from '../services/dictionaryService';
import { AlertIcon, SparkleIcon } from '../components/icons';

export function AddManualScreen() {
  const navigate = useNavigate();
  const [word, setWord] = useState('');
  const [meaning, setMeaning] = useState('');
  const [exampleEn, setExampleEn] = useState('');
  const [exampleJa, setExampleJa] = useState('');
  const [synonyms, setSynonyms] = useState('');
  const [etymology, setEtymology] = useState('');
  const [tags, setTags] = useState('');

  const [dirty, setDirty] = useState(false);
  const [saving, setSaving] = useState(false);
  const [generating, setGenerating] = useState(false);
  const [generateError, setGenerateError] = useState<string | null>(null);
  const [translationNote, setTranslationNote] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [leaveConfirm, setLeaveConfirm] = useState(false);

  const touch = <T,>(setter: (v: T) => void) => (v: T) => {
    setter(v);
    setDirty(true);
  };

  const handleGenerate = async () => {
    if (!word.trim()) {
      setGenerateError('先に単語を入力してください');
      return;
    }
    setGenerating(true);
    setGenerateError(null);
    setTranslationNote(false);
    try {
      const draft = await generateWordDraft(word);
      if (draft.exampleEn) setExampleEn(draft.exampleEn);
      if (draft.synonyms.length) setSynonyms(draft.synonyms.join(', '));
      if (!meaning) setMeaning(draft.definitionEn);
      setDirty(true);
      if (draft.translationUnavailable) setTranslationNote(true);
    } catch (e) {
      if (e instanceof WordNotFoundError) {
        setGenerateError(`「${word}」は辞書に見つかりませんでした。手動で入力してください`);
      } else {
        setGenerateError('自動生成に失敗しました。しばらくしてから再度お試しください');
      }
    } finally {
      setGenerating(false);
    }
  };

  const handleBack = () => {
    if (dirty) setLeaveConfirm(true);
    else navigate(-1);
  };

  const handleSave = async () => {
    setErrorMessage(null);
    if (!word.trim() || !meaning.trim() || !exampleEn.trim() || !exampleJa.trim()) {
      setErrorMessage('単語・意味・例文（英語）・例文の日本語訳は必須です');
      return;
    }
    setSaving(true);
    try {
      await addWord({
        word,
        meaning: meaning.trim(),
        exampleEn: exampleEn.trim(),
        exampleJa: exampleJa.trim(),
        synonyms: synonyms.split(',').map((s) => s.trim()).filter(Boolean),
        etymology: etymology.trim() || undefined,
        tags: tags.split(',').map((s) => s.trim()).filter(Boolean),
      });
      navigate('/');
    } catch (e) {
      if (e instanceof DuplicateWordError) {
        setErrorMessage(`「${e.word}」は既に登録されています`);
      } else {
        setErrorMessage('保存に失敗しました');
      }
    } finally {
      setSaving(false);
    }
  };

  return (
    <FocusedLayout
      title="単語を追加 — 手動入力"
      backLabel="キャンセル"
      onBack={handleBack}
      actions={
        <button className="btn-primary" style={{ padding: '11px 26px', fontSize: 14 }} onClick={handleSave} disabled={saving}>
          {saving ? '保存中…' : '保存する'}
        </button>
      }
    >
      <div style={{ padding: '36px 48px', display: 'flex', justifyContent: 'center' }}>
        <div style={{ width: 1080, display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 32, alignItems: 'start' }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
            {errorMessage && (
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 8,
                  padding: '10px 14px',
                  background: 'var(--rose-soft)',
                  borderRadius: 10,
                  color: 'var(--rose-ink)',
                  fontSize: 13,
                  fontWeight: 600,
                }}
              >
                <AlertIcon size={16} />
                {errorMessage}
              </div>
            )}

            <div>
              <label className="field-label">
                単語 <span style={{ color: 'var(--rose)' }}>*</span>
              </label>
              <div style={{ display: 'flex', gap: 10 }}>
                <input
                  className="field serif"
                  style={{ fontSize: 17, fontWeight: 600 }}
                  value={word}
                  onChange={(e) => touch(setWord)(e.target.value)}
                  placeholder="serendipity"
                />
                <button className="btn-ghost" style={{ whiteSpace: 'nowrap' }} onClick={handleGenerate} disabled={generating}>
                  <SparkleIcon size={16} />
                  {generating ? '生成中…' : '自動生成'}
                </button>
              </div>
              {generateError && (
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 8,
                    marginTop: 9,
                    padding: '9px 13px',
                    background: 'var(--rose-soft)',
                    borderRadius: 9,
                    color: 'var(--rose-ink)',
                    fontSize: 12.5,
                    fontWeight: 600,
                  }}
                >
                  <AlertIcon size={15} />
                  {generateError}
                </div>
              )}
              {translationNote && (
                <div style={{ marginTop: 9, fontSize: 12, color: 'var(--ink-faint)' }}>
                  日本語訳の自動生成にはDeepL APIキーの設定が必要です。意味・例文訳は手動で入力してください（英語の定義を意味欄に仮入力しました）。
                </div>
              )}
            </div>

            <div>
              <label className="field-label">
                意味 <span style={{ color: 'var(--rose)' }}>*</span>
              </label>
              <input className="field" value={meaning} onChange={(e) => touch(setMeaning)(e.target.value)} />
            </div>

            <div>
              <label className="field-label">
                例文（英語） <span style={{ color: 'var(--rose)' }}>*</span>
              </label>
              <textarea
                className="field serif"
                rows={2}
                style={{ resize: 'none', fontSize: 14.5, lineHeight: 1.6 }}
                value={exampleEn}
                onChange={(e) => touch(setExampleEn)(e.target.value)}
              />
            </div>

            <div>
              <label className="field-label">
                例文の日本語訳 <span style={{ color: 'var(--rose)' }}>*</span>
              </label>
              <textarea
                className="field"
                rows={2}
                style={{ resize: 'none' }}
                value={exampleJa}
                onChange={(e) => touch(setExampleJa)(e.target.value)}
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 18 }}>
              <div>
                <label className="field-label">類語（カンマ区切り・任意）</label>
                <input className="field" value={synonyms} onChange={(e) => touch(setSynonyms)(e.target.value)} />
              </div>
              <div>
                <label className="field-label">タグ（カンマ区切り・任意）</label>
                <input className="field" value={tags} onChange={(e) => touch(setTags)(e.target.value)} />
              </div>
            </div>

            <div>
              <label className="field-label">語源・豆知識（任意）</label>
              <textarea className="field" rows={2} style={{ resize: 'none' }} value={etymology} onChange={(e) => touch(setEtymology)(e.target.value)} />
            </div>
          </div>

          <div style={{ position: 'sticky', top: 0 }}>
            <div style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--ink-faint)', marginBottom: 10 }}>プレビュー</div>
            <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
              <div
                style={{
                  height: 150,
                  background: 'linear-gradient(135deg, var(--accent-soft), var(--gray-soft))',
                }}
              />
              <div style={{ padding: '22px 22px 24px' }}>
                <div className="serif" style={{ fontSize: 17, lineHeight: 1.6, marginBottom: 14 }}>
                  {highlightWord(exampleEn || '例文を入力すると表示されます', word)}
                </div>
                {exampleJa && <div style={{ fontSize: 13, color: 'var(--ink-muted)', marginBottom: 16 }}>{exampleJa}</div>}
                <div style={{ borderTop: '1px solid var(--border)', paddingTop: 14 }}>
                  <span className="serif" style={{ fontWeight: 700, fontSize: 16 }}>
                    {word || '単語'}
                  </span>
                </div>
                {meaning && <div style={{ fontSize: 13.5, color: 'var(--ink-muted)', marginTop: 4 }}>{meaning}</div>}
              </div>
            </div>
            <div style={{ fontSize: 12, color: 'var(--ink-faint)', marginTop: 10, lineHeight: 1.6 }}>
              「自動生成」で英語の定義・例文・類語の候補を取得します（Free Dictionary APIより）。内容はここで確認・編集してから保存できます。
            </div>
          </div>
        </div>
      </div>

      {leaveConfirm && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            background: 'oklch(20% 0.01 275 / .45)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 50,
          }}
          onClick={() => setLeaveConfirm(false)}
        >
          <div className="card" style={{ width: 400, padding: '28px 26px' }} onClick={(e) => e.stopPropagation()}>
            <div style={{ fontSize: 16, fontWeight: 800, marginBottom: 8 }}>この内容を破棄しますか？</div>
            <div style={{ fontSize: 13, color: 'var(--ink-muted)', lineHeight: 1.6, marginBottom: 22 }}>
              保存していない入力内容は失われます。編集を続ける場合は「続けて編集」を選んでください。
            </div>
            <div style={{ display: 'flex', gap: 10 }}>
              <button
                onClick={() => setLeaveConfirm(false)}
                style={{
                  flex: 1,
                  border: '1px solid var(--border)',
                  borderRadius: 11,
                  padding: 11,
                  fontSize: 13,
                  fontWeight: 700,
                  color: 'var(--ink)',
                  background: 'transparent',
                  cursor: 'pointer',
                }}
              >
                続けて編集する
              </button>
              <button
                onClick={() => navigate(-1)}
                style={{
                  flex: 1,
                  border: 'none',
                  borderRadius: 11,
                  padding: 11,
                  fontSize: 13,
                  fontWeight: 700,
                  color: 'white',
                  background: 'var(--rose)',
                  cursor: 'pointer',
                }}
              >
                保存せず戻る
              </button>
            </div>
          </div>
        </div>
      )}
    </FocusedLayout>
  );
}

function highlightWord(text: string, word: string) {
  if (!word.trim()) return text;
  const idx = text.toLowerCase().indexOf(word.trim().toLowerCase());
  if (idx === -1) return text;
  return (
    <>
      {text.slice(0, idx)}
      <span style={{ color: 'var(--accent)', fontWeight: 700 }}>{text.slice(idx, idx + word.trim().length)}</span>
      {text.slice(idx + word.trim().length)}
    </>
  );
}
