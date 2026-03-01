package com.example.core.controller.internal

import com.example.core.controller.apimodels.AccountResponse
import com.example.core.controller.apimodels.MoneyRequest
import com.example.core.controller.apimodels.toResponse
import com.example.core.service.account.AccountService
import jakarta.validation.Valid
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/internal")
class InternalAccountController(
    private val accountService: AccountService
) {

    @GetMapping("/accounts/{accountId}")
    fun getAccount(@PathVariable accountId: UUID): AccountResponse {
        val account = accountService.getAccountById(accountId)
        return account.toResponse()
    }

    @PostMapping("/accounts/{accountId}/debit")
    fun debit(
        @PathVariable accountId: UUID,
        @RequestBody @Valid request: MoneyRequest
    ): AccountResponse {
        val account = accountService.debit(accountId, request.amount)
        return account.toResponse()
    }

    @PostMapping("/accounts/{accountId}/credit")
    fun credit(
        @PathVariable accountId: UUID,
        @RequestBody @Valid request: MoneyRequest
    ): AccountResponse {
        val account = accountService.credit(accountId, request.amount)
        return account.toResponse()
    }
}
