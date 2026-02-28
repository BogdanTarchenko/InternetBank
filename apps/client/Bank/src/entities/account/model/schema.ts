import { z } from 'zod'

export const AccountSchema = z.object({
  id: z.string(),
  clientId: z.string(),
  accountNumber: z.string(),
  balance: z.number(),
  currency: z.string().default('RUB'),
  status: z.enum(['ACTIVE', 'CLOSED']),
  createdAt: z.string(),
  closedAt: z.string().optional(),
})

export const AccountListSchema = z.array(AccountSchema)
