package com.example.credit.repository.credit

import com.example.credit.domain.credit.Credit
import com.example.credit.domain.credit.CreditStatus
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.time.OffsetDateTime

interface CreditRepository : JpaRepository<Credit, Long> {

    @Query("SELECT c FROM Credit c JOIN FETCH c.tariff WHERE c.userId = :userId ORDER BY c.startedAt DESC")
    fun findAllByUserIdOrderByStartedAtDesc(@Param("userId") userId: String): List<Credit>

    @Query("SELECT c FROM Credit c JOIN FETCH c.tariff WHERE c.status = :status AND c.nextPaymentAt <= :now")
    fun findAllByStatusAndNextPaymentAtBefore(
        @Param("status") status: CreditStatus,
        @Param("now") now: OffsetDateTime
    ): List<Credit>
}
