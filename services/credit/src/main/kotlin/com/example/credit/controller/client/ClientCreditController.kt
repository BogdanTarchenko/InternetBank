package com.example.credit.controller.client

import com.example.credit.controller.apimodels.CreditDetailResponse
import com.example.credit.controller.apimodels.CreditResponse
import com.example.credit.controller.apimodels.RepayRequest
import com.example.credit.controller.apimodels.TariffResponse
import com.example.credit.controller.apimodels.TakeCreditRequest
import com.example.credit.controller.apimodels.toResponse
import com.example.credit.service.credit.CreditService
import com.example.credit.service.credit.CreditTariffService
import com.example.credit.service.user.UserAccountStatusService
import jakarta.validation.Valid
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/client")
class ClientCreditController(
    private val creditService: CreditService,
    private val creditTariffService: CreditTariffService,
    private val userAccountStatusService: UserAccountStatusService
) {

    @GetMapping("/credits")
    fun getMyCredits(@RequestParam("userId") userId: String): List<CreditResponse> {
        userAccountStatusService.assertUserActive(userId)
        return creditService.getCreditsByUserId(userId).map { it.toResponse() }
    }

    @GetMapping("/credits/{creditId}")
    fun getCreditDetail(
        @PathVariable creditId: Long,
        @RequestParam("userId") userId: String
    ): CreditDetailResponse {
        userAccountStatusService.assertUserActive(userId)
        return creditService.getCreditDetailForUser(creditId, userId)
    }

    @GetMapping("/tariffs")
    fun getTariffs(): List<TariffResponse> =
        creditTariffService.getAllTariffs().map { it.toResponse() }

    @PostMapping("/credits")
    fun takeCredit(@RequestBody @Valid request: TakeCreditRequest): CreditResponse {
        userAccountStatusService.assertUserActive(request.userId)
        val credit = creditService.takeCredit(request.userId, request.tariffId, request.amount, request.accountId)
        return credit.toResponse()
    }

    @PostMapping("/credits/{creditId}/repay")
    fun repay(
        @PathVariable creditId: Long,
        @RequestParam("userId") userId: String,
        @RequestBody @Valid request: RepayRequest
    ): CreditResponse {
        userAccountStatusService.assertUserActive(userId)
        val credit = creditService.repay(creditId, userId, request.amount, request.accountId)
        return credit.toResponse()
    }
}
