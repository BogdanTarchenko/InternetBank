package com.example.credit.service.credit

import com.example.credit.client.core.CoreClient
import com.example.credit.controller.apimodels.CreditDetailResponse
import com.example.credit.controller.apimodels.toResponse
import com.example.credit.domain.credit.Credit
import com.example.credit.domain.credit.CreditPayment
import com.example.credit.domain.credit.CreditStatus
import com.example.credit.repository.credit.CreditPaymentRepository
import com.example.credit.repository.credit.CreditRepository
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.server.ResponseStatusException
import java.math.BigDecimal
import java.time.OffsetDateTime
import java.util.UUID

@Service
class CreditService(
    private val creditRepository: CreditRepository,
    private val creditPaymentRepository: CreditPaymentRepository,
    private val creditTariffService: CreditTariffService,
    private val coreClient: CoreClient
) {

    @Transactional
    fun takeCredit(userId: String, tariffId: Long, amount: BigDecimal, accountId: UUID): Credit {
        val tariff = creditTariffService.getTariffById(tariffId)
        coreClient.getAccount(accountId)
        val now = OffsetDateTime.now()
        val nextPaymentAt = now.plusMinutes(tariff.paymentIntervalMinutes.toLong())
        val credit = Credit(
            userId = userId,
            tariff = tariff,
            totalAmount = amount,
            remainingAmount = amount,
            status = CreditStatus.ACTIVE,
            nextPaymentAt = nextPaymentAt
        )
        val saved = creditRepository.save(credit)
        coreClient.credit(accountId, amount)
        return saved
    }

    @Transactional
    fun repay(creditId: Long, userId: String, amount: BigDecimal, accountId: UUID): Credit {
        val credit = creditRepository.findById(creditId).orElseThrow { NoSuchElementException("Credit not found: id=$creditId") }
        if (credit.userId != userId) {
            throw IllegalArgumentException("Credit $creditId does not belong to user $userId")
        }
        if (credit.status != CreditStatus.ACTIVE) {
            throw IllegalStateException("Credit is not active: id=$creditId")
        }
        if (amount <= BigDecimal.ZERO) {
            throw IllegalArgumentException("Repayment amount must be positive")
        }
        val toDeduct = amount.min(credit.remainingAmount)

        val account = coreClient.getAccount(accountId)
        if (account.balance < toDeduct) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, "Insufficient funds on account ${account.id}")
        }
        coreClient.debit(accountId, toDeduct)

        credit.remainingAmount = credit.remainingAmount.subtract(toDeduct)
        creditPaymentRepository.save(
            CreditPayment(credit = credit, amount = toDeduct)
        )
        val tariff = credit.tariff
        if (credit.remainingAmount <= BigDecimal.ZERO) {
            credit.status = CreditStatus.CLOSED
            credit.nextPaymentAt = credit.startedAt
        } else {
            credit.nextPaymentAt = credit.nextPaymentAt.plusMinutes(tariff.paymentIntervalMinutes.toLong())
        }
        return creditRepository.save(credit)
    }

    @Transactional(readOnly = true)
    fun getCreditsByUserId(userId: String): List<Credit> =
        creditRepository.findAllByUserIdOrderByStartedAtDesc(userId)

    @Transactional(readOnly = true)
    fun getCreditById(creditId: Long): Credit =
        creditRepository.findById(creditId).orElseThrow { NoSuchElementException("Credit not found: id=$creditId") }

    @Transactional(readOnly = true)
    fun getPaymentsByCreditId(creditId: Long): List<CreditPayment> =
        creditPaymentRepository.findAllByCreditIdOrderByPaidAtAsc(creditId)

    @Transactional(readOnly = true)
    fun getCreditDetail(creditId: Long): CreditDetailResponse {
        val credit = getCreditById(creditId)
        credit.tariff.name
        val payments = getPaymentsByCreditId(creditId)
        return CreditDetailResponse(
            credit = credit.toResponse(),
            payments = payments.map { it.toResponse() }
        )
    }

    @Transactional(readOnly = true)
    fun getCreditDetailForUser(creditId: Long, userId: String): CreditDetailResponse {
        val credit = getCreditById(creditId)
        if (credit.userId != userId) {
            throw IllegalArgumentException("Credit $creditId does not belong to user $userId")
        }
        val payments = getPaymentsByCreditId(creditId)
        return CreditDetailResponse(
            credit = credit.toResponse(),
            payments = payments.map { it.toResponse() }
        )
    }
}
