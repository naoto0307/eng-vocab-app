import { useSettings } from '../store/settingsStore';

export function SettingsScreen() {
  const { reverseJudge, setReverseJudge, skipScanPreview, setSkipScanPreview } = useSettings();

  return (
    <div style={{ maxWidth: 640 }}>
      <h1 style={{ margin: '0 0 22px', fontSize: 22, fontWeight: 900 }}>設定</h1>

      <SectionLabel>学習</SectionLabel>
      <div className="card" style={{ marginBottom: 26 }}>
        <Row
          title="判定方向を入れ替え"
          description="ONで ← まだ／→ 覚えた と ← 覚えた／→ まだ を入れ替えます"
        >
          <button className={`toggle${reverseJudge ? ' on' : ''}`} onClick={() => setReverseJudge(!reverseJudge)}>
            <div className="dot" />
          </button>
        </Row>
        <Row
          title="スキャン確認をスキップ"
          description="ONにすると、スキャンした単語をプレビューなしで即登録します"
          borderTop
        >
          <button className={`toggle${skipScanPreview ? ' on' : ''}`} onClick={() => setSkipScanPreview(!skipScanPreview)}>
            <div className="dot" />
          </button>
        </Row>
      </div>

      <SectionLabel>表示</SectionLabel>
      <div className="card" style={{ marginBottom: 26 }}>
        <Row title="カラーテーマ" description="お使いの端末・ブラウザの設定に自動で追従します">
          <div style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--ink-muted)' }}>自動</div>
        </Row>
      </div>

      <SectionLabel>データ</SectionLabel>
      <div className="card">
        <Row title="保存先" description="単語・学習記録はこの端末のブラウザ内（IndexedDB）に保存されています">
          <div style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--ink-muted)' }}>ローカル</div>
        </Row>
      </div>
    </div>
  );
}

function SectionLabel({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--ink-faint)', marginBottom: 10, paddingLeft: 2 }}>
      {children}
    </div>
  );
}

function Row({
  title,
  description,
  borderTop,
  children,
}: {
  title: string;
  description: string;
  borderTop?: boolean;
  children: React.ReactNode;
}) {
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '18px 26px',
        borderTop: borderTop ? '1px solid var(--border)' : undefined,
      }}
    >
      <div>
        <div style={{ fontSize: 14, fontWeight: 600 }}>{title}</div>
        <div style={{ fontSize: 12.5, color: 'var(--ink-faint)', marginTop: 3, maxWidth: 380 }}>{description}</div>
      </div>
      {children}
    </div>
  );
}
