import { coreHttp } from '@/shared/api/http.client'
import type { Transaction } from '../model/types'

export const TransactionApi = {
  getByAccount(accountId: string): Promise<Transaction[]> {
    return coreHttp.get<Transaction[]>(`/accounts/${accountId}/transactions`).then((r) => r.data)
  },
}
