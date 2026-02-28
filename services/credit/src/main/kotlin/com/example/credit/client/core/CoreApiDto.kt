package com.example.credit.client.core

import java.math.BigDecimal
import java.time.OffsetDateTime
import java.util.UUID

/**
 * Ответ core GET /internal/accounts/{accountId}
 */
data class CoreAccountResponse(
    val id: UUID,
    val userId: String,
    val balance: BigDecimal,
    val status: String,
    val createdAt: OffsetDateTime,
    val updatedAt: OffsetDateTime
)

/**
 * Тело ошибки от core (совпадает с ErrorResponse core).
 */
data class CoreErrorResponse(
    val code: Int,
    val message: String
)
