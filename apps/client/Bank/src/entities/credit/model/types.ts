export type CreditStatus = 'ACTIVE' | 'PAID' | 'OVERDUE'

export interface Credit {
  id: number
  userId: string
  tariffId: number
  tariffName: string
  totalAmount: number
  remainingAmount: number
  status: CreditStatus
  startedAt: string
  nextPaymentAt: string
}

export interface CreditPayment {
  id: number
  paidAt: string
  amount: number
}

export interface CreditDetail {
  credit: Credit
  payments: CreditPayment[]
}
