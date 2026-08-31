import type { ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronLeftIcon } from './icons';

interface FocusedLayoutProps {
  title: string;
  subtitle?: string;
  backLabel?: string;
  onBack?: () => void;
  actions?: ReactNode;
  children: ReactNode;
  bodyStyle?: React.CSSProperties;
}

export function FocusedLayout({
  title,
  subtitle,
  backLabel = '戻る',
  onBack,
  actions,
  children,
  bodyStyle,
}: FocusedLayoutProps) {
  const navigate = useNavigate();
  const handleBack = onBack ?? (() => navigate(-1));

  return (
    <div className="app-shell" style={{ flexDirection: 'column' }}>
      <div className="focused-topbar">
        <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
          <button className="back-link" onClick={handleBack}>
            <ChevronLeftIcon />
            {backLabel}
          </button>
          <div style={{ width: 1, height: 20, background: 'var(--border)' }} />
          <div>
            <div style={{ fontWeight: 700, fontSize: 15 }}>{title}</div>
            {subtitle && <div style={{ fontSize: 11.5, color: 'var(--ink-faint)' }}>{subtitle}</div>}
          </div>
        </div>
        {actions}
      </div>
      <div style={{ flex: 1, overflow: 'auto', ...bodyStyle }}>{children}</div>
    </div>
  );
}
