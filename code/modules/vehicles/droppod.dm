/obj/vehicle/droppod
	name = "drop pod"
	desc = "A big metal pod, what could be inside?"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "droppod"
	dir = SOUTH
	layer = MOB_LAYER - 0.1

	load_item_visible = 0
	health = 500 // pretty strong because it can't move or be shot out of
	maxhealth = 500

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/list/validfirelocations = list(1, 7) // above the station and at the centcomm z-level.

	var/used = 0

	var/mob/humanload
	var/mob/passenger

/obj/vehicle/droppod/legion
	name = "legion drop pod"
	desc = "A big metal pod painted in the colors of the Tau Ceti Foreign Legion."
	icon_state = "legion_pod"

/obj/vehicle/droppod/Initialize()
	. = ..()

/obj/vehicle/droppod/emag_act()
	return

/obj/vehicle/droppod/Move()
	return

/obj/vehicle/droppod/verb/launchinterface()
	set src in oview(1)
	set category = "Vehicle"
	set name = "Open launch interface"

	ui_interact(usr)

/obj/vehicle/droppod/verb/eject()
	set src in oview(1)
	set category = "Vehicle"
	set name = "Open Pod"

	if(!usr.canmove || usr.stat || usr.restrained())
		return
	unload(usr)

/obj/vehicle/droppod/load(var/mob/C) // this won't call the parent proc due to the differences and the fact it doesn't use load. Also only mobs can be loaded.
	if(!ismob(C))
		return 0
	if(!isturf(C.loc))
		return 0
	if((humanload && passenger) || C.anchored)
		return 0
	if(humanload)
		passenger = C
	else
		humanload = C

	C.forceMove(src)

	C.set_dir(dir)
	C.anchored = 1

	user_buckle_mob(C, C)
	icon_state = initial(icon_state)
	return 1

/obj/vehicle/droppod/unload(var/mob/user, var/direction) // this also won't call the parent proc because it relies on load and doesn't expect a 2nd person
	if(!(humanload || passenger))
		return 0

	var/turf/dest = null

	if(direction)
		dest = get_step(src, direction)
	else if(user)
		dest = get_turf(src)
	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90)))

	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && user.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)

	if(!isturf(dest))
		return 0

	for(var/a in contents)
		if(isliving(a))
			var/mob/living/L = a
			L.forceMove(dest)
			L.set_dir(get_dir(loc, dest))
			L.anchored = 0
			L.pixel_x = initial(user.pixel_x)
			L.pixel_y = initial(user.pixel_y)
			L.layer = initial(user.layer)
			user_unbuckle_mob(L, L)
		else if(istype(a, /obj))
			var/obj/O = a
			O.forceMove(src.loc)

	humanload = null
	passenger = null
	icon_state = "[initial(icon_state)]_open"
	return 1

/obj/vehicle/droppod/attack_hand(mob/user as mob)
	..()
	if(user == humanload || user == passenger)
		unload(user)
	else
		load(user)

/obj/vehicle/droppod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/data[0]
	data["used"] = used

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "droppod.tmpl", "Drop Pod", 400, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/vehicle/droppod/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["fire"])
		var/area/A = null
		var/target = href_list["fire"]
		switch(target)
			if("arrivals")
				A = pick(/area/hallway/secondary/entry/fore, /area/hallway/secondary/entry/port, /area/hallway/secondary/entry/starboard, /area/hallway/secondary/entry/aft, /area/maintenance/arrivals)
			if("cargo")
				A = pick(/area/quartermaster/loading, /area/quartermaster/qm)
			if("tcoms")
				A = pick(/area/tcommsat/entrance, /area/turret_protected/tcomfoyer, /area/turret_protected/tcomwest, /area/turret_protected/tcomeast, /area/tcommsat/computer, /area/tcommsat/powercontrol)
			if("commandescape")
				A = /area/bridge/levela
		if(A)
			firefromarea(A)

/obj/vehicle/droppod/proc/firefromarea(var/area/A)

	var/turf/targetturf = pick_area_turf(A)
	if(iswall(targetturf))
		ermessage(0,2)
		firefromarea(A)
	else
		fire(targetturf)

/obj/vehicle/droppod/proc/fire(var/turf/A)
	if(!isturf(A))
		ermessage()
		return

	if(!(src.z in validfirelocations))
		ermessage(1, 1)
		return

	var/turf/aboveturf = GetAbove(A)
	if(aboveturf)
		if(aboveturf.is_hole)
			A.visible_message("<span class='danger'>The [src] drops through the hole in the roof!</span>")
			applyfalldamage(A)
			forceMove(aboveturf)
		else
			applyfalldamage(aboveturf)
			aboveturf.ChangeTurf(/turf/simulated/floor/foamedmetal)

			for(var/turf/T in range(1, aboveturf))
				if(turf_clear(T))
					new /obj/structure/foamedmetal(T, src)

			applyfalldamage(A)
			forceMove(A)
			explosion(A, 0, 0, 2, 2)
			A.visible_message("<span class='danger'> \The [src] crashes through the roof!</span>")

		var/turf/belowturf = GetBelow(A)
		if(belowturf)
			//sound here
			belowturf.visible_message("<span class='danger'>You hear something crash into the ceiling above!</span>")

		used = 1

/obj/vehicle/droppod/proc/applyfalldamage(var/turf/A)
	for(var/mob/T in A)
		if(T.simulated)
			T.gib()
			T.visible_message("<span class='danger'>[T] is squished by the drop pod!</span>")
	for(var/obj/B in A)
		if(B.simulated)
			qdel(B)
			B.visible_message("<span class='danger'>[B] is destroyed by the drop pod!</span>")

/obj/vehicle/droppod/proc/ermessage(var/type = 0, var/subtype = 0)
	if(!type)
		if(!subtype)
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
			visible_message("<span class='warning'>\The [src]'s screen flashes an error!</span>")
		else if(subtype == 1)
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
			visible_message("<span class='warning'>\The [src]'s screen flashes an error reading 'Invalid location to launch from!'</span>")
		else if(subtype == 2)
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
			visible_message("<span class='warning'>Target location blocked... Rerouting...</span>")
	else
		if(subtype == 1)
			visible_message("<span class='notice'>\The [src]'s screen flashes a message reading 'Launch coordinates verified.'</span>")
		else if(subtype == 2)
			visible_message("<span class='notice'>The [src]'s screen flashes a message reading 'Laucnhing.'</span>")
