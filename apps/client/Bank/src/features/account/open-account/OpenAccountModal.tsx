import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { useAuthStore } from '@/app/store/auth.store'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'

interface OpenAccountModalProps {
  open: boolean
  onClose: () => void
}

export function OpenAccountModal({ open, onClose }: OpenAccountModalProps) {
  const userId = useAuthStore((s) => s.user?.id ?? '')
  const queryClient = useQueryClient()

  const { mutate, isPending, error } = useMutation({
    mutationFn: () => AccountApi.open(userId),
    onSuccess: (account) => {
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my', userId] })
      EventBus.emit(BusEvents.ACCOUNT_OPENED, { accountId: account.id })
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Открыть новый счёт" size="sm">
      <div className="space-y-4">
        <p className="text-sm text-slate-600">
          Будет открыт новый счёт в рублях. После открытия вы сможете пополнить его.
        </p>
        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">
            Не удалось открыть счёт
          </p>
        )}
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" onClick={onClose}>
            Отмена
          </Button>
          <Button onClick={() => mutate()} loading={isPending}>
            Открыть счёт
          </Button>
        </div>
      </div>
    </Modal>
  )
}
