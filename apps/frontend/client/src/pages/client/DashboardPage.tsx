import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { useAuthStore } from '@/app/store/auth.store'
import { AccountCard } from '@/widgets/AccountCard/AccountCard'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { OpenAccountModal } from '@/features/account/open-account/OpenAccountModal'
import { Button } from '@/shared/ui/Button'
import { Skeleton } from '@/shared/ui/Skeleton'

export function ClientDashboardPage() {
  const user = useAuthStore((s) => s.user)
  const userId = user?.id ?? ''
  const [openModal, setOpenModal] = useState(false)

  const { data: accounts = [], isLoading } = useQuery({
    queryKey: ['accounts', 'my', userId],
    queryFn: () => AccountApi.getMyAccounts(userId),
    enabled: !!userId,
  })

  return (
    <AppLayout>
      <div className="max-w-3xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Мои счета</h1>
            <p className="text-sm text-slate-500 mt-1">Добро пожаловать, {user?.name}</p>
          </div>
          <Button onClick={() => setOpenModal(true)}>+ Открыть счёт</Button>
        </div>

        {isLoading ? (
          <div className="grid gap-4 sm:grid-cols-2">
            {Array.from({ length: 2 }).map((_, i) => (
              <Skeleton key={i} className="h-44 rounded-xl" />
            ))}
          </div>
        ) : accounts.length === 0 ? (
          <div className="rounded-xl border-2 border-dashed border-slate-200 p-12 text-center">
            <p className="text-slate-500 mb-4">У вас ещё нет счетов</p>
            <Button onClick={() => setOpenModal(true)}>Открыть первый счёт</Button>
          </div>
        ) : (
          <div className="grid gap-4 sm:grid-cols-2">
            {accounts.map((a) => (
              <AccountCard key={a.id} account={a} />
            ))}
          </div>
        )}
      </div>
      <OpenAccountModal open={openModal} onClose={() => setOpenModal(false)} />
    </AppLayout>
  )
}
