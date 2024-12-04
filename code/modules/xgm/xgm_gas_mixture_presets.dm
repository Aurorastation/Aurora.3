
/datum/gas_mixture/vacuum/New()
	..()
	// does nothing, type just for clarity/organization

/datum/gas_mixture/earth/New()
	..()
	adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 1)
	adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD, 1)
	temperature = T20C
	update_values()
