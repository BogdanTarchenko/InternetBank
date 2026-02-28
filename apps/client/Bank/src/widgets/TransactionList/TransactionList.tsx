import { useQuery } from '@tanstack/react-query'
import { TransactionApi } from '@/entities/transaction'
import type { Transaction } from '@/entities/transaction'
import { formatCurrency, formatDate } from '@/shared/lib/format'
import { Skeleton } from '@/shared/ui/Skeleton'
import { clsx } from 'clsx'

const TX_LABELS: Record<Transaction['type'], string> = {
  DEPOSIT: 'Пополнение',
  WITHDRAW: 'Снятие',
  CREDIT_ISSUE: 'Выдача кредита',
  CREDIT_PAYMENT: 'Платёж по кредиту',
  TRANSFER: 'Перевод',
}

interface TransactionListProps {
  accountId: string
}

export function TransactionList({ accountId }: TransactionListProps) {
  const { data: transactions, isLoading } = useQuery({
    queryKey: ['transactions', accountId],
    queryFn: () => TransactionApi.getByAccount(accountId),
  })

  if (isLoading) {
    return (
      <div className="space-y-2">
        {Array.from({ length: 5 }).map((_, i) => (
          <Skeleton key={i} className="h-14 w-full" />
        ))}
      </div>
    )
  }

  if (!transactions?.length) {
    return (
      <div className="rounded-xl border border-slate-200 bg-white p-8 text-center text-slate-400">
        История операций пуста
      </div>
    )
  }

  return (
    <div className="overflow-hidden rounded-xl border border-slate-200 bg-white divide-y divide-slate-100">
      {transactions.map((tx) => {
        const isIncoming = tx.type === 'DEPOSIT' || tx.type === 'CREDIT_ISSUE'
        return (
          <div key={tx.id} className="flex items-center justify-between px-4 py-3 hover:bg-slate-50">
            <div>
              <p className="text-sm font-medium text-slate-900">{TX_LABELS[tx.type]}</p>
              {tx.description && <p className="text-xs text-slate-400">{tx.description}</p>}
              <p className="text-xs text-slate-400">{formatDate(tx.createdAt)}</p>
            </div>
            <div className="text-right">
              <p
                className={clsx(
                  'text-sm font-semibold',
                  isIncoming ? 'text-green-600' : 'text-red-600',
                )}
              >
                {isIncoming ? '+' : '-'}{formatCurrency(tx.amount)}
              </p>
              <p className="text-xs text-slate-400">
                Баланс: {formatCurrency(tx.balanceAfter)}
              </p>
            </div>
          </div>
        )
      })}
    </div>
  )
}
