import type { UserRole } from '@/shared/lib/permissions'

export type { UserRole }

export interface User {
  id: string
  email: string
  name: string
  role: UserRole
}

export interface AuthTokens {
  accessToken: string
  refreshToken: string
}

export interface UserPage {
  content: User[]
  totalElements: number
  totalPages: number
  size: number
  number: number
  first: boolean
  last: boolean
}
