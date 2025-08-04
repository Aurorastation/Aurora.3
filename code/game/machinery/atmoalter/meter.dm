/obj/machinery/meter
	name = "meter"
	desc = "Measures the volume and temperature of the pipe under the meter."
	icon = 'icons/obj/meter.dmi'
	icon_state = "meter_base"
	var/obj/machinery/atmospherics/pipe/target = null
	anchored = 1.0
	power_channel = AREA_USAGE_ENVIRON
	var/frequency = 0
	var/id
	idle_power_usage = 15

	var/image/button_overlay
	var/image/atmos_overlay

	var/mutable_appearance/button_emissive
	var/mutable_appearance/atmos_emissive

/obj/machinery/meter/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance > 3 && !isAI(user))
		. += SPAN_WARNING("You are too far away to read it.")

	else if(stat & (NOPOWER|BROKEN))
		. += SPAN_WARNING("The display is off.")

	else if(src.target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			. += "The pressure gauge reads [round(environment.return_pressure(), 0.01)] kPa; [round(environment.temperature,0.01)]K ([round(environment.temperature-T0C,0.01)]&deg;C)"
		else
			. += SPAN_WARNING("The sensor error light is blinking.")
	else
		. += SPAN_WARNING("The connect error light is blinking.")

/obj/machinery/meter/Initialize()
	. = ..()
	if (!target)
		src.target = locate(/obj/machinery/atmospherics/pipe) in loc

/obj/machinery/meter/process()
	ClearOverlays()
	if(!target)
		AddOverlays("pressure_off")
		AddOverlays("buttons-x")
		return FALSE

	if(stat & (BROKEN|NOPOWER))
		AddOverlays("pressure_off")
		return FALSE

	var/datum/gas_mixture/environment = target.return_air()
	if(!environment)
		AddOverlays("buttons_x")
		AddOverlays("pressure0")
		return FALSE

	var/button_overlay_name
	var/atmos_overlay_name
	var/env_pressure = environment.return_pressure()
	if(env_pressure <= 0.15*ONE_ATMOSPHERE)
		button_overlay_name = "buttons_0"
		atmos_overlay_name = "pressure0"
	else if(env_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		button_overlay_name = "buttons_1"
		atmos_overlay_name = "pressure1_[val]"
	else if(env_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		button_overlay_name = "buttons_2"
		atmos_overlay_name = "pressure2_[val]"
	else if(env_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		button_overlay_name = "buttons_3"
		atmos_overlay_name = "pressure3_[val]"
	else
		atmos_overlay_name = "pressure4"

	button_overlay = overlay_image(icon, button_overlay_name)
	atmos_overlay = overlay_image(icon, atmos_overlay_name)
	button_emissive = emissive_appearance(icon, button_overlay_name)
	atmos_emissive = emissive_appearance(icon, atmos_overlay_name)

	var/env_temperature = environment.temperature

	var/temp_color

	if(env_pressure == 0 || env_temperature == 0)
		temp_color = COLOR_GRAY

	else
		switch(env_temperature)
			if((BODYTEMP_HEAT_DAMAGE_LIMIT + 360) to INFINITY)
				temp_color = COLOR_RED
			if((BODYTEMP_HEAT_DAMAGE_LIMIT + 120) to (BODYTEMP_HEAT_DAMAGE_LIMIT + 360))
				temp_color = COLOR_ORANGE
			if(BODYTEMP_HEAT_DAMAGE_LIMIT to (BODYTEMP_HEAT_DAMAGE_LIMIT + 120))
				temp_color = COLOR_YELLOW
			if(BODYTEMP_COLD_DAMAGE_LIMIT to BODYTEMP_HEAT_DAMAGE_LIMIT)
				temp_color = COLOR_LIME
			if((BODYTEMP_COLD_DAMAGE_LIMIT - 120) to BODYTEMP_COLD_DAMAGE_LIMIT)
				temp_color = COLOR_CYAN
			if((BODYTEMP_COLD_DAMAGE_LIMIT - 360) to (BODYTEMP_COLD_DAMAGE_LIMIT - 120))
				temp_color = COLOR_BLUE
			else
				temp_color = COLOR_VIOLET

	if(atmos_overlay.color != temp_color)
		atmos_overlay.color = temp_color

	AddOverlays(button_overlay)
	AddOverlays(atmos_overlay)
	AddOverlays(button_emissive)
	AddOverlays(atmos_emissive)

	if(frequency)
		var/datum/radio_frequency/radio_connection = SSradio.return_frequency(frequency)

		if(!radio_connection) return

		var/datum/signal/signal = new
		signal.source = src
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data = list(
			"tag" = id,
			"device" = "AM",
			"pressure" = round(env_pressure),
			"sigtype" = "status"
		)
		radio_connection.post_signal(src, signal)

/obj/machinery/meter/Click()
	if(istype(usr, /mob/living/silicon/ai)) // ghosts can call ..() for examine
		examinate(usr, src)
		return 1

	return ..()

/obj/machinery/meter/attackby(obj/item/attacking_item, mob/user)
	if (!attacking_item.iswrench())
		return ..()
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, 40, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear ratchet.")
		new /obj/item/pipe_meter(src.loc)
		qdel(src)

// TURF METER - REPORTS A TILE'S AIR CONTENTS

/obj/machinery/meter/turf/Initialize()
	. = ..()
	src.target = loc
	if (!target)
		src.target = loc

/obj/machinery/meter/turf/attackby(obj/item/attacking_item, mob/user)
	return
