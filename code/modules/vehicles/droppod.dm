/obj/vehicle/droppod
	name = "drop-pod"
	desc = "idk"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH

	load_item_visible = 0
	health = 500 // pretty strong because it can't move or be shot out of
	maxhealth = 500

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/list/validfirelocations = list(7)

	var/used = 0
	var/atom/movable/passenger // two seater

	var/area/targetlocation = null
	var/list/protrectedareas = list(/area/hallway/secondary/entry/dock, /area/crew_quarters/sleep/cryo, /area/crew_quarters/sleep/bedrooms)

/obj/vehicle/droppod/Initialize()
	. = ..()

/obj/vehicle/droppod/emag_act()
	return

/obj/vehicle/droppod/Move()
	return

/obj/vehicle/droppod/load(var/atom/movable/C) // this won't call the parent load proc becasue it doesn't support 2 people.
	if(!isturf(C.loc)) 
		return 0
	if((load && passenger) || C.anchored)
		return 0

	var/obj/structure/closet/crate = C
	if(istype(crate))
		return

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	if(load)
		passenger = C
	else
		load = C

	if(ismob(C))
		buckle_mob(C)
	return 1

/obj/vehicle/droppod/attack_hand(mob/user as mob)
	..()
	if(user == (load || passenger))
		ui_interact()
	else
		load(user)

/obj/vehicle/droppod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/data[0]

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "droppod.tmpl", "Drop Pod", 400, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/vehicle/droppod/proc/firefromarea(var/area/A)
	if(A in protrectedareas)
		ermessage()
		return

	var/turf/targetturf = pick_area_turf(A)
	if(iswall(targetturf))
		ermessage(0,2)
		firefromarea(A)
	else
		fire(targetturf)

/obj/vehicle/droppod/proc/fire(var/turf/A)
	if(!isturf(A))
		world << "not a turf"
		ermessage()
		return

	if(!(src.z in validfirelocations))
		ermessage(1, 1)

	var/turf/aboveturf = GetAbove(A)
	world << "Above turf is [aboveturf]"
	if(aboveturf)
		if(aboveturf.is_hole)
			visible_message("<span class='danger'>The [src] drops through the hole in the roof!</span>")
			applyfalldamage(A)
			forceMove(aboveturf)
		else
			applyfalldamage(aboveturf)
			aboveturf.ChangeTurf(/turf/space)
			applyfalldamage(A)
			visible_message("<span class='danger'>The [src] crashes through the roof!</span>")
			forceMove(A)
		
		var/turf/belowturf = GetBelow(A)
		if(belowturf)
			//sound here
			belowturf.visible_message("<span class='danger'>You hear something crash into the ceiling above!</span>")

		if(load)
			load.forceMove(loc)

		if(passenger)
			passenger.forceMove(loc)

/obj/vehicle/droppod/proc/applyfalldamage(var/turf/A)
	for(var/mob/T in A)
		T.gib()
		T.visible_message("<span class='danger'>[T] is squished by the drop pod!</span>")
	for(var/obj/B in A)
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
