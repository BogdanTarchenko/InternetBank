import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@/app/store/auth.store'
import type { AppRole } from '@/shared/lib/permissions'

interface RoleGuardProps {
  role: AppRole
}

export function RoleGuard({ role }: RoleGuardProps) {
  const appRole = useAuthStore((s) => s.appRole)

  if (appRole !== role) {
    const fallback = appRole === 'EMPLOYEE' ? '/employee/dashboard' : '/client/dashboard'
    return <Navigate to={fallback} replace />
  }

  return <Outlet />
}
