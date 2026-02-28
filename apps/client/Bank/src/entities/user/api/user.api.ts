import { userHttp } from '@/shared/api/http.client'
import type { User, AuthTokens } from '../model/types'
import type { LoginInput, CreateUserInput } from '../model/schema'

export const UserApi = {
  login(data: LoginInput): Promise<AuthTokens & { user: User }> {
    return userHttp.post('/auth/login', data).then((r) => r.data)
  },

  logout(): Promise<void> {
    return userHttp.post('/auth/logout', {}).then(() => undefined)
  },

  getMe(): Promise<User> {
    return userHttp.get<User>('/users/me').then((r) => r.data)
  },

  getAll(): Promise<User[]> {
    return userHttp.get<User[]>('/users').then((r) => r.data)
  },

  getClients(): Promise<User[]> {
    return userHttp.get<User[]>('/users?role=CLIENT').then((r) => r.data)
  },

  getEmployees(): Promise<User[]> {
    return userHttp.get<User[]>('/users?role=EMPLOYEE').then((r) => r.data)
  },

  create(data: CreateUserInput): Promise<User> {
    return userHttp.post<User>('/users', data).then((r) => r.data)
  },

  block(userId: string): Promise<User> {
    return userHttp.patch<User>(`/users/${userId}/block`).then((r) => r.data)
  },

  unblock(userId: string): Promise<User> {
    return userHttp.patch<User>(`/users/${userId}/unblock`).then((r) => r.data)
  },
}
