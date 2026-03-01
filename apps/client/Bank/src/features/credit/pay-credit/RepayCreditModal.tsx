import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { RepaySchema, type RepayInput } from '@/entities/credit/model/schema'
import { CreditApi } from '@/entities/credit/api/credit.api'
import { AccountApi } from '@/entities/account'
import { useAuthStore } from '@/app/store/auth.store'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'
import { Modal } from '@/shared/ui/Modal'

interface RepayCreditModalProps {
  open: boolean
  onClose: () => void
  creditId: number
}

export function RepayCreditModal({ open, onClose, creditId }: RepayCreditModalProps) {
  const userId = useAuthStore((s) => s.user?.id ?? '')
  const queryClient = useQueryClient()

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
  } = useForm<RepayInput>({ resolver: zodResolver(RepaySchema) })

  const { mutate, isPending, error } = useMutation({
    mutationFn: (data: RepayInput) => CreditApi.repay(creditId, userId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['credits', 'my', userId] })
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my', userId] })
      EventBus.emit(BusEvents.CREDIT_PAID, { creditId })
      reset()
      onClose()
    },
  })

  const activeAccounts = accounts.filter((a) => a.status === 'ACTIVE')

  return (
    <Modal open={open} onClose={onClose} title="Погасить кредит">
      <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
        <div>
          <label className="text-sm font-medium text-slate-700">Счёт для списания</label>
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
          label="Сумма погашения"
          type="number"
          step="0.01"
          placeholder="1000.00"
          error={errors.amount?.message}
          {...register('amount', { valueAsNumber: true })}
        />

        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">
            Не удалось погасить кредит. Проверьте баланс.
          </p>
        )}

        <div className="flex gap-3 justify-end">
          <Button variant="secondary" type="button" onClick={onClose}>
            Отмена
          </Button>
          <Button type="submit" loading={isPending}>
            Погасить
          </Button>
        </div>
      </form>
    </Modal>
  )
}
