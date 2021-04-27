/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	var/datum/wires/airlock/blueprint/airlock_wires
	var/datum/wires/vending/blueprint/vending_wires

	var/const/AREA_ERRNONE = 0
	var/const/AREA_STATION = 1
	var/const/AREA_SPACE =   2
	var/const/AREA_SPECIAL = 3

	var/const/BORDER_ERROR = 0
	var/const/BORDER_NONE = 1
	var/const/BORDER_BETWEEN =   2
	var/const/BORDER_2NDTILE = 3
	var/const/BORDER_SPACE = 4

	var/const/ROOM_ERR_LOLWAT = 0
	var/const/ROOM_ERR_SPACE = -1
	var/const/ROOM_ERR_TOOLARGE = -2

	var/list/active_blueprints

/obj/item/blueprints/Initialize(mapload, ...)
	. = ..()
	airlock_wires = new(src)
	vending_wires = new(src)

/obj/item/blueprints/attack_self(mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS))
		return
	add_fingerprint(user)
	interact()

/obj/item/blueprints/equipped(var/mob/user, var/slot)
	. = ..()
	if(slot == slot_l_hand || slot == slot_r_hand)
		START_PROCESSING(SSprocessing, src)
		LAZYINITLIST(active_blueprints)

/obj/item/blueprints/dropped(mob/user)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)
	if(user.client)
		for(var/thing in active_blueprints)
			user.client.images -= thing
	LAZYCLEARLIST(active_blueprints)

/obj/item/blueprints/process()
	var/mob/user = loc
	if(!istype(user))
		return PROCESS_KILL

	var/turf/origin_turf = get_turf(src)

	var/list/new_prints = list()
	for(var/turf/T as anything in RANGE_TURFS(world.view, origin_turf))
		for(var/image/I as anything in T.blueprints)
			new_prints += I

	var/list/update_remove = active_blueprints - new_prints
	active_blueprints = new_prints - update_remove

	for(var/thing in update_remove)
		user.client.images -= thing

	for(var/thing in active_blueprints)
		user.client.images += thing

/obj/item/blueprints/Topic(href, href_list)
	..()
	if(use_check_and_message(usr, USE_DISALLOW_SILICONS) || usr.get_active_hand() != src)
		return
	if(!href_list["action"])
		return
	switch(href_list["action"])
		if ("create_area")
			if(get_area_type() != AREA_SPACE)
				interact()
				return
			create_area()
		if ("edit_area")
			if (get_area_type()!=AREA_STATION)
				interact()
				return
			edit_area()
		if("airlock_wires")
			airlock_wires.get_wire_diagram(usr)
		if("vending_wires")
			vending_wires.get_wire_diagram(usr)

/obj/item/blueprints/interact()
	var/area/A = get_area()
	var/text = {"<HTML><head><title>[src]</title></head><BODY>
				<h2>[station_name()] blueprints</h2>
				<small>Property of [current_map.company_name]. For heads of staff only. Store in high-secure storage.</small><hr>
				"}
	switch (get_area_type())
		if (AREA_SPACE)
			text += {"
					<p>According the blueprints, you are now in <b>outer space</b>.  Hold your breath.</p>
					<p><a href='?src=\ref[src];action=create_area'>Mark this place as new area.</a></p>
					"}
		if (AREA_STATION)
			text += {"
					<p>According the blueprints, you are now in <b>\"[A.name]\"</b>.</p>
					<p>You may <a href='?src=\ref[src];action=edit_area'>
					move an amendment</a> to the drawing.</p>
					"}
		if (AREA_SPECIAL)
			text += {"
						<p>This place isn't noted on the blueprint.</p>
					"}

	text += "<br><a href='?src=\ref[src];action=airlock_wires'>View Airlock Wire Schema</a><br>"
	text += "<br><a href='?src=\ref[src];action=vending_wires'>View Vending Machine Wire Schema</a><br>"

	text += "</BODY></HTML>"

	var/datum/browser/blueprints_win = new(usr, "blueprints", capitalize_first_letters(name))
	blueprints_win.set_content(text)
	blueprints_win.open()


/obj/item/blueprints/proc/get_area()
	var/turf/T = get_turf(usr)
	var/area/A = T.loc
	return A

/obj/item/blueprints/proc/get_area_type(var/area/A = get_area())
	if(istype(A, /area/space) || istype(A, /area/mine/unexplored))
		return AREA_SPACE
	var/list/SPECIALS = list(
		/area/shuttle,
		/area/centcom,
		/area/tdome,
		/area/antag
	)
	for (var/type in SPECIALS)
		if ( istype(A,type) )
			return AREA_SPECIAL
	return AREA_STATION

/obj/item/blueprints/proc/create_area()
	var/res = detect_room(get_turf(usr))
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Error! Please notify administration!</span>")
				return
	var/list/turf/turfs = res
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", ""), MAX_NAME_LEN)
	if(!str || !length(str)) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Name too long.</span>")
		return
	var/area/A = new
	A.name = str
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	move_turfs_to_area(turfs, A)

	A.always_unpowered = 0

	sorted_add_area(A)

	addtimer(CALLBACK(src, .proc/interact), 5)
	return


/obj/item/blueprints/proc/move_turfs_to_area(var/list/turf/turfs, var/area/A)
	A.contents.Add(turfs)
		//oldarea.contents.Remove(usr.loc) // not needed
		//T.forceMove(A) //error: cannot change constant value


/obj/item/blueprints/proc/edit_area()
	var/area/A = get_area()
	var/prevname = "[A.name]"
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", prevname), MAX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Text too long.</span>")
		return
	INVOKE_ASYNC(src, .proc/set_area_machinery_title, A, str, prevname)
	A.name = str
	sortTim(all_areas, /proc/cmp_text_asc)
	to_chat(usr, "<span class='notice'>You set the area '[prevname]' title to '[str]'.</span>")
	interact()
	return



/obj/item/blueprints/proc/set_area_machinery_title(var/area/A,var/title,var/oldtitle)
	if (!oldtitle) // or replacetext goes to infinite loop
		return

	var/static/list/types_to_rename = list(
		/obj/machinery/alarm,
		/obj/machinery/power/apc,
		/obj/machinery/atmospherics/unary/vent_scrubber,
		/obj/machinery/atmospherics/unary/vent_pump,
		/obj/machinery/door
	)

	for(var/obj/machinery/M in A)
		if (is_type_in_list(M, types_to_rename))
			M.name = replacetext(M.name, oldtitle, title)

		CHECK_TICK

/obj/item/blueprints/proc/check_tile_is_border(var/turf/T2,var/dir)
	if (istype(T2, /turf/space) || istype(T2, /turf/unsimulated/floor/asteroid))
		return BORDER_SPACE //omg hull breach we all going to die here
	if (get_area_type(T2.loc)!=AREA_SPACE)
		return BORDER_BETWEEN
	if (istype(T2, /turf/simulated/wall))
		return BORDER_2NDTILE
	if (!istype(T2, /turf/simulated))
		return BORDER_BETWEEN

	for (var/obj/structure/window/W in T2)
		if(turn(dir,180) == W.dir)
			return BORDER_BETWEEN
		if (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir,180) == D.dir)
			return BORDER_BETWEEN
	if (locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE

/obj/item/blueprints/proc/detect_room(var/turf/first)
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		if (found.len+pending.len > 300)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		for (var/dir in cardinal)
			var/skip = 0
			for (var/obj/structure/window/W in T)
				if(dir == W.dir || (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)))
					skip = 1; break
			if (skip) continue
			for(var/obj/machinery/door/window/D in T)
				if(dir == D.dir)
					skip = 1; break
			if (skip) continue

			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue

			switch(check_tile_is_border(NT,dir))
				if(BORDER_NONE)
					pending+=NT
				if(BORDER_BETWEEN)
					//do nothing, may be later i'll add 'rejected' list as optimization
				if(BORDER_2NDTILE)
					found+=NT //tile included to new area, but we dont seek more
				if(BORDER_SPACE)
					return ROOM_ERR_SPACE
		found+=T
	return found
