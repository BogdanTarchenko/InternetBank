package com.example.core.controller.employee

import com.example.core.controller.apimodels.AccountResponse
import com.example.core.controller.apimodels.OperationResponse
import com.example.core.controller.apimodels.toResponse
import com.example.core.service.account.AccountService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/employee")
class EmployeeAccountController(
    private val accountService: AccountService
) {

    @GetMapping("/accounts")
    fun getAllAccounts(): List<AccountResponse> =
        accountService.getAllAccounts().map { it.toResponse() }

    @GetMapping("/accounts/{accountId}/operations")
    fun getAccountOperations(
        @PathVariable accountId: UUID
    ): List<OperationResponse> =
        accountService.getAccountOperations(accountId).map { it.toResponse() }
}

