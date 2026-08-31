import { NavLink, useNavigate } from 'react-router-dom';
import { BookIcon, CalendarIcon, HomeIcon, PlusIcon, SlidersIcon } from './icons';

export function Sidebar() {
  const navigate = useNavigate();

  return (
    <aside className="sidebar">
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '4px 6px 22px' }}>
        <div
          style={{
            width: 34,
            height: 34,
            borderRadius: 10,
            background: 'var(--accent)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'white',
            fontFamily: "'Source Serif 4', serif",
            fontWeight: 600,
            fontSize: 18,
          }}
        >
          単
        </div>
        <div style={{ fontWeight: 700, fontSize: 16 }}>単語帳</div>
      </div>

      <button
        className="btn-primary"
        style={{ width: '100%', justifyContent: 'center', marginBottom: 20 }}
        onClick={() => navigate('/add')}
      >
        <PlusIcon size={18} />
        単語を追加
      </button>

      <nav style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
        <NavLink to="/" end className={({ isActive }) => `nav-item${isActive ? ' active' : ''}`}>
          <HomeIcon />
          ホーム
        </NavLink>
        <NavLink to="/words" className={({ isActive }) => `nav-item${isActive ? ' active' : ''}`}>
          <BookIcon />
          単語帳一覧
        </NavLink>
        <NavLink to="/record" className={({ isActive }) => `nav-item${isActive ? ' active' : ''}`}>
          <CalendarIcon />
          学習記録
        </NavLink>
        <NavLink to="/settings" className={({ isActive }) => `nav-item${isActive ? ' active' : ''}`}>
          <SlidersIcon />
          設定
        </NavLink>
      </nav>

      <div
        style={{
          marginTop: 'auto',
          paddingTop: 16,
          borderTop: '1px solid var(--border)',
          display: 'flex',
          alignItems: 'center',
          gap: 10,
        }}
      >
        <div
          style={{
            width: 32,
            height: 32,
            borderRadius: '50%',
            background: 'var(--accent-soft)',
            color: 'var(--accent)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontWeight: 700,
            fontSize: 13,
          }}
        >
          N
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 13, fontWeight: 600 }}>naoto</div>
          <div
            style={{
              fontSize: 11.5,
              color: 'var(--ink-faint)',
              display: 'flex',
              alignItems: 'center',
              gap: 5,
            }}
          >
            <span className="badge-dot" style={{ background: 'var(--green)' }} />
            ローカル保存
          </div>
        </div>
      </div>
    </aside>
  );
}
