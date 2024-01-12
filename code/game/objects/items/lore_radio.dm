/obj/item/lore_radio
	name = "analog radio"
	desc = "A portable radio capable of receiving radio waves from nearby space systems."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	w_class = ITEMSIZE_SMALL

	var/receiving = FALSE
	var/current_station = null
	var/broadcast = FALSE
	var/list/broadcasts_in_line = list()
	var/starts_on = FALSE //so you can map it and have it broadcast without anyone turning it on

/obj/item/lore_radio/Initialize()
	. = ..()
	if(starts_on)
		toggle_receiving()

/obj/item/lore_radio/examine(var/mob/user)
	. = ..()
	if(receiving && current_station)
		to_chat(user, "\The [src] is broadcasing \the [current_station] radio station.")

/obj/item/lore_radio/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/lore_radio/attack_self(var/mob/user)
	if(!receiving)
		toggle_receiving(user)

	if(SSatlas.current_sector.lore_radio_stations)
		var/picked_station = tgui_input_list(user, "Select the radio frequency.", "Radion station selection", SSatlas.current_sector.lore_radio_stations)
		if(picked_station)
			turn_off_broadcast()
			current_station = picked_station
	else
		visible_message("<b>\The [src]</b> only emits white noise...")

/obj/item/lore_radio/proc/toggle_receiving(var/mob/M)
	if(!receiving)
		receiving = TRUE
		START_PROCESSING(SSprocessing, src)
		if(M)
			to_chat(M, "You turn on \the [src]")
	else
		receiving = FALSE
		broadcast = FALSE
		STOP_PROCESSING(SSprocessing, src)
		if(M)
			to_chat(M, "You turn off \the [src]")

/obj/item/lore_radio/process()
	if(prob(25))
		if(SSatlas.current_sector.lore_radio_stations)
			SSatlas.current_sector.lore_radio_message(src, current_station)

/obj/item/lore_radio/proc/relay_lore_radio(var/radio_message)
	if(!receiving)
		return

	if(radio_message)
		visible_message("<b>\The [src]</b> transmits: \"[radio_message]\"")
	else
		visible_message("<b>\The [src]</b> only emits white noise...")

/obj/item/lore_radio/proc/turn_off_broadcast()
	broadcast = FALSE
	for (var/T in broadcasts_in_line)
		deltimer(T)

/obj/item/lore_radio/AltClick(var/mob/user)
	toggle_receiving(user)