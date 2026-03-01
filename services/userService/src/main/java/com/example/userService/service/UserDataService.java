package com.example.userService.service;

import com.example.userService.domain.entity.User;
import com.example.userService.domain.enumeration.Role;
import com.example.userService.dto.EditUserProfileRequest;
import com.example.userService.dto.UserDto;
import org.springframework.data.domain.Page;

import java.util.UUID;

public interface UserDataService {
    UserDto createUser(User user);
    User findUserByEmail(String email);
    boolean comparePassword(User user, String password);
    UserDto findUserById(UUID id);
    UserDto editUserProfile(UUID userId, EditUserProfileRequest request);
    UserDto changeUserRole(UUID requesterId, Role requesterRole, UUID targetUserId, Role newRole);
    Page<UserDto> getUsers(String search, int page, int size);
}
