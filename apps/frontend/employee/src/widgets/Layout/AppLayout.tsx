import { type ReactNode } from 'react'
import { Header } from '@/widgets/Header/Header'
import { EmployeeSidebar } from '@/widgets/Sidebar/EmployeeSidebar'

interface AppLayoutProps {
  children: ReactNode
}

export function AppLayout({ children }: AppLayoutProps) {
  return (
    <div className="flex h-screen flex-col">
      <Header />
      <div className="flex flex-1 min-h-0">
        <EmployeeSidebar />
        <main className="flex-1 overflow-y-auto p-6">{children}</main>
      </div>
    </div>
  )
}
