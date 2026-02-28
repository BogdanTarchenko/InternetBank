--liquibase formatted sql

--changeset core-service:003-create-account-operation
CREATE TABLE account_operation (
    id            UUID          PRIMARY KEY NOT NULL,
    account_id    UUID          NOT NULL,
    type          VARCHAR(32)   NOT NULL,
    amount        NUMERIC(19,2) NOT NULL,
    balance_after NUMERIC(19,2) NOT NULL,
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL
);

ALTER TABLE account_operation
    ADD CONSTRAINT fk_account_operation_account
        FOREIGN KEY (account_id) REFERENCES bank_account (id);

CREATE INDEX idx_account_operation_account_id
    ON account_operation (account_id);

