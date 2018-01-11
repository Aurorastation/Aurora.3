/obj/item/oxycandle
	name = "Oxygen Candle"
	desc = "Oxygen candles are flare-like steel tubes of sodium chlorate that produces oxygen through chemical process."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	w_class = ITEMSIZE_SMALL
	var/target_pressure = ONE_ATMOSPHERE
	var/chemicals = 600
	var/on = 0

	attack_self(mob/user)
		on = 1
		icon_state = "candle1_lit"
		START_PROCESSING(SSprocessing, src)
		update_icon()

/obj/item/oxycandle/process()
	if(!on)
		return
	else
		chemicals--
		if(!chemicals)
			new/obj/item/trash/candle(src.loc)
			if(istype(src.loc, /mob))
				src.dropped()

			STOP_PROCESSING(SSprocessing, src)
			qdel(src)
		var/datum/gas_mixture/environment = loc.return_air()
		var/pressure_delta = target_pressure - environment.return_pressure()
		var/output_volume = environment.volume * environment.group_multiplier
		var/transfer_moles = pressure_delta*output_volume/(environment.temperature * R_IDEAL_GAS_EQUATION)
		if (pressure_delta > 0.01)
			pump_gas(src, environment, transfer_moles)




