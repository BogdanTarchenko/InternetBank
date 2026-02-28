import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ApplyCreditSchema, type ApplyCreditInput, CreditApi } from '@/entities/credit'
import { TariffApi } from '@/entities/tariff'
import { AccountApi } from '@/entities/account'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'
import { Modal } from '@/shared/ui/Modal'
import { formatPercent } from '@/shared/lib/format'

interface ApplyCreditModalProps {
  open: boolean
  onClose: () => void
}

export function ApplyCreditModal({ open, onClose }: ApplyCreditModalProps) {
  const queryClient = useQueryClient()

  const { data: tariffs = [] } = useQuery({
    queryKey: ['tariffs'],
    queryFn: TariffApi.getAll,
    enabled: open,
  })

  const { data: accounts = [] } = useQuery({
    queryKey: ['accounts', 'my'],
    queryFn: AccountApi.getMyAccounts,
    enabled: open,
  })

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<ApplyCreditInput>({ resolver: zodResolver(ApplyCreditSchema) })

  const { mutate, isPending, error } = useMutation({
    mutationFn: CreditApi.apply,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['credits', 'my'] })
      EventBus.emit(BusEvents.CREDIT_APPLIED)
      reset()
      onClose()
    },
  })

  const activeAccounts = accounts.filter((a) => a.status === 'ACTIVE')

  return (
    <Modal open={open} onClose={onClose} title="Взять кредит">
      <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
        <div>
          <label className="text-sm font-medium text-slate-700">Тариф</label>
          <select
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
            {...register('tariffId')}
          >
            <option value="">Выберите тариф</option>
            {tariffs.map((t) => (
              <option key={t.id} value={t.id}>
                {t.name} — {formatPercent(t.interestRate)} / {t.durationDays} дн.
              </option>
            ))}
          </select>
          {errors.tariffId && <span className="text-xs text-red-600">{errors.tariffId.message}</span>}
        </div>

        <div>
          <label className="text-sm font-medium text-slate-700">Счёт для зачисления</label>
          <select
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
            {...register('accountId')}
          >
            <option value="">Выберите счёт</option>
            {activeAccounts.map((a) => (
              <option key={a.id} value={a.id}>
                {a.accountNumber} ({a.currency})
              </option>
            ))}
          </select>
          {errors.accountId && <span className="text-xs text-red-600">{errors.accountId.message}</span>}
        </div>

        <Input
          label="Сумма кредита"
          type="number"
          step="0.01"
          placeholder="10000"
          error={errors.amount?.message}
          {...register('amount', { valueAsNumber: true })}
        />

        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">Не удалось оформить кредит</p>
        )}

        <div className="flex gap-3 justify-end">
          <Button variant="secondary" type="button" onClick={onClose}>
            Отмена
          </Button>
          <Button type="submit" loading={isPending}>
            Оформить кредит
          </Button>
        </div>
      </form>
    </Modal>
  )
}
