GLOBAL_LIST_EMPTY(gps_list)

/obj/item/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/item/gps.dmi'
	icon_state = "gps-com"
	item_state = "radio"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	var/gps_prefix = "COM"
	var/gpstag = "COM0"
	var/compass_color = "#193A7A"

	var/emped = FALSE
	var/uses_device_cell = TRUE
	var/starts_powered = FALSE
	var/always_powered = FALSE
	var/datum/device_power_supply/power_supply
	/// A standard 250 charge device cell lasts forty minutes.
	var/power_usage_per_second = 250 / (40 * 60)
	var/last_broadcast_position = FALSE
	var/offline_since

	var/mob/held_by = null
	var/mob/implanted_into = null
	var/turf/locked_location

	var/list/tracking = list()
	var/list/tracking_compass
	var/obj/compass_holder/compass
	var/list/static/gps_count = list()

	var/process_interval = 6 SECONDS
	var/last_process = 0

/obj/item/gps/Initialize()
	. = ..()
	if(uses_device_cell)
		power_supply = new(src, /obj/item/cell/device, starts_powered)
	compass = new(src)
	gpstag = next_initial_tag()
	name = "global positioning system ([gpstag])"
	if(is_operational())
		update_position()

	if(ismob(loc))
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(src in H.get_equipped_items())
				held_by = H
			else
				implanted_into = loc
		else if(issilicon(loc))
			held_by = loc
			implanted_into = loc
	else if(istype(loc, /obj/item/robot_module))
		held_by = loc.loc
		implanted_into = loc.loc

	update_icon()

	if(held_by)
		RegisterSignal(held_by, COMSIG_MOVABLE_MOVED, PROC_REF(update_position), TRUE)
	if(implanted_into)
		RegisterSignal(implanted_into, COMSIG_MOVABLE_MOVED, PROC_REF(update_position), TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(update_position))

	for(var/gps in GLOB.gps_list)
		tracking += GLOB.gps_list[gps]["tag"]

	START_PROCESSING(SSprocessing, src)

/obj/item/gps/Destroy()
	GLOB.gps_list -= gpstag
	QDEL_NULL(power_supply)
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	if(held_by)
		UnregisterSignal(held_by, COMSIG_MOVABLE_MOVED)
		held_by = null
	if(implanted_into)
		UnregisterSignal(implanted_into, COMSIG_MOVABLE_MOVED)
		implanted_into = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/gps/attack_self(mob/user, modifiers)
	ui_interact(user)
	if(!is_operational())
		return

	var/turf/T = get_turf(src)
	if(T)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)] [src] flashes <i>[T.x].[rand(0,9)]:[T.y].[rand(0,9)]:[T.z].[rand(0,9)]</i>."))

/obj/item/gps/AltClick(mob/user)
	if(!uses_device_cell || !user.Adjacent(src))
		return ..()
	power_supply.toggle_power(user)

/obj/item/gps/attack_hand(mob/user)
	if(uses_device_cell && user.get_inactive_hand() == src && power_supply?.cell)
		power_supply.eject_cell(user)
		return
	return ..()

/obj/item/gps/attackby(obj/item/attacking_item, mob/user)
	if(uses_device_cell && istype(attacking_item, /obj/item/cell))
		power_supply.install_cell(attacking_item, user)
		return
	return ..()

/obj/item/gps/get_cell()
	return power_supply?.cell

/obj/item/gps/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(uses_device_cell)
		. += "ALT-click to turn the GPS on or off."
		. += "While holding it, click it with your empty hand to remove its device power cell."

/obj/item/gps/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(uses_device_cell && distance <= 1)
		. += "It is switched <b>[power_supply?.powered ? "on" : "off"]</b>."
		if(power_supply?.cell)
			. += "Its power cell has <b>[round(power_supply.cell.percent())]%</b> charge remaining."
		else
			. += SPAN_WARNING("It has no power cell installed.")

/obj/item/gps/proc/is_operational()
	return !emped && (always_powered || power_supply?.powered)

/obj/item/gps/on_device_power_change(powered, mob/user)
	if(powered)
		offline_since = null
		update_position()
	else
		mark_offline()
	if(user)
		balloon_alert(user, "switched [powered ? "on" : "off"]")
	update_icon()
	update_compass(TRUE)
	SStgui.update_uis(src)

/obj/item/gps/on_device_cell_changed()
	update_icon()
	SStgui.update_uis(src)

/obj/item/gps/proc/mark_offline()
	if(!last_broadcast_position || !GLOB.gps_list[gpstag])
		return
	offline_since = world.time
	GLOB.gps_list[gpstag]["powered"] = FALSE
	GLOB.gps_list[gpstag]["offline_since"] = offline_since

/obj/item/gps/proc/expire_offline_position()
	if(is_operational() || !offline_since || world.time < offline_since + 10 MINUTES)
		return
	GLOB.gps_list -= gpstag
	last_broadcast_position = FALSE
	offline_since = null

/obj/item/gps/update_icon()
	ClearOverlays()
	if(emped)
		AddOverlays("emp")
	else if(!is_operational())
		AddOverlays("off")
	else if(held_by || implanted_into)
		AddOverlays("working")
	else
		AddOverlays("confused")

/obj/item/gps/pickup(var/mob/user)
	..()
	if(held_by)
		UnregisterSignal(held_by, COMSIG_MOVABLE_MOVED)
	held_by = user
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(update_position), TRUE)
	update_icon()

/obj/item/gps/dropped(mob/user)
	..()
	if(isturf(loc))
		held_by = null
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	if(user.client)
		user.client.screen -= compass
	update_icon()

/obj/item/gps/on_slotmove(mob/user, slot)
	. = ..()
	if(user.client && !(slot == slot_r_hand || slot == slot_l_hand))
		user.client.screen -= compass

/obj/item/gps/equipped(mob/user, slot)
	. = ..()
	if(user.client && (slot == slot_r_hand || slot == slot_l_hand))
		user.client.screen |= compass

/obj/item/gps/on_module_activate(mob/living/silicon/robot/R)
	..()
	if(R.client)
		R.client.screen |= compass

/obj/item/gps/on_module_deactivate(mob/living/silicon/robot/R)
	..()
	if(R.client)
		R.client.screen -= compass

/obj/item/gps/emp_act(severity)
	. = ..()
	if(uses_device_cell)
		power_supply.emp_act(severity)

	emped = TRUE
	mark_offline()
	addtimer(CALLBACK(src, PROC_REF(post_emp)), 30 SECONDS)
	update_icon()
	update_position()

/obj/item/gps/proc/post_emp()
	emped = FALSE
	update_icon()
	if(is_operational())
		offline_since = null
		update_position()

/obj/item/gps/ui_data(mob/user)
	var/list/data = list()

	data["own_tag"] = gpstag
	data["powered"] = is_operational()
	data["has_cell"] = !!power_supply?.cell
	data["charge"] = power_supply?.cell ? power_supply.cell.percent() : 0
	data["uses_cell"] = uses_device_cell

	var/list/tracking_list = list()
	for(var/tracking_tag in sortList(tracking))
		if(!GLOB.gps_list[tracking_tag]) // Another GPS device has changed its tag or been destroyed
			tracking -= tracking_tag
			continue

		if(AreConnectedZLevels(loc.z, GLOB.gps_list[tracking_tag]["pos_z"]))
			var/list/tracked_gps_data = GLOB.gps_list[tracking_tag]
			var/list/gps_data = tracked_gps_data.Copy()
			gps_data["offline_for"] = gps_data["offline_since"] ? round((world.time - gps_data["offline_since"]) / 10) : 0
			tracking_list += list(list("tag" = tracking_tag , "gps" = gps_data))

	data["tracking_list"] = tracking_list
	data["compass_list"] = tracking_compass

	return data

/obj/item/gps/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GPS", capitalize_first_letters(name), 550, 650)
		ui.open()

/obj/item/gps/process(seconds_per_tick)
	if(uses_device_cell && power_supply?.powered)
		power_supply.use(power_usage_per_second * seconds_per_tick)

	expire_offline_position()
	if(!is_operational() || held_by || implanted_into || (world.time < last_process + process_interval))
		return
	last_process = world.time
	update_position(FALSE)

/obj/item/gps/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_power")
			if(uses_device_cell)
				power_supply.toggle_power(usr)
			return TRUE

	if(!is_operational())
		return FALSE

	switch(action)
		if("tag")
			var/set_tag = uppertext(copytext(sanitize(params["tag"]), 1, 8))

			var/was_tracked // If we were tracking this, we want to keep it on the list with its new tag
			if(gpstag in tracking)
				was_tracked = TRUE
				tracking -= gpstag

			if(loc == usr)
				if(!GLOB.gps_list[set_tag])
					GLOB.gps_list -= gpstag
					gpstag = set_tag
					name = "global positioning system ([gpstag])"
					ui.title = capitalize_first_letters(name)

					update_position()

					if(was_tracked)
						tracking |= gpstag
				else
					to_chat(usr, SPAN_WARNING("This GPS tag already assigned, please choose another."))

			return TRUE

		if("add_tag")
			var/new_tag = uppertext(copytext(sanitize(params["add_tag"]), 1, 8))

			if(GLOB.gps_list[new_tag])
				tracking |= new_tag
				update_compass(TRUE)
			else
				to_chat(usr, SPAN_WARNING("That GPS tag could not be located."))

			return TRUE

		if("remove_tag")
			tracking -= params["remove_tag"]
			update_compass(TRUE)
			return TRUE

		if("add_all")
			tracking.Cut()
			for(var/gps in GLOB.gps_list)
				tracking += GLOB.gps_list[gps]["tag"]
			update_compass(TRUE)
			return TRUE

		if("clear_all")
			tracking.Cut()
			tracking |= gpstag // always want to track ourselves
			update_compass(TRUE)
			return TRUE

		if("compass")
			var/tracking_tag = params["compass"]
			if(LAZYISIN(tracking_compass, tracking_tag))
				LAZYREMOVE(tracking_compass, tracking_tag)
			else
				LAZYADD(tracking_compass, tracking_tag)
			update_compass(TRUE)
			return TRUE

	return FALSE

/obj/item/gps/proc/update_position(var/check_held_by = TRUE)
	if(!is_operational())
		return
	var/turf/T = get_turf(src)
	if(check_held_by && held_by && (held_by.x != T.x || held_by.y != T.y || held_by.z != T.z) && held_by != recursive_loc_turf_check(src, 3, held_by))
		UnregisterSignal(held_by, COMSIG_MOVABLE_MOVED)
		held_by = null
		update_icon()
		return
	var/area/gpsarea = get_area(src)
	var/gps_areaname = get_area_display_name(gpsarea, TRUE, FALSE, FALSE, TRUE)

	// Sanity checking with default locations in case something isn't right with locational data.
	// The GPS will prefer the coordinate of its turf, but if the turf is null it will try the coordinate of whoever is holding it.
	// And if both fail, it'll default to <0,0,0> so we don't crash.
	var/x_coord = 0
	var/y_coord = 0
	var/z_coord = 0
	if (T)
		x_coord = T.x
		y_coord = T.y
		z_coord = T.z
	else if (held_by)
		x_coord = held_by.x
		y_coord = held_by.y
		z_coord = held_by.z

	GLOB.gps_list[gpstag] = list("tag" = gpstag, "pos_x" = x_coord, "pos_y" = y_coord, "pos_z" = z_coord, "area" = "[gps_areaname]", "emped" = emped, "powered" = TRUE, "offline_since" = null, "compass_color" = compass_color)
	tracking |= gpstag
	last_broadcast_position = TRUE
	offline_since = null
	if(check_held_by && held_by && (held_by.get_active_hand() == src || held_by.get_inactive_hand() == src))
		update_compass(TRUE)

/obj/item/gps/proc/update_compass(var/update_compass_icon)
	compass.hide_waypoints(FALSE)
	if(!is_operational())
		compass.rebuild_overlay_lists(update_compass_icon)
		return
	if(LAZYLEN(tracking_compass))
		for(var/tracking_tag in tracking_compass - gpstag)
			if(!GLOB.gps_list[tracking_tag])
				continue
			if(!(tracking_tag in tracking))
				continue
			if(GLOB.gps_list[tracking_tag]["pos_x"] == GLOB.gps_list[gpstag]["pos_x"] && GLOB.gps_list[tracking_tag]["pos_y"] == GLOB.gps_list[gpstag]["pos_y"])
				continue
			compass.set_waypoint(tracking_tag, tracking_tag, GLOB.gps_list[tracking_tag]["pos_x"], GLOB.gps_list[tracking_tag]["pos_y"], GLOB.gps_list[tracking_tag]["pos_z"], GLOB.gps_list[tracking_tag]["compass_color"])
			var/turf/origin = get_turf(src)
			if(!emped && GLOB.gps_list[tracking_tag]["powered"] && !GLOB.gps_list[tracking_tag]["emped"] && origin.z == GLOB.gps_list[tracking_tag]["pos_z"])
				compass.show_waypoint(tracking_tag)
	compass.rebuild_overlay_lists(update_compass_icon)

/obj/item/gps/proc/next_initial_tag()
	if(!LAZYACCESS(gps_count, gps_prefix))
		gps_count[gps_prefix] = 0

	. = "[gps_prefix][gps_count[gps_prefix]++]"

	if(GLOB.gps_list[.]) // if someone has renamed a GPS manually to take this tag already
		. = next_initial_tag()

/obj/item/gps/science
	icon_state = "gps-sci"
	gps_prefix = "SCI"
	compass_color = "#993399"
	gpstag = "SCI0"

/obj/item/gps/engineering
	icon_state = "gps-eng"
	gps_prefix = "ENG"
	compass_color = "#A66300"
	gpstag = "ENG0"

/obj/item/gps/mining
	icon_state = "gps-min"
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "MIN0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."

/obj/item/gps/janitor
	icon_state = "gps-jan"
	gps_prefix = "JAN"
	compass_color = "#6eaa2c"
	gpstag = "JAN0"

/obj/item/gps/medical
	icon_state = "gps-med"
	gps_prefix = "MED"
	compass_color = "#5EABEB"
	gpstag = "MED0"

/obj/item/gps/marooning_equipment
	icon_state = "gps-mar"
	gps_prefix = "MAROON"
	compass_color = "#EAD152"
	gpstag = "MAROON0"

/obj/item/gps/integrated
	uses_device_cell = FALSE
	starts_powered = TRUE
	always_powered = TRUE

/obj/item/gps/integrated/mining
	icon_state = "gps-min"
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "MIN0"
	desc = "An integrated positioning system helpful for locating its synthetic user."

/********** Static GPS Start **********/
// Static GPS
/obj/item/gps/stationary
	name = "static GPS"
	desc = "A static global positioning system."
	anchored = TRUE
	unacidable = TRUE
	layer = BASE_ABOVE_OBJ_LAYER
	gpstag = "STAT0"
	uses_device_cell = FALSE
	starts_powered = TRUE
	always_powered = TRUE

/obj/item/gps/stationary/Initialize()
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	compass = new(src)
	update_position()

	if(ismob(loc))
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(src in H.get_equipped_items())
				held_by = H
			else
				implanted_into = loc
		else if(issilicon(loc))
			held_by = loc
			implanted_into = loc
	else if(istype(loc, /obj/item/robot_module))
		held_by = loc.loc
		implanted_into = loc.loc

	update_icon()

	if(held_by)
		RegisterSignal(held_by, COMSIG_MOVABLE_MOVED, PROC_REF(update_position), TRUE)
	if(implanted_into)
		RegisterSignal(implanted_into, COMSIG_MOVABLE_MOVED, PROC_REF(update_position), TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(update_position))

	for(var/gps in GLOB.gps_list)
		tracking += GLOB.gps_list[gps]["tag"]

	START_PROCESSING(SSprocessing, src)

	return INITIALIZE_HINT_NORMAL

/obj/item/gps/stationary/attack_hand() // Don't let users pick it up.
	return

// Spark
/obj/item/gps/stationary/mining_shuttle
	name = "static GPS (SCCV Spark)"
	desc = "A static global positioning system helpful for finding your way back to the mining shuttle."
	icon_state = "gps-min"
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "SPARK"

// Intrepid
/obj/item/gps/stationary/sccv_intrepid
	name = "static GPS (SCCV Intrepid)"
	desc = "A static global positioning system helpful for finding your way back to the SCCV Intrepid."
	icon_state = "gps-com"
	gps_prefix = "COM"
	compass_color = "#193A7A"
	gpstag = "INTREPID"

/obj/item/gps/stationary/sccv_canary
	name = "static GPS (SCCV Canary)"
	desc = "A static global positioning system helpful for finding your way back to the SCCV Canary."
	icon_state = "gps-com"
	gps_prefix = "COM"
	compass_color = "#57c5e0"
	gpstag = "CANARY"

/obj/item/gps/stationary/sccv_quark
	name = "static GPS (SCCV Quark)"
	desc = "A static global positioning system helpful for finding your way back to the SCCV Quark."
	icon_state = "gps-sci"
	gps_prefix = "SCI"
	compass_color = "#d691ce"
	gpstag = "QUARK"

/********** Static GPS End **********/
