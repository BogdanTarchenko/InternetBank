import { z } from 'zod'

export const ApplyCreditSchema = z.object({
  tariffId: z.number().int().min(1, 'Select tariff'),
  accountId: z.string().min(1, 'Select account'),
  amount: z.number().min(0.01, 'Min 0.01'),
})
export type ApplyCreditInput = z.infer<typeof ApplyCreditSchema>

export const RepaySchema = z.object({
  accountId: z.string().min(1, 'Select account'),
  amount: z.number().min(0.01, 'Min 0.01'),
})
export type RepayInput = z.infer<typeof RepaySchema>
