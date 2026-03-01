package com.example.credit.controller.apimodels

import com.example.credit.domain.credit.Credit
import com.example.credit.domain.credit.CreditPayment
import com.example.credit.domain.credit.CreditTariff
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import java.math.BigDecimal

data class CreateTariffRequest(
    @field:NotBlank(message = "Name is required")
    val name: String,

    @field:NotNull
    @field:DecimalMin("0", inclusive = false, message = "Interest rate must be positive")
    val interestRate: BigDecimal,

    @field:NotNull
    @field:Positive(message = "Payment interval must be positive")
    val paymentIntervalMinutes: Int
)

data class TariffResponse(
    val id: Long,
    val name: String,
    val interestRate: BigDecimal,
    val paymentIntervalMinutes: Int
)

fun CreditTariff.toResponse() = TariffResponse(
    id = id!!,
    name = name,
    interestRate = interestRate,
    paymentIntervalMinutes = paymentIntervalMinutes
)

data class TakeCreditRequest(
    @field:NotBlank(message = "UserId is required")
    val userId: String,

    @field:NotNull
    @field:Positive(message = "Tariff id must be positive")
    val tariffId: Long,

    @field:NotNull
    @field:DecimalMin("0", inclusive = false, message = "Amount must be positive")
    val amount: BigDecimal,

    @field:NotNull(message = "Account id is required for crediting loan amount")
    val accountId: java.util.UUID
)

data class RepayRequest(
    @field:NotNull(message = "Account id is required")
    val accountId: java.util.UUID,

    @field:NotNull
    @field:DecimalMin("0", inclusive = false, message = "Amount must be positive")
    val amount: BigDecimal
)

data class CreditResponse(
    val id: Long,
    val userId: String,
    val tariffId: Long,
    val tariffName: String,
    val totalAmount: BigDecimal,
    val remainingAmount: BigDecimal,
    val status: String,
    val startedAt: String,
    val nextPaymentAt: String
)

fun Credit.toResponse() = CreditResponse(
    id = id!!,
    userId = userId,
    tariffId = tariff.id!!,
    tariffName = tariff.name,
    totalAmount = totalAmount,
    remainingAmount = remainingAmount,
    status = status.name,
    startedAt = startedAt.toString(),
    nextPaymentAt = nextPaymentAt.toString()
)

data class CreditPaymentResponse(
    val id: Long,
    val paidAt: String,
    val amount: BigDecimal
)

fun CreditPayment.toResponse() = CreditPaymentResponse(
    id = id!!,
    paidAt = paidAt.toString(),
    amount = amount
)

data class CreditDetailResponse(
    val credit: CreditResponse,
    val payments: List<CreditPaymentResponse>
)
