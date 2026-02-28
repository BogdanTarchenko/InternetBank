package com.example.credit.repository.credit

import com.example.credit.domain.credit.CreditPayment
import org.springframework.data.jpa.repository.JpaRepository

interface CreditPaymentRepository : JpaRepository<CreditPayment, Long> {
    fun findAllByCreditIdOrderByPaidAtAsc(creditId: Long): List<CreditPayment>
}
