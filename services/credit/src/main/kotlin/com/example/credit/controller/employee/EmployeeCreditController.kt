package com.example.credit.controller.employee

import com.example.credit.controller.apimodels.CreateTariffRequest
import com.example.credit.controller.apimodels.CreditDetailResponse
import com.example.credit.controller.apimodels.CreditResponse
import com.example.credit.controller.apimodels.TariffResponse
import com.example.credit.controller.apimodels.toResponse
import com.example.credit.service.credit.CreditService
import com.example.credit.service.credit.CreditTariffService
import jakarta.validation.Valid
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/employee")
class EmployeeCreditController(
    private val creditTariffService: CreditTariffService,
    private val creditService: CreditService
) {

    @PostMapping("/tariffs")
    fun createTariff(@RequestBody @Valid request: CreateTariffRequest): TariffResponse {
        val tariff = creditTariffService.createTariff(
            name = request.name,
            interestRate = request.interestRate,
            paymentIntervalMinutes = request.paymentIntervalMinutes
        )
        return tariff.toResponse()
    }

    @GetMapping("/clients/{userId}/credits")
    fun getCreditsByClient(@PathVariable userId: String): List<CreditResponse> =
        creditService.getCreditsByUserId(userId).map { it.toResponse() }

    @GetMapping("/credits/{creditId}")
    fun getCreditDetail(@PathVariable creditId: Long): CreditDetailResponse =
        creditService.getCreditDetail(creditId)
}
