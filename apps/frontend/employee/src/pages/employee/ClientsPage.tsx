import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { UserApi } from '@/entities/user'
import { CreditApi } from '@/entities/credit'
import { AccountApi } from '@/entities/account'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { CreditCard } from '@/widgets/CreditCard/CreditCard'
import { CreateUserModal } from '@/features/employee/manage-users/CreateUserModal'
import { ChangeRoleModal } from '@/features/employee/manage-users/ChangeRoleModal'
import { Table } from '@/shared/ui/Table'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import type { User } from '@/entities/user'
import { clsx } from 'clsx'
import { formatCurrency } from '@/shared/lib/format'

export function EmployeeClientsPage() {
  const queryClient = useQueryClient()
  const [createOpen, setCreateOpen] = useState(false)
  const [selectedClient, setSelectedClient] = useState<User | null>(null)
  const [creditsTab, setCreditsTab] = useState(false)
  const [roleUser, setRoleUser] = useState<User | null>(null)

  const { data: page, isLoading } = useQuery({
    queryKey: ['users', 'clients'],
    queryFn: () => UserApi.getAll({ size: 100 }),
  })

  const clients = (page?.content ?? []).filter((u) => u.role === 'CLIENT' || u.role === 'BANNED')

  const { data: clientAccounts = [] } = useQuery({
    queryKey: ['accounts', 'client', selectedClient?.id],
    queryFn: () => AccountApi.getClientAccountsEmployee(selectedClient!.id),
    enabled: !!selectedClient && !creditsTab,
  })

  const { data: clientCredits = [] } = useQuery({
    queryKey: ['credits', 'client', selectedClient?.id],
    queryFn: () => CreditApi.getByClient(selectedClient!.id),
    enabled: !!selectedClient && creditsTab,
  })

  const { mutate: toggleBan, isPending: isBanning } = useMutation({
    mutationFn: (u: User) =>
      u.role === 'BANNED' ? UserApi.unban(u.id, 'CLIENT') : UserApi.ban(u.id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users', 'clients'] })
      EventBus.emit(BusEvents.USER_BLOCKED)
    },
  })

  return (
    <AppLayout>
      <div className="max-w-5xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Клиенты</h1>
            <p className="text-sm text-slate-500 mt-1">{clients.length} клиентов</p>
          </div>
          <Button onClick={() => setCreateOpen(true)}>+ Создать клиента</Button>
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
                      variant="ghost"
                      onClick={() => { setSelectedClient(u); setCreditsTab(false) }}
                    >
                      Счета
                    </Button>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => { setSelectedClient(u); setCreditsTab(true) }}
                    >
                      Кредиты
                    </Button>
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
            data={clients}
            keyExtractor={(u) => u.id}
            emptyMessage="Клиенты не найдены"
          />
        )}
      </div>

      <CreateUserModal open={createOpen} onClose={() => setCreateOpen(false)} role="CLIENT" />

      <ChangeRoleModal
        user={roleUser}
        open={!!roleUser}
        onClose={() => setRoleUser(null)}
        invalidateKey={['users', 'clients']}
      />

      <Modal
        open={!!selectedClient}
        onClose={() => setSelectedClient(null)}
        title={selectedClient?.name ?? ''}
        size="lg"
      >
        {selectedClient && (
          <div>
            <div className="flex gap-2 mb-4 border-b pb-3">
              <button
                className={clsx('px-3 py-1.5 text-sm font-medium rounded-lg', !creditsTab ? 'bg-blue-50 text-blue-700' : 'text-slate-600 hover:bg-slate-100')}
                onClick={() => setCreditsTab(false)}
              >
                Счета
              </button>
              <button
                className={clsx('px-3 py-1.5 text-sm font-medium rounded-lg', creditsTab ? 'bg-blue-50 text-blue-700' : 'text-slate-600 hover:bg-slate-100')}
                onClick={() => setCreditsTab(true)}
              >
                Кредиты
              </button>
            </div>

            {!creditsTab ? (
              clientAccounts.length === 0 ? (
                <p className="text-sm text-slate-400 text-center py-4">Нет счетов</p>
              ) : (
                <div className="space-y-2">
                  {clientAccounts.map((a) => (
                    <div key={a.id} className="flex justify-between items-center rounded-lg border px-4 py-2">
                      <span className="font-mono text-xs text-slate-500">{a.id.slice(0, 16)}…</span>
                      <span className={clsx('text-xs rounded-full px-2 py-0.5', a.status === 'ACTIVE' ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500')}>
                        {a.status}
                      </span>
                      <span className="font-semibold">{formatCurrency(a.balance)}</span>
                    </div>
                  ))}
                </div>
              )
            ) : clientCredits.length === 0 ? (
              <p className="text-sm text-slate-400 text-center py-4">Нет кредитов</p>
            ) : (
              <div className="space-y-3">
                {clientCredits.map((c) => (
                  <CreditCard key={c.id} credit={c} />
                ))}
              </div>
            )}
          </div>
        )}
      </Modal>
    </AppLayout>
  )
}
