import { http } from '@/shared/api/http.client'
import type { Credit, CreditDetail } from '../model/types'
import type { ApplyCreditInput, RepayInput } from '../model/schema'

export const CreditApi = {
  getMy(userId: string): Promise<Credit[]> {
    return http.get<Credit[]>('/credit/client/credits', { params: { userId } }).then((r) => r.data)
  },

  getDetail(creditId: number, userId: string): Promise<CreditDetail> {
    return http
      .get<CreditDetail>(`/credit/client/credits/${creditId}`, { params: { userId } })
      .then((r) => r.data)
  },

  apply(data: ApplyCreditInput & { userId: string }): Promise<Credit> {
    return http.post<Credit>('/credit/client/credits', data).then((r) => r.data)
  },

  repay(creditId: number, userId: string, data: RepayInput): Promise<Credit> {
    return http
      .post<Credit>(`/credit/client/credits/${creditId}/repay`, data, { params: { userId } })
      .then((r) => r.data)
  },

  getByClient(userId: string): Promise<Credit[]> {
    return http
      .get<Credit[]>(`/credit/employee/clients/${userId}/credits`)
      .then((r) => r.data)
  },

  getDetailEmployee(creditId: number): Promise<CreditDetail> {
    return http.get<CreditDetail>(`/credit/employee/credits/${creditId}`).then((r) => r.data)
  },
}
