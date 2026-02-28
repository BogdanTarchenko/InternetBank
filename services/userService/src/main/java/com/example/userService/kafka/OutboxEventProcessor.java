package com.example.userService.kafka;

import com.example.userService.domain.entity.OutboxEvent;
import com.example.userService.repository.OutboxEventRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class OutboxEventProcessor {

    private final OutboxEventRepository outboxEventRepository;
    private final KafkaTemplate<String, String> kafkaTemplate;

    @Scheduled(fixedDelayString = "${outbox.processor.fixed-delay-ms:5000}")
    @Transactional
    public void processOutbox() {
        List<OutboxEvent> pending = outboxEventRepository.findAllByOrderByCreatedAtAsc();

        if (pending.isEmpty()) {
            return;
        }

        log.debug("Processing {} outbox event(s)", pending.size());

        for (OutboxEvent event : pending) {
            try {
                kafkaTemplate.send(event.getTopic(), event.getPayload()).get();
                outboxEventRepository.delete(event);
                log.info("Outbox event sent and deleted: topic={}, payload={}", event.getTopic(), event.getPayload());
            } catch (Exception e) {
                log.error("Failed to send outbox event id={}: {}", event.getId(), e.getMessage());
            }
        }
    }
}
