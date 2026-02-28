package com.example.credit.config

import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.web.servlet.HandlerInterceptor

class ApiClientAuthInterceptor(
    private val securityProperties: SecurityProperties
) : HandlerInterceptor {

    override fun preHandle(
        request: HttpServletRequest,
        response: HttpServletResponse,
        handler: Any
    ): Boolean {
        val clientId = request.getHeader("client-id")
        val token = request.getHeader("X-API-TOKEN")

        if (clientId.isNullOrBlank() || token.isNullOrBlank()) {
            response.status = HttpServletResponse.SC_UNAUTHORIZED
            return false
        }

        val expectedToken = securityProperties.clients[clientId]
        if (expectedToken == null || expectedToken != token) {
            response.status = HttpServletResponse.SC_UNAUTHORIZED
            return false
        }

        return true
    }
}
