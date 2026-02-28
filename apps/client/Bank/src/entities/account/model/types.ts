export type AccountStatus = 'ACTIVE' | 'CLOSED'

export interface Account {
  id: string
  clientId: string
  accountNumber: string
  balance: number
  currency: string
  status: AccountStatus
  createdAt: string
  closedAt?: string
}
