var/list/GPS_list = list()

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
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
		moved_event.register(held_by, src, /obj/item/device/gps/proc/update_position)
	if(implanted_into)
		moved_event.register(implanted_into, src, /obj/item/device/gps/proc/update_position)
	moved_event.register(src, src, /obj/item/device/gps/proc/update_position)

	for(var/gps in GPS_list)
		tracking += GPS_list[gps]["tag"]

	START_PROCESSING(SSprocessing, src)

/obj/item/device/gps/Destroy()
	GPS_list -= GPS_list[gpstag]
	moved_event.unregister(src, src)
	if(held_by)
		moved_event.unregister(held_by, src)
		held_by = null
	if(implanted_into)
		moved_event.unregister(implanted_into, src)
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
		moved_event.unregister(held_by, src)
	held_by = user
	moved_event.register(user, src, /obj/item/device/gps/proc/update_position)
	update_icon()

/obj/item/device/gps/dropped(var/mob/user)
	..()
	if(isturf(loc))
		held_by = null
		moved_event.unregister(user, src)
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
	emped = TRUE
	addtimer(CALLBACK(src, .proc/post_emp), 30 SECONDS)
	update_icon()
	update_position()

/obj/item/device/gps/proc/post_emp()
	emped = FALSE
	update_icon()
	update_position()

/obj/item/device/gps/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	data["own_tag"] = gpstag

	var/list/tracking_list = list()
	for(var/tracking_tag in sortList(tracking))
		if(!GPS_list[tracking_tag]) // Another GPS device has changed its tag or been destroyed
			tracking -= tracking_tag
			continue

		if(AreConnectedZLevels(loc.z, GPS_list[tracking_tag]["pos_z"]))
			tracking_list[tracking_tag] = (GPS_list[tracking_tag])

	data["tracking_list"] = tracking_list
	data["compass_list"] = tracking_compass

	return data // should update constantly

/obj/item/device/gps/attack_self(mob/user)
	if(!emped)
		ui_interact(user)

/obj/item/device/gps/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "devices-gps-gps", 460, 600, capitalize(name))
		ui.auto_update_content = TRUE
	ui.open()

/obj/item/device/gps/process()
	if(held_by || implanted_into || (world.time < last_process + process_interval))
		return
	update_position(FALSE)

/obj/item/device/gps/Topic(href, href_list)
	..()

	if(href_list["tag"])
		var/set_tag = uppertext(copytext(sanitize(href_list["tag"]), 1, 8))

		var/was_tracked // If we were tracking this, we want to keep it on the list with its new tag
		if(gpstag in tracking)
			was_tracked = TRUE
			tracking -= gpstag

		if(loc == usr)
			if(!GPS_list[set_tag])
				GPS_list -= gpstag
				gpstag = set_tag
				name = "global positioning system ([gpstag])"

				var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
				if(ui)
					ui.title = capitalize(name)

				update_position()

				if(was_tracked)
					tracking |= gpstag
			else
				to_chat(usr, SPAN_WARNING("GPS tag already assigned, choose another."))

		return TRUE

	if(href_list["add_tag"])
		var/new_tag = uppertext(copytext(sanitize(href_list["add_tag"]), 1, 8))

		if(GPS_list[new_tag])
			tracking |= new_tag
			update_compass(TRUE)
		else
			to_chat(usr, "Could not locate GPS tag.")

		return TRUE

	if(href_list["remove_tag"])
		tracking -= href_list["remove_tag"]
		update_compass(TRUE)
		return TRUE

	if(href_list["add_all"])
		tracking.Cut()
		for(var/gps in GPS_list)
			tracking += GPS_list[gps]["tag"]
		update_compass(TRUE)
		return TRUE

	if(href_list["clear_all"])
		tracking.Cut()
		tracking |= gpstag // always want to track ourselves
		update_compass(TRUE)
		return TRUE

	if(href_list["compass"])
		var/tracking_tag = href_list["compass"]
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
		moved_event.unregister(held_by, src)
		held_by = null
		update_icon()
		return
	var/area/gpsarea = get_area(src)
	GPS_list[gpstag] = list("tag" = gpstag, "pos_x" = T.x, "pos_y" = T.y, "pos_z" = T.z, "area" = "[gpsarea.name]", "emped" = emped, "compass_color" = compass_color)
	SSvueui.check_uis_for_change(src)
	if(check_held_by && held_by && (held_by.get_active_hand() == src || held_by.get_inactive_hand() == src))
		update_compass(TRUE)

/obj/item/device/gps/proc/update_compass(var/update_compass_icon)
	compass.hide_waypoints(FALSE)
	if(LAZYLEN(tracking_compass))
		for(var/tracking_tag in tracking_compass - gpstag)
			if(!GPS_list[tracking_tag])
				continue
			if(!(tracking_tag in tracking))
				continue
			if(GPS_list[tracking_tag]["pos_x"] == GPS_list[gpstag]["pos_x"] && GPS_list[tracking_tag]["pos_y"] == GPS_list[gpstag]["pos_y"])
				continue
			compass.set_waypoint(tracking_tag, tracking_tag, GPS_list[tracking_tag]["pos_x"], GPS_list[tracking_tag]["pos_y"], GPS_list[tracking_tag]["pos_z"], GPS_list[tracking_tag]["compass_color"])
			var/turf/origin = get_turf(src)
			if(!emped && !GPS_list[tracking_tag]["emped"] && origin.z == GPS_list[tracking_tag]["pos_z"])
				compass.show_waypoint(tracking_tag)
	compass.rebuild_overlay_lists(update_compass_icon)

/obj/item/device/gps/proc/next_initial_tag()
	if(!LAZYACCESS(gps_count, gps_prefix))
		gps_count[gps_prefix] = 0

	. = "[gps_prefix][gps_count[gps_prefix]++]"

	if(GPS_list[.]) // if someone has renamed a GPS manually to take this tag already
		. = next_initial_tag()

/obj/item/device/gps/science
	icon_state = "gps-s"
	gps_prefix = "SCI"
	compass_color = "#993399"
	gpstag = "SCI0"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gps_prefix = "ENG"
	compass_color = "#A66300"
	gpstag = "ENG0"

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "MIN0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."

/obj/item/device/gps/janitor
	icon_state = "gps-j"
	gps_prefix = "JAN"
	compass_color = "#6eaa2c"
	gpstag = "JAN0"

/obj/item/device/gps/marooning_equipment
	icon_state = "gps-e"
	gps_prefix = "MAROON"
	compass_color = "#EAD152"
	gpstag = "MAROON0"

// Static GPS
/obj/item/device/gps/stationary
	name = "static GPS"
	desc = "A static global positioning system."
	gpstag = "STAT0"

/obj/item/device/gps/stationary/Initialize()
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
		moved_event.register(held_by, src, /obj/item/device/gps/proc/update_position)
	if(implanted_into)
		moved_event.register(implanted_into, src, /obj/item/device/gps/proc/update_position)
	moved_event.register(src, src, /obj/item/device/gps/proc/update_position)

	for(var/gps in GPS_list)
		tracking += GPS_list[gps]["tag"]

	START_PROCESSING(SSprocessing, src)

/obj/item/device/gps/stationary/attack_hand() // Don't let users pick it up.
	return

/obj/item/device/gps/stationary/mining_shuttle
	name = "static GPS (mining shuttle)"
	desc = "A static global positioning system helpful for finding your way back to the mining shuttle."
	icon_state = "gps-m"
	anchored = TRUE
	layer = 2.1
	gps_prefix = "MIN"
	compass_color = "#5F4519"
	gpstag = "MINSHUT"