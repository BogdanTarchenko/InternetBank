import type { UserRole } from '@/shared/lib/permissions'

export type UserStatus = 'ACTIVE' | 'BLOCKED'

export interface User {
  id: string
  firstName: string
  lastName: string
  email: string
  role: UserRole
  status: UserStatus
  createdAt: string
}

export interface AuthTokens {
  accessToken: string
  refreshToken?: string
}
