package com.example.credit.service.credit

import com.example.credit.domain.credit.CreditStatus
import com.example.credit.repository.credit.CreditRepository
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.OffsetDateTime

@Component
class InterestAccrualJob(
    private val creditRepository: CreditRepository
) {

    private val logger = LoggerFactory.getLogger(javaClass)

    @Scheduled(fixedDelayString = "\${interest-accrual.fixed-delay-ms:60000}")
    @Transactional
    fun accrueInterest() {
        val now = OffsetDateTime.now()
        val credits = creditRepository.findAllByStatusAndNextPaymentAtBefore(CreditStatus.ACTIVE, now)
        if (credits.isEmpty()) return

        logger.info("Interest accrual: processing {} credit(s)", credits.size)

        for (credit in credits) {
            val interest = credit.remainingAmount
                .multiply(credit.tariff.interestRate)
                .divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP)

            credit.remainingAmount = credit.remainingAmount.add(interest)
            credit.nextPaymentAt = credit.nextPaymentAt
                .plusMinutes(credit.tariff.paymentIntervalMinutes.toLong())

            logger.debug(
                "Credit id={}: accrued interest={}, new remainingAmount={}",
                credit.id, interest, credit.remainingAmount
            )
        }

        creditRepository.saveAll(credits)
    }
}
