package com.example.credit.repository.user

import com.example.credit.domain.user.UserAccountStatus
import org.springframework.data.jpa.repository.JpaRepository

interface UserAccountStatusRepository : JpaRepository<UserAccountStatus, String>
