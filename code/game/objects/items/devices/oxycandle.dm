/obj/item/device/oxycandle
	name = "oxygen candle"
	desc = "A steel tube with the words 'OXYGEN - PULL CORD TO IGNITE' stamped on the side. A small label warns against using the device underwater"
	icon = 'icons/obj/device.dmi'
	icon_state = "oxycandle"
	item_state = "oxycandle"
	w_class = ITEMSIZE_SMALL // Should fit into internal's box or maybe pocket
	var/target_pressure = ONE_ATMOSPHERE
	var/datum/gas_mixture/air_contents = null
	var/volume = 5600 // One tile has 2500 volume of air, so two tiles plus a bit extra
	var/on = FALSE
	var/activation_sound = 'sound/items/flare.ogg'
	light_color = LIGHT_COLOR_FLARE
	uv_intensity = 50
	var/brightness_on = 2 // Moderate bright.
	light_power = 2
	action_button_name = null

/obj/item/device/oxycandle/attack_self(mob/user)
	if(!on)
		user << "<span class='notice'>You pull the cord and [src] ignites.</span>"
		light_range = brightness_on
		on = TRUE
		update_icon()
		playsound(src.loc, activation_sound, 75, 1)
		air_contents = new /datum/gas_mixture()
		air_contents.volume = 200 //liters
		air_contents.temperature = T20C
		var/list/air_mix = list("oxygen" = O2STANDARD * (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature),
		 						"nitrogen" = N2STANDARD *  (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
		air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])
		START_PROCESSING(SSprocessing, src)

// Process of Oxygen candles releasing air. Makes 200 volume of oxygen and nitrogen mix
/obj/item/device/oxycandle/process()
	if(!loc)
		return
	var/turf/pos = get_turf(src)
	if(volume <= 0 || istype(pos, /turf/simulated/floor/beach/water) || istype(pos, /turf/unsimulated/beach/water))
		STOP_PROCESSING(SSprocessing, src)
		icon_state = "oxycandle_burnt"
		item_state = icon_state
		set_light(0)
		update_held_icon()
		name = "burnt oxygen candle"
		desc += "This tube has exhausted its chemicals."
		return
	if(pos)
		pos.hotspot_expose(1500, 5)
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
	var/list/air_mix = list("oxygen" = O2STANDARD * (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature),
	 						"nitrogen" = N2STANDARD *  (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])

/obj/item/device/oxycandle/update_icon()
	if(on)
		icon_state = "oxycandle_on"
		item_state = icon_state
		set_light(brightness_on)
	else
		icon_state = "oxycandle"
		item_state = icon_state
		set_light(0)
	update_held_icon()

/obj/item/device/oxycandle/Destroy()
	QDEL_NULL(air_contents)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()