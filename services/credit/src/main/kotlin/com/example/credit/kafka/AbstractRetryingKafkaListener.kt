package com.example.credit.kafka

import com.example.credit.domain.retry.RetryType
import com.example.credit.service.retry.RetryService
import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.LoggerFactory

abstract class AbstractRetryingKafkaListener<T>(
    private val objectMapper: ObjectMapper,
    private val retryService: RetryService,
    private val retryType: RetryType,
    private val payloadClass: Class<T>,
    private val sequenceKeyExtractor: (T) -> String
) {

    private val logger = LoggerFactory.getLogger(javaClass)

    fun handle(rawMessage: String) {
        try {
            val event = objectMapper.readValue(rawMessage, payloadClass)
            handleEvent(event)
        } catch (ex: Exception) {
            logger.error("Failed to process message for type=$retryType, scheduling retry", ex)
            scheduleRetrySafe(rawMessage)
        }
    }

    protected abstract fun handleEvent(event: T)

    private fun scheduleRetrySafe(rawMessage: String) {
        runCatching {
            val event = objectMapper.readValue(rawMessage, payloadClass)
            val sequenceKey = sequenceKeyExtractor(event)
            retryService.scheduleRetry(
                type = retryType,
                sequenceKey = sequenceKey,
                payload = rawMessage
            )
        }.onFailure { ex ->
            logger.error("Failed to schedule retry for type=$retryType", ex)
        }
    }
}
