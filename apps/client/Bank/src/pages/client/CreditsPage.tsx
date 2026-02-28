import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { CreditApi } from '@/entities/credit'
import { CreditCard } from '@/widgets/CreditCard/CreditCard'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { ApplyCreditModal } from '@/features/credit/apply-credit/ApplyCreditModal'
import { Button } from '@/shared/ui/Button'
import { SkeletonCard } from '@/shared/ui/Skeleton'

export function ClientCreditsPage() {
  const [applyOpen, setApplyOpen] = useState(false)

  const { data: credits = [], isLoading } = useQuery({
    queryKey: ['credits', 'my'],
    queryFn: CreditApi.getMy,
  })

  return (
    <AppLayout>
      <div className="max-w-3xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Мои кредиты</h1>
            <p className="text-sm text-slate-500 mt-1">
              {credits.filter((c) => c.status === 'ACTIVE').length} активных кредитов
            </p>
          </div>
          <Button onClick={() => setApplyOpen(true)}>
            + Взять кредит
          </Button>
        </div>

        {isLoading ? (
          <div className="space-y-4">
            {Array.from({ length: 2 }).map((_, i) => <SkeletonCard key={i} />)}
          </div>
        ) : credits.length === 0 ? (
          <div className="rounded-xl border-2 border-dashed border-slate-200 p-12 text-center">
            <p className="text-slate-400 text-sm">У вас нет кредитов</p>
            <Button className="mt-4" onClick={() => setApplyOpen(true)}>
              Оформить кредит
            </Button>
          </div>
        ) : (
          <div className="space-y-4">
            {credits.map((credit) => (
              <CreditCard key={credit.id} credit={credit} />
            ))}
          </div>
        )}
      </div>

      <ApplyCreditModal open={applyOpen} onClose={() => setApplyOpen(false)} />
    </AppLayout>
  )
}
