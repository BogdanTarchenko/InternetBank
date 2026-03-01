import { http } from '@/shared/api/http.client'
import type { Tariff } from '../model/types'
import type { CreateTariffInput } from '../model/schema'

export const TariffApi = {
  getForClient(): Promise<Tariff[]> {
    return http.get<Tariff[]>('/credit/client/tariffs').then((r) => r.data)
  },

  getAll(): Promise<Tariff[]> {
    return http.get<Tariff[]>('/credit/employee/tariffs').then((r) => r.data)
  },

  create(data: CreateTariffInput): Promise<Tariff> {
    return http.post<Tariff>('/credit/employee/tariffs', data).then((r) => r.data)
  },
}
