package com.example.core.service.retry

import com.example.core.domain.retry.RetryType
import com.example.core.repository.retry.RetryTaskRepository
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional

@Component
class RetryProcessor(
    private val retryTaskRepository: RetryTaskRepository,
    handlers: List<RetryHandler>
) {

    private val logger = LoggerFactory.getLogger(javaClass)

    private val handlersByType: Map<RetryType, RetryHandler> =
        handlers.associateBy { it.supportedType }

    @Scheduled(fixedDelayString = "\${retry.processor.fixed-delay-ms:5000}")
    @Transactional
    fun processBatch() {
        val tasks = retryTaskRepository.findTop100ByOrderBySequenceKeyAscCreatedAtAsc()
        if (tasks.isEmpty()) {
            return
        }

        for (task in tasks) {
            val handler = handlersByType[task.type]
            if (handler == null) {
                logger.warn("No handler registered for retry type {}", task.type)
                continue
            }

            try {
                handler.handle(task)
                retryTaskRepository.delete(task)
            } catch (ex: Exception) {
                logger.error("Failed to process retry task id=${task.id}", ex)
                task.markFailed(ex)
                retryTaskRepository.save(task)
            }
        }
    }
}

