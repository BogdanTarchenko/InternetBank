import { http } from '@/shared/api/http.client'
import type { User, AuthTokens, UserPage } from '../model/types'
import type { LoginInput, RegisterInput, CreateUserInput, EditUserInput } from '../model/schema'

export const UserApi = {
  login(data: LoginInput): Promise<AuthTokens> {
    return http.post<AuthTokens>('/auth/login', data).then((r) => r.data)
  },

  register(data: RegisterInput): Promise<AuthTokens> {
    return http.post<AuthTokens>('/auth/register', data).then((r) => r.data)
  },

  getMe(): Promise<User> {
    return http.get<User>('/users/me').then((r) => r.data)
  },

  getAll(params?: { search?: string; page?: number; size?: number }): Promise<UserPage> {
    return http.get<UserPage>('/users', { params }).then((r) => r.data)
  },

  getById(id: string): Promise<User> {
    return http.get<User>(`/users/${id}`).then((r) => r.data)
  },

  create(data: CreateUserInput): Promise<User> {
    return http.post<User>('/users', data).then((r) => r.data)
  },

  edit(id: string, data: EditUserInput): Promise<User> {
    return http.patch<User>(`/users/${id}`, data).then((r) => r.data)
  },

  ban(userId: string): Promise<User> {
    return http.patch<User>(`/users/${userId}/role`, { userId, role: 'BANNED' }).then((r) => r.data)
  },

  unban(userId: string, restoreRole: 'CLIENT' | 'EMPLOYEE' = 'CLIENT'): Promise<User> {
    return http.patch<User>(`/users/${userId}/role`, { userId, role: restoreRole }).then((r) => r.data)
  },
}
