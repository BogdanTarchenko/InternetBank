package com.example.userService.dto;

import com.example.userService.domain.enumeration.Role;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

public record ChangeUserRoleRequest(
        UUID userId,

        @NotNull(message = "Role is required")
        Role role
) {
}
