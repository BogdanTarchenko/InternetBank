import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'

interface CloseAccountModalProps {
  open: boolean
  onClose: () => void
  accountId: string
  accountNumber: string
}

export function CloseAccountModal({ open, onClose, accountId, accountNumber }: CloseAccountModalProps) {
  const queryClient = useQueryClient()

  const { mutate, isPending, error } = useMutation({
    mutationFn: () => AccountApi.close(accountId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my'] })
      EventBus.emit(BusEvents.ACCOUNT_CLOSED, { accountId })
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Закрыть счёт" size="sm">
      <div className="space-y-4">
        <p className="text-sm text-slate-600">
          Вы уверены, что хотите закрыть счёт{' '}
          <span className="font-mono font-semibold text-slate-900">{accountNumber}</span>?
          <br />
          Это действие нельзя отменить.
        </p>
        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">
            Не удалось закрыть счёт. Убедитесь, что баланс равен нулю.
          </p>
        )}
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" onClick={onClose}>
            Отмена
          </Button>
          <Button variant="danger" onClick={() => mutate()} loading={isPending}>
            Закрыть счёт
          </Button>
        </div>
      </div>
    </Modal>
  )
}
