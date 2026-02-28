package com.example.core.repository.retry

import com.example.core.domain.retry.RetryTask
import org.springframework.data.jpa.repository.JpaRepository

interface RetryTaskRepository : JpaRepository<RetryTask, Long> {
    fun findTop100ByOrderBySequenceKeyAscCreatedAtAsc(): List<RetryTask>
}

