--liquibase formatted sql

--changeset core-service:002-create-bank-account
CREATE TABLE bank_account (
    id         UUID          PRIMARY KEY NOT NULL,
    user_id    VARCHAR(255)  NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    balance    NUMERIC(19,2) NOT NULL,
    status     VARCHAR(32)   NOT NULL
);

CREATE INDEX idx_bank_account_user_id
    ON bank_account (user_id);

