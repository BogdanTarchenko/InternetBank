import { NavLink } from 'react-router-dom'
import { clsx } from 'clsx'

const clientLinks = [
  { to: '/client/dashboard', label: 'Мои счета', icon: '💳' },
  { to: '/client/credits', label: 'Кредиты', icon: '📋' },
]

export function ClientSidebar() {
  return (
    <aside className="w-56 shrink-0 border-r border-slate-200 bg-white">
      <nav className="p-3 space-y-1">
        {clientLinks.map(({ to, label, icon }) => (
          <NavLink
            key={to}
            to={to}
            className={({ isActive }) =>
              clsx(
                'flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
                isActive
                  ? 'bg-blue-50 text-blue-700'
                  : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900',
              )
            }
          >
            <span>{icon}</span>
            {label}
          </NavLink>
        ))}
      </nav>
    </aside>
  )
}
