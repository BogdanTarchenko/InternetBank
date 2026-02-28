package com.example.userService.controller;

import com.example.userService.domain.enumeration.Role;
import com.example.userService.dto.ChangeUserRoleRequest;
import com.example.userService.dto.EditUserProfileRequest;
import com.example.userService.dto.UserDto;
import com.example.userService.service.JwtService;
import com.example.userService.service.UserDataService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "Users", description = "Управление пользователями")
public class UserController {

    private final UserDataService userDataService;
    private final JwtService jwtService;

    @GetMapping
    @Operation(summary = "Список пользователей с пагинацией и поиском (только для сотрудников)", security = @SecurityRequirement(name = "bearerAuth"))
    public Page<UserDto> getUsers(
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestHeader("X-USER-ROLE") Role requesterRole
    ) {
        if (!requesterRole.isPrivileged()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Only employees and admins can view user list");
        }
        return userDataService.getUsers(search, page, size);
    }

    @GetMapping("/me")
    @Operation(summary = "Получить свой профиль", security = @SecurityRequirement(name = "bearerAuth"))
    public UserDto getMe(@RequestHeader("X-USER-ID") UUID userId) {
        return userDataService.findUserById(userId);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Получить пользователя по ID")
    public UserDto getById(@PathVariable UUID id) {
        return userDataService.findUserById(id);
    }

    @PatchMapping("/{id}")
    @Operation(summary = "Редактировать профиль пользователя", security = @SecurityRequirement(name = "bearerAuth"))
    public UserDto editProfile(@PathVariable UUID id, @Valid @RequestBody EditUserProfileRequest request) {
        return userDataService.editUserProfile(id, request);
    }

    @PatchMapping("/{id}/role")
    @Operation(summary = "Изменить роль пользователя (только для сотрудников)", security = @SecurityRequirement(name = "bearerAuth"))
    public UserDto changeRole(
            @PathVariable UUID id,
            @Valid @RequestBody ChangeUserRoleRequest request,
            @RequestHeader("X-USER-ID") UUID requesterId,
            @RequestHeader("X-USER-ROLE") Role requesterRole
    ) {
        try {
            return userDataService.changeUserRole(requesterId, requesterRole, id, request.role());
        } catch (AccessDeniedException e) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, e.getMessage());
        }
    }
}
