/datum/computer_file/program/teleporter
	filename = "teleporter"
	filedesc = "Teleporter Control"
	extended_desc = "A NanoTrasen command remote teleportation hub controller."
	program_icon_state = "comm"
	color = LIGHT_COLOR_BLUE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	required_access_run = access_heads
	usage_flags = PROGRAM_LAPTOP
	var/obj/machinery/computer/teleporter/linked_comp

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

/datum/computer_file/program/teleporter/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/turf/T = get_turf(computer.loc)
	if(QDELETED(linked_comp))
		linked_comp = null

	// block of root level data
	data["has_linked_comp"] = !!linked_comp
	LAZYINITLIST(data["nearby_comps"])
	LAZYINITLIST(data["teleport_beacons"])
	LAZYINITLIST(data["teleport_implants"])
	data["comp_locked_in"] = FALSE
	data["locked_in_name"] = "None"

	if(!linked_comp)
		var/list/near_comps_info = list()
		for(var/obj/machinery/computer/teleporter/CT in range(3, T))
			var/list/comp_info = list(
				"comp_name" = CT.name,
				"ref" = "\ref[CT]"
				)
			near_comps_info[++near_comps_info.len] = comp_info
		data["nearby_comps"] = near_comps_info
	else
		data["comp_locked_in"] = !!LAZYLEN(linked_comp.locked)
		if(data["comp_locked_in"])
			data["locked_in_name"] = linked_comp.locked[linked_comp.locked[1]]
		var/list/area_index = list()

		var/list/teleport_beacon_info = list()
		for(var/obj/item/device/radio/beacon/R in teleportbeacons)
			var/turf/BT = get_turf(R)
			if(!BT)
				continue
			if(isNotStationLevel(BT.z))
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
				if(isNotStationLevel(IT.z))
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

	if(href_list["comp"])
		linked_comp = locate(href_list["comp"]) in range(3, get_turf(computer.loc))
	else if(href_list["beacon"])
		LAZYCLEARLIST(linked_comp.locked)
		LAZYSET(linked_comp.locked, locate(href_list["beacon"]) in teleportbeacons, href_list["name"])
		linked_comp.visible_message(SPAN_NOTICE("Locked in."), range = 2)
	else if(href_list["implant"])
		LAZYCLEARLIST(linked_comp.locked)
		LAZYSET(linked_comp.locked, locate(href_list["implant"]) in implants, href_list["name"])
		linked_comp.visible_message(SPAN_NOTICE("Locked in."), range = 2)

	SSvueui.check_uis_for_change(src)