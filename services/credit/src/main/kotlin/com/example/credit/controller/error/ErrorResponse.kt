package com.example.credit.controller.error

/**
 * Тело ответа при ошибке: код и сообщение.
 */
data class ErrorResponse(
    val code: Int,
    val message: String
)
