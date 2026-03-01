package com.example.userService.controller;

import com.example.userService.dto.AuthResponse;
import com.example.userService.dto.LoginRequest;
import com.example.userService.dto.RefreshTokenRequest;
import com.example.userService.dto.RegistrationRequest;
import com.example.userService.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Auth", description = "Аутентификация и регистрация")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    @Operation(summary = "Войти в систему")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Зарегистрировать нового пользователя")
    public AuthResponse register(@Valid @RequestBody RegistrationRequest request) {
        return authService.register(request);
    }

    @PostMapping("/refresh")
    @Operation(summary = "Обновить токены по refresh-токену")
    public AuthResponse refresh(@Valid @RequestBody RefreshTokenRequest request) {
        return authService.refreshToken(request);
    }
}
