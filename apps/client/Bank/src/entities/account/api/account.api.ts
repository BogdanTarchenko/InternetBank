import { coreHttp } from '@/shared/api/http.client'
import type { Account } from '../model/types'

export const AccountApi = {
  getMyAccounts(): Promise<Account[]> {
    return coreHttp.get<Account[]>('/accounts/my').then((r) => r.data)
  },

  getClientAccounts(clientId: string): Promise<Account[]> {
    return coreHttp.get<Account[]>(`/accounts/client/${clientId}`).then((r) => r.data)
  },

  getAllAccounts(): Promise<Account[]> {
    return coreHttp.get<Account[]>('/accounts').then((r) => r.data)
  },

  getById(accountId: string): Promise<Account> {
    return coreHttp.get<Account>(`/accounts/${accountId}`).then((r) => r.data)
  },

  open(currency = 'RUB'): Promise<Account> {
    return coreHttp.post<Account>('/accounts', { currency }).then((r) => r.data)
  },

  close(accountId: string): Promise<Account> {
    return coreHttp.delete<Account>(`/accounts/${accountId}`).then((r) => r.data)
  },

  deposit(accountId: string, amount: number): Promise<Account> {
    return coreHttp.post<Account>(`/accounts/${accountId}/deposit`, { amount }).then((r) => r.data)
  },

  withdraw(accountId: string, amount: number): Promise<Account> {
    return coreHttp.post<Account>(`/accounts/${accountId}/withdraw`, { amount }).then((r) => r.data)
  },
}
