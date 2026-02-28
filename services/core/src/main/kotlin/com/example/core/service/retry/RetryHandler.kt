package com.example.core.service.retry

import com.example.core.domain.retry.RetryTask
import com.example.core.domain.retry.RetryType

interface RetryHandler {

    val supportedType: RetryType

    fun handle(task: RetryTask)
}

