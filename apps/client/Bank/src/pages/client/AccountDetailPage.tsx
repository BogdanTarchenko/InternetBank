import { useParams, useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { TransactionList } from '@/widgets/TransactionList/TransactionList'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { Button } from '@/shared/ui/Button'
import { formatCurrency, formatShortDate } from '@/shared/lib/format'
import { Skeleton } from '@/shared/ui/Skeleton'

export function ClientAccountDetailPage() {
  const { accountId } = useParams<{ accountId: string }>()
  const navigate = useNavigate()

  const { data: account, isLoading } = useQuery({
    queryKey: ['account', accountId],
    queryFn: () => AccountApi.getById(accountId!),
    enabled: !!accountId,
  })

  return (
    <AppLayout>
      <div className="max-w-2xl">
        <div className="mb-6 flex items-center gap-3">
          <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
            ← Назад
          </Button>
          <h1 className="text-2xl font-bold text-slate-900">История операций</h1>
        </div>

        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-24 w-full rounded-xl" />
            <Skeleton className="h-48 w-full rounded-xl" />
          </div>
        ) : account ? (
          <>
            <div className="mb-6 rounded-xl bg-gradient-to-r from-blue-700 to-blue-900 p-6 text-white">
              <p className="text-sm font-medium text-blue-200">{account.currency} счёт</p>
              <p className="mt-1 text-3xl font-bold">{formatCurrency(account.balance, account.currency)}</p>
              <p className="mt-2 font-mono text-sm text-blue-200">{account.accountNumber}</p>
              <p className="mt-1 text-xs text-blue-300">Открыт {formatShortDate(account.createdAt)}</p>
            </div>
            <h2 className="mb-3 text-lg font-semibold text-slate-900">Операции</h2>
            <TransactionList accountId={account.id} />
          </>
        ) : null}
      </div>
    </AppLayout>
  )
}
