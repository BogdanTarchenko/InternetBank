package com.example.userService.dto;

import com.example.userService.domain.enumeration.Role;

public record CreateUserRequest(
        String email,
        String password,
        String name,
        Role role
) {
}
