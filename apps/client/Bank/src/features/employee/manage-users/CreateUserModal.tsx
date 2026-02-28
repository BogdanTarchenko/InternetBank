import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { CreateUserSchema, type CreateUserInput, UserApi } from '@/entities/user'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'
import { Modal } from '@/shared/ui/Modal'

interface CreateUserModalProps {
  open: boolean
  onClose: () => void
  role: 'CLIENT' | 'EMPLOYEE'
}

export function CreateUserModal({ open, onClose, role }: CreateUserModalProps) {
  const queryClient = useQueryClient()
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<CreateUserInput>({
    resolver: zodResolver(CreateUserSchema),
    defaultValues: { role },
  })

  const { mutate, isPending, error } = useMutation({
    mutationFn: UserApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users', role.toLowerCase() + 's'] })
      EventBus.emit(BusEvents.USER_CREATED, { role })
      reset()
      onClose()
    },
  })

  const title = role === 'CLIENT' ? 'Создать клиента' : 'Создать сотрудника'

  return (
    <Modal open={open} onClose={onClose} title={title}>
      <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <Input
            label="Имя"
            placeholder="Иван"
            error={errors.firstName?.message}
            {...register('firstName')}
          />
          <Input
            label="Фамилия"
            placeholder="Иванов"
            error={errors.lastName?.message}
            {...register('lastName')}
          />
        </div>
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
          placeholder="••••••••"
          error={errors.password?.message}
          {...register('password')}
        />
        <input type="hidden" {...register('role')} />
        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">Не удалось создать пользователя</p>
        )}
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" type="button" onClick={onClose}>
            Отмена
          </Button>
          <Button type="submit" loading={isPending}>
            Создать
          </Button>
        </div>
      </form>
    </Modal>
  )
}
