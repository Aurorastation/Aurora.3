/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/teleporter.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/teleport/pad
	name = "teleporter pad"
	desc = "It's the pad of a teleporting machine."
	icon_state = "pad"
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000

	var/obj/machinery/teleport/station/station
	light_color = "#02d1c7"

/obj/machinery/teleport/pad/Initialize()
	. = ..()
	find_station()
	queue_icon_update()

/obj/machinery/teleport/pad/proc/find_station()
	station = locate() in range(2, src)

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
		do_teleport(M, locate(rand((2*TRANSITIONEDGE), world.maxx - (2*TRANSITIONEDGE)), rand((2*TRANSITIONEDGE), world.maxy - (2*TRANSITIONEDGE)), pick(GetConnectedZlevels(z))), 2)
	else
		do_teleport(M, teleport_obj) //dead-on precision
	if(ishuman(M))
		station.calibration = min(station.calibration + 5, 100)

/obj/machinery/teleport/pad/update_icon()
	cut_overlays()
	if (station?.engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
		add_overlay(I)
		set_light(4, 0.4)
	else
		set_light(0)
		if (operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
			add_overlay(I)

/obj/machinery/teleport/station
	name = "teleportation station"
	desc = "A teleportation hub that can be used to lock onto beacons and implants and relaying the coordinates precisely to a nearby teleportation pad."
	icon_state = "station"
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
	find_pad()
	set_dir(get_dir(src, pad))
	id = "[rand(1000, 9999)]"
	queue_icon_update()

/obj/machinery/teleport/station/proc/find_pad()
	pad = locate() in range(2, src)
	if(pad)
		return TRUE
	return FALSE

/obj/machinery/teleport/station/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("\The [src]'s station ID is: <b>[id]</b>."))

/obj/machinery/teleport/station/machinery_process()
	var/old_engaged = engaged
	if(locked_obj)
		if(stat & (NOPOWER|BROKEN))
			engaged = FALSE
		else
			engaged = TRUE
	if(old_engaged != engaged)
		update_icon()
		if(pad)
			pad.update_icon()

/obj/machinery/teleport/station/update_icon()
	. = ..()
	cut_overlays()
	if (engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
		add_overlay(I)
	else if (operable())
		var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
		I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
		add_overlay(I)

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

	var/obj/selected_beacon = locked_obj ? locked_obj.resolve() : null
	var/list/teleport_beacon_info = list()
	for(var/obj/item/device/radio/beacon/R in teleportbeacons)
		var/turf/BT = get_turf(R)
		if(!BT)
			continue
		if(!isAdminLevel(z) && (isAdminLevel(BT.z) || !AreConnectedZLevels(z, BT.z)))
			continue
		var/tmpname = BT.loc.name
		if(area_index[tmpname])
			tmpname = "[tmpname] ([++area_index[tmpname]])"
		else
			area_index[tmpname] = 1
		var/list/teleporter_info = list(
			"beacon_name" = tmpname,
			"ref" = "\ref[R]",
			"selected_beacon" = (selected_beacon == R) ? TRUE : FALSE
			)
		teleport_beacon_info[++teleport_beacon_info.len] = teleporter_info
	data["teleport_beacons"] = teleport_beacon_info

	var/list/teleport_implant_info = list()
	for(var/obj/item/implant/tracking/I in implants)
		if(!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if(M.stat == DEAD && M.timeofdeath + 6000 < world.time)
				continue
			var/turf/IT = get_turf(M)
			if(!IT)
				continue
			if(!isAdminLevel(z) && (isAdminLevel(IT.z) || !AreConnectedZLevels(z, IT.z)))
				continue
			var/tmpname = M.real_name
			if(area_index[tmpname])
				tmpname = "[tmpname] ([++area_index[tmpname]])"
			else
				area_index[tmpname] = 1
			var/list/implant_info = list(
				"implant_name" = tmpname,
				"ref" = "\ref[I]",
				"selected_implant" = (selected_beacon == I) ? TRUE : FALSE
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
				SSvueui.check_uis_for_change(src)
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
				SSvueui.check_uis_for_change(src)
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

	if(!pad && !find_pad())
		return

	use_power(5000)
	update_use_power(2)
	pad.update_use_power(2)
	visible_message(SPAN_NOTICE("Teleporter engaged!"))
	add_fingerprint(usr)
	engaged = TRUE
	pad.queue_icon_update()
	queue_icon_update()

/obj/machinery/teleport/station/proc/disengage()
	if(stat & (BROKEN|NOPOWER))
		return

	update_use_power(1)
	if(pad)
		pad.update_use_power(1)
	locked_obj = null
	locked_obj_name = null
	visible_message(SPAN_NOTICE("Teleporter disengaged!"))
	add_fingerprint(usr)
	engaged = FALSE
	if(pad)
		pad.queue_icon_update()
	queue_icon_update()

/obj/machinery/teleport/station/power_change()
	..()
	queue_icon_update()
	if(pad)
		pad.queue_icon_update()

/obj/machinery/teleport/station/proc/start_recalibration()
	audible_message(SPAN_NOTICE("Recalibrating..."))
	addtimer(CALLBACK(src, .proc/recalibrate), 5 SECONDS, TIMER_UNIQUE)

/obj/machinery/teleport/station/proc/recalibrate()
	calibration = 0
	audible_message(SPAN_NOTICE("Calibration complete."))

/obj/machinery/teleport/station/Destroy()
	pad = null
	return ..()
