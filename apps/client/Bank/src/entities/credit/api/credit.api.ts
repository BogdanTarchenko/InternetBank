import { creditHttp } from '@/shared/api/http.client'
import type { Credit } from '../model/types'
import type { ApplyCreditInput } from '../model/schema'

export const CreditApi = {
  getMy(): Promise<Credit[]> {
    return creditHttp.get<Credit[]>('/credits/my').then((r) => r.data)
  },

  getByClient(clientId: string): Promise<Credit[]> {
    return creditHttp.get<Credit[]>(`/credits/client/${clientId}`).then((r) => r.data)
  },

  getById(creditId: string): Promise<Credit> {
    return creditHttp.get<Credit>(`/credits/${creditId}`).then((r) => r.data)
  },

  apply(data: ApplyCreditInput): Promise<Credit> {
    return creditHttp.post<Credit>('/credits', data).then((r) => r.data)
  },

  pay(creditId: string): Promise<Credit> {
    return creditHttp.post<Credit>(`/credits/${creditId}/pay`, {}).then((r) => r.data)
  },
}
