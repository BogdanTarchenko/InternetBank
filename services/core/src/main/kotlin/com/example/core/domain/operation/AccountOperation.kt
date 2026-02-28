package com.example.core.domain.operation

import com.example.core.domain.account.BankAccount
import jakarta.persistence.*
import java.math.BigDecimal
import java.time.OffsetDateTime
import java.util.UUID

@Entity
@Table(name = "account_operation")
class AccountOperation(
    @Id
    @Column(name = "id", nullable = false, updatable = false)
    val id: UUID = UUID.randomUUID(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    val account: BankAccount,

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    val type: OperationType,

    @Column(name = "amount", nullable = false)
    val amount: BigDecimal,

    @Column(name = "balance_after", nullable = false)
    val balanceAfter: BigDecimal,

    @Column(name = "created_at", nullable = false, updatable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now()
)

