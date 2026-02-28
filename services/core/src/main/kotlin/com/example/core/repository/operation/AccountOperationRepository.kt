package com.example.core.repository.operation

import com.example.core.domain.account.BankAccount
import com.example.core.domain.operation.AccountOperation
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface AccountOperationRepository : JpaRepository<AccountOperation, UUID> {
    fun findAllByAccountOrderByCreatedAtAsc(account: BankAccount): List<AccountOperation>
}

