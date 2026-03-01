import { z } from 'zod'

export const AccountSchema = z.object({
  id: z.string(),
  userId: z.string(),
  balance: z.number(),
  status: z.enum(['ACTIVE', 'CLOSED']),
  createdAt: z.string(),
  updatedAt: z.string(),
})

export const AccountListSchema = z.array(AccountSchema)
