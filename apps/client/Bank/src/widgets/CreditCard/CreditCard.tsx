import type { Credit } from '@/entities/credit'
import { PayCreditButton } from '@/features/credit/pay-credit/PayCreditButton'
import { formatCurrency, formatDate, formatPercent } from '@/shared/lib/format'
import { clsx } from 'clsx'

const STATUS_LABELS: Record<Credit['status'], string> = {
  ACTIVE: 'Активен',
  PAID: 'Погашен',
  OVERDUE: 'Просрочен',
}

const STATUS_CLASSES: Record<Credit['status'], string> = {
  ACTIVE: 'bg-blue-100 text-blue-700',
  PAID: 'bg-green-100 text-green-700',
  OVERDUE: 'bg-red-100 text-red-700',
}

interface CreditCardProps {
  credit: Credit
  showActions?: boolean
}

export function CreditCard({ credit, showActions = true }: CreditCardProps) {
  return (
    <div className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm space-y-3">
      <div className="flex items-start justify-between">
        <div>
          <p className="font-semibold text-slate-900">{credit.tariffName}</p>
          <p className="text-xs text-slate-500">{formatPercent(credit.interestRate)} годовых</p>
        </div>
        <span className={clsx('rounded-full px-2 py-0.5 text-xs font-medium', STATUS_CLASSES[credit.status])}>
          {STATUS_LABELS[credit.status]}
        </span>
      </div>

      <div className="grid grid-cols-2 gap-3 text-sm">
        <div>
          <p className="text-xs text-slate-400">Сумма кредита</p>
          <p className="font-semibold text-slate-900">{formatCurrency(credit.amount)}</p>
        </div>
        <div>
          <p className="text-xs text-slate-400">Остаток</p>
          <p className="font-semibold text-slate-900">{formatCurrency(credit.remainingAmount)}</p>
        </div>
        {credit.status === 'ACTIVE' && (
          <div>
            <p className="text-xs text-slate-400">Следующий платёж</p>
            <p className="font-medium text-slate-700">{formatDate(credit.nextPaymentAt)}</p>
          </div>
        )}
        <div>
          <p className="text-xs text-slate-400">Оформлен</p>
          <p className="font-medium text-slate-700">{formatDate(credit.createdAt)}</p>
        </div>
      </div>

      {showActions && credit.status === 'ACTIVE' && (
        <div className="pt-1">
          <PayCreditButton creditId={credit.id} />
        </div>
      )}
    </div>
  )
}
