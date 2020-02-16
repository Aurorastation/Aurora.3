var/list/GPS_list = list()

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	var/gps_prefix = "COM"
	var/gpstag = "COM0"
	var/emped = 0
	var/held_by = null
	var/turf/locked_location
	var/list/tracking = list()
	var/list/static/gps_count = list()

/obj/item/device/gps/Initialize()
	. = ..()
	gpstag = next_initial_tag()
	name = "global positioning system ([gpstag])"
	update_position()
	add_overlay("working")
	moved_event.register(src, src, /obj/item/device/gps/proc/update_position)

	for(var/gps in GPS_list)
		tracking += GPS_list[gps]["tag"]

/obj/item/device/gps/Destroy()
	GPS_list -= GPS_list[gpstag]
	moved_event.unregister(src, src)
	if(held_by)
		moved_event.unregister(held_by, src)
		held_by = null
	return ..()

/obj/item/device/gps/pickup(var/mob/user)
	..()
	held_by = user
	moved_event.register(user, src, /obj/item/device/gps/proc/update_position)

/obj/item/device/gps/dropped(var/mob/user)
	..()
	held_by = null
	moved_event.unregister(user, src)

/obj/item/device/gps/emp_act(severity)
	emped = 1
	cut_overlay("working")
	add_overlay("emp")
	addtimer(CALLBACK(src, .proc/post_emp), 300)
	update_position()

/obj/item/device/gps/proc/post_emp()
	emped = 0
	cut_overlay("emp")
	add_overlay("working")
	update_position()

/obj/item/device/gps/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

<<<<<<< HEAD
	var/obj/item/device/gps/t = ""
	var/gps_window_height = 110 + GPS_list.len * 20 // Variable window height, depending on how many GPS units there are to show
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		t += "<BR>Tag: [gpstag]"
		if(locked_location && locked_location.loc)
			t += "<BR>Bluespace coordinates saved: [locked_location.loc]"
			gps_window_height += 20

		for(var/obj/item/device/gps/G in GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1 || !pos)
				t += "<BR>[tracked_gpstag]: ERROR"
			else
<<<<<<< HEAD
				t += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([pos.x], [pos.y], [pos.z])"
=======
				to_chat(usr, span("warning", "GPS tag already assigned, choose another."))

		return TRUE

	if(href_list["add_tag"])
		var/new_tag = uppertext(copytext(sanitize(href_list["add_tag"]), 1, 8))

		if(GPS_list[new_tag])
			tracking |= new_tag
		else
			to_chat(usr, "Could not locate GPS tag.")

		return TRUE

	if(href_list["remove_tag"])
		tracking -= href_list["remove_tag"]

		return TRUE

	if(href_list["add_all"])
		tracking.Cut()
		for(var/gps in GPS_list)
			tracking += GPS_list[gps]["tag"]
>>>>>>> upstream/master
=======
	data["own_tag"] = gpstag

	var/list/tracking_list = list()
	for(var/tracking_tag in sortList(tracking))
		if(!GPS_list[tracking_tag]) // Another GPS device has changed its tag or been destroyed
			tracking -= tracking_tag
			continue
>>>>>>> parent of 003240027c... Revert "Merge branch 'master' into Bongoborgo-Painted-Robots-V2"

		if(AreConnectedZLevels(loc.z, GPS_list[tracking_tag]["pos_z"]))
			tracking_list[tracking_tag] = (GPS_list[tracking_tag])

	data["tracking_list"] = tracking_list

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

<<<<<<< HEAD
/obj/item/device/gps/Topic(href, href_list)
	..()
<<<<<<< HEAD
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system ([gpstag])"
			attack_self(usr)
=======
=======

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
				to_chat(usr, span("warning", "GPS tag already assigned, choose another."))

		return TRUE

	if(href_list["add_tag"])
		var/new_tag = uppertext(copytext(sanitize(href_list["add_tag"]), 1, 8))
		
		if(GPS_list[new_tag])
			tracking |= new_tag
		else
			to_chat(usr, "Could not locate GPS tag.")
		
		return TRUE

	if(href_list["remove_tag"])
		tracking -= href_list["remove_tag"]

		return TRUE

	if(href_list["add_all"])
		tracking.Cut()
		for(var/gps in GPS_list)
			tracking += GPS_list[gps]["tag"]

		return TRUE

>>>>>>> parent of 003240027c... Revert "Merge branch 'master' into Bongoborgo-Painted-Robots-V2"
	if(href_list["clear_all"])
		tracking.Cut()
		tracking |= gpstag // always want to track ourselves

		return TRUE

	return FALSE

/obj/item/device/gps/proc/update_position()
	var/turf/T = get_turf(src)
<<<<<<< HEAD
	var/area/gpsarea = get_area(src)
	GPS_list[gpstag] = list("tag" = gpstag, "pos_x" = T.x, "pos_y" = T.y, "pos_z" = T.z, "area" = "[gpsarea.name]", "emped" = emped)
=======
	GPS_list[gpstag] = list("tag" = gpstag, "pos_x" = T.x, "pos_y" = T.y, "pos_z" = T.z, "area" = "[get_area(src).name]", "emped" = emped)
>>>>>>> parent of 003240027c... Revert "Merge branch 'master' into Bongoborgo-Painted-Robots-V2"
	SSvueui.check_uis_for_change(src)

/obj/item/device/gps/proc/next_initial_tag()
	if(!LAZYACCESS(gps_count, gps_prefix))
		gps_count[gps_prefix] = 0

	. = "[gps_prefix][gps_count[gps_prefix]++]"

	if(GPS_list[.]) // if someone has renamed a GPS manually to take this tag already
		. = next_initial_tag()
<<<<<<< HEAD
>>>>>>> upstream/master
=======
>>>>>>> parent of 003240027c... Revert "Merge branch 'master' into Bongoborgo-Painted-Robots-V2"

/obj/item/device/gps/science
	icon_state = "gps-s"
	gps_prefix = "SCI"
	gpstag = "SCI0"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gps_prefix = "ENG"
	gpstag = "ENG0"

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gps_prefix = "MIN"
	gpstag = "MIN0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."
