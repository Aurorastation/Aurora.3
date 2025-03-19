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
	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles

	var/list/results = list()
	if (total_moles>0)
		results += SPAN_NOTICE("Pressure: [round(pressure,0.1)] kPa")
		results += SPAN_NOTICE("Moles: [round(total_moles,0.1)]")
		for(var/mix in mixture.gas)
			results += SPAN_NOTICE("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%")
		results += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C)]&deg;C")
	else
		results += SPAN_NOTICE("\The [target] is empty!")

	return results

/atom/proc/atmosanalyze(var/mob/user)
	return

/obj/item/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/item/flamethrower/atmosanalyze(var/mob/user)
	if(gas_tank)	return atmosanalyzer_scan(src, gas_tank.air_contents, user)
