package com.example.userService.service;

import com.example.userService.domain.enumeration.Role;

import java.util.UUID;

public interface JwtService {
    String generateAccessToken(UUID userId, Role role, Long ttl);
    String generateRefreshToken(UUID userId, Long ttl);
    UUID extractUserIdFromToken(String token);
    Role extractRoleFromToken(String token);
    void validateToken(String token);
}
