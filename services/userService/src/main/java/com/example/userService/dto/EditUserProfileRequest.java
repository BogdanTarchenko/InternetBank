package com.example.userService.dto;

public record EditUserProfileRequest(
        String name,
        String email
) {
}
