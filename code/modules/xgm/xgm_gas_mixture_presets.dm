
/datum/gas_mixture/vacuum
	// default/empty values, new type just for clarity/organization

/datum/gas_mixture/earth_standard/New()
	..()
	adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, FALSE)
	adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, FALSE)
	temperature = T20C
	update_values()

/datum/gas_mixture/earth_cold/New()
	..()
	adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, FALSE)
	adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, FALSE)
	temperature = 258 // around -15C
	update_values()

/datum/gas_mixture/earth_slightly_cold/New()
	..()
	adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, FALSE)
	adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, FALSE)
	temperature = T0C - 10 // between -10C and -8C after atmos fuckery, thank you ZAS
	update_values()

/datum/gas_mixture/earth_hot/New()
	..()
	adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, FALSE)
	adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, FALSE)
	temperature = T0C + 32
	update_values()
