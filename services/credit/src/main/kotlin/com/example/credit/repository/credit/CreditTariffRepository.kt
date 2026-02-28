package com.example.credit.repository.credit

import com.example.credit.domain.credit.CreditTariff
import org.springframework.data.jpa.repository.JpaRepository

interface CreditTariffRepository : JpaRepository<CreditTariff, Long>
