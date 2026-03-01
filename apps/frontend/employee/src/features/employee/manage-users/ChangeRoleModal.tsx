import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { UserApi } from '@/entities/user'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'
import type { User, UserRole } from '@/entities/user'
import { clsx } from 'clsx'

interface ChangeRoleModalProps {
  user: User | null
  open: boolean
  onClose: () => void
  invalidateKey: string[]
}

const ROLES: { value: UserRole; label: string; description: string; color: string }[] = [
  {
    value: 'CLIENT',
    label: 'Клиент',
    description: 'Доступ к личным счетам и кредитам',
    color: 'bg-green-50 border-green-200 text-green-800',
  },
  {
    value: 'EMPLOYEE',
    label: 'Сотрудник',
    description: 'Управление клиентами, счетами, тарифами',
    color: 'bg-blue-50 border-blue-200 text-blue-800',
  },
  {
    value: 'ADMIN',
    label: 'Администратор',
    description: 'Расширенный доступ, аналогичный сотруднику',
    color: 'bg-purple-50 border-purple-200 text-purple-800',
  },
  {
    value: 'BANNED',
    label: 'Заблокирован',
    description: 'Доступ в систему полностью закрыт',
    color: 'bg-red-50 border-red-200 text-red-800',
  },
]

export function ChangeRoleModal({ user, open, onClose, invalidateKey }: ChangeRoleModalProps) {
  const queryClient = useQueryClient()
  const [selectedRole, setSelectedRole] = useState<UserRole | null>(null)

  const { mutate, isPending, error } = useMutation({
    mutationFn: (role: UserRole) => UserApi.changeRole(user!.id, role),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: invalidateKey })
      setSelectedRole(null)
      onClose()
    },
  })

  function handleClose() {
    setSelectedRole(null)
    onClose()
  }

  const currentRole = user?.role
  const activeRole = selectedRole ?? currentRole

  return (
    <Modal open={open} onClose={handleClose} title={`Роль пользователя: ${user?.name ?? ''}`} size="sm">
      <div className="space-y-3">
        <p className="text-sm text-slate-500 mb-4">Выберите новую роль для пользователя</p>
        {ROLES.map((r) => (
          <button
            key={r.value}
            type="button"
            onClick={() => setSelectedRole(r.value)}
            className={clsx(
              'w-full text-left rounded-lg border-2 px-4 py-3 transition-all',
              activeRole === r.value
                ? r.color + ' border-current ring-2 ring-offset-1 ring-current/30'
                : 'border-slate-200 hover:border-slate-300 bg-white',
            )}
          >
            <div className="flex items-center justify-between">
              <span className="font-medium text-sm">{r.label}</span>
              {currentRole === r.value && (
                <span className="text-xs text-slate-400">текущая</span>
              )}
            </div>
            <p className="text-xs text-slate-500 mt-0.5">{r.description}</p>
          </button>
        ))}

        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">
            Не удалось изменить роль
          </p>
        )}

        <div className="flex gap-3 justify-end pt-2">
          <Button variant="secondary" type="button" onClick={handleClose}>
            Отмена
          </Button>
          <Button
            type="button"
            loading={isPending}
            disabled={!selectedRole || selectedRole === currentRole}
            onClick={() => selectedRole && mutate(selectedRole)}
          >
            Сохранить
          </Button>
        </div>
      </div>
    </Modal>
  )
}
