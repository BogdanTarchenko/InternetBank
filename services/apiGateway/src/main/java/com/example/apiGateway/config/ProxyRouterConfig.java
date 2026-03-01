package com.example.apiGateway.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpHeaders;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

import java.net.URI;
import java.util.Set;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class ProxyRouterConfig {

    private final RouteProperties routeProperties;
    private final WebClient webClient;

    @Bean
    public RouterFunction<ServerResponse> proxyRouter() {
        RouterFunctions.Builder builder = RouterFunctions.route();

        for (RouteProperties.RouteDefinition route : routeProperties.getRoutes()) {
            builder.route(
                    RequestPredicates.path(route.getPath()),
                    req -> proxyRequest(req, route)
            );
        }

        return builder.build();
    }

    private static final Set<String> SKIP_RESPONSE_HEADERS = Set.of(
            HttpHeaders.TRANSFER_ENCODING.toLowerCase(),
            HttpHeaders.CONTENT_LENGTH.toLowerCase()
    );

    private Mono<ServerResponse> proxyRequest(ServerRequest request, RouteProperties.RouteDefinition route) {
        String rawPath = request.uri().getRawPath();

        if (route.getStripPrefix() != null && !route.getStripPrefix().isBlank()) {
            String prefix = route.getStripPrefix();
            if (rawPath.startsWith(prefix)) {
                rawPath = rawPath.substring(prefix.length());
                if (rawPath.isEmpty()) rawPath = "/";
            }
        }

        String rawQuery = request.uri().getRawQuery();
        String targetUrl = route.getTarget() + rawPath + (rawQuery != null ? "?" + rawQuery : "");
        URI targetUri = URI.create(targetUrl);

        String clientId = route.getClientId();
        String apiToken = route.getApiToken();
        boolean addServiceAuth = clientId != null && !clientId.isBlank()
                && apiToken != null && !apiToken.isBlank();
        log.info("Proxying {} {} → {} (serviceAuth: {}, clientId: {})",
                request.method(), request.uri().getRawPath(), targetUri, addServiceAuth, addServiceAuth ? clientId : "n/a");

        return webClient
                .method(request.method())
                .uri(targetUri)
                .headers(headers -> {
                    headers.addAll(request.headers().asHttpHeaders());
                    headers.remove(HttpHeaders.HOST);
                    if (addServiceAuth) {
                        headers.set("X-CLIENT-ID", clientId);
                        headers.set("client-id", clientId);
                        headers.set("X-API-TOKEN", apiToken);
                    }
                })
                .body(request.bodyToFlux(DataBuffer.class), DataBuffer.class)
                .exchangeToMono(clientResponse ->
                        clientResponse.bodyToMono(byte[].class)
                                .defaultIfEmpty(new byte[0])
                                .flatMap(body -> {
                                    ServerResponse.BodyBuilder builder = ServerResponse
                                            .status(clientResponse.statusCode())
                                            .headers(headers ->
                                                    clientResponse.headers().asHttpHeaders()
                                                            .forEach((name, values) -> {
                                                                if (!SKIP_RESPONSE_HEADERS.contains(name.toLowerCase())) {
                                                                    headers.addAll(name, values);
                                                                }
                                                            })
                                            );
                                    return body.length > 0
                                            ? builder.bodyValue(body)
                                            : builder.build();
                                })
                );
    }
}
