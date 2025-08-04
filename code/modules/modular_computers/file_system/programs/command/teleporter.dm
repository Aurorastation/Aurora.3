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
	required_access_run = ACCESS_HEADS
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	tgui_id = "Teleporter"
	var/datum/weakref/pad_ref

/datum/computer_file/program/teleporter/ui_data(mob/user)
	var/list/data = list()

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
	data["nearby_pads"] = list()
	data["teleport_beacons"] = list()
	data["teleport_implants"] = list()
	data["calibration"] = 0
	data["selected_target"] = null
	data["selected_target_name"] = "None"

	if(!linked_pad)
		var/list/near_pads_info = list()
		for(var/obj/machinery/teleport/pad/S in range(3, T))
			var/list/pad_info = list(
				"name" = "[S.name] ([S.x]-[S.y][S.z])",
				"ref" = "[REF(S)]"
				)
			near_pads_info += list(pad_info)
		data["nearby_pads"] = near_pads_info
	else
		var/atom/selected_atom = linked_pad.locked_obj ? linked_pad.locked_obj.resolve() : null
		if(selected_atom)
			data["selected_target"] = "[REF(selected_atom)]"
			data["selected_target_name"] = linked_pad.locked_obj_name
		data["calibration"] = 100 - linked_pad.calibration
		var/list/area_index = list()

		var/list/teleport_beacon_info = list()
		for(var/obj/item/device/radio/beacon/R as anything in GLOB.teleportbeacons)
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
				"name" = tmpname,
				"ref" = "[REF(R)]"
				)
			teleport_beacon_info += list(teleporter_info)
		data["teleport_beacons"] = teleport_beacon_info

		var/list/teleport_implant_info = list()
		for(var/obj/item/implant/tracking/I in GLOB.implants)
			if(!I.implanted || !ismob(I.loc))
				continue
			else
				var/mob/M = I.loc
				if(M.stat == DEAD)
					if(M.timeofdeath + I.lifespan_postmortem < world.time)
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
					"name" = tmpname,
					"ref" = "[REF(I)]"
				)
				teleport_implant_info += list(implant_info)
		data["teleport_implants"] = teleport_implant_info

	return data

/datum/computer_file/program/teleporter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("pad")
			var/obj/machinery/teleport/pad/linked_pad = locate(params["pad"]) in range(3, get_turf(computer.loc))
			pad_ref = WEAKREF(linked_pad)
			. = TRUE

		if("recalibrate")
			var/obj/machinery/teleport/pad/linked_pad = pad_ref.resolve()
			linked_pad.start_recalibration()
			. = TRUE

		if("beacon")
			var/obj/machinery/teleport/pad/linked_pad = pad_ref.resolve()
			var/obj/O = locate(params["beacon"]) in GLOB.teleportbeacons
			if(linked_pad.locked_obj)
				var/obj/LO = linked_pad.locked_obj.resolve()
				if(LO == O)
					linked_pad.disengage()
					return
			linked_pad.locked_obj = WEAKREF(O)
			linked_pad.locked_obj_name = params["name"]
			if(!linked_pad.engaged)
				linked_pad.engage()
				linked_pad.visible_message(SPAN_NOTICE("Locked in."), range = 2)
			. = TRUE

		if("implant")
			var/obj/machinery/teleport/pad/linked_pad = pad_ref.resolve()
			var/obj/O = locate(params["implant"]) in GLOB.implants
			if(linked_pad.locked_obj)
				var/obj/LO = linked_pad.locked_obj.resolve()
				if(LO == O)
					linked_pad.disengage()
					return
			linked_pad.locked_obj = WEAKREF(O)
			linked_pad.locked_obj_name = params["name"]
			if(!linked_pad.engaged)
				linked_pad.engage()
				linked_pad.visible_message(SPAN_NOTICE("Locked in."), range = 2)
			. = TRUE

/datum/computer_file/program/teleporter/ninja
	filename = "ninjateleporter"
	filedesc = "Ninja Teleporter Control"
	requires_ntnet = FALSE
	requires_access_to_run = FALSE
