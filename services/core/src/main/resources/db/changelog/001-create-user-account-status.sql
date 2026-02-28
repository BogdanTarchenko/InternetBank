--liquibase formatted sql

--changeset core-service:001-create-user-account-status
CREATE TABLE user_account_status (
    user_id VARCHAR(255) PRIMARY KEY NOT NULL,
    status  VARCHAR(32)  NOT NULL
);

