import { z } from 'zod'

export const LoginSchema = z.object({
  email: z.string().email('Некорректный email'),
  password: z.string().min(6, 'Минимум 6 символов'),
})

export type LoginInput = z.infer<typeof LoginSchema>

export const CreateUserSchema = z.object({
  firstName: z.string().min(2, 'Минимум 2 символа'),
  lastName: z.string().min(2, 'Минимум 2 символа'),
  email: z.string().email('Некорректный email'),
  password: z.string().min(6, 'Минимум 6 символов'),
  role: z.enum(['CLIENT', 'EMPLOYEE']),
})

export type CreateUserInput = z.infer<typeof CreateUserSchema>
