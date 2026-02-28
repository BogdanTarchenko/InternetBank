package com.example.credit.controller.client

import com.example.credit.controller.apimodels.CreditDetailResponse
import com.example.credit.controller.apimodels.CreditResponse
import com.example.credit.controller.apimodels.RepayRequest
import com.example.credit.controller.apimodels.TakeCreditRequest
import com.example.credit.controller.apimodels.TariffResponse
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

    /** Список тарифов для оформления кредита */
    @GetMapping("/tariffs")
    fun listTariffs(): List<TariffResponse> =
        creditTariffService.getAllTariffs().map { it.toResponse() }

    /** Оформить кредит: указывается id счёта, куда начислить кредитные деньги */
    @PostMapping("/credits")
    fun takeCredit(@RequestBody @Valid request: TakeCreditRequest): CreditResponse {
        userAccountStatusService.assertUserActive(request.userId)
        val credit = creditService.takeCredit(request.userId, request.tariffId, request.amount)
        return credit.toResponse()
    }

    /** Список кредитов клиента */
    @GetMapping("/credits")
    fun listMyCredits(@RequestParam("userId") userId: String): List<CreditResponse> {
        userAccountStatusService.assertUserActive(userId)
        return creditService.getCreditsByUserId(userId).map { it.toResponse() }
    }

    /** Детали кредита (кредит + история платежей) */
    @GetMapping("/credits/{creditId}")
    fun getMyCredit(
        @PathVariable creditId: Long,
        @RequestParam("userId") userId: String
    ): CreditDetailResponse {
        userAccountStatusService.assertUserActive(userId)
        val detail = creditService.getCreditDetail(creditId)
        if (detail.credit.userId != userId) {
            throw IllegalArgumentException("Credit $creditId does not belong to user $userId")
        }
        return detail
    }

    /** Оплата кредита: указывается счёт, откуда списать деньги */
    @PostMapping("/credits/{creditId}/repay")
    fun repay(
        @PathVariable creditId: Long,
        @RequestParam("userId") userId: String,
        @RequestBody @Valid request: RepayRequest
    ): CreditResponse {
        userAccountStatusService.assertUserActive(userId)
        val credit = creditService.repay(creditId, userId, request.amount)
        return credit.toResponse()
    }
}
