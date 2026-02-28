import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { UserApi } from '@/entities/user'
import { CreditApi } from '@/entities/credit'
import { AccountApi } from '@/entities/account'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { CreditCard } from '@/widgets/CreditCard/CreditCard'
import { CreateUserModal } from '@/features/employee/manage-users/CreateUserModal'
import { Table } from '@/shared/ui/Table'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { formatShortDate } from '@/shared/lib/format'
import type { User } from '@/entities/user'
import { clsx } from 'clsx'

export function EmployeeClientsPage() {
  const queryClient = useQueryClient()
  const [createOpen, setCreateOpen] = useState(false)
  const [selectedClient, setSelectedClient] = useState<User | null>(null)
  const [creditsTab, setCreditsTab] = useState(false)

  const { data: clients = [], isLoading } = useQuery({
    queryKey: ['users', 'clients'],
    queryFn: UserApi.getClients,
  })

  const { data: clientAccounts = [] } = useQuery({
    queryKey: ['accounts', 'client', selectedClient?.id],
    queryFn: () => AccountApi.getClientAccounts(selectedClient!.id),
    enabled: !!selectedClient && !creditsTab,
  })

  const { data: clientCredits = [] } = useQuery({
    queryKey: ['credits', 'client', selectedClient?.id],
    queryFn: () => CreditApi.getByClient(selectedClient!.id),
    enabled: !!selectedClient && creditsTab,
  })

  const { mutate: toggleBlock, isPending: isBlocking } = useMutation({
    mutationFn: (u: User) => (u.status === 'ACTIVE' ? UserApi.block(u.id) : UserApi.unblock(u.id)),
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
                <div className="flex gap-2">
                  <Button size="sm" variant="ghost" onClick={() => { setSelectedClient(u); setCreditsTab(false) }}>
                    Счета
                  </Button>
                  <Button size="sm" variant="ghost" onClick={() => { setSelectedClient(u); setCreditsTab(true) }}>
                    Кредиты
                  </Button>
                  <Button
                    size="sm"
                    variant={u.status === 'ACTIVE' ? 'danger' : 'secondary'}
                    loading={isBlocking}
                    onClick={() => toggleBlock(u)}
                  >
                    {u.status === 'ACTIVE' ? 'Блок' : 'Разблок'}
                  </Button>
                </div>
              )},
            ]}
            data={clients}
            keyExtractor={(u) => u.id}
            emptyMessage="Клиенты не найдены"
          />
        )}
      </div>

      <CreateUserModal open={createOpen} onClose={() => setCreateOpen(false)} role="CLIENT" />

      <Modal
        open={!!selectedClient}
        onClose={() => setSelectedClient(null)}
        title={selectedClient ? `${selectedClient.firstName} ${selectedClient.lastName}` : ''}
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
                      <span className="font-mono text-sm">{a.accountNumber}</span>
                      <span className="font-semibold">{a.balance} {a.currency}</span>
                    </div>
                  ))}
                </div>
              )
            ) : (
              clientCredits.length === 0 ? (
                <p className="text-sm text-slate-400 text-center py-4">Нет кредитов</p>
              ) : (
                <div className="space-y-3">
                  {clientCredits.map((c) => (
                    <CreditCard key={c.id} credit={c} showActions={false} />
                  ))}
                </div>
              )
            )}
          </div>
        )}
      </Modal>
    </AppLayout>
  )
}
