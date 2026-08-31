import { useNavigate } from 'react-router-dom';
import { FocusedLayout } from '../components/FocusedLayout';
import { CameraIcon, ChevronRightIcon, PencilIcon } from '../components/icons';

export function AddMethodScreen() {
  const navigate = useNavigate();

  return (
    <FocusedLayout title="単語を追加" onBack={() => navigate('/')}>
      <div
        style={{
          minHeight: '100%',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 44,
          padding: '40px 20px',
        }}
      >
        <div style={{ textAlign: 'center' }}>
          <h1 style={{ margin: '0 0 8px', fontSize: 24, fontWeight: 900 }}>どうやって追加しますか？</h1>
          <div style={{ fontSize: 14, color: 'var(--ink-muted)' }}>
            単語を1語ずつ入力するか、テキストにマーカーを引いた紙・PDFをまとめて取り込みます。
          </div>
        </div>

        <div style={{ display: 'flex', gap: 28, flexWrap: 'wrap', justifyContent: 'center' }}>
          <MethodCard
            icon={<PencilIcon size={28} />}
            title="手動で入力する"
            description="単語を入力すれば、意味・例文・類語を自動生成。じっくり1語ずつ丁寧に登録したいときに。"
            onClick={() => navigate('/add/manual')}
            highlighted
          />
          <MethodCard
            icon={<CameraIcon size={28} />}
            title="マーカースキャンで追加"
            description="マーカーを引いた参考書のページやPDFをアップロード。単語をまとめて検出して一括登録します。"
            disabled
          />
        </div>
      </div>
    </FocusedLayout>
  );
}

function MethodCard({
  icon,
  title,
  description,
  onClick,
  highlighted,
  disabled,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
  onClick?: () => void;
  highlighted?: boolean;
  disabled?: boolean;
}) {
  return (
    <div
      onClick={disabled ? undefined : onClick}
      style={{
        background: 'var(--bg-elevated)',
        border: `1.5px solid ${highlighted ? 'var(--accent)' : 'var(--border)'}`,
        boxShadow: highlighted ? 'var(--shadow)' : undefined,
        borderRadius: 22,
        padding: '40px 36px',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'flex-start',
        gap: 16,
        cursor: disabled ? 'not-allowed' : 'pointer',
        width: 340,
        opacity: disabled ? 0.6 : 1,
      }}
    >
      <div
        style={{
          width: 56,
          height: 56,
          borderRadius: 16,
          background: highlighted ? 'var(--accent-soft)' : 'var(--gray-soft)',
          color: highlighted ? 'var(--accent)' : 'var(--ink-muted)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        {icon}
      </div>
      <div>
        <div style={{ fontSize: 17, fontWeight: 800, marginBottom: 6 }}>{title}</div>
        <div style={{ fontSize: 13.5, color: 'var(--ink-muted)', lineHeight: 1.6 }}>{description}</div>
      </div>
      <div
        style={{
          marginTop: 6,
          fontSize: 13,
          fontWeight: 700,
          color: highlighted ? 'var(--accent)' : 'var(--ink-faint)',
          display: 'flex',
          alignItems: 'center',
          gap: 4,
        }}
      >
        {disabled ? '準備中' : 'はじめる'}
        {!disabled && <ChevronRightIcon size={15} />}
      </div>
    </div>
  );
}
