package com.example.core.service.role

import com.example.core.domain.role.Role
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException

@Service
class RoleAccessService {

    fun parseRole(roleHeader: String?): Role? {
        if (roleHeader.isNullOrBlank()) return null
        return try {
            Role.valueOf(roleHeader.trim().uppercase())
        } catch (_: IllegalArgumentException) {
            null
        }
    }

    fun requireRole(roleHeader: String?, allowedRoles: Set<Role>) {
        val role = parseRole(roleHeader)
            ?: throw ResponseStatusException(HttpStatus.FORBIDDEN, "Missing or invalid $ROLE_HEADER")
        if (role == Role.BANNED) {
            throw ResponseStatusException(HttpStatus.FORBIDDEN, "User is banned")
        }
        if (role !in allowedRoles) {
            throw ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied for role: $role")
        }
    }

    fun requireClient(roleHeader: String?) {
        requireRole(roleHeader, setOf(Role.CLIENT))
    }

    fun requirePrivileged(roleHeader: String?) {
        requireRole(roleHeader, setOf(Role.EMPLOYEE, Role.ADMIN))
    }

    companion object {
        const val ROLE_HEADER = "X-USER-ROLE"
    }
}
