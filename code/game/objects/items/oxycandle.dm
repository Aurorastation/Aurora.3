/obj/item/oxycandle
	name = "Oxygen Candle"
	desc = "Oxygen candles are flare-like steel tubes of sodium chlorate that produces oxygen through chemical process."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	w_class = ITEMSIZE_SMALL
	var/target_pressure = ONE_ATMOSPHERE
	var/datum/gas_mixture/air_contents = null
	var/volume = 600
	var/on = 0

/obj/item/oxycandle/attack_self(mob/user)
	on = 1
	icon_state = "candle1_lit"
	update_icon()
	air_contents = new /datum/gas_mixture()
	air_contents.volume = volume //liters
	air_contents.temperature = T20C
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])
	START_PROCESSING(SSprocessing, src)

/obj/item/oxycandle/proc/StandardAirMix()
	return list(
		"oxygen" = O2STANDARD * MolesForPressure(),
		"nitrogen" = N2STANDARD *  MolesForPressure())

/obj/item/oxycandle/proc/MolesForPressure()
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/item/oxycandle/process()
	if(!on)
		return
	else
		if(!volume)
			new/obj/item/trash/candle(src.loc)
			if(istype(src.loc, /mob))
				src.dropped()

			STOP_PROCESSING(SSprocessing, src)
			qdel(src)
		var/datum/gas_mixture/environment = loc.return_air()
		var/pressure_delta = target_pressure - environment.return_pressure()
		var/output_volume = environment.volume * environment.group_multiplier
		var/air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature
		var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)
		if (pressure_delta > 0.01)
			pump_gas(src, air_contents, environment, transfer_moles, 0)




