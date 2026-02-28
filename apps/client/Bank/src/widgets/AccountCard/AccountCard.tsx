import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import type { Account } from '@/entities/account'
import { DepositModal } from '@/features/account/deposit/DepositModal'
import { WithdrawModal } from '@/features/account/withdraw/WithdrawModal'
import { CloseAccountModal } from '@/features/account/close-account/CloseAccountModal'
import { Button } from '@/shared/ui/Button'
import { formatCurrency, formatShortDate } from '@/shared/lib/format'
import { clsx } from 'clsx'

interface AccountCardProps {
  account: Account
}

export function AccountCard({ account }: AccountCardProps) {
  const navigate = useNavigate()
  const [depositOpen, setDepositOpen] = useState(false)
  const [withdrawOpen, setWithdrawOpen] = useState(false)
  const [closeOpen, setCloseOpen] = useState(false)
  const isActive = account.status === 'ACTIVE'

  return (
    <>
      <div
        className={clsx(
          'rounded-xl border bg-white p-5 shadow-sm transition-shadow hover:shadow-md',
          isActive ? 'border-slate-200' : 'border-slate-100 opacity-70',
        )}
      >
        <div className="flex items-start justify-between">
          <div>
            <p className="text-xs font-medium uppercase tracking-wide text-slate-400">{account.currency}</p>
            <p className="mt-1 text-2xl font-bold text-slate-900">
              {formatCurrency(account.balance, account.currency)}
            </p>
            <p className="mt-1 font-mono text-sm text-slate-500">{account.accountNumber}</p>
          </div>
          <span
            className={clsx(
              'rounded-full px-2 py-0.5 text-xs font-medium',
              isActive ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500',
            )}
          >
            {isActive ? 'Активен' : 'Закрыт'}
          </span>
        </div>

        <p className="mt-2 text-xs text-slate-400">Открыт {formatShortDate(account.createdAt)}</p>

        {isActive && (
          <div className="mt-4 flex flex-wrap gap-2">
            <Button size="sm" variant="secondary" onClick={() => navigate(`/client/accounts/${account.id}`)}>
              История
            </Button>
            <Button size="sm" onClick={() => setDepositOpen(true)}>
              Пополнить
            </Button>
            <Button size="sm" variant="secondary" onClick={() => setWithdrawOpen(true)}>
              Снять
            </Button>
            <Button size="sm" variant="danger" onClick={() => setCloseOpen(true)}>
              Закрыть
            </Button>
          </div>
        )}
      </div>

      <DepositModal open={depositOpen} onClose={() => setDepositOpen(false)} accountId={account.id} />
      <WithdrawModal
        open={withdrawOpen}
        onClose={() => setWithdrawOpen(false)}
        accountId={account.id}
        maxAmount={account.balance}
      />
      <CloseAccountModal
        open={closeOpen}
        onClose={() => setCloseOpen(false)}
        accountId={account.id}
        accountNumber={account.accountNumber}
      />
    </>
  )
}
