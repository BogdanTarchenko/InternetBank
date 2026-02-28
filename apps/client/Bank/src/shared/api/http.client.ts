import axios, { type AxiosInstance, type InternalAxiosRequestConfig, type AxiosResponse } from 'axios'

let accessToken: string | null = null

export function setAccessToken(token: string | null) {
  accessToken = token
}

export function getAccessToken(): string | null {
  return accessToken
}

function createHttpClient(baseURL: string): AxiosInstance {
  const instance = axios.create({ baseURL, timeout: 10_000 })

  instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    if (accessToken) {
      config.headers.set('Authorization', `Bearer ${accessToken}`)
    }
    return config
  })

  instance.interceptors.response.use(
    (response: AxiosResponse) => response,
    async (error) => {
      const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean }

      if (error.response?.status === 401 && !originalRequest._retry) {
        originalRequest._retry = true

        try {
          const refreshResponse = await axios.post<{ accessToken: string }>(
            `${originalRequest.baseURL}/auth/refresh`,
            {},
            { withCredentials: true },
          )
          const newToken = refreshResponse.data.accessToken
          setAccessToken(newToken)
          originalRequest.headers.set('Authorization', `Bearer ${newToken}`)
          return instance(originalRequest)
        } catch {
          setAccessToken(null)
          window.location.href = '/login'
          return Promise.reject(error)
        }
      }

      return Promise.reject(error)
    },
  )

  return instance
}

import { ENDPOINTS } from './endpoints'

export const coreHttp = createHttpClient(ENDPOINTS.CORE_SERVICE)
export const creditHttp = createHttpClient(ENDPOINTS.CREDIT_SERVICE)
export const userHttp = createHttpClient(ENDPOINTS.USER_SERVICE)
