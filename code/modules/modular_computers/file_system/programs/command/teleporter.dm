/datum/computer_file/program/teleporter
	filename = "teleporter"
	filedesc = "Teleporter Control"
	extended_desc = "A NanoTrasen command remote teleportation hub controller."
	program_icon_state = "teleport"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	required_access_run = access_heads
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	var/datum/weakref/pad_ref

/datum/computer_file/program/teleporter/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-command-teleporter", 600, 400, "Teleporter Control System")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/teleporter/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "mcomputer-command-teleporter", 600, 400, "Teleporter Control System")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/datum/computer_file/program/teleporter/vueui_on_transfer(datum/vueui/ui)
	. = ..()
	ui.auto_update_content = FALSE

/datum/computer_file/program/teleporter/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/turf/T = get_turf(computer.loc)
	var/obj/machinery/teleport/pad/linked_pad
	if(pad_ref)
		linked_pad = pad_ref.resolve()
	if(QDELETED(linked_pad))
		pad_ref = null

	// block of root level data
	data["has_linked_pad"] = !!linked_pad
	LAZYINITLIST(data["nearby_pads"])
	LAZYINITLIST(data["teleport_beacons"])
	LAZYINITLIST(data["teleport_implants"])
	data["calibration"] = 0
	data["selected_target"] = null
	data["selected_target_name"] = "None"

	if(!linked_pad)
		var/list/near_pads_info = list()
		for(var/obj/machinery/teleport/pad/S in range(3, T))
			var/list/pad_info = list(
				"pad_name" = "[S.name] ([S.x]-[S.y][S.z])",
				"ref" = "\ref[S]"
				)
			near_pads_info[++near_pads_info.len] = pad_info
		data["nearby_pads"] = near_pads_info
	else
		var/atom/selected_atom = linked_pad.locked_obj ? linked_pad.locked_obj.resolve() : null
		if(selected_atom)
			data["selected_target"] = "\ref[selected_atom]"
			data["selected_target_name"] = linked_pad.locked_obj_name
		data["calibration"] = 100 - linked_pad.calibration
		var/list/area_index = list()

		var/list/teleport_beacon_info = list()
		for(var/obj/item/device/radio/beacon/R as anything in teleportbeacons)
			var/turf/BT = get_turf(R)
			if(!BT)
				continue
			if(!isAdminLevel(linked_pad.z) && isAdminLevel(BT.z))
				continue
			if(!linked_pad.within_range(BT))
				continue
			var/tmpname = BT.loc.name
			if(area_index[tmpname])
				tmpname = "[tmpname] ([++area_index[tmpname]])"
			else
				area_index[tmpname] = 1
			var/list/teleporter_info = list(
				"beacon_name" = tmpname,
				"ref" = "\ref[R]"
				)
			teleport_beacon_info[++teleport_beacon_info.len] = teleporter_info
		data["teleport_beacons"] = teleport_beacon_info

		var/list/teleport_implant_info = list()
		for(var/obj/item/implant/tracking/I in implants)
			if(!I.implanted || !ismob(I.loc))
				continue
			else
				var/mob/M = I.loc
				if(M.stat == DEAD)
					if(M.timeofdeath + 6000 < world.time)
						continue
				var/turf/IT = get_turf(M)
				if(!IT)
					continue
				if(!isAdminLevel(linked_pad.z) && isAdminLevel(IT.z))
					continue
				if(!linked_pad.within_range(IT))
					continue
				var/tmpname = M.real_name
				if(area_index[tmpname])
					tmpname = "[tmpname] ([++area_index[tmpname]])"
				else
					area_index[tmpname] = 1
				var/list/implant_info = list(
					"implant_name" = tmpname,
					"ref" = "\ref[I]"
				)
				teleport_implant_info[++teleport_implant_info.len] = implant_info
		data["teleport_implants"] = teleport_implant_info

	return data

/datum/computer_file/program/teleporter/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["pad"])
		var/obj/machinery/teleport/pad/linked_pad = locate(href_list["pad"]) in range(3, get_turf(computer.loc))
		pad_ref = WEAKREF(linked_pad)
	else if(href_list["recalibrate"])
		var/obj/machinery/teleport/pad/linked_pad = pad_ref.resolve()
		linked_pad.start_recalibration()
	else if(href_list["beacon"])
		var/obj/machinery/teleport/pad/linked_pad = pad_ref.resolve()
		var/obj/O = locate(href_list["beacon"]) in teleportbeacons
		if(linked_pad.locked_obj)
			var/obj/LO = linked_pad.locked_obj.resolve()
			if(LO == O)
				linked_pad.disengage()
				return
		linked_pad.locked_obj = WEAKREF(O)
		linked_pad.locked_obj_name = href_list["name"]
		if(!linked_pad.engaged)
			linked_pad.engage()
			linked_pad.visible_message(SPAN_NOTICE("Locked in."), range = 2)
	else if(href_list["implant"])
		var/obj/machinery/teleport/pad/linked_pad = pad_ref.resolve()
		var/obj/O = locate(href_list["implant"]) in implants
		if(linked_pad.locked_obj)
			var/obj/LO = linked_pad.locked_obj.resolve()
			if(LO == O)
				linked_pad.disengage()
				return
		linked_pad.locked_obj = WEAKREF(O)
		linked_pad.locked_obj_name = href_list["name"]
		if(!linked_pad.engaged)
			linked_pad.engage()
			linked_pad.visible_message(SPAN_NOTICE("Locked in."), range = 2)

	SSvueui.check_uis_for_change(src)

/datum/computer_file/program/teleporter/ninja
	required_access_run = list()
	requires_ntnet = FALSE
	requires_access_to_run = FALSE