package com.example.credit.domain.user

data class UserStatusEvent(
    val userId: String,
    val status: UserStatus
)
