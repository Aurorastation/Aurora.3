/obj/item/device/oxycandle
	name = "Oxygen Candle"
	desc = "Oxygen candles are flare-like steel tubes of sodium chlorate that produces oxygen through chemical process."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	w_class = ITEMSIZE_SMALL
	var/target_pressure = ONE_ATMOSPHERE
	var/datum/gas_mixture/air_contents = null
	var/volume = 5500 //One tile has 2500 volume of air, so two tiles plus a bit extra
	var/on = 0
	var/activation_sound = 'sound/items/flare.ogg'
	light_color = LIGHT_COLOR_FLARE
	light_wedge = LIGHT_OMNI
	uv_intensity = 50
	var/brightness_on = 2 // Moderate bright.
	light_power = 2
	action_button_name = null

/obj/item/device/oxycandle/attack_self(mob/user)
	if(!on)
		light_range = brightness_on
		on = 1
		update_icon()
		playsound(src.loc, activation_sound, 75, 1)
		air_contents = new /datum/gas_mixture()
		air_contents.volume = 200 //liters
		air_contents.temperature = T20C
		var/list/air_mix = StandardAirMix()
		air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])
		START_PROCESSING(SSprocessing, src)
	else
		var/turf/pos = get_turf(src)
		if(pos)
			pos.hotspot_expose(1500, 5)

/obj/item/device/oxycandle/proc/StandardAirMix()
	return list(
		"oxygen" = O2STANDARD * MolesForPressure(),
		"nitrogen" = N2STANDARD *  MolesForPressure())

/obj/item/device/oxycandle/proc/MolesForPressure()
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/item/device/oxycandle/process()
	if(on)
		if(volume <= 0)
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
		var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
		if (!removed) //Just in case
			return
		environment.merge(removed)
		volume -= 200
		var/list/air_mix = StandardAirMix()
		air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])

/obj/item/device/flashlight/update_icon()
	if(on)
		icon_state = "candle1_lit"
		set_light(brightness_on)
	else
		icon_state = "candle1"
		set_light(0)




