package com.example.userService.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final SecurityProperties securityProperties;

    public WebConfig(SecurityProperties securityProperties) {
        this.securityProperties = securityProperties;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new ApiClientAuthInterceptor(securityProperties))
                .addPathPatterns("/**");
    }
}
