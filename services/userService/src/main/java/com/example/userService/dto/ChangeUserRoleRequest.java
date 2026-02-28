package com.example.userService.dto;

import com.example.userService.domain.enumeration.Role;

import java.util.UUID;

public record ChangeUserRoleRequest(
        UUID userId,
        Role role
) {
}
