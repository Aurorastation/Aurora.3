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
	var/datum/weakref/station_ref

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
	var/obj/machinery/teleport/station/linked_station
	if(station_ref)
		linked_station = station_ref.resolve()
	if(QDELETED(linked_station))
		station_ref = null

	// block of root level data
	data["has_linked_station"] = !!linked_station
	LAZYINITLIST(data["nearby_stations"])
	LAZYINITLIST(data["teleport_beacons"])
	LAZYINITLIST(data["teleport_implants"])
	data["station_locked_in"] = FALSE
	data["locked_in_name"] = "None"
	data["calibration"] = 0

	if(!linked_station)
		var/list/near_stations_info = list()
		for(var/obj/machinery/teleport/station/S in range(3, T))
			var/list/station_info = list(
				"station_name" = "[S.name] ([S.x]-[S.y][S.z])",
				"ref" = "\ref[S]"
				)
			near_stations_info[++near_stations_info.len] = station_info
		data["nearby_stations"] = near_stations_info
	else
		data["station_locked_in"] = !!linked_station.locked_obj
		if(data["station_locked_in"])
			data["locked_in_name"] = linked_station.locked_obj_name
		data["calibration"] = 100 - linked_station.calibration
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

	if(href_list["station"])
		var/obj/machinery/teleport/station/linked_station = locate(href_list["station"]) in range(3, get_turf(computer.loc))
		station_ref = WEAKREF(linked_station)
	else if(href_list["recalibrate"])
		var/obj/machinery/teleport/station/linked_station = station_ref.resolve()
		linked_station.start_recalibration()
	else if(href_list["beacon"])
		var/obj/machinery/teleport/station/linked_station = station_ref.resolve()
		var/obj/O = locate(href_list["beacon"]) in teleportbeacons
		if(linked_station.locked_obj)
			var/obj/LO = linked_station.locked_obj.resolve()
			if(LO == O)
				linked_station.disengage()
				return
		linked_station.locked_obj = WEAKREF(O)
		linked_station.locked_obj_name = href_list["name"]
		if(!linked_station.engaged)
			linked_station.engage()
		linked_station.visible_message(SPAN_NOTICE("Locked in."), range = 2)
	else if(href_list["implant"])
		var/obj/machinery/teleport/station/linked_station = station_ref.resolve()
		var/obj/O = locate(href_list["implant"]) in teleportbeacons
		if(linked_station.locked_obj)
			var/obj/LO = linked_station.locked_obj.resolve()
			if(LO == O)
				linked_station.disengage()
				return
		linked_station.locked_obj = WEAKREF(O)
		linked_station.locked_obj_name = href_list["name"]
		if(!linked_station.engaged)
			linked_station.engage()
		linked_station.visible_message(SPAN_NOTICE("Locked in."), range = 2)

	SSvueui.check_uis_for_change(src)