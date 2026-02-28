package com.example.userService.service;

import com.example.userService.dto.AuthResponse;
import com.example.userService.dto.LoginRequest;
import com.example.userService.dto.RefreshTokenRequest;
import com.example.userService.dto.RegistrationRequest;

public interface AuthService {
    AuthResponse login(LoginRequest loginRequest);
    AuthResponse refreshToken(RefreshTokenRequest refreshTokenRequest);
    AuthResponse register(RegistrationRequest registrationRequest);
}
