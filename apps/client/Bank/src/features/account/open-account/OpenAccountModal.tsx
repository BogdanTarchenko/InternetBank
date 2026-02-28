import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AccountApi } from '@/entities/account'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Modal } from '@/shared/ui/Modal'

interface OpenAccountModalProps {
  open: boolean
  onClose: () => void
}

const CURRENCIES = ['RUB', 'USD', 'EUR']

export function OpenAccountModal({ open, onClose }: OpenAccountModalProps) {
  const [currency, setCurrency] = useState('RUB')
  const queryClient = useQueryClient()

  const { mutate, isPending, error } = useMutation({
    mutationFn: () => AccountApi.open(currency),
    onSuccess: (account) => {
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my'] })
      EventBus.emit(BusEvents.ACCOUNT_OPENED, { accountId: account.id })
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Открыть новый счёт">
      <div className="space-y-4">
        <div>
          <label className="text-sm font-medium text-slate-700">Валюта</label>
          <div className="mt-2 flex gap-2">
            {CURRENCIES.map((c) => (
              <button
                key={c}
                type="button"
                onClick={() => setCurrency(c)}
                className={`px-4 py-2 rounded-lg border text-sm font-medium transition-colors ${
                  currency === c
                    ? 'border-blue-600 bg-blue-50 text-blue-700'
                    : 'border-slate-300 bg-white text-slate-600 hover:bg-slate-50'
                }`}
              >
                {c}
              </button>
            ))}
          </div>
        </div>
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
