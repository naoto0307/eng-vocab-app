import { useLiveQuery } from 'dexie-react-hooks';
import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { db } from '../db/db';
import { deleteWord, updateWord } from '../db/wordRepository';
import type { WordStatus } from '../db/types';
import { FocusedLayout } from '../components/FocusedLayout';
import { TrashIcon, XIcon } from '../components/icons';

const STATUS_OPTIONS: { key: WordStatus; label: string }[] = [
  { key: 'remembered', label: '覚えた' },
  { key: 'not_yet', label: 'まだ' },
  { key: 'unstudied', label: '未学習' },
];

export function WordDetailScreen() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const word = useLiveQuery(() => (id ? db.words.get(id) : undefined), [id]);

  const [form, setForm] = useState<{
    word: string;
    meaning: string;
    exampleEn: string;
    exampleJa: string;
    synonyms: string;
    etymology: string;
    status: WordStatus;
  } | null>(null);
  const [dirty, setDirty] = useState(false);
  const [leaveConfirm, setLeaveConfirm] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);

  useEffect(() => {
    if (word) {
      setForm({
        word: word.word,
        meaning: word.meaning,
        exampleEn: word.exampleEn,
        exampleJa: word.exampleJa,
        synonyms: word.synonyms.join(', '),
        etymology: word.etymology ?? '',
        status: word.status === 'pending_review' ? 'unstudied' : word.status,
      });
      setDirty(false);
    }
  }, [word]);

  if (word === undefined || form === null) return null;

  const field = (key: keyof typeof form) => ({
    value: form[key],
    onChange: (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
      setForm((f) => (f ? { ...f, [key]: e.target.value } : f));
      setDirty(true);
    },
  });

  const handleBack = () => {
    if (dirty) setLeaveConfirm(true);
    else navigate(-1);
  };

  const handleSave = async () => {
    await updateWord(word.id, {
      word: form.word.trim(),
      wordNormalized: form.word.trim().toLowerCase(),
      meaning: form.meaning.trim(),
      exampleEn: form.exampleEn.trim(),
      exampleJa: form.exampleJa.trim(),
      synonyms: form.synonyms.split(',').map((s) => s.trim()).filter(Boolean),
      etymology: form.etymology.trim() || undefined,
      status: form.status,
    });
    setDirty(false);
    navigate('/words');
  };

  const handleDelete = async () => {
    await deleteWord(word.id);
    navigate('/words');
  };

  return (
    <FocusedLayout
      title="単語の詳細"
      subtitle={`${new Date(word.createdAt).toLocaleDateString('ja-JP')} 追加・${word.source === 'manual' ? '手動入力' : 'マーカースキャン'}`}
      onBack={handleBack}
      actions={
        <div style={{ display: 'flex', gap: 10 }}>
          <button className="btn-danger" onClick={() => setConfirmDelete(true)}>
            <TrashIcon size={15} />
            削除
          </button>
          <button className="btn-primary" style={{ padding: '11px 26px' }} onClick={handleSave}>
            変更を保存
          </button>
        </div>
      }
    >
      <div style={{ padding: '36px 48px', display: 'flex', justifyContent: 'center' }}>
        <div style={{ width: 1080, display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 32, alignItems: 'start' }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
            <div>
              <label className="field-label">単語</label>
              <input className="field serif" style={{ fontSize: 17, fontWeight: 600 }} {...field('word')} />
            </div>
            <div>
              <label className="field-label">意味</label>
              <input className="field" {...field('meaning')} />
            </div>
            <div>
              <label className="field-label">例文（英語）</label>
              <textarea className="field serif" rows={2} style={{ resize: 'none', fontSize: 14.5, lineHeight: 1.6 }} {...field('exampleEn')} />
            </div>
            <div>
              <label className="field-label">例文の日本語訳</label>
              <textarea className="field" rows={2} style={{ resize: 'none' }} {...field('exampleJa')} />
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 18 }}>
              <div>
                <label className="field-label">類語</label>
                <input className="field" {...field('synonyms')} />
              </div>
              <div>
                <label className="field-label">タグ</label>
                <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 8 }}>
                  {word.tags.length === 0 && <span style={{ fontSize: 12, color: 'var(--ink-faint)' }}>タグなし</span>}
                  {word.tags.map((t) => (
                    <span key={t} className="tag-chip">
                      {t}
                    </span>
                  ))}
                </div>
                <input className="field" placeholder="新しいタグを追加（カンマ区切り）" disabled />
              </div>
            </div>
            <div>
              <label className="field-label">語源・豆知識</label>
              <textarea className="field" rows={2} style={{ resize: 'none' }} {...field('etymology')} />
            </div>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
            <div className="card" style={{ padding: '22px 24px', overflow: 'hidden' }}>
              <div
                style={{
                  height: 130,
                  margin: '-22px -24px 16px',
                  backgroundImage: word.imageUrl
                    ? `url(${word.imageUrl})`
                    : 'linear-gradient(135deg, var(--accent-soft), var(--gray-soft))',
                  backgroundSize: 'cover',
                  backgroundPosition: 'center',
                }}
              />
              <div style={{ fontSize: 12, color: 'var(--ink-faint)' }}>
                {word.imageUrl ? '画像は自動生成されました' : '画像は未設定です'}
              </div>
            </div>

            <div className="card" style={{ padding: '22px 24px' }}>
              <div className="field-label" style={{ marginBottom: 12 }}>
                学習ステータス
              </div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
                {STATUS_OPTIONS.map((opt) => {
                  const active = form.status === opt.key;
                  return (
                    <button
                      key={opt.key}
                      onClick={() => {
                        setForm((f) => (f ? { ...f, status: opt.key } : f));
                        setDirty(true);
                      }}
                      style={{
                        padding: '8px 15px',
                        borderRadius: 999,
                        fontSize: 12.5,
                        fontWeight: 700,
                        border: active ? 'none' : '1.5px solid var(--border)',
                        background: active ? 'var(--green-soft)' : 'var(--bg)',
                        color: active ? 'var(--green-ink)' : 'var(--ink-muted)',
                        cursor: 'pointer',
                      }}
                    >
                      {opt.label}
                    </button>
                  );
                })}
              </div>
              <div
                style={{
                  borderTop: '1px solid var(--border)',
                  marginTop: 18,
                  paddingTop: 16,
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 9,
                  fontSize: 12.5,
                  color: 'var(--ink-faint)',
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                  <span>追加日</span>
                  <span style={{ color: 'var(--ink-muted)', fontWeight: 600 }}>
                    {new Date(word.createdAt).toLocaleDateString('ja-JP')}
                  </span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                  <span>追加方法</span>
                  <span style={{ color: 'var(--ink-muted)', fontWeight: 600 }}>
                    {word.source === 'manual' ? '手動入力' : 'マーカースキャン'}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {leaveConfirm && (
        <Modal
          title="変更を保存せずに戻りますか？"
          body="編集した内容は保存されていません。編集を続ける場合は「続けて編集」を選んでください。"
          confirmLabel="保存せず戻る"
          onCancel={() => setLeaveConfirm(false)}
          onConfirm={() => navigate(-1)}
        />
      )}
      {confirmDelete && (
        <Modal
          title={`「${word.word}」を削除しますか？`}
          body="この操作は取り消せません。"
          confirmLabel="削除する"
          onCancel={() => setConfirmDelete(false)}
          onConfirm={handleDelete}
        />
      )}
    </FocusedLayout>
  );
}

function Modal({
  title,
  body,
  confirmLabel,
  onCancel,
  onConfirm,
}: {
  title: string;
  body: string;
  confirmLabel: string;
  onCancel: () => void;
  onConfirm: () => void;
}) {
  return (
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
      onClick={onCancel}
    >
      <div
        className="card"
        style={{ width: 400, padding: '28px 26px' }}
        onClick={(e) => e.stopPropagation()}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
          <div style={{ fontSize: 16, fontWeight: 800, marginBottom: 8 }}>{title}</div>
          <button className="iconbtn" style={{ width: 28, height: 28, border: 'none' }} onClick={onCancel}>
            <XIcon size={14} />
          </button>
        </div>
        <div style={{ fontSize: 13, color: 'var(--ink-muted)', lineHeight: 1.6, marginBottom: 22 }}>{body}</div>
        <div style={{ display: 'flex', gap: 10 }}>
          <button
            onClick={onCancel}
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
            続ける
          </button>
          <button
            onClick={onConfirm}
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
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
}
