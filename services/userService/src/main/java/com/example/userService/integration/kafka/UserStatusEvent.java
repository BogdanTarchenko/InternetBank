package com.example.userService.kafka;

public record UserStatusEvent(
        String userId,
        String status
) {
    public static UserStatusEvent banned(String userId) {
        return new UserStatusEvent(userId, "INACTIVE");
    }

    public static UserStatusEvent unbanned(String userId) {
        return new UserStatusEvent(userId, "ACTIVE");
    }
}
