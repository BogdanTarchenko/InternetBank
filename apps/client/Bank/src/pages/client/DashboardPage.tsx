import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { AccountCard } from '@/widgets/AccountCard/AccountCard'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { OpenAccountModal } from '@/features/account/open-account/OpenAccountModal'
import { Button } from '@/shared/ui/Button'
import { SkeletonCard } from '@/shared/ui/Skeleton'

export function ClientDashboardPage() {
  const [openModalVisible, setOpenModalVisible] = useState(false)

  const { data: accounts = [], isLoading } = useQuery({
    queryKey: ['accounts', 'my'],
    queryFn: AccountApi.getMyAccounts,
  })

  return (
    <AppLayout>
      <div className="max-w-4xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Мои счета</h1>
            <p className="text-sm text-slate-500 mt-1">
              {accounts.filter((a) => a.status === 'ACTIVE').length} активных счётов
            </p>
          </div>
          <Button onClick={() => setOpenModalVisible(true)}>
            + Открыть счёт
          </Button>
        </div>

        {isLoading ? (
          <div className="grid gap-4 sm:grid-cols-2">
            {Array.from({ length: 3 }).map((_, i) => <SkeletonCard key={i} />)}
          </div>
        ) : accounts.length === 0 ? (
          <div className="rounded-xl border-2 border-dashed border-slate-200 p-12 text-center">
            <p className="text-slate-400 text-sm">У вас пока нет счетов</p>
            <Button className="mt-4" onClick={() => setOpenModalVisible(true)}>
              Открыть первый счёт
            </Button>
          </div>
        ) : (
          <div className="grid gap-4 sm:grid-cols-2">
            {accounts.map((account) => (
              <AccountCard key={account.id} account={account} />
            ))}
          </div>
        )}
      </div>

      <OpenAccountModal
        open={openModalVisible}
        onClose={() => setOpenModalVisible(false)}
      />
    </AppLayout>
  )
}
