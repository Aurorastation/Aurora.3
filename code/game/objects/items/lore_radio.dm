#define WEATHER_RADIO_CHANNEL "Shortband Weather Broadcast"

/obj/item/lore_radio
	name = "analog radio"
	desc = "A portable radio capable of receiving radio waves from nearby space systems."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	w_class = WEIGHT_CLASS_SMALL

	var/receiving = FALSE
	var/current_station = null
	var/starts_on = FALSE //so you can map it and have it broadcast without anyone turning it on

/obj/item/lore_radio/Initialize()
	. = ..()
	if(!current_station)
		var/list/possible_stations = get_possible_stations()
		current_station = pick(possible_stations)
	if(starts_on)
		toggle_receiving()
	RegisterSignal(SSdcs, COMSIG_GLOB_LORE_RADIO_BROADCAST, PROC_REF(relay_lore_radio))

/obj/item/lore_radio/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	to_chat(user, SPAN_NOTICE("\The [src] is turned [receiving ? "on" : "off"]."))
	if(current_station)
		to_chat(user, SPAN_NOTICE("\The [src] is listening to \the [current_station] radio station."))

/obj/item/lore_radio/attack_self(var/mob/user)
	var/list/possible_stations = get_possible_stations()
	var/picked_station = tgui_input_list(user, "Select the radio frequency:", "Radio Station Selection", possible_stations, current_station)
	if(picked_station)
		current_station = picked_station
		if(!receiving)
			toggle_receiving(user)

/obj/item/lore_radio/AltClick(var/mob/user)
	toggle_receiving(user)

/obj/item/lore_radio/proc/get_possible_stations()
	var/list/possible_stations = list(WEATHER_RADIO_CHANNEL)
	if(SSatlas.current_sector?.lore_radio_stations)
		possible_stations += SSatlas.current_sector.lore_radio_stations
	return possible_stations

/obj/item/lore_radio/proc/toggle_receiving(var/mob/user)
	if(!receiving)
		receiving = TRUE
		if(user)
			user.visible_message("<b>[user]</b> flicks \the [src] on.", SPAN_NOTICE("You flick \the [src] on."), range = 3)
		RegisterSignal(SSdcs, COMSIG_GLOB_Z_WEATHER_BROADCAST, PROC_REF(relay_weather_broadcast))
	else
		receiving = FALSE
		if(user)
			user.visible_message("<b>[user]</b> flicks \the [src] off.", SPAN_NOTICE("You flick \the [src] off."), range = 3)
		UnregisterSignal(SSdcs, COMSIG_GLOB_Z_WEATHER_BROADCAST, PROC_REF(relay_weather_broadcast))

/obj/item/lore_radio/proc/relay_lore_radio(var/datum/source, var/radio_station, var/radio_message)
	SIGNAL_HANDLER

	if(!receiving || radio_station != current_station)
		return

	if(radio_message)
		output_spoken_message(radio_message)
	else
		audible_message("The [SPAN_BOLD("[name]")] only emits white noise...") // using name instead of src so it doesn't add a bolded The or whatever, better control of what displays

/// Listens to when a weather change on this Z-level is broadcasted from a configured weather reader (survey probe), and reads it aloud
/obj/item/lore_radio/proc/relay_weather_broadcast(var/datum/source, var/z_level, var/singleton/state_transition/weather/weather_transition, var/time_to_transition, var/broadcast_message)
	SIGNAL_HANDLER

	if(!receiving || current_station != WEATHER_RADIO_CHANNEL)
		return

	var/turf/current_turf = get_turf(src)
	var/list/connected_z_levels = GetConnectedZlevels(current_turf.z)
	if(!(z_level in connected_z_levels))
		return

	output_spoken_message(broadcast_message)

#undef WEATHER_RADIO_CHANNEL
