import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { User } from '@/entities/user'
import { getAppRole, type AppRole } from '@/shared/lib/permissions'
import { setTokens } from '@/shared/api/http.client'

interface AuthState {
  user: User | null
  accessToken: string | null
  refreshToken: string | null
  appRole: AppRole | null
  isAuthenticated: boolean
  setAuth: (user: User, accessToken: string, refreshToken: string) => void
  clearAuth: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      refreshToken: null,
      appRole: null,
      isAuthenticated: false,

      setAuth: (user, accessToken, refreshToken) => {
        setTokens(accessToken, refreshToken)
        set({
          user,
          accessToken,
          refreshToken,
          appRole: getAppRole(user.role),
          isAuthenticated: true,
        })
      },

      clearAuth: () => {
        setTokens(null, null)
        set({ user: null, accessToken: null, refreshToken: null, appRole: null, isAuthenticated: false })
      },
    }),
    {
      name: 'auth',
      partialize: (state) => ({
        accessToken: state.accessToken,
        refreshToken: state.refreshToken,
        user: state.user,
        appRole: state.appRole,
      }),
      onRehydrateStorage: () => (state) => {
        if (state?.accessToken) {
          setTokens(state.accessToken, state.refreshToken ?? null)
          state.isAuthenticated = true
        }
      },
    },
  ),
)
