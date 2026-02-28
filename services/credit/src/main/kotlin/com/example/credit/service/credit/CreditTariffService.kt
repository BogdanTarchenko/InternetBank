package com.example.credit.service.credit

import com.example.credit.domain.credit.CreditTariff
import com.example.credit.repository.credit.CreditTariffRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal

@Service
class CreditTariffService(
    private val creditTariffRepository: CreditTariffRepository
) {

    @Transactional
    fun createTariff(name: String, interestRate: BigDecimal, paymentIntervalMinutes: Int): CreditTariff {
        val tariff = CreditTariff(
            name = name,
            interestRate = interestRate,
            paymentIntervalMinutes = paymentIntervalMinutes
        )
        return creditTariffRepository.save(tariff)
    }

    @Transactional(readOnly = true)
    fun getTariffById(id: Long): CreditTariff =
        creditTariffRepository.findById(id).orElseThrow { NoSuchElementException("Tariff not found: id=$id") }

    @Transactional(readOnly = true)
    fun getAllTariffs(): List<CreditTariff> = creditTariffRepository.findAll()
}
