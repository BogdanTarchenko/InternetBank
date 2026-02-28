package com.example.credit.domain.role

enum class Role {
    CLIENT,
    EMPLOYEE,
    ADMIN,
    BANNED;

    fun isPrivileged(): Boolean = this == EMPLOYEE || this == ADMIN
}
