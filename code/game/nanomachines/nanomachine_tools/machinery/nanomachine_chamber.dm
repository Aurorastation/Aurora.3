/obj/machinery/nanomachine_chamber
	name = "nanomachine chamber"
	desc = "The apparatus bringing the man to the machine. This piece of machinery can infuse nanomachines into a body, as well as scan them to see what's running on them."
	desc_fluff = "Created in coordination with all the SCC companies, this machine combines the strengths of all of them to create a machine-to-man interface."
	icon = 'icons/obj/machines/nanomachines.dmi'
	icon_state = "chamber"

	density = TRUE
	anchored = TRUE

	idle_power_usage = 60
	active_power_usage = 10000

	var/mob/living/carbon/human/occupant
	var/obj/machinery/nanomachine_incubator/connected_incubator

	var/infusing = FALSE
	var/locked = FALSE

/obj/machinery/nanomachine_chamber/Initialize(mapload, d, populate_components)
	. = ..()
	connected_incubator = locate() in range(1, src)
	update_icon()

/obj/machinery/nanomachine_chamber/Destroy()
	connected_incubator = null
	return ..()

/obj/machinery/nanomachine_chamber/update_icon(var/power_state)
	if(!power_state)
		power_state = !(stat & (BROKEN|NOPOWER|EMPED))
	icon_state = "[initial(icon_state)][occupant ? "_o" : ""][power_state ? "" : "_u"]"

/obj/machinery/nanomachine_chamber/machinery_process()
	if(stat & (BROKEN|NOPOWER|EMPED))
		update_icon(FALSE)
		return
	update_icon(TRUE)

/obj/machinery/nanomachine_chamber/relaymove(mob/user, direction)
	if(use_check(user))
		return
	if(user != occupant)
		return
	user.dir = direction
	go_out()

/obj/machinery/nanomachine_chamber/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Nanomachine Chamber"

	if(use_check_and_message(usr))
		return
	if(locked)
		to_chat(usr, SPAN_WARNING("\The [src] is locked."))
		return
	go_out()
	add_fingerprint(usr)

/obj/machinery/nanomachine_chamber/proc/go_out()
	if(!occupant || locked)
		return

	playsound(loc, 'sound/machines/compbeep2.ogg', 50)
	playsound(loc, 'sound/machines/windowdoor.ogg', 50)

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	SSvueui.check_uis_for_change(src)
	update_use_power(1)
	update_icon()

/obj/machinery/nanomachine_chamber/attackby(obj/item/grab/G, mob/user)
	if(istype(G, /obj/item/grab))
		if(occupant)
			to_chat(user, SPAN_WARNING("The chamber is already occupied!"))
			return
		if(!ishuman(G.affecting))
			to_chat(user, SPAN_WARNING("\The [src] can only hold humanoids!"))
			return

		var/mob/living/M = G.affecting
		user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [M] into \the [src]."), SPAN_NOTICE("You start putting \the [M] into \the [src]."), range = 3)

		if(do_mob(user, G.affecting, 3 SECONDS))
			var/bucklestatus = M.bucklecheck(user)
			if(!bucklestatus)//incase the patient got buckled_to during the delay
				return
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

			M.forceMove(src)
			occupant = M
			SSvueui.check_uis_for_change(src)
			update_use_power(2)
			update_icon()
		add_fingerprint(user)
		qdel(G)
		return
	return ..()

/obj/machinery/nanomachine_chamber/MouseDrop_T(var/mob/living/carbon/human/H, mob/living/user)
	if(!istype(user))
		return
	if(occupant)
		to_chat(user, SPAN_WARNING("The chamber is already occupied!"))
		return
	if(!ishuman(H))
		to_chat(user, SPAN_WARNING("\The [src] can only hold humanoids!"))
		return

	if(H == user)
		user.visible_message(SPAN_NOTICE("\The [user] starts climbing into \the [src]."), SPAN_NOTICE("You start climbing into \the [src]."), range = 3)
	else
		user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [H] into \the [src]."), SPAN_NOTICE("You start putting \the [H] into \the [src]."), range = 3)
	if(do_mob(user, H, 3 SECONDS))
		var/bucklestatus = H.bucklecheck(user)
		if(!bucklestatus)//incase the patient got buckled during the delay
			return
		if (H.client)
			H.client.perspective = EYE_PERSPECTIVE
			H.client.eye = src

		H.forceMove(src)
		occupant = H
		SSvueui.check_uis_for_change(src)
		update_use_power(2)
		update_icon()
	add_fingerprint(user)
	return

/obj/machinery/nanomachine_chamber/attack_hand(mob/user)
	if(..())
		return TRUE
	if(user == occupant) // we don't want nanomachine technicians to give themselves nanomachines
		to_chat(user, SPAN_WARNING("You can't reach the controls!"))
		return

	ui_interact(user)

/obj/machinery/nanomachine_chamber/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "medical-nanomachinechamber", 600, 500, capitalize_first_letters(name))
		ui.auto_update_content = TRUE
	ui.open()

/obj/machinery/nanomachine_chamber/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		data = list()

	data["occupant"] = !!occupant
	data["occupant_species"] = null
	data["occupant_nanomachines"] = null
	data["occupant_nanomachines_loaded_programs"] = null
	if(occupant)
		data["occupant_species"] = occupant.species.name
		data["occupant_nanomachines"] = !!occupant.nanomachines
		if(occupant.nanomachines)
			data["occupant_nanomachines_loaded_programs"] = occupant.nanomachines.get_loaded_programs()

	data["connected_incubator"] = !!connected_incubator
	data["connected_incubator_nanomachine_cluster"] = null
	data["connected_incubator_loaded_programs"] = null
	if(connected_incubator)
		data["connected_incubator_nanomachine_cluster"] = !!connected_incubator.loaded_nanomachines
		if(connected_incubator.loaded_nanomachines)
			data["connected_incubator_loaded_programs"] = connected_incubator.loaded_nanomachines.get_loaded_programs()

	data["infusing"] = infusing
	data["locked"] = locked

	return data

/obj/machinery/nanomachine_chamber/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["infuse"])
		infusing = TRUE
		locked = TRUE
		audible_message("[get_accent("tts")] <b>[capitalize_first_letters(src.name)]</b> beeps, \"Infusing occupant with nanomachine cluster now.\"")
		playsound(loc, 'sound/machines/juicer.ogg', 50, TRUE)
		addtimer(CALLBACK(src, .proc/do_infusement), 10 SECONDS)

	if(href_list["eject"])
		go_out()

	SSvueui.check_uis_for_change(src)

/obj/machinery/nanomachine_chamber/proc/do_infusement()
	infusing = FALSE
	locked = FALSE
	if(!connected_incubator)
		return
	connected_incubator.infuse_occupant(occupant)
	playsound(loc, 'sound/machines/microwave/microwave-end.ogg', 50, FALSE)
	SSvueui.check_uis_for_change(src)