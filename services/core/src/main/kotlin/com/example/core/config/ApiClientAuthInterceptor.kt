package com.example.core.config

import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.slf4j.LoggerFactory
import org.springframework.web.servlet.HandlerInterceptor

class ApiClientAuthInterceptor(
    private val securityProperties: SecurityProperties
) : HandlerInterceptor {

    private val log = LoggerFactory.getLogger(javaClass)

    override fun preHandle(
        request: HttpServletRequest,
        response: HttpServletResponse,
        handler: Any
    ): Boolean {
        // stderr всегда виден в docker logs, даже если уровень логирования режет INFO
        System.err.println("[ApiClientAuth] preHandle: " + request.getMethod() + " " + request.requestURI)

        val method: String = request.getMethod()
        val uri: String = request.requestURI
        val msg: String = "ApiClientAuth preHandle: " + method + " " + uri
        log.info(msg)

        val clientId = request.getHeader("X-CLIENT-ID") ?: request.getHeader("client-id")
        val token = request.getHeader("X-API-TOKEN")

        if (clientId.isNullOrBlank() || token.isNullOrBlank()) {
            System.err.println("[ApiClientAuth] 401 missing headers — clientId='" + clientId + "', tokenPresent=" + (token != null && token.isNotBlank()))
            val missingMsg = "ApiClientAuth: UNAUTHORIZED missing headers — clientId: '" + clientId + "', tokenPresent: " + (token != null && token.isNotBlank())
            log.info(missingMsg)
            response.status = HttpServletResponse.SC_UNAUTHORIZED
            return false
        }

        val expectedToken = securityProperties.clients[clientId]
        if (expectedToken == null || expectedToken != token) {
            val known = securityProperties.clients.keys.joinToString()
            System.err.println("[ApiClientAuth] 401 rejected — clientId='" + clientId + "', knownClients=[" + known + "]")
            val match = expectedToken != null && expectedToken == token
            val rejectedMsg = "ApiClientAuth: UNAUTHORIZED rejected — clientId: '" + clientId + "', knownClients: [" + known + "], tokenMatch: " + match
            log.info(rejectedMsg)
            response.status = HttpServletResponse.SC_UNAUTHORIZED
            return false
        }

        return true
    }
}

