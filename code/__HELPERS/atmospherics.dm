/obj/proc/analyze_gases(var/atom/A, var/mob/user)
	if(src != A)
		user.visible_message(SPAN_NOTICE("\The [user] has used \an [src] on \the [A]"))

	if(istype(A))
		A.add_fingerprint(user)
		var/list/result = A.atmosanalyze(user)
		if(result && result.len)
			to_chat(user, SPAN_NOTICE("Results of the analysis[src == A ? "" : " of [A]"]"))
			for(var/line in result)
				to_chat(user, SPAN_NOTICE("[line]"))
			return 1

	to_chat(user, SPAN_WARNING("Your [src] flashes a red light as it fails to analyze \the [A]."))
	return 0

/proc/atmosanalyzer_scan(var/obj/target, var/datum/gas_mixture/mixture, var/mob/user)
	var/pressure = XGM_PRESSURE(mixture)
	var/total_moles = mixture.total_moles
	var/skill = get_atmospherics_skill(user)

	var/list/results = list()
	if (total_moles>0)
		if(skill <= SKILL_LEVEL_UNFAMILIAR)
			results += SPAN_NOTICE("Pressure: [round(pressure, 1)] kPa")
			var/unidentified_moles = 0
			for(var/mix in mixture.gas)
				if(is_basic_atmospheric_gas(mix))
					results += SPAN_NOTICE("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%")
				else
					unidentified_moles += mixture.gas[mix]
			if(unidentified_moles > 0)
				results += SPAN_WARNING("Unidentified industrial/hazardous gas: [max(round((unidentified_moles / total_moles) * 100), 1)]%")
			results += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C)]&deg;C")
		else if(skill == SKILL_LEVEL_FAMILIAR)
			results += SPAN_NOTICE("Pressure: [round(pressure,0.1)] kPa")
			results += SPAN_NOTICE("Moles: [round(total_moles,0.1)]")
			for(var/mix in mixture.gas)
				results += SPAN_NOTICE("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%")
			results += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C)]&deg;C")
		else
			results += SPAN_NOTICE("Pressure: [round(pressure,0.1)] kPa")
			results += SPAN_NOTICE("Moles: [round(total_moles,0.1)]")
			var/has_fuel = FALSE
			var/has_oxidizer = FALSE
			for(var/mix in mixture.gas)
				var/fraction = mixture.gas[mix] / total_moles
				var/pct = round(fraction * 100, 0.1)
				var/partial_kpa = round(fraction * pressure, 0.1)
				var/hazard_tags = get_gas_hazard_tags(mix)
				if(gas_data.flags[mix] & XGM_GAS_FUEL)
					has_fuel = TRUE
				if(gas_data.flags[mix] & XGM_GAS_OXIDIZER)
					has_oxidizer = TRUE
				if(skill >= SKILL_LEVEL_PROFESSIONAL)
					results += SPAN_NOTICE("[gas_data.name[mix]]: [pct]% ([partial_kpa] kPa | [round(mixture.gas[mix], 0.1)] mol)[hazard_tags]")
				else
					results += SPAN_NOTICE("[gas_data.name[mix]]: [pct]% ([partial_kpa] kPa)[hazard_tags]")
			results += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C, 0.1)]&deg;C ([round(mixture.temperature, 0.1)] K)")
			if(skill >= SKILL_LEVEL_PROFESSIONAL)
				results += SPAN_NOTICE("Heat Capacity: [round(mixture.heat_capacity(), 0.1)] J/K")
				if(has_fuel && has_oxidizer)
					var/cmb = 0
					CHECK_COMBUSTIBLE(cmb, mixture)
					var/ignition_temp = (mixture.gas[GAS_PHORON] > 0) ? PHORON_MINIMUM_BURN_TEMPERATURE : HYDROGEN_MINIMUM_BURN_TEMPERATURE
					if(cmb)
						if(mixture.temperature >= ignition_temp)
							results += SPAN_DANGER("Combustion Status: FLAMMABLE MIXTURE — ABOVE AUTO-IGNITION TEMPERATURE ([round(ignition_temp - T0C)]&deg;C)!")
						else
							results += SPAN_WARNING("Combustion Status: Flammable fuel/oxidizer ratio (auto-ignites at [round(ignition_temp - T0C)]&deg;C / [round(ignition_temp)] K).")
					else
						results += SPAN_NOTICE("Combustion Status: Fuel and oxidizer present, but molar concentration is below sustained combustion threshold.")
	else
		results += SPAN_NOTICE("\The [target] is empty!")

	return results

/atom/proc/atmosanalyze(var/mob/user)
	return

/obj/item/tank/atmosanalyze(var/mob/user)
	src.manipulated_by = user
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/structure/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/structure/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)
