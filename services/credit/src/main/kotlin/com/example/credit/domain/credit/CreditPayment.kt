package com.example.credit.domain.credit

import jakarta.persistence.*
import java.math.BigDecimal
import java.time.OffsetDateTime

@Entity
@Table(name = "credit_payment")
class CreditPayment(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, updatable = false)
    val id: Long? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "credit_id", nullable = false)
    val credit: Credit,

    @Column(name = "paid_at", nullable = false)
    val paidAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "amount", nullable = false, precision = 19, scale = 4)
    val amount: BigDecimal
)
