package com.example.apiGateway.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

@Configuration
@ConfigurationProperties(prefix = "gateway")
@Getter
@Setter
public class RouteProperties {

    private List<RouteDefinition> routes = new ArrayList<>();

    @Getter
    @Setter
    public static class RouteDefinition {
        private String path;
        private String target;
        private boolean requiresAuth;
        private String stripPrefix;
    }
}
