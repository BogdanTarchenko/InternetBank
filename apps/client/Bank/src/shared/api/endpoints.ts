export const ENDPOINTS = {
  CORE_SERVICE: import.meta.env.VITE_CORE_SERVICE_URL ?? 'http://localhost:5001',
  CREDIT_SERVICE: import.meta.env.VITE_CREDIT_SERVICE_URL ?? 'http://localhost:5002',
  USER_SERVICE: import.meta.env.VITE_USER_SERVICE_URL ?? 'http://localhost:5003',
} as const
