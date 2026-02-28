package com.example.userService.dto;

public record LoginRequest(
        String email,
        String password
) {
}
