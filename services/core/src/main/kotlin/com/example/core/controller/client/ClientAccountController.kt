package com.example.core.controller.client

import com.example.core.controller.apimodels.*
import com.example.core.service.account.AccountService
import com.example.core.service.user.UserAccountStatusService
import jakarta.validation.Valid
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/client")
class ClientAccountController(
    private val accountService: AccountService,
    private val userAccountStatusService: UserAccountStatusService
) {

    @PostMapping("/accounts")
    fun openAccount(@RequestBody @Valid request: OpenAccountRequest): AccountResponse {
        userAccountStatusService.assertUserActive(request.userId)
        val account = accountService.openAccount(request.userId)
        return account.toResponse()
    }

    @GetMapping("/accounts")
    fun getUserAccounts(@RequestParam("userId") userId: String): List<AccountResponse> {
        userAccountStatusService.assertUserActive(userId)
        return accountService.getUserAccounts(userId).map { it.toResponse() }
    }

    @DeleteMapping("/accounts/{accountId}")
    fun closeAccount(
        @PathVariable accountId: UUID,
        @RequestParam("userId") userId: String
    ): AccountResponse {
        userAccountStatusService.assertUserActive(userId)
        val account = accountService.closeAccountForUser(userId, accountId)
        return account.toResponse()
    }

    @PostMapping("/accounts/{accountId}/deposit")
    fun deposit(
        @PathVariable accountId: UUID,
        @RequestParam("userId") userId: String,
        @RequestBody @Valid request: MoneyRequest
    ): AccountResponse {
        userAccountStatusService.assertUserActive(userId)
        val account = accountService.deposit(userId, accountId, request.amount)
        return account.toResponse()
    }

    @PostMapping("/accounts/{accountId}/withdraw")
    fun withdraw(
        @PathVariable accountId: UUID,
        @RequestParam("userId") userId: String,
        @RequestBody @Valid request: MoneyRequest
    ): AccountResponse {
        userAccountStatusService.assertUserActive(userId)
        val account = accountService.withdraw(userId, accountId, request.amount)
        return account.toResponse()
    }

    @GetMapping("/accounts/{accountId}/operations")
    fun getAccountOperations(
        @PathVariable accountId: UUID,
        @RequestParam("userId") userId: String
    ): List<OperationResponse> {
        userAccountStatusService.assertUserActive(userId)
        return accountService.getUserAccountOperations(userId, accountId)
            .map { it.toResponse() }
    }
}

