import { useQuery } from '@tanstack/react-query'
import { TransactionApi } from '@/entities/transaction'
import { useAuthStore } from '@/app/store/auth.store'
import type { OperationType } from '@/entities/transaction'
import { Skeleton } from '@/shared/ui/Skeleton'
import { formatCurrency, formatDate } from '@/shared/lib/format'
import { clsx } from 'clsx'

const TYPE_LABELS: Record<OperationType, string> = {
  OPEN_ACCOUNT: 'Открытие счёта',
  CLOSE_ACCOUNT: 'Закрытие счёта',
  DEPOSIT: 'Пополнение',
  WITHDRAW: 'Снятие',
}

const TYPE_CLASSES: Record<OperationType, string> = {
  OPEN_ACCOUNT: 'text-blue-600',
  CLOSE_ACCOUNT: 'text-slate-500',
  DEPOSIT: 'text-green-600',
  WITHDRAW: 'text-red-600',
}

const SIGN: Record<OperationType, string> = {
  OPEN_ACCOUNT: '',
  CLOSE_ACCOUNT: '',
  DEPOSIT: '+',
  WITHDRAW: '−',
}

interface TransactionListProps {
  accountId: string
  isEmployee?: boolean
}

export function TransactionList({ accountId, isEmployee = false }: TransactionListProps) {
  const userId = useAuthStore((s) => s.user?.id ?? '')

  const { data: operations = [], isLoading } = useQuery({
    queryKey: ['operations', accountId],
    queryFn: () =>
      isEmployee
        ? TransactionApi.getByAccountEmployee(accountId)
        : TransactionApi.getByAccount(accountId, userId),
    enabled: !!accountId && (isEmployee || !!userId),
  })

  if (isLoading) {
    return (
      <div className="space-y-2">
        {Array.from({ length: 4 }).map((_, i) => (
          <Skeleton key={i} className="h-12 w-full rounded-lg" />
        ))}
      </div>
    )
  }

  if (operations.length === 0) {
    return <p className="text-center text-sm text-slate-400 py-6">Операций нет</p>
  }

  return (
    <div className="divide-y rounded-xl border">
      {operations.map((op) => (
        <div key={op.id} className="flex items-center justify-between px-4 py-3">
          <div>
            <p className={clsx('text-sm font-medium', TYPE_CLASSES[op.type])}>{TYPE_LABELS[op.type]}</p>
            <p className="text-xs text-slate-400">{formatDate(op.createdAt)}</p>
          </div>
          <div className="text-right">
            <p className={clsx('font-semibold', TYPE_CLASSES[op.type])}>
              {SIGN[op.type]}{formatCurrency(op.amount)}
            </p>
            <p className="text-xs text-slate-400">Баланс: {formatCurrency(op.balanceAfter)}</p>
          </div>
        </div>
      ))}
    </div>
  )
}
