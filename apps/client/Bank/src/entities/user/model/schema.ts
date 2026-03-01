import { z } from 'zod'

export const LoginSchema = z.object({
  email: z.string().email('Некорректный email'),
  password: z.string().min(6, 'Минимум 6 символов'),
})
export type LoginInput = z.infer<typeof LoginSchema>

export const RegisterSchema = z.object({
  email: z.string().email('Некорректный email'),
  password: z.string().min(8, 'Минимум 8 символов').max(100),
  name: z.string().min(2, 'Минимум 2 символа').max(100),
})
export type RegisterInput = z.infer<typeof RegisterSchema>

export const CreateUserSchema = z.object({
  email: z.string().email('Некорректный email'),
  password: z.string().min(8, 'Минимум 8 символов').max(100),
  name: z.string().min(2, 'Минимум 2 символа').max(100),
  role: z.enum(['CLIENT', 'EMPLOYEE']),
})
export type CreateUserInput = z.infer<typeof CreateUserSchema>

export const EditUserSchema = z.object({
  name: z.string().min(2, 'Минимум 2 символа').max(100),
  email: z.string().email('Некорректный email'),
})
export type EditUserInput = z.infer<typeof EditUserSchema>