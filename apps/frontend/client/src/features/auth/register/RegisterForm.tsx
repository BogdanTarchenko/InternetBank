import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation } from '@tanstack/react-query'
import { useNavigate, Link } from 'react-router-dom'
import { RegisterSchema, type RegisterInput, UserApi } from '@/entities/user'
import { useAuthStore } from '@/app/store/auth.store'
import { getAppRole } from '@/shared/lib/permissions'
import { setTokens } from '@/shared/api/http.client'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'

export function RegisterForm() {
  const navigate = useNavigate()
  const setAuth = useAuthStore((s) => s.setAuth)

  const {
    register,
    handleSubmit,
    formState: { errors },
    setError,
  } = useForm<RegisterInput>({ resolver: zodResolver(RegisterSchema) })

  const { mutate, isPending } = useMutation({
    mutationFn: async (data: RegisterInput) => {
      const tokens = await UserApi.register(data)
      setTokens(tokens.accessToken, tokens.refreshToken)
      const user = await UserApi.getMe()
      return { tokens, user }
    },
    onSuccess: ({ tokens, user }) => {
      setAuth(user, tokens.accessToken, tokens.refreshToken)
      const appRole = getAppRole(user.role)
      navigate(appRole === 'EMPLOYEE' ? '/employee/dashboard' : '/client/dashboard', { replace: true })
    },
    onError: () => {
      setError('root', { message: 'Ошибка регистрации. Возможно, email уже занят.' })
    },
  })

  return (
    <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
      <Input
        label="Имя и фамилия"
        placeholder="Иван Иванов"
        error={errors.name?.message}
        {...register('name')}
      />
      <Input
        label="Email"
        type="email"
        placeholder="ivan@bank.ru"
        error={errors.email?.message}
        {...register('email')}
      />
      <Input
        label="Пароль"
        type="password"
        placeholder="Минимум 8 символов"
        error={errors.password?.message}
        {...register('password')}
      />
      {errors.root && (
        <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">{errors.root.message}</p>
      )}
      <Button type="submit" loading={isPending} className="w-full">
        Создать аккаунт
      </Button>
      <p className="text-center text-sm text-slate-500">
        Уже есть аккаунт?{' '}
        <Link to="/login" className="font-medium text-blue-600 hover:underline">
          Войти
        </Link>
      </p>
    </form>
  )
}
