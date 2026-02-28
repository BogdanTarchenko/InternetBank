package com.example.core.domain.account

import jakarta.persistence.*
import java.math.BigDecimal
import java.time.OffsetDateTime
import java.util.UUID

@Entity
@Table(name = "bank_account")
class BankAccount(
    @Id
    @Column(name = "id", nullable = false, updatable = false)
    val id: UUID = UUID.randomUUID(),

    @Column(name = "user_id", nullable = false)
    val userId: String,

    @Column(name = "created_at", nullable = false, updatable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    var updatedAt: OffsetDateTime = createdAt,

    @Column(name = "balance", nullable = false)
    var balance: BigDecimal = BigDecimal.ZERO,

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    var status: AccountStatus = AccountStatus.ACTIVE
) {

    fun close() {
        status = AccountStatus.CLOSED
        updatedAt = OffsetDateTime.now()
    }

    fun deposit(amount: BigDecimal) {
        require(amount > BigDecimal.ZERO) { "Deposit amount must be positive" }
        balance = balance.add(amount)
        updatedAt = OffsetDateTime.now()
    }

    fun withdraw(amount: BigDecimal) {
        require(amount > BigDecimal.ZERO) { "Withdraw amount must be positive" }
        require(balance >= amount) { "Insufficient funds" }
        balance = balance.subtract(amount)
        updatedAt = OffsetDateTime.now()
    }
}

