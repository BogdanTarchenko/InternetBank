package com.example.credit.repository.retry

import com.example.credit.domain.retry.RetryTask
import org.springframework.data.jpa.repository.JpaRepository

interface RetryTaskRepository : JpaRepository<RetryTask, Long> {
    fun findTop100ByOrderBySequenceKeyAscCreatedAtAsc(): List<RetryTask>
}
