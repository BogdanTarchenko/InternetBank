package com.example.credit.config

import com.example.credit.service.role.RoleAccessService
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.InterceptorRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
class WebConfig(
    private val securityProperties: SecurityProperties,
    private val roleAccessService: RoleAccessService
) : WebMvcConfigurer {

    override fun addInterceptors(registry: InterceptorRegistry) {
        registry.addInterceptor(ApiClientAuthInterceptor(securityProperties))
            .addPathPatterns("/**")
        registry.addInterceptor(RoleAccessInterceptor(roleAccessService))
            .addPathPatterns("/client/**", "/employee/**")
    }
}
