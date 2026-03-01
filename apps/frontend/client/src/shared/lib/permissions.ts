export type UserRole = 'CLIENT' | 'EMPLOYEE' | 'ADMIN' | 'BANNED'

export type AppRole = 'CLIENT' | 'EMPLOYEE'

export type Permission =
  | 'view:own-accounts'
  | 'view:all-accounts'
  | 'open:account'
  | 'close:account'
  | 'deposit:account'
  | 'withdraw:account'
  | 'view:own-credits'
  | 'view:all-credits'
  | 'apply:credit'
  | 'pay:credit'
  | 'view:transactions'
  | 'create:tariff'
  | 'manage:clients'
  | 'manage:employees'

const ROLE_PERMISSIONS: Partial<Record<UserRole, Permission[]>> = {
  CLIENT: [
    'view:own-accounts',
    'open:account',
    'close:account',
    'deposit:account',
    'withdraw:account',
    'view:own-credits',
    'apply:credit',
    'pay:credit',
    'view:transactions',
  ],
  EMPLOYEE: [
    'view:all-accounts',
    'view:own-accounts',
    'view:all-credits',
    'view:own-credits',
    'view:transactions',
    'create:tariff',
    'manage:clients',
    'manage:employees',
  ],
  ADMIN: [
    'view:all-accounts',
    'view:own-accounts',
    'view:all-credits',
    'view:own-credits',
    'view:transactions',
    'create:tariff',
    'manage:clients',
    'manage:employees',
  ],
}

export function hasPermission(role: UserRole, permission: Permission): boolean {
  return ROLE_PERMISSIONS[role]?.includes(permission) ?? false
}

export function getAppRole(role: UserRole): AppRole | null {
  if (role === 'CLIENT') return 'CLIENT'
  if (role === 'EMPLOYEE' || role === 'ADMIN') return 'EMPLOYEE'
  return null 
}
