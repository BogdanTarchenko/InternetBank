package com.example.core.repository.account

import com.example.core.domain.account.BankAccount
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface BankAccountRepository : JpaRepository<BankAccount, UUID> {
    fun findAllByUserId(userId: String): List<BankAccount>
}

