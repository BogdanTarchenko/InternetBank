package com.example.userService.dto;

public record AuthResponse(
        String accessToken,
        String refreshToken
) {
}
