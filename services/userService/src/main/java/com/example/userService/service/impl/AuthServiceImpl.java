package com.example.userService.service.impl;

import com.example.userService.domain.entity.User;
import com.example.userService.domain.enumeration.Role;
import com.example.userService.dto.AuthResponse;
import com.example.userService.dto.LoginRequest;
import com.example.userService.dto.RefreshTokenRequest;
import com.example.userService.dto.RegistrationRequest;
import com.example.userService.dto.UserDto;
import com.example.userService.service.AuthService;
import com.example.userService.service.JwtService;
import com.example.userService.service.UserDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final JwtService jwtService;

    private final UserDataService userDataService;

    @Value("${jwt.refreshTokenTtl}")
    private Long refreshTokenTtl;

    @Value("${jwt.accessTokenTtl}")
    private Long accessTokenTtl;

    @Override
    @Transactional
    public AuthResponse login(LoginRequest loginRequest) {
        var targetUser = userDataService.findUserByEmail(loginRequest.email());

        if (!userDataService.comparePassword(targetUser, loginRequest.password())) {
            throw new BadCredentialsException("Wrong password");
        }

        return createAuthResponse(targetUser.getId(), targetUser.getRole());
    }

    @Override
    @Transactional
    public AuthResponse register(RegistrationRequest registrationRequest) {
        var user = User.builder()
                .email(registrationRequest.email())
                .password(registrationRequest.password())
                .name(registrationRequest.name())
                .role(Role.CLIENT)
                .build();

        userDataService.createUser(user);

        return createAuthResponse(user.getId(), user.getRole());
    }

    @Override
    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest refreshTokenRequest) {
        var tokenOwnerId = jwtService.extractUserIdFromToken(refreshTokenRequest.refreshToken());
        var tokenOwner = userDataService.findUserById(tokenOwnerId);

        return createAuthResponse(tokenOwner.id(), tokenOwner.role());
    }

    private AuthResponse createAuthResponse(UUID userId, Role role) {
        var accessToken = jwtService.generateAccessToken(userId, role, accessTokenTtl);
        var refreshToken = jwtService.generateRefreshToken(userId, refreshTokenTtl);

        return new AuthResponse(accessToken, refreshToken);
    }

}
