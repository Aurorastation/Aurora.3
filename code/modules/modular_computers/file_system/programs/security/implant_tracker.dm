/datum/computer_file/program/implant_tracker
	filename = "implnttrckr"
	filedesc = "Remote Implant Tracking"
	program_icon_state = "security"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program allows authorized security personnel to track and remotely interface with active implants."
	required_access_run = ACCESS_ARMORY
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	size = 6
	usage_flags = PROGRAM_CONSOLE | PROGRAM_SILICON_AI
	color = LIGHT_COLOR_ORANGE
	tgui_id = "ImplantTracker"

/datum/computer_file/program/implant_tracker/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/list/chem_implants = list()
	for(var/obj/item/implant/chem/C in GLOB.implants)
		if(!C.implanted)
			continue
		var/turf/Tr = get_turf(C)
		if(!Tr || !is_station_level(Tr.z))
			continue
		var/list/chem_info = list(
			"implanted_name" = C.imp_in.real_name,
			"remaining_units" = round(C.reagents.total_volume, 0.1),
			"ref" = "[REF(C)]"
			)
		chem_implants += list(chem_info)
	data["chem_implants"] = chem_implants
	var/list/tracking_implants = list()
	for(var/obj/item/implant/tracking/T in GLOB.implants)
		if(!T.implanted)
			continue
		var/turf/Tr = get_turf(T)
		if(!Tr || !is_station_level(Tr.z))
			continue
		var/loc_display = "Unknown"
		var/mob/living/carbon/M = T.imp_in
		if(is_station_level(M.z) && !istype(M.loc, /turf/space))
			var/area/A = get_area(M)
			loc_display = A.name
		if(T.malfunction)
			var/area/location = pick(GLOB.the_station_areas)
			loc_display = location.name
		var/list/tracker_info = list(
			"id" = T.id,
			"loc_display" = loc_display,
			"ref" = "[REF(T)]"
			)
		tracking_implants += list(tracker_info)
	data["tracking_implants"] = tracking_implants

	return data

/datum/computer_file/program/implant_tracker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("inject1")
			var/obj/item/implant/I = locate(params["inject1"]) in GLOB.implants
			if(I)
				if(I.reagents.total_volume < 1)
					to_chat(usr, SPAN_WARNING("\The [I] does not have enough of a payload to do this!"))
					return
				I.activate(1)

		if("inject5")
			var/obj/item/implant/I = locate(params["inject5"]) in GLOB.implants
			if(I)
				if(I.reagents.total_volume < 5)
					to_chat(usr, SPAN_WARNING("\The [I] does not have enough of a payload to do this!"))
					return
				I.activate(5)

		if("inject10")
			var/obj/item/implant/I = locate(params["inject10"]) in GLOB.implants
			if(I)
				if(I.reagents.total_volume < 10)
					to_chat(usr, SPAN_WARNING("\The [I] does not have enough of a payload to do this!"))
					return
				I.activate(10)

		if("warn")
			var/warning = sanitize(input(usr, "Message:", "Enter your message here!") as text|null)
			if(!warning)
				return

			warning = formalize_text(warning)

			var/obj/item/implant/I = locate(params["warn"]) in GLOB.implants
			if(istype(I) && I.imp_in)
				var/mob/living/carbon/R = I.imp_in
				to_chat(R, SPAN_NOTICE("You hear a voice in your head saying: '[warning]'."))
				message_admins("[key_name_admin(usr)] messaged [key_name_admin(I.imp_in)]: '[warning]' via \the [computer]. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
