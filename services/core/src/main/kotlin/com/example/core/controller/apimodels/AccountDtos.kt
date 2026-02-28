package com.example.core.controller.apimodels

import com.example.core.domain.account.AccountStatus
import com.example.core.domain.account.BankAccount
import com.example.core.domain.operation.AccountOperation
import com.example.core.domain.operation.OperationType
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.math.BigDecimal
import java.time.OffsetDateTime
import java.util.UUID

data class OpenAccountRequest(
    @field:NotBlank
    val userId: String
)

data class MoneyRequest(
    @field:NotNull
    @field:DecimalMin("0.01")
    val amount: BigDecimal
)

data class AccountResponse(
    val id: UUID,
    val userId: String,
    val balance: BigDecimal,
    val status: AccountStatus,
    val createdAt: OffsetDateTime,
    val updatedAt: OffsetDateTime
)

data class OperationResponse(
    val id: UUID,
    val accountId: UUID,
    val type: OperationType,
    val amount: BigDecimal,
    val balanceAfter: BigDecimal,
    val createdAt: OffsetDateTime
)

fun BankAccount.toResponse(): AccountResponse =
    AccountResponse(
        id = id,
        userId = userId,
        balance = balance,
        status = status,
        createdAt = createdAt,
        updatedAt = updatedAt
    )

fun AccountOperation.toResponse(): OperationResponse =
    OperationResponse(
        id = id,
        accountId = account.id,
        type = type,
        amount = amount,
        balanceAfter = balanceAfter,
        createdAt = createdAt
    )

