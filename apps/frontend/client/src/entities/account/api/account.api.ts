import { http } from '@/shared/api/http.client'
import type { Account } from '../model/types'

function unwrapAccounts(data: unknown): Account[] {
  if (Array.isArray(data)) return data as Account[]
  if (data && typeof data === 'object' && 'content' in data && Array.isArray((data as { content: unknown }).content)) {
    return (data as { content: Account[] }).content
  }
  return []
}

export const AccountApi = {
  open(userId: string): Promise<Account> {
    return http.post<Account>('/core/client/accounts', { userId }).then((r) => r.data)
  },

  getMyAccounts(userId: string): Promise<Account[]> {
    return http.get<unknown>('/core/client/accounts', { params: { userId } }).then((r) => unwrapAccounts(r.data))
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
    return http.get<unknown>('/core/employee/accounts').then((r) => unwrapAccounts(r.data))
  },

  getClientAccountsEmployee(userId: string): Promise<Account[]> {
    return http
      .get<unknown>('/core/employee/accounts', { params: { userId } })
      .then((r) => unwrapAccounts(r.data))
  },

  getClientAccounts(userId: string): Promise<Account[]> {
    return http.get<unknown>('/core/client/accounts', { params: { userId } }).then((r) => unwrapAccounts(r.data))
  },
}
