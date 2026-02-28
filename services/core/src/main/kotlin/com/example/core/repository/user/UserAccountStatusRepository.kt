package com.example.core.repository.user

import com.example.core.domain.user.UserAccountStatus
import org.springframework.data.jpa.repository.JpaRepository

interface UserAccountStatusRepository : JpaRepository<UserAccountStatus, String>

