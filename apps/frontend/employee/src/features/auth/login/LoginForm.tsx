import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { LoginSchema, type LoginInput, UserApi } from '@/entities/user'
import { useAuthStore } from '@/app/store/auth.store'
import { getAppRole } from '@/shared/lib/permissions'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'

export function LoginForm() {
  const navigate = useNavigate()
  const setAuth = useAuthStore((s) => s.setAuth)

  const {
    register,
    handleSubmit,
    formState: { errors },
    setError,
  } = useForm<LoginInput>({ resolver: zodResolver(LoginSchema) })

  const { mutate, isPending } = useMutation({
    mutationFn: async (data: LoginInput) => {
      const tokens = await UserApi.login(data)
      const { setTokens } = await import('@/shared/api/http.client')
      setTokens(tokens.accessToken, tokens.refreshToken)
      const user = await UserApi.getMe()
      return { tokens, user }
    },
    onSuccess: ({ tokens, user }) => {
      const appRole = getAppRole(user.role)
      if (appRole !== 'EMPLOYEE') {
        setError('root', { message: 'Доступ разрешён только сотрудникам' })
        return
      }
      setAuth(user, tokens.accessToken, tokens.refreshToken)
      navigate('/employee/dashboard', { replace: true })
    },
    onError: () => {
      setError('root', { message: 'Неверный email или пароль' })
    },
  })

  return (
    <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
      <Input
        label="Email"
        type="email"
        placeholder="employee@bank.ru"
        error={errors.email?.message}
        {...register('email')}
      />
      <Input
        label="Пароль"
        type="password"
        placeholder="••••••••"
        error={errors.password?.message}
        {...register('password')}
      />
      {errors.root && (
        <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">{errors.root.message}</p>
      )}
      <Button type="submit" loading={isPending} className="w-full">
        Войти
      </Button>
    </form>
  )
}
