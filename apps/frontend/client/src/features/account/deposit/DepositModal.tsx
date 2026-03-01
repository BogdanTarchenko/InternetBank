import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { useAuthStore } from '@/app/store/auth.store'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'
import { Modal } from '@/shared/ui/Modal'

const DepositSchema = z.object({
  amount: z
    .number({ error: 'Введите сумму' })
    .min(0.01, 'Минимум 0.01'),
})
type DepositInput = z.infer<typeof DepositSchema>

interface DepositModalProps {
  open: boolean
  onClose: () => void
  accountId: string
}

export function DepositModal({ open, onClose, accountId }: DepositModalProps) {
  const userId = useAuthStore((s) => s.user?.id ?? '')
  const queryClient = useQueryClient()
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<DepositInput>({ resolver: zodResolver(DepositSchema) })

  const { mutate, isPending, error } = useMutation({
    mutationFn: ({ amount }: DepositInput) => AccountApi.deposit(accountId, userId, amount),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my', userId] })
      queryClient.invalidateQueries({ queryKey: ['operations', accountId] })
      EventBus.emit(BusEvents.DEPOSIT_MADE, { accountId })
      reset()
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Внести деньги" size="sm">
      <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
        <Input
          label="Сумма"
          type="number"
          step="0.01"
          placeholder="1000.00"
          error={errors.amount?.message}
          {...register('amount', { valueAsNumber: true })}
        />
        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">Не удалось пополнить счёт</p>
        )}
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" type="button" onClick={onClose}>
            Отмена
          </Button>
          <Button type="submit" loading={isPending}>
            Пополнить
          </Button>
        </div>
      </form>
    </Modal>
  )
}
