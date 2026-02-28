export type UserRole = 'CLIENT' | 'EMPLOYEE'

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

const ROLE_PERMISSIONS: Record<UserRole, Permission[]> = {
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
}

export function hasPermission(role: UserRole, permission: Permission): boolean {
  return ROLE_PERMISSIONS[role]?.includes(permission) ?? false
}

export function getPermissions(role: UserRole): Permission[] {
  return ROLE_PERMISSIONS[role] ?? []
}
