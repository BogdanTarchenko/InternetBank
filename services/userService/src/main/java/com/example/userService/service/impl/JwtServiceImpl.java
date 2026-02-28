package com.example.userService.service.impl;

import com.example.userService.domain.enumeration.Role;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import com.example.userService.service.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.time.Instant;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class JwtServiceImpl implements JwtService {

    private static final String CLAIM_ROLE = "role";

    @Value("${jwt.secret}")
    private String jwtSecretKey;

    @Override
    public String generateAccessToken(UUID userId, Role role, Long ttl) {
        Instant now = Instant.now();
        Instant expiration = now.plusMillis(ttl);

        return Jwts.builder()
                .subject(userId.toString())
                .claim(CLAIM_ROLE, role.name())
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiration))
                .signWith(getSecretKey())
                .compact();
    }

    @Override
    public String generateRefreshToken(UUID userId, Long ttl) {
        Instant now = Instant.now();
        Instant expiration = now.plusMillis(ttl);

        return Jwts.builder()
                .subject(userId.toString())
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiration))
                .signWith(getSecretKey())
                .compact();
    }

    @Override
    public UUID extractUserIdFromToken(String token) {
        Claims claims = extractClaimsFromToken(token);
        return UUID.fromString(claims.getSubject());
    }

    @Override
    public Role extractRoleFromToken(String token) {
        Claims claims = extractClaimsFromToken(token);
        return Role.valueOf(claims.get(CLAIM_ROLE, String.class));
    }

    @Override
    public void validateToken(String token) {
        Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parse(token);
    }

    private Claims extractClaimsFromToken(String token) {
        return Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    private SecretKey getSecretKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtSecretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

}
