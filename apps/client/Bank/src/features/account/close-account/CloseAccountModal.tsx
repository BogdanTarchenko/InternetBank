import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { useAuthStore } from '@/app/store/auth.store'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'

interface CloseAccountModalProps {
  open: boolean
  onClose: () => void
  accountId: string
}

export function CloseAccountModal({ open, onClose, accountId }: CloseAccountModalProps) {
  const userId = useAuthStore((s) => s.user?.id ?? '')
  const queryClient = useQueryClient()

  const { mutate, isPending, error } = useMutation({
    mutationFn: () => AccountApi.close(accountId, userId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my', userId] })
      EventBus.emit(BusEvents.ACCOUNT_CLOSED, { accountId })
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Закрыть счёт" size="sm">
      <div className="space-y-4">
        <p className="text-sm text-slate-600">
          Вы уверены, что хотите закрыть этот счёт? Это действие нельзя отменить.
          <br />
          <span className="text-red-600 font-medium">Баланс должен быть равен нулю.</span>
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
