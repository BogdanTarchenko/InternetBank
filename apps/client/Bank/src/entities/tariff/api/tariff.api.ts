import { creditHttp } from '@/shared/api/http.client'
import type { Tariff } from '../model/types'
import type { CreateTariffInput } from '../model/schema'

export const TariffApi = {
  getAll(): Promise<Tariff[]> {
    return creditHttp.get<Tariff[]>('/tariffs').then((r) => r.data)
  },

  create(data: CreateTariffInput): Promise<Tariff> {
    return creditHttp.post<Tariff>('/tariffs', data).then((r) => r.data)
  },
}
