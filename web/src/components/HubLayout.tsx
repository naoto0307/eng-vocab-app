import type { ReactNode } from 'react';
import { Sidebar } from './Sidebar';

export function HubLayout({ children }: { children: ReactNode }) {
  return (
    <div className="app-shell">
      <Sidebar />
      <main style={{ flex: 1, overflow: 'auto', padding: '36px 44px' }}>{children}</main>
    </div>
  );
}
