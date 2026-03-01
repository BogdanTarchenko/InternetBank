import { LoginForm } from '@/features/auth/login/LoginForm'

export function LoginPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-blue-50 to-slate-100 px-4">
      <div className="w-full max-w-sm">
        <div className="mb-8 text-center">
          <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-blue-700 text-white text-2xl font-bold shadow-lg">
            B
          </div>
          <h1 className="text-2xl font-bold text-slate-900">InternetBank</h1>
          <p className="mt-1 text-sm text-slate-500">Портал сотрудника</p>
        </div>
        <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
          <LoginForm />
        </div>
      </div>
    </div>
  )
}
