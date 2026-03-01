import { useAuthStore } from '@/app/store/auth.store'
import { Button } from '@/shared/ui/Button'

export function Header() {
  const user = useAuthStore((s) => s.user)
  const appRole = useAuthStore((s) => s.appRole)
  const clearAuth = useAuthStore((s) => s.clearAuth)

  const roleLabel = appRole === 'EMPLOYEE' ? 'Сотрудник' : 'Клиент'

  return (
    <header className="flex h-14 items-center justify-between border-b bg-white px-6 shadow-sm">
      <div className="flex items-center gap-3">
        <span className="text-lg font-bold text-blue-700">💳 InternetBank</span>
        <span className="rounded-full bg-blue-50 px-2 py-0.5 text-xs font-medium text-blue-600">
          {roleLabel}
        </span>
      </div>
      {user && (
        <div className="flex items-center gap-4">
          <span className="text-sm text-slate-600">{user.name}</span>
          <Button size="sm" variant="ghost" onClick={clearAuth}>
            Выйти
          </Button>
        </div>
      )}
    </header>
  )
}
