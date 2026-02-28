import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'
import { Modal } from '@/shared/ui/Modal'

const WithdrawSchema = z.object({
  amount: z
    .number({ error: 'Введите сумму' })
    .min(1, 'Минимум 1'),
})
type WithdrawInput = z.infer<typeof WithdrawSchema>

interface WithdrawModalProps {
  open: boolean
  onClose: () => void
  accountId: string
  maxAmount: number
}

export function WithdrawModal({ open, onClose, accountId, maxAmount }: WithdrawModalProps) {
  const queryClient = useQueryClient()
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<WithdrawInput>({
    resolver: zodResolver(
      WithdrawSchema.refine((d) => d.amount <= maxAmount, {
        message: `Недостаточно средств. Максимум: ${maxAmount}`,
        path: ['amount'],
      }),
    ),
  })

  const { mutate, isPending, error } = useMutation({
    mutationFn: ({ amount }: WithdrawInput) => AccountApi.withdraw(accountId, amount),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my'] })
      queryClient.invalidateQueries({ queryKey: ['account', accountId] })
      queryClient.invalidateQueries({ queryKey: ['transactions', accountId] })
      EventBus.emit(BusEvents.WITHDRAW_MADE, { accountId })
      reset()
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Снять деньги" size="sm">
      <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
        <Input
          label="Сумма"
          type="number"
          step="0.01"
          placeholder="500.00"
          error={errors.amount?.message}
          {...register('amount', { valueAsNumber: true })}
        />
        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">Не удалось снять средства</p>
        )}
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" type="button" onClick={onClose}>
            Отмена
          </Button>
          <Button type="submit" loading={isPending}>
            Снять
          </Button>
        </div>
      </form>
    </Modal>
  )
}
