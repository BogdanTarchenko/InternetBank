import { lazy, Suspense } from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import { AuthGuard } from './guards/AuthGuard'
import { Skeleton } from '@/shared/ui'

const LoginPage = lazy(() => import('@/pages/auth/LoginPage').then((m) => ({ default: m.LoginPage })))
const RegisterPage = lazy(() => import('@/pages/auth/RegisterPage').then((m) => ({ default: m.RegisterPage })))

const ClientDashboardPage = lazy(() =>
  import('@/pages/client/DashboardPage').then((m) => ({ default: m.ClientDashboardPage })),
)
const ClientAccountDetailPage = lazy(() =>
  import('@/pages/client/AccountDetailPage').then((m) => ({ default: m.ClientAccountDetailPage })),
)
const ClientCreditsPage = lazy(() =>
  import('@/pages/client/CreditsPage').then((m) => ({ default: m.ClientCreditsPage })),
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
        <Route path="/login"    element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/"         element={<Navigate to="/login" replace />} />

        {/* Protected — client only */}
        <Route element={<AuthGuard />}>
          <Route path="/client/dashboard"             element={<ClientDashboardPage />} />
          <Route path="/client/accounts/:accountId"   element={<ClientAccountDetailPage />} />
          <Route path="/client/credits"               element={<ClientCreditsPage />} />
        </Route>

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Suspense>
  )
}
