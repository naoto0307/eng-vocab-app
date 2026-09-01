import { useEffect, useState, type ReactNode } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { Sidebar } from './Sidebar';

export function HubLayout({ children }: { children: ReactNode }) {
  const location = useLocation();
  const navigate = useNavigate();
  const [toast, setToast] = useState<string | null>(null);

  useEffect(() => {
    const state = location.state as { toast?: string } | null;
    if (state?.toast) {
      setToast(state.toast);
      navigate(location.pathname, { replace: true, state: {} });
      const timer = window.setTimeout(() => setToast(null), 3500);
      return () => window.clearTimeout(timer);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [location.state]);

  return (
    <div className="app-shell">
      <Sidebar />
      <main style={{ flex: 1, overflow: 'auto', padding: '36px 44px', position: 'relative' }}>
        {children}
        {toast && (
          <div
            style={{
              position: 'fixed',
              bottom: 28,
              left: '50%',
              transform: 'translateX(-50%)',
              background: 'var(--ink)',
              color: 'var(--bg)',
              padding: '12px 22px',
              borderRadius: 12,
              fontSize: 13.5,
              fontWeight: 600,
              boxShadow: 'var(--shadow)',
              zIndex: 100,
            }}
          >
            {toast}
          </div>
        )}
      </main>
    </div>
  );
}
