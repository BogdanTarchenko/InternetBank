package com.example.credit.domain.user

import jakarta.persistence.*

@Entity
@Table(name = "user_account_status")
class UserAccountStatus(
    @Id
    @Column(name = "user_id", nullable = false, updatable = false)
    val userId: String,

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    var status: UserStatus = UserStatus.ACTIVE
)
