package com.example.userService.domain.enumeration;

public enum Role {
    CLIENT,
    EMPLOYEE,
    ADMIN,
    BANNED;

    public boolean isPrivileged() {
        return this == EMPLOYEE || this == ADMIN;
    }
}
