import { useMutation } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { UserApi } from '@/entities/user'
import { useAuthStore } from '@/app/store/auth.store'
import { Button } from '@/shared/ui/Button'

export function Header() {
  const navigate = useNavigate()
  const { user, clearAuth } = useAuthStore()

  const { mutate: logout, isPending } = useMutation({
    mutationFn: UserApi.logout,
    onSettled: () => {
      clearAuth()
      navigate('/login', { replace: true })
    },
  })

  return (
    <header className="sticky top-0 z-40 border-b border-slate-200 bg-white px-6 py-3">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-700 text-white text-sm font-bold">
            B
          </div>
          <span className="font-semibold text-slate-900">InternetBank</span>
        </div>
        <div className="flex items-center gap-4">
          {user && (
            <div className="text-right">
              <p className="text-sm font-medium text-slate-900">
                {user.firstName} {user.lastName}
              </p>
              <p className="text-xs text-slate-500">
                {user.role === 'EMPLOYEE' ? 'Сотрудник' : 'Клиент'}
              </p>
            </div>
          )}
          <Button variant="ghost" size="sm" onClick={() => logout()} loading={isPending}>
            Выйти
          </Button>
        </div>
      </div>
    </header>
  )
}
