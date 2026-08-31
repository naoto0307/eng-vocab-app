import { useLiveQuery } from 'dexie-react-hooks';
import { useMemo, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { db } from '../db/db';
import { FocusedLayout } from '../components/FocusedLayout';
import { AlertIcon, PlayIcon } from '../components/icons';

type Period = 'all' | 'today' | 'week' | 'month';

export function StudyScopeScreen() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const preset = params.get('preset');

  const words = useLiveQuery(() => db.words.where('status').notEqual('pending_review').toArray(), []);
  const [wrongOnly, setWrongOnly] = useState(preset === 'weak');
  const [period, setPeriod] = useState<Period>('all');
  const [selectedTags, setSelectedTags] = useState<string[]>([]);

  const allTags = useMemo(() => {
    if (!words) return [];
    const set = new Set<string>();
    words.forEach((w) => w.tags.forEach((t) => set.add(t)));
    return Array.from(set).sort();
  }, [words]);

  const target = useMemo(() => {
    if (!words) return [];
    const now = Date.now();
    const periodStart =
      period === 'today'
        ? new Date().setHours(0, 0, 0, 0)
        : period === 'week'
          ? now - 7 * 24 * 60 * 60 * 1000
          : period === 'month'
            ? now - 30 * 24 * 60 * 60 * 1000
            : null;

    return words.filter((w) => {
      if (wrongOnly && w.status !== 'not_yet') return false;
      if (periodStart !== null && w.createdAt < periodStart) return false;
      if (selectedTags.length > 0 && !selectedTags.some((t) => w.tags.includes(t))) return false;
      return true;
    });
  }, [words, wrongOnly, period, selectedTags]);

  if (words === undefined) return null;

  const toggleTag = (tag: string) => {
    setSelectedTags((prev) => (prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]));
  };

  const startStudy = () => {
    navigate('/study', { state: { wordIds: target.map((w) => w.id) } });
  };

  return (
    <FocusedLayout title="学習範囲を選ぶ">
      <div style={{ minHeight: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
        <div style={{ width: 620, display: 'flex', flexDirection: 'column', gap: 18 }}>
          <div className="card" style={{ padding: '22px 26px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <div>
                <div style={{ fontSize: 14.5, fontWeight: 700, marginBottom: 4 }}>間違えた単語のみ</div>
                <div style={{ fontSize: 12.5, color: 'var(--ink-muted)' }}>直近の判定が「まだ」の単語だけを出題</div>
              </div>
              <button className={`toggle${wrongOnly ? ' on' : ''}`} onClick={() => setWrongOnly((v) => !v)}>
                <div className="dot" />
              </button>
            </div>
          </div>

          <div className="card" style={{ padding: '22px 26px' }}>
            <div style={{ fontSize: 14.5, fontWeight: 700, marginBottom: 12 }}>追加期間で絞り込み</div>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
              {(
                [
                  ['today', '今日'],
                  ['week', '今週'],
                  ['month', '今月'],
                  ['all', '指定なし'],
                ] as [Period, string][]
              ).map(([key, label]) => (
                <button key={key} className={`chip${period === key ? ' active' : ''}`} onClick={() => setPeriod(key)}>
                  {label}
                </button>
              ))}
            </div>
          </div>

          {allTags.length > 0 && (
            <div className="card" style={{ padding: '22px 26px' }}>
              <div style={{ fontSize: 14.5, fontWeight: 700, marginBottom: 12 }}>タグで絞り込み</div>
              <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                {allTags.map((tag) => (
                  <button
                    key={tag}
                    className={`chip${selectedTags.includes(tag) ? ' active' : ''}`}
                    onClick={() => toggleTag(tag)}
                  >
                    {tag}
                  </button>
                ))}
              </div>
            </div>
          )}

          {target.length > 0 ? (
            <>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '6px 4px' }}>
                <div style={{ fontSize: 13, color: 'var(--ink-muted)' }}>
                  条件は<b style={{ color: 'var(--ink)' }}>すべて満たす</b>単語が対象になります
                </div>
                <div style={{ fontSize: 13.5, fontWeight: 700, color: 'var(--accent)' }}>対象：{target.length}語</div>
              </div>
              <button className="btn-primary" style={{ padding: '15px 20px', fontSize: 15, justifyContent: 'center' }} onClick={startStudy}>
                <PlayIcon />
                この範囲で学習を始める（{target.length}語）
              </button>
            </>
          ) : (
            <>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 8,
                  padding: '10px 4px',
                  color: 'var(--rose-ink)',
                  fontSize: 13,
                  fontWeight: 600,
                }}
              >
                <AlertIcon size={16} />
                条件に合う単語が0語です。条件を減らしてみてください。
              </div>
              <button className="btn-primary" style={{ padding: '15px 20px', fontSize: 15, justifyContent: 'center', background: 'var(--gray-soft)', color: 'var(--ink-faint)', cursor: 'not-allowed' }} disabled>
                <PlayIcon />
                この範囲で学習を始める（0語）
              </button>
            </>
          )}
        </div>
      </div>
    </FocusedLayout>
  );
}
