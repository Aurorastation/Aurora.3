/obj/item/device/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	desc_info = "Use this item in-hand to select the active warrant. Click on the person you want to show it to to display the warrant."
	icon = 'icons/obj/holowarrant.dmi'
	icon_state = "holowarrant"
	item_state = "holowarrant"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTABLE

	var/datum/record/warrant/selected_warrant

/obj/item/device/holowarrant/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSrecords, COMSIG_RECORD_CREATED, PROC_REF(handle_warrant_created))

/obj/item/device/holowarrant/Destroy()
	unload_warrant()
	return ..()

/obj/item/device/holowarrant/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(selected_warrant)
		to_chat(user, "It's a holographic warrant for '[selected_warrant.name]'.")

/obj/item/device/holowarrant/attack_self(mob/living/user as mob)
	if(!LAZYLEN(SSrecords.warrants))
		to_chat(user, SPAN_NOTICE("There are no warrants available at this time."))
		return

	var/list/warrant_list = list()
	for(var/datum/record/warrant/warrant in SSrecords.warrants)
		warrant_list["[warrant.id] - [warrant.name] - [capitalize_first_letters(warrant.wtype)]"] = warrant

	if(selected_warrant)
		warrant_list += "Unload Warrant"

	var/chosen_warrant = tgui_input_list(usr, "Which warrant do you want to load?", "Warrant Projector", warrant_list)
	if(!chosen_warrant)
		return
	else if(chosen_warrant == "Unload Warrant")
		unload_warrant()
	else
		load_warrant(warrant_list[chosen_warrant])

	play_message(SPAN_NOTICE("\The [src] pings, \"Warrant [selected_warrant ? "" : "un"]loaded.\""))

/obj/item/device/holowarrant/proc/load_warrant(var/datum/record/warrant/warrant)
	selected_warrant = warrant
	RegisterSignal(selected_warrant, COMSIG_QDELETING, PROC_REF(handle_warrant_delete))
	RegisterSignal(selected_warrant, COMSIG_RECORD_MODIFIED, PROC_REF(handle_warrant_modify))
	update_icon()

/obj/item/device/holowarrant/proc/unload_warrant()
	if(selected_warrant)
		UnregisterSignal(selected_warrant, COMSIG_QDELETING)
		UnregisterSignal(selected_warrant, COMSIG_RECORD_MODIFIED)
		selected_warrant = null
		update_icon()

/obj/item/device/holowarrant/proc/play_message(var/message)
	playsound(get_turf(src), 'sound/machines/ping.ogg', 40)
	audible_message(message)

/// Called when a warrant is created
/obj/item/device/holowarrant/proc/handle_warrant_created(datum/source, datum/record/record)
	SIGNAL_HANDLER

	if(istype(record, /datum/record/warrant))
		play_message(SPAN_NOTICE("\The [src] pings, \"New warrant on database.\""))

/// Called right before the warrant is deleted
/obj/item/device/holowarrant/proc/handle_warrant_delete(datum/source)
	SIGNAL_HANDLER

	unload_warrant()

	play_message(SPAN_NOTICE("\The [src] pings, \"Active warrant deleted.\""))

/// Called right after the warrant is modified
/obj/item/device/holowarrant/proc/handle_warrant_modify(datum/source)
	SIGNAL_HANDLER

	play_message(SPAN_NOTICE("\The [src] pings, \"Active warrant modified.\""))

/obj/item/device/holowarrant/attack(mob/living/victim, mob/living/user)
	if(!selected_warrant)
		to_chat(user, SPAN_WARNING("There are no warrants loaded!"))
		return

	user.visible_message("<b>[user]</b> holds \the [src] up to \the [victim].", SPAN_NOTICE("You hold up \the [src] to \the [victim]."))
	show_content(victim)

/obj/item/device/holowarrant/update_icon()
	if(selected_warrant)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/device/holowarrant/proc/show_content(mob/user)
	if(selected_warrant.wtype == "arrest")
		var/output = {"
		<HTML><HEAD><TITLE>Arrest Warrant: [selected_warrant.name]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'>
		<font face="Verdana" color=black><font size = "1">
		<center><large><b>Stellar Corporate Conglomerate
		<br>Civilian Branch of Operation</b></large>
		<br>
		<br><b>DIGITAL ARREST WARRANT</b></center>
		<hr>
		<b>Facility:</b>__<u>[current_map.station_name]</u>__<b>Date:</b>__<u>[worlddate2text()]__</u>
		<br>
		<br><small><i>This document serves as a notice and permits the sanctioned arrest of
		the denoted employee of the SCC Civilian Branch of Operation by the
		Security Department of the denoted vessel. </br>
		In accordance with Corporate Regulations, the denoted employee must be presented with a signed and stamped or
		digitally authorized warrant before the actions entailed can be conducted legally. </br>
		The Suspect/Department staff are expected to offer full co-operation.</br>
		In the event of the Suspect attempting to resist or flee, resisting arrest charges need to be applied !</br>
		In the event of staff attempting to interfere with a lawful arrest, they are to be detained as an accomplice !</br>
		In the event of no warrant being displayed <b>prior</b> to the arrest, security personnel performing the arrest are subject to illegal detention charges !
		</i></small>
		<br>
		<br><b>Suspect's name: </b>
		<br>[selected_warrant.name]
		<br>
		<br><b>Reason(s): </b>
		<br>[selected_warrant.notes]
		<br>
		<br>__<u>[selected_warrant.authorization]</u>__
		<br><small>Person authorizing arrest</small></br>
		</font></font>
		</BODY></HTML>
		"}

		show_browser(user, output, "window=Warrant for the arrest of [selected_warrant.name]")
	if(selected_warrant.wtype == "search")
		var/output= {"
		<HTML><HEAD><TITLE>Search Warrant: [selected_warrant.name]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'>
		<font face="Verdana" color=black><font size = "1">
		<center><large><b>Stellar Corporate Conglomerate
		<br>Civilian Branch of Operation</b></large>
		<br>
		<br><b>DIGITAL SEARCH WARRANT</b></center>
		<hr>
		<b>Facility:</b>__<u>[current_map.station_name]</u>__<b>Date:</b>__<u>[worlddate2text()]__</u></br>
		<br>
		<small><i>This document serves as notice and permits the sanctioned search of
		the Suspect's person/belongings/premises and/or Department for any items and materials
		that could be connected to the suspected regulation violation described below,
		pending an investigation in progress. </br>
		The Security Officer(s) are obligated to remove any and all such items from the Suspect's posession
		and/or Department and file it as evidence. </br>
		In accordance with Corporate Regulations, the denoted employee must be presented with a signed and stamped or
		digitally authorized warrant before the actions entailed can be conducted legally. </br>
		The Suspect/Department staff are expected to offer full co-operation.</br>
		In the event of the Suspect/Department staff attempting	to resist/impede this search or flee, they must be taken into custody immediately! </br>
		All confiscated items must be filed and taken to Evidence!</small></i></br>
		<br><b>Suspect's/location name: </b>
		<br>[selected_warrant.name]
		<br>
		<br><b>For the following reasons: </b>
		<br>[selected_warrant.notes]
		<br>
		<br>__<u>[selected_warrant.authorization]</u>__
		<br><small>Person authorizing search</small></br>
		</font></font>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for [selected_warrant.name]")
