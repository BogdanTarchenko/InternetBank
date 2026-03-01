package com.example.core.service.user

import com.example.core.domain.user.UserAccountStatus
import com.example.core.domain.user.UserStatus
import com.example.core.domain.user.UserStatusEvent
import com.example.core.repository.user.UserAccountStatusRepository
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

    @Transactional
    fun assertUserActive(userId: String) {
        val status = userAccountStatusRepository.findById(userId)
            .orElseGet {
                UserAccountStatus(userId = userId, status = UserStatus.ACTIVE)
                    .also { userAccountStatusRepository.save(it) }
            }
        if (status.status != UserStatus.ACTIVE) {
            throw IllegalStateException("User is not active: userId=$userId")
        }
    }
}

