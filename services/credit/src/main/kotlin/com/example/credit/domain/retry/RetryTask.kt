package com.example.credit.domain.retry

import jakarta.persistence.*
import java.time.OffsetDateTime

@Entity
@Table(name = "retry_task")
class RetryTask(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, updatable = false)
    val id: Long? = null,

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    val type: RetryType,

    @Column(name = "sequence_key", nullable = false)
    val sequenceKey: String,

    @Lob
    @Column(name = "payload", nullable = false)
    val payload: String,

    @Column(name = "attempt", nullable = false)
    var attempt: Int = 0,

    @Column(name = "last_error", nullable = true, length = 2000)
    var lastError: String? = null,

    @Column(name = "created_at", nullable = false, updatable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    var updatedAt: OffsetDateTime = createdAt
) {

    fun markFailed(error: Throwable) {
        attempt += 1
        lastError = error.message
        updatedAt = OffsetDateTime.now()
    }
}
