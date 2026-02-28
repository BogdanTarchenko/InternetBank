package com.example.apiGateway.service;

import java.util.UUID;

public interface JwtService {

    UUID extractUserId(String token);

    String extractRole(String token);

    void validateToken(String token);
}
