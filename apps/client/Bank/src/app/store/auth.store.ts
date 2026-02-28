import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { User } from '@/entities/user'
import type { UserRole } from '@/shared/lib/permissions'
import { setAccessToken } from '@/shared/api/http.client'

interface AuthState {
  user: User | null
  accessToken: string | null
  role: UserRole | null
  isAuthenticated: boolean
  setAuth: (user: User, token: string) => void
  clearAuth: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      role: null,
      isAuthenticated: false,

      setAuth: (user, token) => {
        setAccessToken(token)
        set({ user, accessToken: token, role: user.role, isAuthenticated: true })
      },

      clearAuth: () => {
        setAccessToken(null)
        set({ user: null, accessToken: null, role: null, isAuthenticated: false })
      },
    }),
    {
      name: 'auth',
      partialize: (state) => ({ accessToken: state.accessToken, user: state.user, role: state.role }),
      onRehydrateStorage: () => (state) => {
        if (state?.accessToken) {
          setAccessToken(state.accessToken)
          state.isAuthenticated = true
        }
      },
    },
  ),
)
