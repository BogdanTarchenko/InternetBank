import { useState } from 'react'
import { Button } from '@/shared/ui/Button'
import { RepayCreditModal } from './RepayCreditModal'

interface PayCreditButtonProps {
  creditId: number
}

export function PayCreditButton({ creditId }: PayCreditButtonProps) {
  const [open, setOpen] = useState(false)

  return (
    <>
      <Button size="sm" onClick={() => setOpen(true)}>
        Погасить кредит
      </Button>
      <RepayCreditModal open={open} onClose={() => setOpen(false)} creditId={creditId} />
    </>
  )
}
