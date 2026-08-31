import { useLiveQuery } from 'dexie-react-hooks';
import { useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { db } from '../db/db';
import type { WordStatus } from '../db/types';
import { ChevronRightIcon, PlusIcon, SearchIcon } from '../components/icons';

const STATUS_LABEL: Record<WordStatus, string> = {
  remembered: '覚えた',
  not_yet: 'まだ',
  unstudied: '未学習',
  pending_review: '要確認',
};
const STATUS_COLOR: Record<WordStatus, string> = {
  remembered: 'var(--green)',
  not_yet: 'var(--amber)',
  unstudied: 'var(--gray)',
  pending_review: 'var(--rose)',
};
const STATUS_SOFT: Record<WordStatus, string> = {
  remembered: 'var(--green-soft)',
  not_yet: 'var(--amber-soft)',
  unstudied: 'var(--gray-soft)',
  pending_review: 'var(--rose-soft)',
};
const STATUS_INK: Record<WordStatus, string> = {
  remembered: 'var(--green-ink)',
  not_yet: 'var(--amber-ink)',
  unstudied: 'var(--ink-muted)',
  pending_review: 'var(--rose-ink)',
};

type FilterKey = 'all' | WordStatus;
const FILTERS: { key: FilterKey; label: string }[] = [
  { key: 'all', label: 'すべて' },
  { key: 'remembered', label: '覚えた' },
  { key: 'not_yet', label: 'まだ' },
  { key: 'unstudied', label: '未学習' },
  { key: 'pending_review', label: '要確認' },
];

export function WordListScreen() {
  const navigate = useNavigate();
  const words = useLiveQuery(() => db.words.orderBy('createdAt').reverse().toArray(), []);
  const [query, setQuery] = useState('');
  const [filter, setFilter] = useState<FilterKey>('all');

  const filtered = useMemo(() => {
    if (!words) return [];
    return words.filter((w) => {
      if (filter !== 'all' && w.status !== filter) return false;
      if (query.trim()) {
        const q = query.trim().toLowerCase();
        if (!w.word.toLowerCase().includes(q) && !w.meaning.toLowerCase().includes(q)) return false;
      }
      return true;
    });
  }, [words, filter, query]);

  if (words === undefined) return null;

  const pendingCount = words.filter((w) => w.status === 'pending_review').length;

  return (
    <div style={{ maxWidth: 1120 }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
        <div>
          <h1 style={{ margin: 0, fontSize: 22, fontWeight: 900 }}>単語帳一覧</h1>
          <div style={{ fontSize: 13, color: 'var(--ink-faint)', marginTop: 4 }}>
            全{words.length}語{pendingCount > 0 && `（うち要確認 ${pendingCount}語）`}
          </div>
        </div>
        <button className="btn-primary" onClick={() => navigate('/add')}>
          <PlusIcon size={17} />
          単語を追加
        </button>
      </div>

      <div className="card" style={{ padding: '16px 20px', marginBottom: 18 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, flexWrap: 'wrap' }}>
          <div
            style={{
              flex: 1,
              minWidth: 220,
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              background: 'var(--bg)',
              border: '1px solid var(--border)',
              borderRadius: 10,
              padding: '9px 13px',
              color: 'var(--ink-faint)',
            }}
          >
            <SearchIcon size={17} />
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="単語・意味で検索"
              style={{
                border: 'none',
                background: 'transparent',
                outline: 'none',
                font: 'inherit',
                fontSize: 13.5,
                color: 'var(--ink)',
                width: '100%',
              }}
            />
          </div>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {FILTERS.map((f) => (
              <button
                key={f.key}
                className={`chip${filter === f.key ? ' active' : ''}`}
                onClick={() => setFilter(f.key)}
              >
                {f.label}
              </button>
            ))}
          </div>
        </div>
      </div>

      {filtered.length === 0 ? (
        <div
          className="card"
          style={{
            padding: '70px 20px',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: 12,
            textAlign: 'center',
          }}
        >
          <div
            style={{
              width: 52,
              height: 52,
              borderRadius: 14,
              background: 'var(--gray-soft)',
              color: 'var(--ink-faint)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            <SearchIcon size={24} />
          </div>
          <div style={{ fontSize: 15, fontWeight: 700 }}>該当する単語がありません</div>
          <div style={{ fontSize: 13, color: 'var(--ink-muted)' }}>検索条件やフィルタを見直してみてください</div>
          {(query || filter !== 'all') && (
            <button
              onClick={() => {
                setQuery('');
                setFilter('all');
              }}
              style={{
                marginTop: 6,
                border: '1px solid var(--border)',
                borderRadius: 10,
                padding: '9px 16px',
                fontSize: 12.5,
                fontWeight: 700,
                color: 'var(--ink-muted)',
                background: 'transparent',
                cursor: 'pointer',
              }}
            >
              フィルタをクリア
            </button>
          )}
        </div>
      ) : (
        <div className="card" style={{ overflow: 'hidden' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr>
                <th style={thStyle('22px')}>単語</th>
                <th style={thStyle()}>意味</th>
                <th style={thStyle()}>ステータス</th>
                <th style={thStyle()}>タグ</th>
                <th style={thStyle()}>追加日</th>
                <th style={thStyle()} />
              </tr>
            </thead>
            <tbody>
              {filtered.map((w) => (
                <tr
                  key={w.id}
                  onClick={() => navigate(`/words/${w.id}`)}
                  style={{ cursor: 'pointer' }}
                  className="word-row"
                >
                  <td style={tdStyle('22px')}>
                    <span className="serif" style={{ fontWeight: 600, fontSize: 15 }}>
                      {w.word}
                    </span>
                  </td>
                  <td style={{ ...tdStyle(), color: 'var(--ink-muted)' }}>{w.meaning || '—'}</td>
                  <td style={tdStyle()}>
                    <span className="badge" style={{ background: STATUS_SOFT[w.status], color: STATUS_INK[w.status] }}>
                      <span className="badge-dot" style={{ background: STATUS_COLOR[w.status] }} />
                      {STATUS_LABEL[w.status]}
                    </span>
                  </td>
                  <td style={tdStyle()}>
                    {w.tags.length === 0
                      ? <span style={{ color: 'var(--ink-faint)' }}>—</span>
                      : w.tags.map((t) => (
                          <span key={t} className="tag-chip" style={{ marginRight: 5 }}>
                            {t}
                          </span>
                        ))}
                  </td>
                  <td style={{ ...tdStyle(), color: 'var(--ink-faint)' }}>
                    {new Date(w.createdAt).toLocaleDateString('ja-JP', { month: '2-digit', day: '2-digit' })}
                  </td>
                  <td style={{ ...tdStyle(), paddingRight: 20, textAlign: 'right', color: 'var(--ink-faint)' }}>
                    <ChevronRightIcon size={17} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

function thStyle(paddingLeft?: string): React.CSSProperties {
  return {
    textAlign: 'left',
    fontSize: 12,
    color: 'var(--ink-faint)',
    fontWeight: 700,
    padding: `0 12px 10px ${paddingLeft ?? '12px'}`,
    textTransform: 'uppercase',
    letterSpacing: '0.03em',
  };
}
function tdStyle(paddingLeft?: string): React.CSSProperties {
  return {
    padding: `13px 12px 13px ${paddingLeft ?? '12px'}`,
    fontSize: 14,
    borderTop: '1px solid var(--border)',
    verticalAlign: 'middle',
  };
}
