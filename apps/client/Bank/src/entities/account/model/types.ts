export type AccountStatus = 'ACTIVE' | 'CLOSED'

export interface Account {
  id: string
  userId: string
  balance: number
  status: AccountStatus
  createdAt: string
  updatedAt: string
}
