export type OperationType = 'OPEN_ACCOUNT' | 'CLOSE_ACCOUNT' | 'DEPOSIT' | 'WITHDRAW'

export interface Operation {
  id: string
  accountId: string
  type: OperationType
  amount: number
  balanceAfter: number
  createdAt: string
}

export type Transaction = Operation
export type TransactionType = OperationType
