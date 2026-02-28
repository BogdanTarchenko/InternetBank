package com.example.credit.domain.credit

import jakarta.persistence.*
import java.math.BigDecimal
import java.time.OffsetDateTime

@Entity
@Table(name = "credit")
class Credit(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, updatable = false)
    val id: Long? = null,

    @Column(name = "user_id", nullable = false)
    val userId: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tariff_id", nullable = false)
    val tariff: CreditTariff,

    @Column(name = "total_amount", nullable = false, precision = 19, scale = 4)
    val totalAmount: BigDecimal,

    @Column(name = "remaining_amount", nullable = false, precision = 19, scale = 4)
    var remainingAmount: BigDecimal,

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    var status: CreditStatus = CreditStatus.ACTIVE,

    @Column(name = "started_at", nullable = false, updatable = false)
    val startedAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "next_payment_at", nullable = false)
    var nextPaymentAt: OffsetDateTime
)
