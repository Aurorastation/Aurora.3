/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/stationobjs.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/teleport/pad
	name = "teleporter hub"
	desc = "It's the hub of a teleporting machine."
	icon_state = "tele0"
	dir = EAST
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000

	var/obj/machinery/teleport/station/station

/obj/machinery/teleport/pad/Initialize()
	. = ..()
	station = locate() in range(2, src)
	underlays.Cut()
	underlays += image('icons/obj/stationobjs.dmi', icon_state = "tele-wires")

/obj/machinery/teleport/pad/Destroy()
	station = null
	return ..()

/obj/machinery/teleport/pad/CollidedWith(M as mob|obj)
	if(station?.engaged)
		teleport(M)
		use_power(5000)

/obj/machinery/teleport/pad/proc/teleport(atom/movable/M as mob|obj)
	if(!station.locked_obj)
		audible_message(SPAN_WARNING("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix."))
	var/obj/teleport_obj = station.locked_obj.resolve()
	if(!teleport_obj)
		station.locked_obj = null
		return
	if(prob(station.calibration)) //oh dear a problem, put em in deep space
		do_teleport(M, locate(rand((2*TRANSITIONEDGE), world.maxx - (2*TRANSITIONEDGE)), rand((2*TRANSITIONEDGE), world.maxy - (2*TRANSITIONEDGE)), 3), 2)
	else
		do_teleport(M, teleport_obj) //dead-on precision
	station.calibration = min(station.calibration + 5, 100)

/obj/machinery/teleport/pad/update_icon()
	if(station?.engaged)
		icon_state = "tele1"
	else
		icon_state = "tele0"

/obj/machinery/teleport/station
	name = "teleportation station"
	desc = "A teleportation hub that can be used to lock onto beacons and implants and relaying the coordinates precisely to a nearby teleportation pad."
	icon_state = "controller"
	dir = EAST
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000

	var/obj/machinery/teleport/pad/pad

	var/id = null
	var/engaged = FALSE

	var/calibration = 0 // a percentage chance for teleporting into space instead of your target. 0 is perfectly calibrated, 100 is totally uncalibrated

	var/datum/weakref/locked_obj
	var/locked_obj_name

/obj/machinery/teleport/station/Initialize()
	. = ..()
	pad = locate() in range(2, src)
	id = "[rand(1000, 9999)]"
	set_overlays("controller-wires")

/obj/machinery/teleport/station/attack_hand(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui(user, src, "machinery-teleporter", 600, 400, "Teleporter Control System")
		ui.auto_update_content = TRUE
	ui.open()

/obj/machinery/teleport/station/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// block of root level data
	LAZYINITLIST(data["teleport_beacons"])
	LAZYINITLIST(data["teleport_implants"])
	data["locked_in_name"] = "None"

	data["station_locked_in"] = !!locked_obj
	if(data["station_locked_in"])
		data["locked_in_name"] = locked_obj_name
	data["calibration"] = 100 - calibration
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

/obj/machinery/teleport/station/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["recalibrate"])
		start_recalibration()
	else if(href_list["beacon"])
		var/obj/O = locate(href_list["beacon"]) in teleportbeacons
		if(locked_obj)
			var/obj/LO = locked_obj.resolve()
			if(LO == O)
				disengage()
				return
		locked_obj = WEAKREF(O)
		locked_obj_name = href_list["name"]
		if(!engaged)
			engage()
		visible_message(SPAN_NOTICE("Locked in."), range = 2)
	else if(href_list["implant"])
		var/obj/O = locate(href_list["implant"]) in teleportbeacons
		if(locked_obj)
			var/obj/LO = locked_obj.resolve()
			if(LO == O)
				disengage()
				return
		locked_obj = WEAKREF(O)
		locked_obj_name = href_list["name"]
		if(!engaged)
			engage()
		visible_message(SPAN_NOTICE("Locked in."), range = 2)

	SSvueui.check_uis_for_change(src)

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(5000)
	update_use_power(2)
	pad.update_use_power(2)
	visible_message(SPAN_NOTICE("Teleporter engaged!"))
	add_fingerprint(usr)
	engaged = TRUE
	pad.update_icon()

/obj/machinery/teleport/station/proc/disengage()
	if(stat & (BROKEN|NOPOWER))
		return

	update_use_power(1)
	pad.update_use_power(1)
	locked_obj = null
	locked_obj_name = null
	visible_message(SPAN_NOTICE("Teleporter disengaged!"))
	add_fingerprint(usr)
	engaged = FALSE
	pad.update_icon()

/obj/machinery/teleport/station/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "controller-p"
		if(pad)
			pad.update_icon()
	else
		icon_state = "controller"

/obj/machinery/teleport/station/proc/start_recalibration()
	audible_message(SPAN_NOTICE("Recalibrating..."))
	addtimer(CALLBACK(src, .proc/recalibrate), 5 SECONDS, TIMER_UNIQUE)

/obj/machinery/teleport/station/proc/recalibrate()
	calibration = 0
	audible_message(SPAN_NOTICE("Calibration complete."))

/obj/machinery/teleport/station/Destroy()
	pad = null
	return ..()