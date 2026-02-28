package com.example.userService.dto;

public record RegistrationRequest(
        String email,
        String password,
        String name
) {
}
