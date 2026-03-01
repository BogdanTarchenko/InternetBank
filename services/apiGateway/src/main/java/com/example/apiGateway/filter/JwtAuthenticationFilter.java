package com.example.apiGateway.filter;

import com.example.apiGateway.config.RouteProperties;
import com.example.apiGateway.service.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Component
@Order(-1)
@RequiredArgsConstructor
public class JwtAuthenticationFilter implements WebFilter {

    private static final String BEARER_PREFIX = "Bearer ";
    private static final String HEADER_USER_ID = "X-USER-ID";
    private static final String HEADER_USER_ROLE = "X-USER-ROLE";
    private static final AntPathMatcher PATH_MATCHER = new AntPathMatcher();

    private final JwtService jwtService;
    private final RouteProperties routeProperties;

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        String path = exchange.getRequest().getPath().value();

        boolean requiresAuth = routeProperties.getRoutes().stream()
                .filter(route -> PATH_MATCHER.match(route.getPath(), path))
                .findFirst()
                .map(RouteProperties.RouteDefinition::isRequiresAuth)
                .orElse(false);

        if (!requiresAuth) {
            return chain.filter(exchange);
        }

        String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if (authHeader == null || !authHeader.startsWith(BEARER_PREFIX)) {
            return respondUnauthorized(exchange, "Missing or invalid Authorization header");
        }

        String token = authHeader.substring(BEARER_PREFIX.length());

        try {
            jwtService.validateToken(token);

            UUID userId = jwtService.extractUserId(token);
            String role = jwtService.extractRole(token);

            ServerWebExchange mutatedExchange = exchange.mutate()
                    .request(req -> req
                            .header(HEADER_USER_ID, userId.toString())
                            .header(HEADER_USER_ROLE, role))
                    .build();

            return chain.filter(mutatedExchange);

        } catch (Exception e) {
            return respondUnauthorized(exchange, "Invalid or expired token");
        }
    }

    private Mono<Void> respondUnauthorized(ServerWebExchange exchange, String message) {
        byte[] body = ("{\"error\": \"" + message + "\"}").getBytes(StandardCharsets.UTF_8);
        exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        exchange.getResponse().getHeaders().setContentType(MediaType.APPLICATION_JSON);
        exchange.getResponse().getHeaders().setContentLength(body.length);
        return exchange.getResponse().writeWith(
                Mono.just(exchange.getResponse().bufferFactory().wrap(body))
        );
    }
}
