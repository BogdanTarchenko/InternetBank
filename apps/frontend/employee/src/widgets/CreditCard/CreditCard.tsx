import type { Credit } from '@/entities/credit'
import { formatCurrency, formatDate } from '@/shared/lib/format'
import { clsx } from 'clsx'

const STATUS_LABELS: Record<string, string> = {
  ACTIVE:  'Активен',
  PAID:    'Погашен',
  OVERDUE: 'Просрочен',
}

const STATUS_CLASSES: Record<string, string> = {
  ACTIVE:  'bg-blue-100 text-blue-700',
  PAID:    'bg-green-100 text-green-700',
  OVERDUE: 'bg-red-100 text-red-700',
}

interface CreditCardProps {
  credit: Credit
}

export function CreditCard({ credit }: CreditCardProps) {
  return (
    <div className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm space-y-3">
      <div className="flex items-start justify-between">
        <div>
          <p className="font-semibold text-slate-900">{credit.tariffName}</p>
          <p className="text-xs text-slate-400">#{credit.id}</p>
        </div>
        <span className={clsx('rounded-full px-2 py-0.5 text-xs font-medium', STATUS_CLASSES[credit.status] ?? 'bg-slate-100 text-slate-600')}>
          {STATUS_LABELS[credit.status] ?? credit.status}
        </span>
      </div>

      <div className="grid grid-cols-2 gap-3 text-sm">
        <div>
          <p className="text-xs text-slate-400">Сумма кредита</p>
          <p className="font-semibold text-slate-900">{formatCurrency(credit.totalAmount)}</p>
        </div>
        <div>
          <p className="text-xs text-slate-400">Остаток</p>
          <p className="font-semibold text-slate-900">{formatCurrency(credit.remainingAmount)}</p>
        </div>
        {credit.status === 'ACTIVE' && credit.nextPaymentAt && (
          <div>
            <p className="text-xs text-slate-400">Следующий платёж</p>
            <p className="font-medium text-slate-700">{formatDate(credit.nextPaymentAt)}</p>
          </div>
        )}
        <div>
          <p className="text-xs text-slate-400">Оформлен</p>
          <p className="font-medium text-slate-700">{formatDate(credit.startedAt)}</p>
        </div>
      </div>
    </div>
  )
}
