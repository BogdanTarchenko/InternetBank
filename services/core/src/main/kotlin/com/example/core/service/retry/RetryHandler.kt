package com.example.core.service.retry

import com.example.core.domain.retry.RetryTask
import com.example.core.domain.retry.RetryType

/**
 * Обработчик задачи ретрая для конкретного типа.
 * Можно переиспользовать в разных Kafka-слушателях, регистрируя новые реализации.
 */
interface RetryHandler {

    val supportedType: RetryType

    fun handle(task: RetryTask)
}

