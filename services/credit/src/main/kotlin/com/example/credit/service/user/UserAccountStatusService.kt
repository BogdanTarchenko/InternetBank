package com.example.credit.service.user

import com.example.credit.domain.user.UserAccountStatus
import com.example.credit.domain.user.UserStatus
import com.example.credit.domain.user.UserStatusEvent
import com.example.credit.repository.user.UserAccountStatusRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class UserAccountStatusService(
    private val userAccountStatusRepository: UserAccountStatusRepository
) {

    @Transactional
    fun applyStatusEvent(event: UserStatusEvent) {
        val entity = userAccountStatusRepository.findById(event.userId).orElse(
            UserAccountStatus(userId = event.userId)
        )
        entity.status = event.status
        userAccountStatusRepository.save(entity)
    }

    @Transactional(readOnly = true)
    fun assertUserActive(userId: String) {
        val status = userAccountStatusRepository.findById(userId)
            .orElseThrow { IllegalStateException("User status not found for userId=$userId") }
        if (status.status != UserStatus.ACTIVE) {
            throw IllegalStateException("User is not active: userId=$userId")
        }
    }
}
