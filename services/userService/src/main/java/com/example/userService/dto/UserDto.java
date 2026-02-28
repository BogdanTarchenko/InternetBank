package com.example.userService.dto;

import com.example.userService.domain.enumeration.Role;

import java.util.UUID;

public record UserDto(
        UUID id,
        String email,
        String name,
        Role role
) {
}
