import { z } from 'zod'

export const ApplyCreditSchema = z.object({
  tariffId: z.string().min(1, 'Выберите тариф'),
  accountId: z.string().min(1, 'Выберите счёт'),
  amount: z
    .number({ error: 'Введите сумму' })
    .min(100, 'Минимальная сумма 100'),
})

export type ApplyCreditInput = z.infer<typeof ApplyCreditSchema>
