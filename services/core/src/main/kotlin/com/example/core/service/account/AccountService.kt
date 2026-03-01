package com.example.core.service.account

import com.example.core.domain.account.BankAccount
import com.example.core.domain.operation.AccountOperation
import com.example.core.domain.operation.OperationType
import com.example.core.repository.account.BankAccountRepository
import com.example.core.repository.operation.AccountOperationRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.util.UUID

@Service
class AccountService(
    private val bankAccountRepository: BankAccountRepository,
    private val accountOperationRepository: AccountOperationRepository
) {

    @Transactional
    fun openAccount(userId: String): BankAccount {
        val account = BankAccount(userId = userId)
        val saved = bankAccountRepository.save(account)
        createOperation(saved, OperationType.OPEN_ACCOUNT, BigDecimal.ZERO)
        return saved
    }

    @Transactional
    fun closeAccountForUser(userId: String, accountId: UUID): BankAccount {
        val account = getUserAccount(userId, accountId)
        account.close()
        return bankAccountRepository.save(account).also {
            createOperation(it, OperationType.CLOSE_ACCOUNT, BigDecimal.ZERO)
        }
    }

    @Transactional
    fun deposit(userId: String, accountId: UUID, amount: BigDecimal): BankAccount {
        val account = getUserAccount(userId, accountId)
        account.deposit(amount)
        val saved = bankAccountRepository.save(account)
        createOperation(saved, OperationType.DEPOSIT, amount)
        return saved
    }

    @Transactional
    fun withdraw(userId: String, accountId: UUID, amount: BigDecimal): BankAccount {
        val account = getUserAccount(userId, accountId)
        account.withdraw(amount)
        val saved = bankAccountRepository.save(account)
        createOperation(saved, OperationType.WITHDRAW, amount)
        return saved
    }

    @Transactional(readOnly = true)
    fun getUserAccounts(userId: String): List<BankAccount> =
        bankAccountRepository.findAllByUserId(userId)

    @Transactional(readOnly = true)
    fun getUserAccountOperations(userId: String, accountId: UUID): List<AccountOperation> {
        val account = getUserAccount(userId, accountId)
        return accountOperationRepository.findAllByAccountOrderByCreatedAtAsc(account)
    }

    @Transactional(readOnly = true)
    fun getAllAccounts(): List<BankAccount> =
        bankAccountRepository.findAll()

    @Transactional(readOnly = true)
    fun getAccountOperations(accountId: UUID): List<AccountOperation> {
        val account = bankAccountRepository.findById(accountId)
            .orElseThrow { IllegalArgumentException("Account not found: $accountId") }
        return accountOperationRepository.findAllByAccountOrderByCreatedAtAsc(account)
    }

    /** Получение счёта по id (для внутреннего/межсервисного API). */
    @Transactional(readOnly = true)
    fun getAccountById(accountId: UUID): BankAccount =
        bankAccountRepository.findById(accountId)
            .orElseThrow { IllegalArgumentException("Account not found: $accountId") }

    /** Списание средств со счёта по id (межсервисное использование, без проверки userId). */
    @Transactional
    fun debit(accountId: UUID, amount: BigDecimal): BankAccount {
        val account = getAccountById(accountId)
        account.withdraw(amount)
        val saved = bankAccountRepository.save(account)
        createOperation(saved, OperationType.WITHDRAW, amount)
        return saved
    }

    @Transactional
    fun credit(accountId: UUID, amount: BigDecimal): BankAccount {
        val account = getAccountById(accountId)
        account.deposit(amount)
        val saved = bankAccountRepository.save(account)
        createOperation(saved, OperationType.DEPOSIT, amount)
        return saved
    }

    private fun getUserAccount(userId: String, accountId: UUID): BankAccount {
        val account = bankAccountRepository.findById(accountId)
            .orElseThrow { IllegalArgumentException("Account not found: $accountId") }
        if (account.userId != userId) {
            throw IllegalArgumentException("Account $accountId does not belong to user $userId")
        }
        return account
    }

    private fun createOperation(
        account: BankAccount,
        type: OperationType,
        amount: BigDecimal
    ) {
        val operation = AccountOperation(
            account = account,
            type = type,
            amount = amount,
            balanceAfter = account.balance
        )
        accountOperationRepository.save(operation)
    }
}

