package com.example.core.kafka.user

import com.example.core.domain.retry.RetryType
import com.example.core.domain.user.UserStatusEvent
import com.example.core.kafka.AbstractRetryingKafkaListener
import com.example.core.service.retry.RetryService
import com.example.core.service.user.UserAccountStatusService
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component

@Component
class UserStatusKafkaListener(
    private val userAccountStatusService: UserAccountStatusService,
    objectMapper: ObjectMapper,
    retryService: RetryService
) : AbstractRetryingKafkaListener<UserStatusEvent>(
    objectMapper = objectMapper,
    retryService = retryService,
    retryType = RetryType.USER_STATUS,
    payloadClass = UserStatusEvent::class.java,
    sequenceKeyExtractor = { it.userId }
) {

    @KafkaListener(
        topics = ["\${user-status.topic:user-status}"],
        groupId = "\${spring.kafka.consumer.group-id:user-status-consumer}"
    )
    fun onMessage(rawMessage: String) {
        handle(rawMessage)
    }

    override fun handleEvent(event: UserStatusEvent) {
        userAccountStatusService.applyStatusEvent(event)
    }
}

