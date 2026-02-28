package com.example.credit.client.core

import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.stereotype.Component
import org.springframework.web.client.HttpStatusCodeException
import org.springframework.web.client.RestTemplate
import org.springframework.web.server.ResponseStatusException
import java.math.BigDecimal
import java.util.UUID

@Component
class CoreClient(
    private val restTemplate: RestTemplate,
    private val coreProperties: CoreProperties,
    private val objectMapper: com.fasterxml.jackson.databind.ObjectMapper
) {

    fun getAccount(accountId: UUID): CoreAccountResponse {
        return execute(
            method = HttpMethod.GET,
            url = "${coreProperties.baseUrl}/internal/accounts/$accountId",
            body = null,
            responseType = CoreAccountResponse::class.java
        )
    }

    fun debit(accountId: UUID, amount: BigDecimal): CoreAccountResponse {
        return execute(
            method = HttpMethod.POST,
            url = "${coreProperties.baseUrl}/internal/accounts/$accountId/debit",
            body = mapOf("amount" to amount),
            responseType = CoreAccountResponse::class.java
        )
    }

    private fun <T> execute(
        method: HttpMethod,
        url: String,
        body: Any?,
        responseType: Class<T>
    ): T {
        val headers = HttpHeaders().apply {
            set("X-CLIENT-ID", coreProperties.clientId)
            set("X-API-TOKEN", coreProperties.apiToken)
            contentType = MediaType.APPLICATION_JSON
        }
        val entity = HttpEntity(body, headers)
        return try {
            restTemplate.exchange(url, method, entity, responseType).body!!
        } catch (ex: HttpStatusCodeException) {
            val statusCode = ex.statusCode
            val errorMessage = try {
                val errorBody = objectMapper.readValue(ex.responseBodyAsString, CoreErrorResponse::class.java)
                errorBody.message
            } catch (_: Exception) {
                ex.responseBodyAsString.ifBlank { (statusCode as? org.springframework.http.HttpStatus)?.reasonPhrase ?: "Error" }
            }
            throw ResponseStatusException(HttpStatus.valueOf(statusCode.value()), errorMessage)
        }
    }
}
