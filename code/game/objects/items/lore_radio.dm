/obj/item/lore_radio
	name = "analog radio"
	desc = "A portable radio capable of receiving radio waves from nearby space systems."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	w_class = ITEMSIZE_SMALL

	var/receiving = FALSE
	var/current_station = null
	var/starts_on = FALSE //so you can map it and have it broadcast without anyone turning it on

/obj/item/lore_radio/Initialize()
	. = ..()
	if(!current_station && SSatlas.current_sector?.lore_radio_stations)
		current_station = pick(SSatlas.current_sector.lore_radio_stations)
	if(starts_on)
		toggle_receiving()
	RegisterSignal(SSdcs, COMSIG_GLOB_LORE_RADIO_BROADCAST, PROC_REF(relay_lore_radio))

/obj/item/lore_radio/examine(var/mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("\The [src] is turned [receiving ? "on" : "off"]."))
	if(current_station)
		to_chat(user, SPAN_NOTICE("\The [src] is listening to \the [current_station] radio station."))

/obj/item/lore_radio/attack_self(var/mob/user)
	if(SSatlas.current_sector?.lore_radio_stations)
		var/picked_station = tgui_input_list(user, "Select the radio frequency:", "Radio Station Selection", SSatlas.current_sector.lore_radio_stations, current_station)
		if(picked_station)
			current_station = picked_station
			if(!receiving)
				toggle_receiving(user)
	else
		audible_message("<b>[src]</b> only emits white noise...")

/obj/item/lore_radio/AltClick(var/mob/user)
	toggle_receiving(user)

/obj/item/lore_radio/proc/toggle_receiving(var/mob/user)
	if(!receiving)
		receiving = TRUE
		if(user)
			user.visible_message("<b>[user]</b> flicks \the [src] on.", SPAN_NOTICE("You flick \the [src] on."), range = 3)
	else
		receiving = FALSE
		if(user)
			user.visible_message("<b>[user]</b> flicks \the [src] off.", SPAN_NOTICE("You flick \the [src] off."), range = 3)

/obj/item/lore_radio/proc/relay_lore_radio(var/datum/source, var/radio_station, var/radio_message)
	SIGNAL_HANDLER

	if(!receiving || radio_station != current_station)
		return

	var/displayed_message = radio_message ? "\The <b>[src.name]</b> transmits, \"[radio_message]\"" : "\The <b>[src]</b> only emits white noise..."
	audible_message(displayed_message)
	if(radio_message)
		var/list/hearers = get_hearers_in_view(7, src)
		var/list/clients_in_hearers = list()
		for(var/mob/mob in hearers)
			if(mob.client)
				clients_in_hearers += mob.client
		if(length(clients_in_hearers))
			INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, animate_chat), radio_message, null, FALSE, clients_in_hearers, 2 SECONDS)
