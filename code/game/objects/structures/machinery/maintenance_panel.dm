/**
 * A chassis that combines an APC, air alarm, and fire alarm on one tile.
 *
 * `installed_modules` is mapper-facing: APC = 1, air alarm = 2, fire alarm = 4.
 * Add the values together for any combination. The spawned children are the real
 * machines, so their normal interfaces, processing, damage, and construction
 * behaviour remain available.
 */
/obj/structure/machinery/maintenance_panel
	name = "modular maintenance panel"
	desc = "A modular chassis for power, atmospheric, and fire control equipment."
	anchored = TRUE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	use_power = POWER_USE_OFF

	/// Bitfield of complete modules created on map load.
	var/installed_modules = MAINTENANCE_PANEL_ALL
	/// Floor panels must be opened before their modules can be reached.
	var/cover_open = TRUE
	var/has_cover = FALSE

	var/apc_type = /obj/structure/machinery/power/apc/maintenance_panel/wall
	var/air_alarm_type = /obj/structure/machinery/alarm/maintenance_panel/wall
	var/fire_alarm_type = /obj/structure/machinery/firealarm/maintenance_panel/wall
	var/frame_type = /obj/item/frame/maintenance_panel

	var/obj/structure/machinery/power/apc/maintenance_panel/apc
	var/obj/structure/machinery/alarm/maintenance_panel/air_alarm
	var/obj/structure/machinery/firealarm/maintenance_panel/fire_alarm

/obj/structure/machinery/maintenance_panel/Initialize(mapload, ndir, building = FALSE)
	. = ..()
	if(ndir)
		set_dir(ndir)
	set_pixel_offsets()
	if(building)
		installed_modules = 0
		cover_open = TRUE

	if(installed_modules & MAINTENANCE_PANEL_APC)
		apc = new apc_type(loc)
		apc.panel_owner = src
		apc.set_dir(dir)
		apc.set_pixel_offsets()
		apc.terminal?.set_dir(dir)
	if(installed_modules & MAINTENANCE_PANEL_AIR_ALARM)
		air_alarm = new air_alarm_type(loc)
		air_alarm.panel_owner = src
		air_alarm.set_dir(dir)
		air_alarm.set_pixel_offsets()
	if(installed_modules & MAINTENANCE_PANEL_FIRE_ALARM)
		fire_alarm = new fire_alarm_type(loc)
		fire_alarm.panel_owner = src
		fire_alarm.set_dir(dir)
		fire_alarm.set_pixel_offsets()

	update_icon()

/obj/structure/machinery/maintenance_panel/Destroy()
	QDEL_NULL(apc)
	QDEL_NULL(air_alarm)
	QDEL_NULL(fire_alarm)
	return ..()

/obj/structure/machinery/maintenance_panel/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(has_cover)
		. += "Its cover is [cover_open ? "open" : "closed"]."
	if(is_adjacent && (!has_cover || cover_open))
		. += "It has [QDELETED(apc) ? "an empty APC slot" : "an APC module"], [QDELETED(air_alarm) ? "an empty air alarm slot" : "an air alarm module"], and [QDELETED(fire_alarm) ? "an empty fire alarm slot" : "a fire alarm module"]."

/obj/structure/machinery/maintenance_panel/assembly_hints(mob/user, distance, is_adjacent)
	. = list()
	. += ..()
	. += "APC, air alarm, and fire alarm frames can be fitted into empty slots."
	if(has_cover)
		. += "The cover can be opened or closed with a crowbar."
	. += "Once fitted, each module is assembled and serviced normally."

/obj/structure/machinery/maintenance_panel/attackby(obj/item/attacking_item, mob/user)
	if(has_cover && attacking_item.tool_behaviour == TOOL_CROWBAR)
		cover_open = !cover_open
		attacking_item.play_tool_sound(src, 50)
		user.visible_message(SPAN_NOTICE("[user] [cover_open ? "opens" : "closes"] \the [src]."), SPAN_NOTICE("You [cover_open ? "open" : "close"] \the [src]."))
		update_icon()
		return TRUE

	if(has_cover && !cover_open)
		to_chat(user, SPAN_WARNING("You need to open \the [src] first."))
		return TRUE

	if(istype(attacking_item, /obj/item/frame/apc))
		if(!QDELETED(apc))
			to_chat(user, SPAN_WARNING("There is already an APC module fitted in \the [src]."))
			return TRUE
		var/area/panel_area = get_area(src)
		if(!panel_area.requires_power || istype(panel_area, /area/space) || istype(panel_area, /area/mine))
			to_chat(user, SPAN_WARNING("An APC cannot be installed in this area."))
			return TRUE
		if(panel_area.get_apc())
			to_chat(user, SPAN_WARNING("This area already has an APC."))
			return TRUE
		for(var/obj/structure/machinery/power/terminal/terminal in loc)
			if(terminal.master)
				to_chat(user, SPAN_WARNING("There is another network terminal here."))
				return TRUE
			var/obj/item/stack/cable_coil/cable_refund = new(get_turf(src))
			cable_refund.amount = 10
			to_chat(user, SPAN_NOTICE("You cut the cables and disassemble the unused power terminal."))
			qdel(terminal)
		apc = new apc_type(loc, dir, TRUE)
		apc.panel_owner = src
		transfer_fingerprints(attacking_item, apc)
		user.remove_from_mob(attacking_item)
		qdel(attacking_item)
		to_chat(user, SPAN_NOTICE("You fit the APC frame into \the [src]."))
		return TRUE

	if(istype(attacking_item, /obj/item/frame/air_alarm))
		if(!QDELETED(air_alarm))
			to_chat(user, SPAN_WARNING("There is already an air alarm module fitted in \the [src]."))
			return TRUE
		air_alarm = new air_alarm_type(loc, dir, TRUE)
		air_alarm.panel_owner = src
		transfer_fingerprints(attacking_item, air_alarm)
		user.remove_from_mob(attacking_item)
		qdel(attacking_item)
		to_chat(user, SPAN_NOTICE("You fit the air alarm frame into \the [src]."))
		return TRUE

	if(istype(attacking_item, /obj/item/frame/fire_alarm))
		if(!QDELETED(fire_alarm))
			to_chat(user, SPAN_WARNING("There is already a fire alarm module fitted in \the [src]."))
			return TRUE
		fire_alarm = new fire_alarm_type(loc, dir, TRUE)
		fire_alarm.panel_owner = src
		transfer_fingerprints(attacking_item, fire_alarm)
		user.remove_from_mob(attacking_item)
		qdel(attacking_item)
		to_chat(user, SPAN_NOTICE("You fit the fire alarm frame into \the [src]."))
		return TRUE

	if(attacking_item.tool_behaviour == TOOL_WRENCH && QDELETED(apc) && QDELETED(air_alarm) && QDELETED(fire_alarm))
		attacking_item.play_tool_sound(src, 50)
		to_chat(user, SPAN_NOTICE("You unfasten \the [src]."))
		new frame_type(get_turf(src))
		qdel(src)
		return TRUE

	return ..()

/obj/structure/machinery/maintenance_panel/proc/transfer_fingerprints(obj/item/frame/source, obj/structure/machinery/target)
	target.fingerprints = source.fingerprints
	target.fingerprintshidden = source.fingerprintshidden
	target.fingerprintslast = source.fingerprintslast

/// Recreates a pristine standalone assembly inside a newly combined wall panel.
/obj/structure/machinery/maintenance_panel/proc/add_unfinished_module(module_flag)
	switch(module_flag)
		if(MAINTENANCE_PANEL_APC)
			if(!QDELETED(apc))
				return FALSE
			apc = new apc_type(loc, dir, TRUE)
			apc.panel_owner = src
		if(MAINTENANCE_PANEL_AIR_ALARM)
			if(!QDELETED(air_alarm))
				return FALSE
			air_alarm = new air_alarm_type(loc, dir, TRUE)
			air_alarm.panel_owner = src
		if(MAINTENANCE_PANEL_FIRE_ALARM)
			if(!QDELETED(fire_alarm))
				return FALSE
			fire_alarm = new fire_alarm_type(loc, dir, TRUE)
			fire_alarm.panel_owner = src
		else
			return FALSE
	return TRUE

/obj/structure/machinery/maintenance_panel/set_pixel_offsets()
	pixel_x = ((dir & (NORTH|SOUTH)) ? 0 : (dir == EAST ? 12 : -12))
	pixel_y = ((dir & (NORTH|SOUTH)) ? (dir == NORTH ? 22 : -8) : 0)

/obj/structure/machinery/maintenance_panel/update_icon()
	if(has_cover && !cover_open)
		icon_state = "maintpanel_closed"
	else
		icon_state = "maintpanel"
	set_module_visibility(!has_cover || cover_open)

/obj/structure/machinery/maintenance_panel/proc/set_module_visibility(visible)
	for(var/obj/structure/machinery/module in list(apc, air_alarm, fire_alarm))
		if(QDELETED(module))
			continue
		module.alpha = visible ? 255 : 0
		module.mouse_opacity = visible ? MOUSE_OPACITY_ICON : MOUSE_OPACITY_TRANSPARENT
		if(visible)
			if(module == apc)
				// The APC normally skips identical icon updates, including its light refresh.
				apc.update_state = -1
				apc.update_overlay = -1
			module.update_icon()
		else
			module.set_light(0)

/obj/structure/machinery/maintenance_panel/wall
	icon = 'icons/obj/machinery/wall_maintpanel.dmi'
	icon_state = "alarm_b1"

/obj/structure/machinery/maintenance_panel/wall/update_icon()
	icon_state = "alarm_b1"
	set_module_visibility(TRUE)

/obj/structure/machinery/maintenance_panel/floor
	icon = 'icons/obj/machinery/floor_maintpanel.dmi'
	// Shows all available slots in the map editor; Initialize() selects the real state.
	icon_state = "maintpanel_preview"
	has_cover = TRUE
	cover_open = FALSE
	apc_type = /obj/structure/machinery/power/apc/maintenance_panel/floor
	air_alarm_type = /obj/structure/machinery/alarm/maintenance_panel/floor
	fire_alarm_type = /obj/structure/machinery/firealarm/maintenance_panel/floor
	frame_type = /obj/item/floor_frame/maintenance_panel

/obj/structure/machinery/maintenance_panel/floor/set_pixel_offsets()
	pixel_x = 0
	pixel_y = 0

// These are full machinery subtypes, with only their presentation and wall offset changed.
/obj/structure/machinery/power/apc/maintenance_panel
	icon = 'icons/obj/machinery/wall_maintpanel.dmi'
	icon_state = "apc"
	layer = ABOVE_OBJ_LAYER
	var/obj/structure/machinery/maintenance_panel/panel_owner

/obj/structure/machinery/power/apc/maintenance_panel/set_pixel_offsets()
	pixel_x = ((dir & (NORTH|SOUTH)) ? 0 : (dir == EAST ? 12 : -12))
	pixel_y = ((dir & (NORTH|SOUTH)) ? (dir == NORTH ? 22 : -8) : 0)

/obj/structure/machinery/power/apc/maintenance_panel/Destroy()
	if(panel_owner?.apc == src)
		panel_owner.apc = null
	panel_owner = null
	return ..()

/obj/structure/machinery/power/apc/maintenance_panel/update_icon()
	. = ..()
	if(icon_state == "apc0")
		icon_state = "apc"
	if(panel_owner?.has_cover && !panel_owner.cover_open)
		set_light(0)

/obj/structure/machinery/power/apc/maintenance_panel/wall

/obj/structure/machinery/power/apc/maintenance_panel/floor
	icon = 'icons/obj/machinery/floor_maintpanel.dmi'

/obj/structure/machinery/power/apc/maintenance_panel/floor/set_pixel_offsets()
	pixel_x = 0
	pixel_y = 0

/obj/structure/machinery/alarm/maintenance_panel
	icon = 'icons/obj/machinery/wall_maintpanel.dmi'
	layer = ABOVE_OBJ_LAYER
	var/obj/structure/machinery/maintenance_panel/panel_owner

/obj/structure/machinery/alarm/maintenance_panel/set_pixel_offsets()
	pixel_x = ((dir & (NORTH|SOUTH)) ? 0 : (dir == EAST ? 12 : -12))
	pixel_y = ((dir & (NORTH|SOUTH)) ? (dir == NORTH ? 22 : -8) : 0)

/obj/structure/machinery/alarm/maintenance_panel/Destroy()
	if(panel_owner?.air_alarm == src)
		panel_owner.air_alarm = null
	panel_owner = null
	return ..()

/obj/structure/machinery/alarm/maintenance_panel/update_icon()
	. = ..()
	if(panel_owner?.has_cover && !panel_owner.cover_open)
		set_light(0)

/obj/structure/machinery/alarm/maintenance_panel/wall

/obj/structure/machinery/alarm/maintenance_panel/floor
	icon = 'icons/obj/machinery/floor_maintpanel.dmi'

/obj/structure/machinery/alarm/maintenance_panel/floor/set_pixel_offsets()
	pixel_x = 0
	pixel_y = 0

/obj/structure/machinery/firealarm/maintenance_panel
	icon = 'icons/obj/machinery/wall_maintpanel.dmi'
	icon_state = "fire"
	layer = ABOVE_OBJ_LAYER
	var/obj/structure/machinery/maintenance_panel/panel_owner

/obj/structure/machinery/firealarm/maintenance_panel/set_pixel_offsets()
	pixel_x = ((dir & (NORTH|SOUTH)) ? 0 : (dir == EAST ? 12 : -12))
	pixel_y = ((dir & (NORTH|SOUTH)) ? (dir == NORTH ? 22 : -8) : 0)

/obj/structure/machinery/firealarm/maintenance_panel/Destroy()
	if(panel_owner?.fire_alarm == src)
		panel_owner.fire_alarm = null
	panel_owner = null
	return ..()

/obj/structure/machinery/firealarm/maintenance_panel/update_icon()
	ClearOverlays()
	if(panel_open)
		switch(buildstage)
			if(2)
				AddOverlays("fire_b2")
			if(1)
				AddOverlays("fire_b1")
			if(0)
				AddOverlays("fire_b0")
		if(panel_owner?.has_cover && !panel_owner.cover_open)
			set_light(0)
		return
	if(stat & BROKEN)
		AddOverlays("fireex")
		set_light(0)
	else if(stat & NOPOWER)
		AddOverlays("firep")
		set_light(0)
	else
		var/area/fire_area = get_area(src)
		if(fire_area.fire)
			AddOverlays("fire1")
			set_light(L_WALLMOUNT_HI_RANGE, L_WALLMOUNT_HI_POWER, COLOR_RED)
		else
			AddOverlays("fire0")
			set_light(0)
	if(panel_owner?.has_cover && !panel_owner.cover_open)
		set_light(0)

/obj/structure/machinery/firealarm/maintenance_panel/wall

/obj/structure/machinery/firealarm/maintenance_panel/floor
	icon = 'icons/obj/machinery/floor_maintpanel.dmi'

/obj/structure/machinery/firealarm/maintenance_panel/floor/set_pixel_offsets()
	pixel_x = 0
	pixel_y = 0

/obj/item/frame/maintenance_panel
	name = "wall maintenance panel frame"
	desc = "A modular wall chassis for an APC, air alarm, and fire alarm."
	icon = 'icons/obj/machinery/wall_maintpanel.dmi'
	icon_state = "maintpanel"
	build_machine_type = /obj/structure/machinery/maintenance_panel/wall

/obj/item/floor_frame/maintenance_panel
	name = "floor maintenance panel frame"
	desc = "A modular floor chassis for an APC, air alarm, and fire alarm."
	icon = 'icons/obj/machinery/floor_maintpanel.dmi'
	icon_state = "maintpanel"
	build_machine_type = /obj/structure/machinery/maintenance_panel/floor

/// Lets a second alarm/APC frame combine with a pristine wall assembly instead of being blocked.
/proc/try_merge_maintenance_panel_frame(obj/item/frame/frame, turf/build_turf, ndir, mob/user)
	var/incoming_module
	if(istype(frame, /obj/item/frame/apc))
		incoming_module = MAINTENANCE_PANEL_APC
	else if(istype(frame, /obj/item/frame/air_alarm))
		incoming_module = MAINTENANCE_PANEL_AIR_ALARM
	else if(istype(frame, /obj/item/frame/fire_alarm))
		incoming_module = MAINTENANCE_PANEL_FIRE_ALARM
	else
		return FALSE

	for(var/obj/structure/machinery/maintenance_panel/wall/existing_panel in build_turf)
		if(existing_panel.dir == ndir)
			existing_panel.attackby(frame, user)
			return TRUE

	var/obj/structure/machinery/existing_module
	var/existing_flag
	for(var/obj/structure/machinery/power/apc/candidate_apc in build_turf)
		if(candidate_apc.dir == ndir && candidate_apc.can_merge_into_maintenance_panel())
			existing_module = candidate_apc
			existing_flag = MAINTENANCE_PANEL_APC
			break
	if(!existing_module)
		for(var/obj/structure/machinery/alarm/candidate_air_alarm in build_turf)
			if(candidate_air_alarm.dir == ndir && candidate_air_alarm.can_merge_into_maintenance_panel())
				existing_module = candidate_air_alarm
				existing_flag = MAINTENANCE_PANEL_AIR_ALARM
				break
	if(!existing_module)
		for(var/obj/structure/machinery/firealarm/candidate_fire_alarm in build_turf)
			if(candidate_fire_alarm.dir == ndir && candidate_fire_alarm.can_merge_into_maintenance_panel())
				existing_module = candidate_fire_alarm
				existing_flag = MAINTENANCE_PANEL_FIRE_ALARM
				break

	if(!existing_module || existing_flag == incoming_module)
		return FALSE

	qdel(existing_module)
	var/obj/structure/machinery/maintenance_panel/wall/combined_panel = new(build_turf, ndir, TRUE)
	combined_panel.add_unfinished_module(existing_flag)
	combined_panel.attackby(frame, user)
	return TRUE

/obj/structure/machinery/alarm/proc/can_merge_into_maintenance_panel()
	return buildstage == 0 && panel_open

/obj/structure/machinery/firealarm/proc/can_merge_into_maintenance_panel()
	return buildstage == 0 && panel_open
