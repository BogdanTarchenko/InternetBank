import { http } from '@/shared/api/http.client'
import type { Account } from '../model/types'

export const AccountApi = {
  open(userId: string): Promise<Account> {
    return http.post<Account>('/core/client/accounts', { userId }).then((r) => r.data)
  },

  getMyAccounts(userId: string): Promise<Account[]> {
    return http.get<Account[]>('/core/client/accounts', { params: { userId } }).then((r) => r.data)
  },

  close(accountId: string, userId: string): Promise<Account> {
    return http
      .delete<Account>(`/core/client/accounts/${accountId}`, { params: { userId } })
      .then((r) => r.data)
  },

  deposit(accountId: string, userId: string, amount: number): Promise<Account> {
    return http
      .post<Account>(`/core/client/accounts/${accountId}/deposit`, { amount }, { params: { userId } })
      .then((r) => r.data)
  },

  withdraw(accountId: string, userId: string, amount: number): Promise<Account> {
    return http
      .post<Account>(`/core/client/accounts/${accountId}/withdraw`, { amount }, { params: { userId } })
      .then((r) => r.data)
  },

  getAllAccounts(): Promise<Account[]> {
    return http.get<Account[]>('/core/employee/accounts').then((r) => r.data)
  },

  getClientAccounts(userId: string): Promise<Account[]> {
    return http.get<Account[]>('/core/client/accounts', { params: { userId } }).then((r) => r.data)
  },
}
