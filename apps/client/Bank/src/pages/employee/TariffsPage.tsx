import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { TariffApi } from '@/entities/tariff'
import { AppLayout } from '@/widgets/Layout/AppLayout'
import { CreateTariffModal } from '@/features/employee/create-tariff/CreateTariffModal'
import { Table } from '@/shared/ui/Table'
import { Button } from '@/shared/ui/Button'
import { formatPercent, formatShortDate } from '@/shared/lib/format'

export function EmployeeTariffsPage() {
  const [createOpen, setCreateOpen] = useState(false)

  const { data: tariffs = [], isLoading } = useQuery({
    queryKey: ['tariffs'],
    queryFn: TariffApi.getAll,
  })

  return (
    <AppLayout>
      <div className="max-w-3xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Кредитные тарифы</h1>
            <p className="text-sm text-slate-500 mt-1">{tariffs.length} тарифов</p>
          </div>
          <Button onClick={() => setCreateOpen(true)}>+ Создать тариф</Button>
        </div>

        {isLoading ? (
          <div className="h-48 animate-pulse rounded-xl bg-slate-100" />
        ) : (
          <Table
            columns={[
              { key: 'name', header: 'Название тарифа', render: (t) => (
                <span className="font-medium text-slate-900">{t.name}</span>
              )},
              { key: 'interestRate', header: 'Ставка', render: (t) => (
                <span className="font-semibold text-blue-700">{formatPercent(t.interestRate)}</span>
              )},
              { key: 'durationDays', header: 'Срок', render: (t) => `${t.durationDays} дн.` },
              { key: 'createdAt', header: 'Создан', render: (t) => formatShortDate(t.createdAt) },
            ]}
            data={tariffs}
            keyExtractor={(t) => t.id}
            emptyMessage="Тарифы не созданы"
          />
        )}
      </div>

      <CreateTariffModal open={createOpen} onClose={() => setCreateOpen(false)} />
    </AppLayout>
  )
}
