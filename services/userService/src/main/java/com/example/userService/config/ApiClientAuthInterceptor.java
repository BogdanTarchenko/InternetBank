package com.example.userService.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

public class ApiClientAuthInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(ApiClientAuthInterceptor.class);

    private final SecurityProperties securityProperties;

    public ApiClientAuthInterceptor(SecurityProperties securityProperties) {
        this.securityProperties = securityProperties;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        log.info("ApiClientAuth preHandle: {} {}", request.getMethod(), request.getRequestURI());

        String clientId = request.getHeader("X-CLIENT-ID");
        if (clientId == null || clientId.isBlank()) {
            clientId = request.getHeader("client-id");
        }
        String token = request.getHeader("X-API-TOKEN");

        if (clientId == null || clientId.isBlank() || token == null || token.isBlank()) {
            log.warn("ApiClientAuth: UNAUTHORIZED — missing headers, clientId='{}', tokenPresent={}",
                    clientId, token != null && !token.isBlank());
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }

        String expectedToken = securityProperties.getClients().get(clientId);
        if (expectedToken == null || !expectedToken.equals(token)) {
            log.warn("ApiClientAuth: UNAUTHORIZED — rejected clientId='{}', knownClients={}",
                    clientId, securityProperties.getClients().keySet());
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }

        return true;
    }
}
