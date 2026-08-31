import { useEffect, useState } from 'react';
import { getCurrentStreak, getMonthlyStudyRecords, type DailyStudyRecord } from '../db/studyRepository';
import { ChevronLeftIcon, ChevronRightIcon } from '../components/icons';

const WEEKDAY_LABELS = ['日', '月', '火', '水', '木', '金', '土'];

export function RecordScreen() {
  const [cursor, setCursor] = useState(() => {
    const now = new Date();
    return { year: now.getFullYear(), month: now.getMonth() };
  });
  const [records, setRecords] = useState<DailyStudyRecord[]>([]);
  const [streak, setStreak] = useState(0);

  useEffect(() => {
    getMonthlyStudyRecords(cursor.year, cursor.month).then(setRecords);
    getCurrentStreak().then(setStreak);
  }, [cursor]);

  const byDay = new Map(records.map((r) => [r.day, r.durationMs]));
  const totalMs = records.reduce((sum, r) => sum + r.durationMs, 0);
  const totalMinutes = Math.round(totalMs / 60000);
  const totalHours = Math.floor(totalMinutes / 60);
  const totalRemainMinutes = totalMinutes % 60;
  const maxMinutes = records.length === 0 ? 0 : Math.max(...records.map((r) => Math.round(r.durationMs / 60000)));

  const firstOfMonth = new Date(cursor.year, cursor.month, 1);
  const daysInMonth = new Date(cursor.year, cursor.month + 1, 0).getDate();
  const leadingEmpty = firstOfMonth.getDay();
  const todayKey = (() => {
    const t = new Date();
    return `${t.getFullYear()}-${String(t.getMonth() + 1).padStart(2, '0')}-${String(t.getDate()).padStart(2, '0')}`;
  })();

  const cells: (number | null)[] = [
    ...Array(leadingEmpty).fill(null),
    ...Array.from({ length: daysInMonth }, (_, i) => i + 1),
  ];
  while (cells.length % 7 !== 0) cells.push(null);

  return (
    <div style={{ maxWidth: 900 }}>
      <h1 style={{ margin: '0 0 22px', fontSize: 22, fontWeight: 900 }}>学習記録</h1>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 18, marginBottom: 20 }}>
        <StatCard label="月間合計" value={`${totalHours}h${totalRemainMinutes}min`} />
        <StatCard label="連続学習日数" value={`${streak}days`} accent />
        <StatCard label="今月の学習回数" value={String(records.length)} unit="回" />
      </div>

      <div className="card" style={{ padding: '26px 30px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 18, marginBottom: 22 }}>
          <button
            className="iconbtn"
            style={{ width: 32, height: 32 }}
            onClick={() => setCursor((c) => (c.month === 0 ? { year: c.year - 1, month: 11 } : { year: c.year, month: c.month - 1 }))}
          >
            <ChevronLeftIcon size={14} />
          </button>
          <div style={{ fontSize: 16, fontWeight: 800, width: 120, textAlign: 'center' }}>
            {cursor.year}年{cursor.month + 1}月
          </div>
          <button
            className="iconbtn"
            style={{ width: 32, height: 32 }}
            onClick={() => setCursor((c) => (c.month === 11 ? { year: c.year + 1, month: 0 } : { year: c.year, month: c.month + 1 }))}
          >
            <ChevronRightIcon size={14} />
          </button>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 8, marginBottom: 8 }}>
          {WEEKDAY_LABELS.map((label) => (
            <div key={label} style={{ textAlign: 'center', fontSize: 12, fontWeight: 700, color: 'var(--ink-faint)' }}>
              {label}
            </div>
          ))}
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 8 }}>
          {cells.map((day, i) => {
            if (day === null) return <div key={i} style={{ height: 66 }} />;
            const key = `${cursor.year}-${String(cursor.month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            const ms = byDay.get(key) ?? 0;
            const minutes = Math.round(ms / 60000);
            const ratio = maxMinutes === 0 ? 0 : Math.min(1, minutes / maxMinutes);
            const isToday = key === todayKey;
            return (
              <div
                key={i}
                style={{
                  height: 66,
                  borderRadius: 10,
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: 2,
                  background:
                    minutes > 0
                      ? `color-mix(in oklch, var(--green) ${Math.round(20 + ratio * 60)}%, var(--bg-elevated))`
                      : 'var(--gray-soft)',
                  border: isToday ? '2px solid var(--accent)' : undefined,
                }}
              >
                <span style={{ fontSize: 12, color: minutes > 0 ? 'var(--green-ink)' : 'var(--ink-faint)' }}>{day}</span>
                {minutes > 0 && (
                  <span style={{ fontSize: 10.5, fontWeight: 700, color: 'var(--green-ink)' }}>{minutes}min</span>
                )}
              </div>
            );
          })}
        </div>

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 8, marginTop: 18, fontSize: 11.5, color: 'var(--ink-faint)' }}>
          少ない
          <Swatch pct={0} />
          <Swatch pct={35} />
          <Swatch pct={55} />
          <Swatch pct={80} />
          多い
        </div>
      </div>
    </div>
  );
}

function StatCard({ label, value, unit, accent }: { label: string; value: string; unit?: string; accent?: boolean }) {
  return (
    <div className="card" style={{ padding: '18px 22px' }}>
      <div style={{ fontSize: 12.5, color: 'var(--ink-faint)', fontWeight: 600, marginBottom: 8 }}>{label}</div>
      <div style={{ fontSize: 24, fontWeight: 900, letterSpacing: '-0.01em', color: accent ? 'var(--accent)' : undefined }}>
        {value}
        {unit && <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--ink-faint)' }}>{unit}</span>}
      </div>
    </div>
  );
}

function Swatch({ pct }: { pct: number }) {
  return (
    <span
      style={{
        width: 14,
        height: 14,
        borderRadius: 4,
        display: 'inline-block',
        background: pct === 0 ? 'var(--gray-soft)' : `color-mix(in oklch, var(--green) ${pct}%, var(--bg-elevated))`,
      }}
    />
  );
}
