package com.example.userService.service.impl;

import com.example.userService.domain.entity.OutboxEvent;
import com.example.userService.domain.entity.User;
import com.example.userService.domain.enumeration.Role;
import com.example.userService.dto.EditUserProfileRequest;
import com.example.userService.dto.UserDto;
import com.example.userService.exception.EmailAlreadyExistsException;
import com.example.userService.exception.UserNotFoundException;
import com.example.userService.integration.kafka.UserStatusEvent;
import com.example.userService.repository.OutboxEventRepository;
import com.example.userService.repository.UserRepository;
import com.example.userService.service.UserDataService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserDataServiceImpl implements UserDataService {

    private final UserRepository userRepository;
    private final OutboxEventRepository outboxEventRepository;
    private final PasswordEncoder passwordEncoder;
    private final ObjectMapper objectMapper;

    @Value("${user-status.topic:user-status}")
    private String userStatusTopic;

    @Override
    @Transactional
    public UserDto createUser(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new EmailAlreadyExistsException("Email already exists: " + user.getEmail());
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        publishRegisteredEvent(user.getId());
        return toDto(user);
    }

    private void publishRegisteredEvent(UUID userId) {
        UserStatusEvent event = UserStatusEvent.unbanned(userId.toString());
        try {
            String payload = objectMapper.writeValueAsString(event);
            outboxEventRepository.save(OutboxEvent.builder()
                    .topic(userStatusTopic)
                    .payload(payload)
                    .createdAt(LocalDateTime.now())
                    .build());
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to serialize UserStatusEvent", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public User findUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("User not found with email: " + email));
    }

    @Override
    public boolean comparePassword(User user, String password) {
        return passwordEncoder.matches(password, user.getPassword());
    }

    @Override
    @Transactional(readOnly = true)
    public UserDto findUserById(UUID id) {
        var user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with id: " + id));
        return toDto(user);
    }

    @Override
    @Transactional
    public UserDto editUserProfile(UUID userId, EditUserProfileRequest request) {
        var user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("User not found with id: " + userId));

        if (request.email() != null && !request.email().isBlank()) {
            var sameEmailUser = userRepository.findByEmail(request.email());
            if (sameEmailUser.isPresent() && !sameEmailUser.get().getId().equals(userId)) {
                throw new EmailAlreadyExistsException("Email already exists: " + request.email());
            }
            user.setEmail(request.email());
        }

        if (request.name() != null && !request.name().isBlank()) {
            user.setName(request.name());
        }

        return toDto(user);
    }

    @Override
    @Transactional
    public UserDto changeUserRole(UUID requesterId, Role requesterRole, UUID targetUserId, Role newRole) {
        if (!requesterRole.isPrivileged()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Only employees and admins can change user roles");
        }
        if (requesterId.equals(targetUserId)) {
            throw new AccessDeniedException("Cannot change your own role");
        }

        var target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException("User not found with id: " + targetUserId));

        if (target.getRole() == Role.ADMIN) {
            throw new AccessDeniedException("Cannot change role of an admin");
        }

        Role previousRole = target.getRole();
        target.setRole(newRole);

        publishUserStatusEventIfNeeded(previousRole, newRole, targetUserId);

        return toDto(target);
    }

    private void publishUserStatusEventIfNeeded(Role previousRole, Role newRole, UUID userId) {
        UserStatusEvent event = null;

        if (newRole == Role.BANNED && previousRole != Role.BANNED) {
            event = UserStatusEvent.banned(userId.toString());
        } else if (newRole != Role.BANNED && previousRole == Role.BANNED) {
            event = UserStatusEvent.unbanned(userId.toString());
        }

        if (event == null) {
            return;
        }

        try {
            String payload = objectMapper.writeValueAsString(event);
            outboxEventRepository.save(OutboxEvent.builder()
                    .topic(userStatusTopic)
                    .payload(payload)
                    .createdAt(LocalDateTime.now())
                    .build());
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to serialize UserStatusEvent", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Page<UserDto> getUsers(String search, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("name").ascending());

        Page<User> users = (search != null && !search.isBlank())
                ? userRepository.findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(search, search, pageable)
                : userRepository.findAll(pageable);

        return users.map(this::toDto);
    }

    private UserDto toDto(User user) {
        return new UserDto(user.getId(), user.getEmail(), user.getName(), user.getRole());
    }
}
