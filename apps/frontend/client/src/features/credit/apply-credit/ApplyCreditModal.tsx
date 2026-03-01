import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ApplyCreditSchema, type ApplyCreditInput, CreditApi } from '@/entities/credit'
import { TariffApi } from '@/entities/tariff'
import { AccountApi } from '@/entities/account'
import { useAuthStore } from '@/app/store/auth.store'
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
  const userId = useAuthStore((s) => s.user?.id ?? '')
  const queryClient = useQueryClient()

  const { data: tariffs = [] } = useQuery({
    queryKey: ['tariffs', 'client'],
    queryFn: TariffApi.getForClient,
    enabled: open,
  })

  const { data: accounts = [] } = useQuery({
    queryKey: ['accounts', 'my', userId],
    queryFn: () => AccountApi.getMyAccounts(userId),
    enabled: open && !!userId,
  })

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<ApplyCreditInput>({ resolver: zodResolver(ApplyCreditSchema) })

  const { mutate, isPending, error } = useMutation({
    mutationFn: (data: ApplyCreditInput) => CreditApi.apply({ ...data, userId }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['credits', 'my', userId] })
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my', userId] })
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
            {...register('tariffId', { valueAsNumber: true })}
          >
            <option value="">Выберите тариф</option>
            {tariffs.map((t) => (
              <option key={t.id} value={t.id}>
                {t.name} — {formatPercent(t.interestRate)} / каждые {t.paymentIntervalMinutes} мин.
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
                {a.id.slice(0, 8)}… — {a.balance.toFixed(2)} ₽
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
