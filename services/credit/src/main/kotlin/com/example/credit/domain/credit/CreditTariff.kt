package com.example.credit.domain.credit

import jakarta.persistence.*
import java.math.BigDecimal

@Entity
@Table(name = "credit_tariff")
class CreditTariff(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, updatable = false)
    val id: Long? = null,

    @Column(name = "name", nullable = false)
    var name: String,

    @Column(name = "interest_rate", nullable = false, precision = 19, scale = 4)
    var interestRate: BigDecimal,

    @Column(name = "payment_interval_minutes", nullable = false)
    var paymentIntervalMinutes: Int
)
