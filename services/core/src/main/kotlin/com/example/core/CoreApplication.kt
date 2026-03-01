package com.example.core

import com.example.core.config.JacksonConfig
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.context.annotation.Import
import org.springframework.kafka.annotation.EnableKafka
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableKafka
@EnableScheduling
@ConfigurationPropertiesScan
@Import(JacksonConfig::class)
class CoreApplication

fun main(args: Array<String>) {
    runApplication<CoreApplication>(*args)
}
