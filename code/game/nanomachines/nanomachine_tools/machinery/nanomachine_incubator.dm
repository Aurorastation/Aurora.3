/obj/machinery/nanomachine_incubator
	name = "nanomachine incubator"
	desc = "An advanced machine capable of generating nanomachines with various programs loaded into them."
	desc_fluff = "Created in coordination with all the SCC companies, this machine combines the strengths of all of them to create a man-to-machine interface."
	icon = 'icons/obj/machines/nanomachines.dmi'
	icon_state = "incubator"

	density = TRUE
	anchored = TRUE

	var/nanomachine_reserve = 100
	var/max_nanomachine_reserve = 1000

	var/datum/nanomachine/loaded_nanomachines

	var/list/available_programs = list(
		/decl/nanomachine_effect/blood_regen,
		/decl/nanomachine_effect/muscle_clamp,
		/decl/nanomachine_effect/reproductive_nullifier,
		/decl/nanomachine_effect/metabolic_hijack
		)

/obj/machinery/nanomachine_incubator/Initialize(mapload, d, populate_components)
	. = ..()
	var/obj/machinery/nanomachine_chamber/NC = locate() in range(1, src)
	if(NC)
		NC.connected_incubator = src

/obj/machinery/nanomachine_incubator/Destroy()
	var/obj/machinery/nanomachine_chamber/NC = locate() in range(1, src)
	if(NC?.connected_incubator == src)
		NC.connected_incubator = null
	return ..()

/obj/machinery/nanomachine_incubator/update_icon(var/power_state)
	if(!power_state)
		power_state = !(stat & (BROKEN|NOPOWER|EMPED))
	icon_state = "[initial(icon_state)][power_state ? "" : "_off"]"

/obj/machinery/nanomachine_incubator/machinery_process()
	if(stat & (BROKEN|NOPOWER|EMPED))
		update_icon(FALSE)
		return
	update_icon(TRUE)

/obj/machinery/nanomachine_incubator/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/nanomachine_capsule))
		var/obj/item/nanomachine_capsule/NC = W
		if(nanomachine_reserve + NC.nanomachine_payload > max_nanomachine_reserve)
			to_chat(user, SPAN_WARNING("\The [src] cannot hold this many nanomachines!"))
			return
		to_chat(user, SPAN_NOTICE("You feed \the [NC] into \the [src]."))
		nanomachine_reserve += NC.nanomachine_payload
		SSvueui.check_uis_for_change(src)
		user.drop_from_inventory(NC)
		qdel(NC)
		return
	else if(istype(W, /obj/item/nanomachine_disk))
		var/obj/item/nanomachine_disk/ND = W
		if(!ND.loaded_program)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a program loaded!"))
			return
		if(ND.loaded_program in available_programs)
			to_chat(user, SPAN_WARNING("\The [src] already has the program loaded on this disk installed!"))
			return
		to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src]."))
		available_programs += ND.loaded_program
		SSvueui.check_uis_for_change(src)
		user.drop_from_inventory(ND)
		qdel(ND)
		return
	return ..()

/obj/machinery/nanomachine_incubator/attack_hand(var/mob/user)
	if(..())
		return TRUE

	ui_interact(user)

/obj/machinery/nanomachine_incubator/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "medical-nanomachineincubator", 700, 500, capitalize_first_letters(name))
	ui.open()

/obj/machinery/nanomachine_incubator/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		data = list()
	data["max_nanomachine_reserve"] = max_nanomachine_reserve
	data["nanomachine_reserve"] = nanomachine_reserve

	data["loaded_nanomachines"] = !!loaded_nanomachines
	data["available_programs"] = null
	data["loaded_programs"] = null
	data["space_remaining"] = null
	data["max_space"] = null
	data["regen_rate"] = null
	data["max_regen_rate"] = null
	if(loaded_nanomachines)
		data["loaded_programs"] = loaded_nanomachines.get_loaded_programs()
		data["available_programs"] = get_available_programs()
		data["space_remaining"] = loaded_nanomachines.max_programs - loaded_nanomachines.check_program_capacity_usage()
		data["max_space"] = loaded_nanomachines.max_programs
		data["regen_rate"] = loaded_nanomachines.regen_rate - loaded_nanomachines.check_program_deterioration_rate()
		data["max_regen_rate"] = loaded_nanomachines.regen_rate

	return data

/obj/machinery/nanomachine_incubator/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["print"])
		var/obj/item/nanomachine_capsule/NC = new /obj/item/nanomachine_capsule(loc)
		nanomachine_reserve -= NC.nanomachine_payload

	if(href_list["create"])
		loaded_nanomachines = new /datum/nanomachine(src)
		nanomachine_reserve -= loaded_nanomachines.machine_volume

	if(href_list["program"])
		var/decl_path
		for(var/decl in available_programs)
			var/decl/nanomachine_effect/NE = decls_repository.get_decl(decl)
			if(href_list["program"] == NE.name)
				decl_path = decl
				break
		if(!decl_path)
			log_debug("NANOMACHINES: Nanomachine Incubator failed to get Nanomachine program called: [href_list["program"]]")
			return
		if(decl_path in loaded_nanomachines.loaded_programs)
			loaded_nanomachines.remove_program(decl_path)
		else
			loaded_nanomachines.add_program(decl_path)

	if(href_list["flush"])
		nanomachine_reserve += loaded_nanomachines.machine_volume
		QDEL_NULL(loaded_nanomachines)

	SSvueui.check_uis_for_change(src)

/obj/machinery/nanomachine_incubator/proc/get_available_programs()
	var/list/ui_programs = list()
	for(var/decl in available_programs)
		var/decl/nanomachine_effect/NE = decls_repository.get_decl(decl)
		ui_programs[NE.name] = NE.desc
	return ui_programs

/obj/machinery/nanomachine_incubator/proc/infuse_occupant(var/mob/living/carbon/human/H)
	if(!ishuman(H))
		log_debug("NANOMACHINES: Somehow, someone managed to try and infuse nanomachines into a non-human: [H.name] [H.type]")
		return

	if(inoperable(MAINT))
		return

	H.add_nanomachines(loaded_nanomachines)
	loaded_nanomachines = null

	SSvueui.check_uis_for_change(src)