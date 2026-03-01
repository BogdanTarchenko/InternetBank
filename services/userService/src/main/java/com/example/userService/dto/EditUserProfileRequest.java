package com.example.userService.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;

public record EditUserProfileRequest(
        @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
        String name,

        @Email(message = "Invalid email format")
        String email
) {
}
