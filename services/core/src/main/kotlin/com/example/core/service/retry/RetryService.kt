package com.example.core.service.retry

import com.example.core.domain.retry.RetryTask
import com.example.core.domain.retry.RetryType
import com.example.core.repository.retry.RetryTaskRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class RetryService(
    private val retryTaskRepository: RetryTaskRepository
) {

    @Transactional
    fun scheduleRetry(type: RetryType, sequenceKey: String, payload: String) {
        val task = RetryTask(
            type = type,
            sequenceKey = sequenceKey,
            payload = payload
        )
        retryTaskRepository.save(task)
    }
}

