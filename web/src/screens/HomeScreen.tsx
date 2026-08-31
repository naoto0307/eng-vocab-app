import { useLiveQuery } from 'dexie-react-hooks';
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { db } from '../db/db';
import { getCurrentStreak, getTodayStudyMinutes } from '../db/studyRepository';
import { DonutChart } from '../components/DonutChart';
import { BookIcon, LoopIcon, PlayIcon, PlusIcon } from '../components/icons';

const STATUS_LABEL: Record<string, string> = {
  remembered: '覚えた',
  not_yet: 'まだ',
  unstudied: '未学習',
};
const STATUS_COLOR: Record<string, string> = {
  remembered: 'var(--green)',
  not_yet: 'var(--amber)',
  unstudied: 'var(--gray)',
};
const STATUS_INK: Record<string, string> = {
  remembered: 'var(--green-ink)',
  not_yet: 'var(--amber-ink)',
  unstudied: 'var(--ink-faint)',
};

export function HomeScreen() {
  const navigate = useNavigate();
  const words = useLiveQuery(() => db.words.orderBy('createdAt').reverse().toArray(), []);
  const [streak, setStreak] = useState(0);
  const [todayMinutes, setTodayMinutes] = useState(0);

  useEffect(() => {
    getCurrentStreak().then(setStreak);
    getTodayStudyMinutes().then(setTodayMinutes);
  }, [words]);

  if (words === undefined) return null;

  const studyable = words.filter((w) => w.status !== 'pending_review');
  const total = studyable.length;
  const remembered = studyable.filter((w) => w.status === 'remembered').length;
  const notYet = studyable.filter((w) => w.status === 'not_yet').length;
  const unstudied = studyable.filter((w) => w.status === 'unstudied').length;
  const percent = total === 0 ? 0 : (remembered / total) * 100;
  const recent = words.slice(0, 4);
  const weakWords = studyable.filter((w) => w.status === 'not_yet');

  if (total === 0) {
    return (
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          textAlign: 'center',
          padding: '130px 20px',
          gap: 22,
        }}
      >
        <div
          style={{
            width: 84,
            height: 84,
            borderRadius: 22,
            background: 'var(--accent-soft)',
            color: 'var(--accent)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <BookIcon size={40} />
        </div>
        <div>
          <h1 style={{ margin: '0 0 8px', fontSize: 22, fontWeight: 900 }}>まだ単語が登録されていません</h1>
          <div style={{ fontSize: 14, color: 'var(--ink-muted)' }}>
            最初の1語を追加して、高速周回学習をはじめましょう。
          </div>
        </div>
        <button className="btn-primary" style={{ padding: '14px 28px', fontSize: 15 }} onClick={() => navigate('/add')}>
          <PlusIcon />
          最初の単語を追加
        </button>
      </div>
    );
  }

  const today = new Date();

  return (
    <div style={{ maxWidth: 1080 }}>
      <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', marginBottom: 28 }}>
        <div>
          <div style={{ fontSize: 13, color: 'var(--ink-faint)', fontWeight: 600, marginBottom: 6 }}>
            {today.getFullYear()}年{today.getMonth() + 1}月{today.getDate()}日
          </div>
          <h1 style={{ margin: 0, fontSize: 26, fontWeight: 900, letterSpacing: '-0.01em' }}>おかえりなさい</h1>
          <div style={{ marginTop: 6, fontSize: 14, color: 'var(--ink-muted)' }}>
            今日も気持ちよく一周していきましょう。
          </div>
        </div>
        <button
          className="btn-primary"
          style={{ padding: '14px 26px', fontSize: 15 }}
          onClick={() => navigate('/study/scope')}
        >
          <PlayIcon />
          学習を始める
        </button>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1.35fr 1fr', gap: 20 }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
          <div className="card" style={{ padding: '26px 28px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 6 }}>
              <div style={{ fontSize: 15, fontWeight: 700 }}>進捗</div>
              <a onClick={() => navigate('/words')} style={{ fontSize: 13, fontWeight: 600, cursor: 'pointer' }}>
                単語帳一覧へ
              </a>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 36, padding: '14px 4px 6px' }}>
              <DonutChart
                segments={[
                  { value: remembered, color: 'var(--green)' },
                  { value: notYet, color: 'var(--amber)' },
                  { value: unstudied, color: 'var(--gray)' },
                ]}
                centerValue={`${percent.toFixed(1)}%`}
                centerLabel="覚えた割合"
              />
              <div style={{ display: 'flex', flexDirection: 'column', gap: 14, flex: 1 }}>
                {(['remembered', 'not_yet', 'unstudied'] as const).map((key) => (
                  <div key={key} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 9, fontSize: 14 }}>
                      <span
                        style={{
                          width: 10,
                          height: 10,
                          borderRadius: 3,
                          background: STATUS_COLOR[key],
                          display: 'inline-block',
                        }}
                      />
                      {STATUS_LABEL[key]}
                    </div>
                    <div style={{ fontWeight: 700, fontSize: 14 }}>
                      {key === 'remembered' ? remembered : key === 'not_yet' ? notYet : unstudied}語
                    </div>
                  </div>
                ))}
                <div
                  style={{
                    borderTop: '1px solid var(--border)',
                    marginTop: 2,
                    paddingTop: 12,
                    fontSize: 13.5,
                    color: 'var(--ink-muted)',
                  }}
                >
                  覚えた <b style={{ color: 'var(--ink)' }}>{remembered}</b> / {total}語
                </div>
              </div>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 20 }}>
            <div className="card" style={{ padding: '20px 22px' }}>
              <div style={{ fontSize: 12.5, color: 'var(--ink-faint)', fontWeight: 600, marginBottom: 8 }}>
                総単語数
              </div>
              <div style={{ fontSize: 26, fontWeight: 900 }}>
                {total}
                <span style={{ fontSize: 14, fontWeight: 600, color: 'var(--ink-faint)' }}>語</span>
              </div>
            </div>
            <div className="card" style={{ padding: '20px 22px' }}>
              <div style={{ fontSize: 12.5, color: 'var(--ink-faint)', fontWeight: 600, marginBottom: 8 }}>
                連続学習日数
              </div>
              <div style={{ fontSize: 26, fontWeight: 900, color: 'var(--accent)' }}>
                {streak}
                <span style={{ fontSize: 14, fontWeight: 600, color: 'var(--ink-faint)' }}>days</span>
              </div>
            </div>
            <div className="card" style={{ padding: '20px 22px' }}>
              <div style={{ fontSize: 12.5, color: 'var(--ink-faint)', fontWeight: 600, marginBottom: 8 }}>
                今日の学習
              </div>
              <div style={{ fontSize: 26, fontWeight: 900 }}>
                {todayMinutes}
                <span style={{ fontSize: 14, fontWeight: 600, color: 'var(--ink-faint)' }}>min</span>
              </div>
            </div>
          </div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
          <div className="card" style={{ padding: '22px 24px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
              <div style={{ fontSize: 15, fontWeight: 700 }}>最近追加した単語</div>
              <a onClick={() => navigate('/words')} style={{ fontSize: 12.5, fontWeight: 600, cursor: 'pointer' }}>
                すべて見る
              </a>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column' }}>
              {recent.map((w, i) => (
                <div
                  key={w.id}
                  onClick={() => navigate(`/words/${w.id}`)}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 12,
                    padding: '9px 0',
                    borderBottom: i < recent.length - 1 ? '1px solid var(--border)' : undefined,
                    cursor: 'pointer',
                  }}
                >
                  {w.imageUrl ? (
                    <img
                      src={w.imageUrl}
                      alt=""
                      style={{ width: 38, height: 38, borderRadius: 9, objectFit: 'cover', flex: '0 0 38px' }}
                    />
                  ) : (
                    <div
                      style={{ width: 38, height: 38, borderRadius: 9, background: 'var(--accent-soft)', flex: '0 0 38px' }}
                    />
                  )}
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div className="serif" style={{ fontWeight: 600, fontSize: 14.5 }}>
                      {w.word}
                    </div>
                    <div
                      style={{
                        fontSize: 12,
                        color: 'var(--ink-faint)',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      }}
                    >
                      {w.status === 'pending_review' ? '要確認' : w.meaning || '（意味未入力）'}
                    </div>
                  </div>
                  {w.status !== 'pending_review' && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: 5, flex: '0 0 auto' }}>
                      <span
                        style={{
                          width: 7,
                          height: 7,
                          borderRadius: '50%',
                          background: STATUS_COLOR[w.status],
                          display: 'inline-block',
                        }}
                      />
                      <span style={{ fontSize: 11, fontWeight: 700, color: STATUS_INK[w.status] }}>
                        {STATUS_LABEL[w.status]}
                      </span>
                    </div>
                  )}
                </div>
              ))}
              {recent.length === 0 && (
                <div style={{ fontSize: 13, color: 'var(--ink-faint)', padding: '12px 0' }}>まだ単語がありません</div>
              )}
            </div>
          </div>

          {weakWords.length > 0 && (
            <div
              className="card"
              style={{
                padding: '22px 24px',
                background: 'linear-gradient(160deg, var(--accent-soft), var(--bg-elevated) 60%)',
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
                <LoopIcon size={17} style={{ color: 'var(--accent)' }} />
                <div style={{ fontSize: 15, fontWeight: 700 }}>今日の一周</div>
              </div>
              <div style={{ fontSize: 12.5, color: 'var(--ink-muted)', lineHeight: 1.6, marginBottom: 16 }}>
                「まだ」の単語が{weakWords.length}語あります。忘れる前にサクッと1周しませんか？
              </div>
              <button
                className="btn-primary"
                style={{ width: '100%', justifyContent: 'center' }}
                onClick={() => navigate('/study/scope?preset=weak')}
              >
                <PlayIcon size={16} />
                {weakWords.length}語を復習する
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
