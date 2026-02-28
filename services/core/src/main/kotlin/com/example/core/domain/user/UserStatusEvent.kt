package com.example.core.domain.user

data class UserStatusEvent(
    val userId: String,
    val status: UserStatus
)

