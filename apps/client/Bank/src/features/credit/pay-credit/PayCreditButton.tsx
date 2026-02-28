import { useMutation, useQueryClient } from '@tanstack/react-query'
import { CreditApi } from '@/entities/credit'
import { EventBus, BusEvents } from '@/shared/lib/event-bus'
import { Button } from '@/shared/ui/Button'

interface PayCreditButtonProps {
  creditId: string
}

export function PayCreditButton({ creditId }: PayCreditButtonProps) {
  const queryClient = useQueryClient()

  const { mutate, isPending } = useMutation({
    mutationFn: () => CreditApi.pay(creditId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['credits', 'my'] })
      queryClient.invalidateQueries({ queryKey: ['accounts', 'my'] })
      EventBus.emit(BusEvents.CREDIT_PAID, { creditId })
    },
  })

  return (
    <Button size="sm" onClick={() => mutate()} loading={isPending}>
      Погасить
    </Button>
  )
}
