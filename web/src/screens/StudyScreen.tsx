import { useEffect, useRef, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { db } from '../db/db';
import { deleteWord, updateStatus } from '../db/wordRepository';
import { startSession, endSession, recordResult, deleteLog } from '../db/studyRepository';
import type { StudyResult, Word, WordStatus } from '../db/types';
import { useSettings } from '../store/settingsStore';
import { CheckIcon, ImageIcon, PlayIcon, TrashIcon, UndoIcon, VolumeIcon, XIcon } from '../components/icons';

interface JudgedEntry {
  word: Word;
  logId: string;
  previousStatus: WordStatus;
  result: StudyResult;
}

function speak(text: string) {
  if (!('speechSynthesis' in window) || !text) return;
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = 'en-US';
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(utterance);
}

export function StudyScreen() {
  const navigate = useNavigate();
  const location = useLocation();
  const { reverseJudge } = useSettings();

  const [queue, setQueue] = useState<Word[] | null>(null);
  const [index, setIndex] = useState(0);
  const [revealed, setRevealed] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [history, setHistory] = useState<JudgedEntry[]>([]);
  const [finished, setFinished] = useState(false);
  const [deleteArmed, setDeleteArmed] = useState(false);
  const [busy, setBusy] = useState(false);
  const disarmTimer = useRef<number | null>(null);

  useEffect(() => {
    const wordIds: string[] | undefined = (location.state as { wordIds?: string[] } | null)?.wordIds;
    (async () => {
      let words: Word[];
      if (wordIds) {
        const fetched = await Promise.all(wordIds.map((id) => db.words.get(id)));
        words = fetched.filter((w): w is Word => !!w);
      } else {
        words = await db.words.where('status').notEqual('pending_review').toArray();
      }
      setQueue(words);
      setSessionId(await startSession());
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const current = queue && !finished ? queue[index] : undefined;

  const finishSession = async (finalHistory: JudgedEntry[], total: number) => {
    const rememberedCount = finalHistory.filter((h) => h.result === 'remembered').length;
    const accuracy = total === 0 ? 0 : rememberedCount / total;
    if (sessionId) await endSession(sessionId, total, accuracy);
    setFinished(true);
  };

  const judge = async (result: StudyResult) => {
    if (!current || !sessionId || busy) return;
    setBusy(true);
    const logId = await recordResult(current.id, sessionId, result);
    await updateStatus(current.id, result);
    const entry: JudgedEntry = { word: current, logId, previousStatus: current.status, result };
    const nextHistory = [...history, entry];
    setHistory(nextHistory);
    const nextIndex = index + 1;
    setIndex(nextIndex);
    setRevealed(false);
    setDeleteArmed(false);
    setBusy(false);
    if (queue && nextIndex >= queue.length) {
      await finishSession(nextHistory, queue.length);
    }
  };

  const undo = async () => {
    if (history.length === 0 || busy) return;
    setBusy(true);
    const last = history[history.length - 1];
    await deleteLog(last.logId);
    await updateStatus(last.word.id, last.previousStatus);
    setHistory((h) => h.slice(0, -1));
    setIndex((i) => i - 1);
    setRevealed(false);
    setFinished(false);
    setBusy(false);
  };

  const handleDeleteClick = () => {
    if (!deleteArmed) {
      setDeleteArmed(true);
      if (disarmTimer.current) window.clearTimeout(disarmTimer.current);
      disarmTimer.current = window.setTimeout(() => setDeleteArmed(false), 3000);
      return;
    }
    void handleDeleteConfirm();
  };

  const handleDeleteConfirm = async () => {
    if (!current || !queue) return;
    await deleteWord(current.id);
    const nextQueue = queue.filter((w) => w.id !== current.id);
    setQueue(nextQueue);
    setRevealed(false);
    setDeleteArmed(false);
    if (index >= nextQueue.length) {
      await finishSession(history, nextQueue.length);
    }
  };

  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if (finished || !current) return;
      if (e.key === 'ArrowLeft') judge(reverseJudge ? 'remembered' : 'not_yet');
      else if (e.key === 'ArrowRight') judge(reverseJudge ? 'not_yet' : 'remembered');
      else if (e.key === ' ') {
        e.preventDefault();
        setRevealed((r) => !r);
      }
    }
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [current, finished, reverseJudge, history, index, busy]);

  if (queue === null) return null;

  if (queue.length === 0 && !finished) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '100vh', gap: 16 }}>
        <div style={{ fontSize: 15, color: 'var(--ink-muted)' }}>学習できる単語がありません</div>
        <button className="btn-primary" onClick={() => navigate('/')}>
          ホームに戻る
        </button>
      </div>
    );
  }

  const total = queue.length;
  const rememberedCount = history.filter((h) => h.result === 'remembered').length;
  const stillWeak = history.filter((h) => h.result === 'not_yet').map((h) => h.word.id);

  const startToEndResult: StudyResult = reverseJudge ? 'not_yet' : 'remembered';
  const startToEndLabel = reverseJudge ? 'まだ' : '覚えた';
  const endToStartLabel = reverseJudge ? '覚えた' : 'まだ';

  return (
    <div style={{ width: '100%', height: '100vh', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <div style={{ height: 60, flex: '0 0 60px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 28px' }}>
        <button className="iconbtn" title="終了する" onClick={() => navigate('/')}>
          <XIcon size={16} />
        </button>
        {!finished && (
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{ width: 220, height: 6, background: 'var(--border)', borderRadius: 999, overflow: 'hidden' }}>
              <div style={{ width: `${(index / total) * 100}%`, height: '100%', background: 'var(--accent)' }} />
            </div>
            <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--ink-muted)' }}>
              {Math.min(index + 1, total)} / {total}
            </div>
          </div>
        )}
        {!finished && (
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <button className="iconbtn" title="直前の判定を戻す" onClick={undo} disabled={history.length === 0}>
              <UndoIcon size={16} />
            </button>
            <div style={{ width: 1, height: 18, background: 'var(--border)' }} />
            {!deleteArmed ? (
              <button className="iconbtn" title="この単語を削除" onClick={handleDeleteClick}>
                <TrashIcon size={16} />
              </button>
            ) : (
              <button
                onClick={handleDeleteClick}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 6,
                  height: 36,
                  padding: '0 12px',
                  borderRadius: 10,
                  background: 'var(--rose-soft)',
                  color: 'var(--rose-ink)',
                  fontSize: 12,
                  fontWeight: 700,
                  whiteSpace: 'nowrap',
                  border: 'none',
                  cursor: 'pointer',
                }}
              >
                <TrashIcon size={15} />
                もう一度タップで削除
              </button>
            )}
          </div>
        )}
        {finished && <div style={{ width: 36 }} />}
      </div>

      {!finished && current && (
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0 40px 20px' }}>
          <div style={{ width: 640, background: 'var(--bg-elevated)', border: '1px solid var(--border)', borderRadius: 26, boxShadow: 'var(--shadow)', overflow: 'hidden' }}>
            {revealed ? (
              <div>
                <div
                  style={{
                    height: 220,
                    backgroundImage: current.imageUrl
                      ? `url(${current.imageUrl})`
                      : 'linear-gradient(135deg, var(--accent-soft), var(--gray-soft))',
                    backgroundSize: 'cover',
                    backgroundPosition: 'center',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: 'var(--ink-faint)',
                  }}
                  onClick={() => setRevealed(false)}
                >
                  {!current.imageUrl && <ImageIcon size={46} />}
                </div>
                <div style={{ padding: '32px 40px 28px' }}>
                  <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                    <div className="serif" style={{ fontSize: 22, lineHeight: 1.68, flex: 1 }}>
                      {highlightSentence(current.exampleEn, current.word)}
                    </div>
                    <button className="iconbtn" style={{ flex: '0 0 36px' }} onClick={() => speak(current.exampleEn)}>
                      <VolumeIcon size={16} />
                    </button>
                  </div>
                  <div style={{ fontSize: 14, color: 'var(--ink-muted)', marginTop: 10 }}>{current.exampleJa}</div>

                  <div style={{ borderTop: '1px solid var(--border)', marginTop: 22, paddingTop: 22 }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                      <span className="serif" style={{ fontWeight: 800, fontSize: 24 }}>
                        {current.word}
                      </span>
                      <button className="iconbtn" style={{ width: 32, height: 32 }} onClick={() => speak(current.word)}>
                        <VolumeIcon size={15} />
                      </button>
                    </div>
                    <div style={{ fontSize: 15.5, color: 'var(--ink-muted)', marginTop: 6 }}>{current.meaning}</div>
                    {current.synonyms.length > 0 && (
                      <div style={{ fontSize: 13, color: 'var(--ink-faint)', marginTop: 14 }}>
                        類語　{current.synonyms.join(' ・ ')}
                      </div>
                    )}
                    {current.etymology && (
                      <div style={{ fontSize: 13, color: 'var(--ink-faint)', marginTop: 6 }}>語源　{current.etymology}</div>
                    )}
                  </div>
                </div>
              </div>
            ) : (
              <div
                style={{ padding: '80px 48px', display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center', gap: 26, cursor: 'pointer' }}
                onClick={() => setRevealed(true)}
              >
                <div className="serif" style={{ fontSize: 22, lineHeight: 1.68 }}>
                  {highlightSentence(current.exampleEn, current.word)}
                </div>
                <button
                  className="iconbtn"
                  style={{ width: 40, height: 40 }}
                  onClick={(e) => {
                    e.stopPropagation();
                    speak(current.exampleEn);
                  }}
                >
                  <VolumeIcon size={18} />
                </button>
                <div style={{ fontSize: 12.5, color: 'var(--ink-faint)', fontWeight: 600 }}>カードをクリックして裏面を見る</div>
              </div>
            )}
          </div>
        </div>
      )}

      {!finished && current && (
        <div style={{ flex: '0 0 100px', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 22, paddingBottom: 14 }}>
          <button
            onClick={() => judge(reverseJudge ? 'remembered' : 'not_yet')}
            style={judgeBtnStyle('var(--rose-soft)', 'var(--rose-ink)')}
            disabled={busy}
          >
            <XIcon size={19} />
            {endToStartLabel}
            <span style={kbdStyle('var(--rose)', 'var(--rose-ink)')}>←</span>
          </button>
          <button
            onClick={() => judge(startToEndResult)}
            style={judgeBtnStyle('var(--green-soft)', 'var(--green-ink)')}
            disabled={busy}
          >
            <CheckIcon size={19} />
            {startToEndLabel}
            <span style={kbdStyle('var(--green)', 'var(--green-ink)')}>→</span>
          </button>
        </div>
      )}

      {finished && (
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0 40px 40px' }}>
          <div className="card" style={{ width: 520, padding: '56px 48px', display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center', gap: 20 }}>
            <div
              style={{
                width: 64,
                height: 64,
                borderRadius: '50%',
                background: 'var(--green-soft)',
                color: 'var(--green-ink)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <CheckIcon size={30} />
            </div>
            <div>
              <h1 style={{ margin: '0 0 6px', fontSize: 21, fontWeight: 900 }}>1周お疲れさまでした！</h1>
              <div style={{ fontSize: 14, color: 'var(--ink-muted)' }}>
                覚えた {rememberedCount} / {total}語（{total === 0 ? 0 : Math.round((rememberedCount / total) * 100)}%）
              </div>
            </div>
            <div style={{ width: '100%', height: 8, background: 'var(--gray-soft)', borderRadius: 999, overflow: 'hidden' }}>
              <div style={{ width: `${total === 0 ? 0 : (rememberedCount / total) * 100}%`, height: '100%', background: 'var(--green)' }} />
            </div>
            <div style={{ display: 'flex', gap: 12, width: '100%', marginTop: 8 }}>
              <button
                onClick={() => navigate('/')}
                style={{
                  flex: 1,
                  border: '1px solid var(--border)',
                  borderRadius: 12,
                  padding: 13,
                  fontSize: 13.5,
                  fontWeight: 700,
                  color: 'var(--ink-muted)',
                  background: 'transparent',
                  cursor: 'pointer',
                }}
              >
                ホームに戻る
              </button>
              {stillWeak.length > 0 && (
                <button
                  className="btn-primary"
                  style={{ flex: 1, justifyContent: 'center', padding: 13 }}
                  onClick={() => navigate('/study', { state: { wordIds: stillWeak }, replace: true })}
                >
                  <PlayIcon size={16} />
                  まだの{stillWeak.length}語をもう1周
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function judgeBtnStyle(bg: string, color: string): React.CSSProperties {
  return {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    border: 'none',
    borderRadius: 14,
    padding: '16px 30px',
    fontWeight: 800,
    fontSize: 15,
    cursor: 'pointer',
    background: bg,
    color,
  };
}
function kbdStyle(base: string, color: string): React.CSSProperties {
  return {
    fontSize: 11,
    fontWeight: 700,
    background: `color-mix(in oklch, ${base} 15%, transparent)`,
    color,
    padding: '2px 7px',
    borderRadius: 5,
  };
}

function highlightSentence(sentence: string, word: string) {
  if (!sentence) return sentence;
  const idx = sentence.toLowerCase().indexOf(word.toLowerCase());
  if (idx === -1) return sentence;
  return (
    <>
      {sentence.slice(0, idx)}
      <span style={{ color: 'var(--accent)', fontWeight: 700 }}>{sentence.slice(idx, idx + word.length)}</span>
      {sentence.slice(idx + word.length)}
    </>
  );
}
