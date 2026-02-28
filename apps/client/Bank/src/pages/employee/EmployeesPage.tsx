import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { UserApi } from '@/entities/user'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { CreateUserModal } from '@/features/employee/manage-users/CreateUserModal'
import { Table } from '@/shared/ui/Table'
import { Button } from '@/shared/ui/Button'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { formatShortDate } from '@/shared/lib/format'
import type { User } from '@/entities/user'
import { clsx } from 'clsx'

export function EmployeeEmployeesPage() {
  const queryClient = useQueryClient()
  const [createOpen, setCreateOpen] = useState(false)

  const { data: employees = [], isLoading } = useQuery({
    queryKey: ['users', 'employees'],
    queryFn: UserApi.getEmployees,
  })

  const { mutate: toggleBlock, isPending: isBlocking } = useMutation({
    mutationFn: (u: User) => (u.status === 'ACTIVE' ? UserApi.block(u.id) : UserApi.unblock(u.id)),
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
              { key: 'name', header: 'Имя', render: (u) => `${u.firstName} ${u.lastName}` },
              { key: 'email', header: 'Email' },
              { key: 'status', header: 'Статус', render: (u) => (
                <span className={clsx(
                  'rounded-full px-2 py-0.5 text-xs font-medium',
                  u.status === 'ACTIVE' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                )}>
                  {u.status === 'ACTIVE' ? 'Активен' : 'Заблокирован'}
                </span>
              )},
              { key: 'createdAt', header: 'Дата регистрации', render: (u) => formatShortDate(u.createdAt) },
              { key: 'id', header: '', render: (u) => (
                <Button
                  size="sm"
                  variant={u.status === 'ACTIVE' ? 'danger' : 'secondary'}
                  loading={isBlocking}
                  onClick={() => toggleBlock(u)}
                >
                  {u.status === 'ACTIVE' ? 'Заблокировать' : 'Разблокировать'}
                </Button>
              )},
            ]}
            data={employees}
            keyExtractor={(u) => u.id}
            emptyMessage="Сотрудники не найдены"
          />
        )}
      </div>

      <CreateUserModal open={createOpen} onClose={() => setCreateOpen(false)} role="EMPLOYEE" />
    </AppLayout>
  )
}
