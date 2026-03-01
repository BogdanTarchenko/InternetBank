import { http } from '@/shared/api/http.client'
import type { Operation } from '../model/types'

export const TransactionApi = {
  getByAccount(accountId: string, userId: string): Promise<Operation[]> {
    return http
      .get<Operation[]>(`/core/client/accounts/${accountId}/operations`, { params: { userId } })
      .then((r) => r.data)
  },

  getByAccountEmployee(accountId: string): Promise<Operation[]> {
    return http
      .get<Operation[]>(`/core/employee/accounts/${accountId}/operations`)
      .then((r) => r.data)
  },
}
