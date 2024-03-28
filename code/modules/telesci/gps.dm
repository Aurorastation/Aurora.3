GLOBAL_LIST_EMPTY(gps_list)

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-com"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	var/gps_prefix = "COM"
	var/gpstag = "COM0"
	var/compass_color = "#193A7A"

	var/emped = FALSE

	var/mob/held_by = null
	var/mob/implanted_into = null
	var/turf/locked_location

	var/list/tracking = list()
	var/list/tracking_compass
	var/obj/compass_holder/compass
	var/list/static/gps_count = list()

	var/process_interval = 6 SECONDS
	var/last_process = 0

/obj/item/device/gps/Initialize()
	. = ..()
	compass = new(src)
	gpstag = next_initial_tag()
	name = "global positioning system ([gpstag])"
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
		GLOB.moved_event.register(held_by, src, PROC_REF(update_position))
	if(implanted_into)
		GLOB.moved_event.register(implanted_into, src, PROC_REF(update_position))
	GLOB.moved_event.register(src, src, PROC_REF(update_position))

	for(var/gps in GLOB.gps_list)
		tracking += GLOB.gps_list[gps]["tag"]

	START_PROCESSING(SSprocessing, src)

/obj/item/device/gps/Destroy()
	GLOB.gps_list -= GLOB.gps_list[gpstag]
	GLOB.moved_event.unregister(src, src)
	if(held_by)
		GLOB.moved_event.unregister(held_by, src)
		held_by = null
	if(implanted_into)
		GLOB.moved_event.unregister(implanted_into, src)
		implanted_into = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/device/gps/update_icon()
	cut_overlays()
	if(emped)
		add_overlay("emp")
	else if(held_by || implanted_into)
		add_overlay("working")
	else
		add_overlay("confused")

/obj/item/device/gps/pickup(var/mob/user)
	..()
	if(held_by)
		GLOB.moved_event.unregister(held_by, src)
	held_by = user
	GLOB.moved_event.register(user, src, PROC_REF(update_position))
	update_icon()

/obj/item/device/gps/dropped(mob/user)
	..()
	if(isturf(loc))
		held_by = null
		GLOB.moved_event.unregister(user, src)
	if(user.client)
		user.client.screen -= compass
	update_icon()

/obj/item/device/gps/on_slotmove(mob/user, slot)
	. = ..()
	if(user.client && !(slot == slot_r_hand || slot == slot_l_hand))
		user.client.screen -= compass

/obj/item/device/gps/equipped(mob/user, slot)
	. = ..()
	if(user.client && (slot == slot_r_hand || slot == slot_l_hand))
		user.client.screen |= compass

/obj/item/device/gps/on_module_activate(mob/living/silicon/robot/R)
	..()
	if(R.client)
		R.client.screen |= compass

/obj/item/device/gps/on_module_deactivate(mob/living/silicon/robot/R)
	..()
	if(R.client)
		R.client.screen -= compass

/obj/item/device/gps/emp_act(severity)
	. = ..()

	emped = TRUE
	addtimer(CALLBACK(src, PROC_REF(post_emp)), 30 SECONDS)
	update_icon()
	update_position()

/obj/item/device/gps/proc/post_emp()
	emped = FALSE
	update_icon()
	update_position()

/obj/item/device/gps/ui_data(mob/user)
	var/list/data = list()

	data["own_tag"] = gpstag

	var/list/tracking_list = list()
	for(var/tracking_tag in sortList(tracking))
		if(!GLOB.gps_list[tracking_tag]) // Another GPS device has changed its tag or been destroyed
			tracking -= tracking_tag
			continue

		if(AreConnectedZLevels(loc.z, GLOB.gps_list[tracking_tag]["pos_z"]))
			tracking_list += list(list("tag" = tracking_tag , "gps" = (GLOB.gps_list[tracking_tag])))

	data["tracking_list"] = tracking_list
	data["compass_list"] = tracking_compass

	return data

/obj/item/device/gps/attack_self(mob/user)
	if(!emped)
		ui_interact(user)

/obj/item/device/gps/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GPS", capitalize_first_letters(name), 460, 600)
		ui.open()

/obj/item/device/gps/process()
	if(held_by || implanted_into || (world.time < last_process + process_interval))
		return
	update_position(FALSE)

/obj/item/device/gps/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

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

/obj/item/device/gps/proc/update_position(var/check_held_by = TRUE)
	var/turf/T = get_turf(src)
	if(check_held_by && held_by && (held_by.x != T.x || held_by.y != T.y || held_by.z != T.z) && held_by != recursive_loc_turf_check(src, 3, held_by))
		GLOB.moved_event.unregister(held_by, src)
		held_by = null
		update_icon()
		return
	var/area/gpsarea = get_area(src)
	GLOB.gps_list[gpstag] = list("tag" = gpstag, "pos_x" = T.x, "pos_y" = T.y, "pos_z" = T.z, "area" = "[gpsarea.name]", "emped" = emped, "compass_color" = compass_color)
	if(check_held_by && held_by && (held_by.get_active_hand() == src || held_by.get_inactive_hand() == src))
		update_compass(TRUE)

/obj/item/device/gps/proc/update_compass(var/update_compass_icon)
	compass.hide_waypoints(FALSE)
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
			if(!emped && !GLOB.gps_list[tracking_tag]["emped"] && origin.z == GLOB.gps_list[tracking_tag]["pos_z"])
				compass.show_waypoint(tracking_tag)
	compass.rebuild_overlay_lists(update_compass_icon)

/obj/item/device/gps/proc/next_initial_tag()
	if(!LAZYACCESS(gps_count, gps_prefix))
		gps_count[gps_prefix] = 0

	. = "[gps_prefix][gps_count[gps_prefix]++]"

	if(GLOB.gps_list[.]) // if someone has renamed a GPS manually to take this tag already
		. = next_initial_tag()

/obj/item/device/gps/science
	icon_state = "gps-sci"
	gps_prefix = "SCI"
	compass_color = "#993399"
	gpstag = "SCI0"

/obj/item/device/gps/engineering
	icon_state = "gps-eng"
	gps_prefix = "ENG"
	compass_color = "#A66300"
	gpstag = "ENG0"

/obj/item/device/gps/mining
	icon_state = "gps-min"
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "MIN0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."

/obj/item/device/gps/janitor
	icon_state = "gps-jan"
	gps_prefix = "JAN"
	compass_color = "#6eaa2c"
	gpstag = "JAN0"

/obj/item/device/gps/medical
	icon_state = "gps-med"
	gps_prefix = "MED"
	compass_color = "#5EABEB"
	gpstag = "MED0"

/obj/item/device/gps/marooning_equipment
	icon_state = "gps-mar"
	gps_prefix = "MAROON"
	compass_color = "#EAD152"
	gpstag = "MAROON0"

/********** Static GPS Start **********/
// Static GPS
/obj/item/device/gps/stationary
	name = "static GPS"
	desc = "A static global positioning system."
	anchored = TRUE
	unacidable = TRUE
	layer = BASE_ABOVE_OBJ_LAYER
	gpstag = "STAT0"

/obj/item/device/gps/stationary/Initialize()
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
		GLOB.moved_event.register(held_by, src, PROC_REF(update_position))
	if(implanted_into)
		GLOB.moved_event.register(implanted_into, src, PROC_REF(update_position))
	GLOB.moved_event.register(src, src, PROC_REF(update_position))

	for(var/gps in GLOB.gps_list)
		tracking += GLOB.gps_list[gps]["tag"]

	START_PROCESSING(SSprocessing, src)

	return INITIALIZE_HINT_NORMAL

/obj/item/device/gps/stationary/attack_hand() // Don't let users pick it up.
	return

// Spark
/obj/item/device/gps/stationary/mining_shuttle
	name = "static GPS (SCCV Spark)"
	desc = "A static global positioning system helpful for finding your way back to the mining shuttle."
	icon_state = "gps-min"
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "SPARK"

// Intrepid
/obj/item/device/gps/stationary/sccv_intrepid
	name = "static GPS (SCCV Intrepid)"
	desc = "A static global positioning system helpful for finding your way back to the SCCV Intrepid."
	icon_state = "gps-com"
	gps_prefix = "COM"
	compass_color = "#193A7A"
	gpstag = "INTREPID"

/obj/item/device/gps/stationary/sccv_canary
	name = "static GPS (SCCV Canary)"
	desc = "A static global positioning system helpful for finding your way back to the SCCV Canary."
	icon_state = "gps-com"
	gps_prefix = "COM"
	compass_color = "#57c5e0"
	gpstag = "CANARY"
/********** Static GPS End **********/
