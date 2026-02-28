package com.example.credit.service.retry

import com.example.credit.domain.retry.RetryTask
import com.example.credit.domain.retry.RetryType

interface RetryHandler {

    val supportedType: RetryType

    fun handle(task: RetryTask)
}
