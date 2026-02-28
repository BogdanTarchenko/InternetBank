export type CreditStatus = 'ACTIVE' | 'PAID' | 'OVERDUE'

export interface Credit {
  id: string
  clientId: string
  accountId: string
  tariffId: string
  tariffName: string
  amount: number
  remainingAmount: number
  interestRate: number
  status: CreditStatus
  nextPaymentAt: string
  createdAt: string
}
