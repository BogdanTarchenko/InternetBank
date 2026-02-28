package com.example.credit.config

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "security")
data class SecurityProperties(
    var clients: Map<String, String> = emptyMap()
)
