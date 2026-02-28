export type TransactionType = 'DEPOSIT' | 'WITHDRAW' | 'CREDIT_ISSUE' | 'CREDIT_PAYMENT' | 'TRANSFER'

export interface Transaction {
  id: string
  accountId: string
  type: TransactionType
  amount: number
  balanceAfter: number
  description?: string
  createdAt: string
}
