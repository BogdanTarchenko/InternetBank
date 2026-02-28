import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@/app/store/auth.store'
import type { UserRole } from '@/shared/lib/permissions'

interface RoleGuardProps {
  role: UserRole
}

export function RoleGuard({ role }: RoleGuardProps) {
  const userRole = useAuthStore((s) => s.role)

  if (userRole !== role) {
    const fallback = userRole === 'EMPLOYEE' ? '/employee/dashboard' : '/client/dashboard'
    return <Navigate to={fallback} replace />
  }

  return <Outlet />
}
