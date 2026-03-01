import { lazy, Suspense } from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import { AuthGuard } from './guards/AuthGuard'
import { Skeleton } from '@/shared/ui'

const LoginPage = lazy(() => import('@/pages/auth/LoginPage').then((m) => ({ default: m.LoginPage })))

const EmployeeAllAccountsPage = lazy(() =>
  import('@/pages/employee/AllAccountsPage').then((m) => ({ default: m.EmployeeAllAccountsPage })),
)
const EmployeeClientsPage = lazy(() =>
  import('@/pages/employee/ClientsPage').then((m) => ({ default: m.EmployeeClientsPage })),
)
const EmployeeEmployeesPage = lazy(() =>
  import('@/pages/employee/EmployeesPage').then((m) => ({ default: m.EmployeeEmployeesPage })),
)
const EmployeeTariffsPage = lazy(() =>
  import('@/pages/employee/TariffsPage').then((m) => ({ default: m.EmployeeTariffsPage })),
)

function PageFallback() {
  return (
    <div className="p-8 space-y-4">
      <Skeleton className="h-8 w-64" />
      <Skeleton className="h-4 w-full" />
      <Skeleton className="h-4 w-3/4" />
    </div>
  )
}

export function AppRouter() {
  return (
    <Suspense fallback={<PageFallback />}>
      <Routes>
        {/* Public */}
        <Route path="/login" element={<LoginPage />} />
        <Route path="/" element={<Navigate to="/login" replace />} />

        {/* Protected — employee only */}
        <Route element={<AuthGuard />}>
          <Route path="/employee/dashboard" element={<EmployeeAllAccountsPage />} />
          <Route path="/employee/accounts"  element={<EmployeeAllAccountsPage />} />
          <Route path="/employee/clients"   element={<EmployeeClientsPage />} />
          <Route path="/employee/employees" element={<EmployeeEmployeesPage />} />
          <Route path="/employee/tariffs"   element={<EmployeeTariffsPage />} />
        </Route>

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Suspense>
  )
}
