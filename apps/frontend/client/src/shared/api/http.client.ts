import axios, { type InternalAxiosRequestConfig, type AxiosResponse } from 'axios'
import { GATEWAY_URL } from './endpoints'

let accessToken: string | null = null
let refreshToken: string | null = null

export function setTokens(access: string | null, refresh: string | null = null) {
  accessToken = access
  refreshToken = refresh
}

export function getAccessToken(): string | null {
  return accessToken
}

export function getRefreshToken(): string | null {
  return refreshToken
}

export const http = axios.create({
  baseURL: GATEWAY_URL,
  timeout: 10_000,
})

http.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  if (accessToken) {
    config.headers.set('Authorization', `Bearer ${accessToken}`)
  }
  return config
})

http.interceptors.response.use(
  (response: AxiosResponse) => response,
  async (error) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean }

    if (error.response?.status === 401 && !originalRequest._retry && refreshToken) {
      originalRequest._retry = true

      try {
        const { data } = await axios.post<{ accessToken: string; refreshToken: string }>(
          `${GATEWAY_URL}/auth/refresh`,
          { refreshToken },
        )
        setTokens(data.accessToken, data.refreshToken)
        originalRequest.headers.set('Authorization', `Bearer ${data.accessToken}`)
        return http(originalRequest)
      } catch {
        setTokens(null, null)
        window.location.href = '/login'
        return Promise.reject(error)
      }
    }

    return Promise.reject(error)
  },
)

export const coreHttp = http
export const creditHttp = http
export const userHttp = http
