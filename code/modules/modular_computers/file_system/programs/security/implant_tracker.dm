/datum/computer_file/program/implant_tracker
	filename = "implnttrckr"
	filedesc = "Remote Implant Tracking"
	program_icon_state = "security"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program allows authorized security personnel to track and remotely interface with active implants."
	required_access_run = access_armory
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	size = 6
	usage_flags = PROGRAM_CONSOLE
	color = LIGHT_COLOR_ORANGE

/datum/computer_file/program/implant_tracker/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-security-implanttracker", 650, 500, "Remote Implant Tracking")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/implant_tracker/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "mcomputer-security-implanttracker", 650, 500, "Remote Implant Tracking")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/datum/computer_file/program/implant_tracker/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/list/chem_implants = list()
	for(var/obj/item/implant/chem/C in implants)
		if(!C.implanted)
			continue
		var/turf/Tr = get_turf(C)
		if(!Tr || !isStationLevel(Tr.z))
			continue
		var/list/chem_info = list(
			"implanted_name" = C.imp_in.real_name,
			"remaining_units" = round(C.reagents.total_volume, 0.1),
			"ref" = "\ref[C]"
			)
		chem_implants[++chem_implants.len] = chem_info
	data["chem_implants"] = chem_implants
	var/list/tracking_implants = list()
	for(var/obj/item/implant/tracking/T in implants)
		if(!T.implanted)
			continue
		var/turf/Tr = get_turf(T)
		if(!Tr || !isStationLevel(Tr.z))
			continue
		var/loc_display = "Unknown"
		var/mob/living/carbon/M = T.imp_in
		if(isStationLevel(M.z) && !istype(M.loc, /turf/space))
			var/area/A = get_area(M)
			loc_display = A.name
		if(T.malfunction)
			var/area/location = pick(the_station_areas)
			loc_display = location.name
		var/list/tracker_info = list(
			"id" = T.id,
			"loc_display" = loc_display,
			"ref" = "\ref[T]"
			)
		tracking_implants[++tracking_implants.len] = tracker_info
	data["tracking_implants"] = tracking_implants

	return data // This UI needs to constantly update


/datum/computer_file/program/implant_tracker/Topic(href, href_list)
	. = ..()
	if(.)
		return TRUE

	if(href_list["inject1"])
		var/obj/item/implant/I = locate(href_list["inject1"]) in implants
		if(I)
			if(I.reagents.total_volume < 1)
				to_chat(usr, SPAN_WARNING("\The [I] does not have enough of a payload to do this!"))
				return
			I.activate(1)

	else if(href_list["inject5"])
		var/obj/item/implant/I = locate(href_list["inject5"]) in implants
		if(I)
			if(I.reagents.total_volume < 5)
				to_chat(usr, SPAN_WARNING("\The [I] does not have enough of a payload to do this!"))
				return
			I.activate(5)

	else if(href_list["inject10"])
		var/obj/item/implant/I = locate(href_list["inject10"]) in implants
		if(I)
			if(I.reagents.total_volume < 10)
				to_chat(usr, SPAN_WARNING("\The [I] does not have enough of a payload to do this!"))
				return
			I.activate(10)

	else if(href_list["warn"])
		var/warning = sanitize(input(usr, "Message:", "Enter your message here!") as text|null)
		if(!warning)
			return

		warning = formalize_text(warning)

		var/obj/item/implant/I = locate(href_list["warn"]) in implants
		if(istype(I) && I.imp_in)
			var/mob/living/carbon/R = I.imp_in
			to_chat(R, SPAN_NOTICE("You hear a voice in your head saying: '[warning]'."))
			message_admins("[key_name_admin(usr)] messaged [key_name_admin(I.imp_in)]: '[warning]' via \the [computer]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	SSvueui.check_uis_for_change(src)
