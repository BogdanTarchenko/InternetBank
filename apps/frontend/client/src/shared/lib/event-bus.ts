type EventHandler<T = unknown> = (payload: T) => void

class EventBusClass {
  private listeners: Map<string, EventHandler[]> = new Map()

  on<T>(event: string, handler: EventHandler<T>) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, [])
    }
    this.listeners.get(event)!.push(handler as EventHandler)
    return () => this.off(event, handler)
  }

  off<T>(event: string, handler: EventHandler<T>) {
    const handlers = this.listeners.get(event)
    if (handlers) {
      this.listeners.set(
        event,
        handlers.filter((h) => h !== (handler as EventHandler)),
      )
    }
  }

  emit<T>(event: string, payload?: T) {
    const handlers = this.listeners.get(event) ?? []
    handlers.forEach((h) => h(payload))
  }
}

export const EventBus = new EventBusClass()

export const BusEvents = {
  ACCOUNT_OPENED: 'account:opened',
  ACCOUNT_CLOSED: 'account:closed',
  DEPOSIT_MADE: 'account:deposit',
  WITHDRAW_MADE: 'account:withdraw',
  CREDIT_APPLIED: 'credit:applied',
  CREDIT_PAID: 'credit:paid',
  USER_BLOCKED: 'user:blocked',
  USER_CREATED: 'user:created',
  TARIFF_CREATED: 'tariff:created',
} as const
