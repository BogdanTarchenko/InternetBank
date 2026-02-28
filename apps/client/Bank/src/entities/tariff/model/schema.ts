import { z } from 'zod'

export const CreateTariffSchema = z.object({
  name: z.string().min(2, 'Минимум 2 символа'),
  interestRate: z
    .number({ error: 'Введите число' })
    .min(0.01, 'Ставка должна быть больше 0')
    .max(100, 'Ставка не может превышать 100%'),
  durationDays: z
    .number({ error: 'Введите число' })
    .int()
    .min(1, 'Минимум 1 день'),
})

export type CreateTariffInput = z.infer<typeof CreateTariffSchema>
