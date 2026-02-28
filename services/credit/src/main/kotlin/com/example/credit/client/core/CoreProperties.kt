package com.example.credit.client.core

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "core")
data class CoreProperties(
    var baseUrl: String = "http://localhost:8082",
    var clientId: String = "credit-client",
    var apiToken: String = "client-client-api-token"
)
