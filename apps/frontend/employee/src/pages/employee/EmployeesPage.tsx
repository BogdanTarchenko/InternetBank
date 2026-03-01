import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { UserApi } from '@/entities/user'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { CreateUserModal } from '@/features/employee/manage-users/CreateUserModal'
import { ChangeRoleModal } from '@/features/employee/manage-users/ChangeRoleModal'
import { Table } from '@/shared/ui/Table'
import { Button } from '@/shared/ui/Button'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import type { User } from '@/entities/user'
import { clsx } from 'clsx'

export function EmployeeEmployeesPage() {
  const queryClient = useQueryClient()
  const [createOpen, setCreateOpen] = useState(false)
  const [roleUser, setRoleUser] = useState<User | null>(null)

  const { data: page, isLoading } = useQuery({
    queryKey: ['users', 'employees'],
    queryFn: () => UserApi.getAll({ size: 100 }),
  })

  const employees = (page?.content ?? []).filter(
    (u) => u.role === 'EMPLOYEE' || u.role === 'ADMIN',
  )

  const { mutate: toggleBan, isPending: isBanning } = useMutation({
    mutationFn: (u: User) =>
      u.role === 'BANNED' ? UserApi.unban(u.id, 'EMPLOYEE') : UserApi.ban(u.id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users', 'employees'] })
      EventBus.emit(BusEvents.USER_BLOCKED)
    },
  })

  return (
    <AppLayout>
      <div className="max-w-4xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Сотрудники</h1>
            <p className="text-sm text-slate-500 mt-1">{employees.length} сотрудников</p>
          </div>
          <Button onClick={() => setCreateOpen(true)}>+ Создать сотрудника</Button>
        </div>

        {isLoading ? (
          <div className="h-48 animate-pulse rounded-xl bg-slate-100" />
        ) : (
          <Table
            columns={[
              { key: 'name',  header: 'Имя' },
              { key: 'email', header: 'Email' },
              {
                key: 'role',
                header: 'Роль',
                render: (u) => {
                  const styles: Record<string, string> = {
                    CLIENT:   'bg-green-100 text-green-700',
                    EMPLOYEE: 'bg-blue-100 text-blue-700',
                    ADMIN:    'bg-purple-100 text-purple-700',
                    BANNED:   'bg-red-100 text-red-700',
                  }
                  const labels: Record<string, string> = {
                    CLIENT:   'Клиент',
                    EMPLOYEE: 'Сотрудник',
                    ADMIN:    'Администратор',
                    BANNED:   'Заблокирован',
                  }
                  return (
                    <span className={clsx('rounded-full px-2 py-0.5 text-xs font-medium', styles[u.role] ?? 'bg-slate-100 text-slate-600')}>
                      {labels[u.role] ?? u.role}
                    </span>
                  )
                },
              },
              {
                key: 'id',
                header: '',
                render: (u) => (
                  <div className="flex gap-2">
                    <Button
                      size="sm"
                      variant="secondary"
                      onClick={() => setRoleUser(u)}
                    >
                      Роль
                    </Button>
                    <Button
                      size="sm"
                      variant={u.role === 'BANNED' ? 'secondary' : 'danger'}
                      loading={isBanning}
                      onClick={() => toggleBan(u)}
                    >
                      {u.role === 'BANNED' ? 'Разблок' : 'Блок'}
                    </Button>
                  </div>
                ),
              },
            ]}
            data={employees}
            keyExtractor={(u) => u.id}
            emptyMessage="Сотрудники не найдены"
          />
        )}
      </div>

      <CreateUserModal open={createOpen} onClose={() => setCreateOpen(false)} role="EMPLOYEE" />

      <ChangeRoleModal
        user={roleUser}
        open={!!roleUser}
        onClose={() => setRoleUser(null)}
        invalidateKey={['users', 'employees']}
      />
    </AppLayout>
  )
}
