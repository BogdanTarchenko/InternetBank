package com.example.credit.service.retry.handlers

import com.example.credit.domain.retry.RetryTask
import com.example.credit.domain.retry.RetryType
import com.example.credit.domain.user.UserStatusEvent
import com.example.credit.service.retry.RetryHandler
import com.example.credit.service.user.UserAccountStatusService
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.stereotype.Component

@Component
class UserStatusRetryHandler(
    private val objectMapper: ObjectMapper,
    private val userAccountStatusService: UserAccountStatusService
) : RetryHandler {

    override val supportedType: RetryType = RetryType.USER_STATUS

    override fun handle(task: RetryTask) {
        val event = objectMapper.readValue(task.payload, UserStatusEvent::class.java)
        userAccountStatusService.applyStatusEvent(event)
    }
}
