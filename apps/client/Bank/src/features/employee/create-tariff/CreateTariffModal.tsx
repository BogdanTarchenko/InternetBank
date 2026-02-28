import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { CreateTariffSchema, type CreateTariffInput, TariffApi } from '@/entities/tariff'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'
import { Input } from '@/shared/ui/Input'
import { Modal } from '@/shared/ui/Modal'

interface CreateTariffModalProps {
  open: boolean
  onClose: () => void
}

export function CreateTariffModal({ open, onClose }: CreateTariffModalProps) {
  const queryClient = useQueryClient()
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<CreateTariffInput>({ resolver: zodResolver(CreateTariffSchema) })

  const { mutate, isPending, error } = useMutation({
    mutationFn: TariffApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tariffs'] })
      EventBus.emit(BusEvents.TARIFF_CREATED)
      reset()
      onClose()
    },
  })

  return (
    <Modal open={open} onClose={onClose} title="Создать тариф">
      <form onSubmit={handleSubmit((data) => mutate(data))} className="space-y-4">
        <Input
          label="Название тарифа"
          placeholder="Стандартный"
          error={errors.name?.message}
          {...register('name')}
        />
        <Input
          label="Процентная ставка (%)"
          type="number"
          step="0.01"
          placeholder="12.5"
          error={errors.interestRate?.message}
          {...register('interestRate', { valueAsNumber: true })}
        />
        <Input
          label="Срок (дней)"
          type="number"
          placeholder="30"
          error={errors.durationDays?.message}
          {...register('durationDays', { valueAsNumber: true })}
        />
        {error && (
          <p className="text-sm text-red-600 bg-red-50 px-3 py-2 rounded-lg">Не удалось создать тариф</p>
        )}
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" type="button" onClick={onClose}>
            Отмена
          </Button>
          <Button type="submit" loading={isPending}>
            Создать тариф
          </Button>
        </div>
      </form>
    </Modal>
  )
}
