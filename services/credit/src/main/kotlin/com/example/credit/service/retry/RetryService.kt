package com.example.credit.service.retry

import com.example.credit.domain.retry.RetryTask
import com.example.credit.domain.retry.RetryType
import com.example.credit.repository.retry.RetryTaskRepository
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
