package com.example.core.config

import com.example.core.service.role.RoleAccessService
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.web.servlet.HandlerInterceptor

class RoleAccessInterceptor(
    private val roleAccessService: RoleAccessService
) : HandlerInterceptor {

    override fun preHandle(
        request: HttpServletRequest,
        response: HttpServletResponse,
        handler: Any
    ): Boolean {
        val path = request.requestURI
        val roleHeader = request.getHeader(RoleAccessService.ROLE_HEADER)

        when {
            path.startsWith("/client") -> roleAccessService.requireClient(roleHeader)
            path.startsWith("/employee") -> roleAccessService.requirePrivileged(roleHeader)
        }
        return true
    }
}