import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { TransactionList } from '@/widgets/TransactionList/TransactionList'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { Table } from '@/shared/ui/Table'
import { Modal } from '@/shared/ui/Modal'
import { Button } from '@/shared/ui/Button'
import { formatCurrency, formatShortDate } from '@/shared/lib/format'
import type { Account } from '@/entities/account'
import { clsx } from 'clsx'

export function EmployeeAllAccountsPage() {
  const [selectedAccount, setSelectedAccount] = useState<Account | null>(null)

  const { data: accounts = [], isLoading, isError, error } = useQuery({
    queryKey: ['accounts', 'all'],
    queryFn: AccountApi.getAllAccounts,
  })

  return (
    <AppLayout>
      <div className="max-w-5xl">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-slate-900">Все счета</h1>
          <p className="text-sm text-slate-500 mt-1">{accounts.length} счётов</p>
        </div>

        {isLoading ? (
          <div className="h-48 animate-pulse rounded-xl bg-slate-100" />
        ) : isError ? (
          <div className="rounded-xl border border-red-200 bg-red-50 px-6 py-4 text-sm text-red-700">
            <p className="font-semibold mb-1">Ошибка загрузки счетов</p>
            <p className="font-mono text-xs">{(error as Error)?.message ?? 'Неизвестная ошибка'}</p>
          </div>
        ) : (
          <Table
            columns={[
              {
                key: 'id',
                header: 'ID счёта',
                render: (a) => <span className="font-mono text-xs">{a.id.slice(0, 16)}…</span>,
              },
              {
                key: 'userId',
                header: 'Клиент (userId)',
                render: (a) => <span className="font-mono text-xs">{a.userId.slice(0, 16)}…</span>,
              },
              {
                key: 'balance',
                header: 'Баланс',
                render: (a) => <span className="font-semibold">{formatCurrency(a.balance)}</span>,
              },
              {
                key: 'status',
                header: 'Статус',
                render: (a) => (
                  <span
                    className={clsx(
                      'rounded-full px-2 py-0.5 text-xs font-medium',
                      a.status === 'ACTIVE' ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500',
                    )}
                  >
                    {a.status === 'ACTIVE' ? 'Активен' : 'Закрыт'}
                  </span>
                ),
              },
              {
                key: 'createdAt',
                header: 'Открыт',
                render: (a) => formatShortDate(a.createdAt),
              },
              {
                key: 'id',
                header: '',
                render: (a) => (
                  <Button size="sm" variant="ghost" onClick={() => setSelectedAccount(a)}>
                    Операции
                  </Button>
                ),
              },
            ]}
            data={accounts}
            keyExtractor={(a) => a.id}
            emptyMessage="Счетов нет"
          />
        )}
      </div>

      <Modal
        open={!!selectedAccount}
        onClose={() => setSelectedAccount(null)}
        title={`Операции по счёту ${selectedAccount?.id.slice(0, 8) ?? ''}…`}
        size="lg"
      >
        {selectedAccount && <TransactionList accountId={selectedAccount.id} />}
      </Modal>
    </AppLayout>
  )
}
