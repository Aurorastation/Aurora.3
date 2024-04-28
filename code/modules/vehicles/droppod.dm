#define READY 0
#define USED 1
#define LAUNCHING 2

/obj/vehicle/droppod
	name = "drop pod"
	desc = "A big metal pod, what could be inside?"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "droppod"
	dir = SOUTH
	light_range = 0

	load_item_visible = 0
	health = 500 // pretty strong because it can't move or be shot out of
	maxhealth = 500

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/status = READY

	var/mob/humanload
	var/mob/passenger

	var/connected_blastdoor //Connect a blast door's _wifi_id here to have it close when the droppod is launched.

/obj/vehicle/droppod/legion
	name = "legion drop pod"
	desc = "A big metal pod painted in the colors of the Tau Ceti Foreign Legion."
	icon_state = "legion_pod"

/obj/vehicle/droppod/syndie
	desc = "A high-tech titanium pod, capable of transporting its passenger right into the action at considerable ranges. The metal foam dispensers lining the top prevent most hull breaches on station ingress."
	icon_state = "syndie_pod"

/obj/vehicle/droppod/MouseDrop()
	return

/obj/vehicle/droppod/MouseDrop_T()
	return

/obj/vehicle/droppod/emag_act()
	return

/obj/vehicle/droppod/Move()
	return

/obj/vehicle/droppod/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswelder() && status == USED && !humanload && !passenger)
		var/obj/item/weldingtool/W = attacking_item
		if(W.welding)
			src.visible_message(SPAN_NOTICE("[user] starts cutting \the [src] apart."))
			if(attacking_item.use_tool(src, user, 200, volume = 50))
				src.visible_message(SPAN_DANGER("\The [src] is cut apart by [user]!"))
				new /obj/item/stack/material/titanium(src.loc, 10)
				new /obj/item/stack/material/plasteel(src.loc, 10)
				var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(src.loc)
				C.amount = rand(5,15)
				qdel(src)
	else
		return ..()

/obj/vehicle/droppod/verb/launchinterface()
	set src in oview(1)
	set category = "Vehicle"
	set name = "Open launch interface"

	if(status == READY)
		ui_interact(usr)

/obj/vehicle/droppod/verb/eject()
	set src in oview(1)
	set category = "Vehicle"
	set name = "Eject Pod"

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

	user_buckle(C, C)
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
		for(var/test_dir in GLOB.alldirs)
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
			user_unbuckle(L, L)
		else if(istype(a, /obj))
			var/obj/O = a
			O.forceMove(src.loc)

	humanload = null
	passenger = null
	icon_state = "[initial(icon_state)]_open"
	return 1

/obj/vehicle/droppod/attack_hand(mob/user as mob)
	..()
	if(isobserver(user))
		return
	if(user == humanload || user == passenger)
		if(status != USED)
			launchinterface()
		else
			unload(user)
	else if ((!humanload || !passenger) && status != USED)
		load(user)
		launchinterface()

/obj/vehicle/droppod/attack_ghost(mob/user)
	if(isobserver(user) && check_rights(R_ADMIN, FALSE, user))
		..()
	else // normal ghosts cannot use this
		return

/obj/vehicle/droppod/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DropPod", "Drop Pod", 400, 400)
		ui.open()

/obj/vehicle/droppod/ui_state(mob/user)
	return GLOB.always_state

/obj/vehicle/droppod/ui_data(mob/user)
	var/list/data = list()

	data["status"] = status

	return data

/obj/vehicle/droppod/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "fire")
		var/area/A = null
		var/target = params["fire"]
		switch(target)
			if("recreational_areas")
				var/list/recreational_areas_list = list(
					/area/horizon/crew_quarters/fitness/hallway = 25,
					/area/horizon/crew_quarters/fitness/changing = 25,
					/area/horizon/crew_quarters/fitness/pool = 25,
					/area/horizon/crew_quarters/fitness/gym = 25
					)
				A = pickweight(recreational_areas_list)
			if("operations")
				var/list/ops_list = list(
					/area/operations/break_room = 15,
					/area/maintenance/wing/starboard = 20,
					/area/maintenance/wing/starboard/deck1 = 20,
					/area/operations/office = 10,
					/area/operations/storage = 15,
					/area/outpost/mining_main/refinery = 20
					)
				A = pickweight(ops_list)
			if("starboard_wing")
				var/list/starboard_wing_list = list(
					/area/maintenance/wing/starboard = 50,
					/area/maintenance/wing/starboard/far = 50
					)
				A = pickweight(starboard_wing_list)
		if(A)
			var/mob/user = usr
			if(!(user in src))
				if(alert(user, "WARNING: You are not in the droppod! Are you sure you wish to launch?", "Launch Confirmation", "Yes", "No") == "No")
					return
			status = LAUNCHING

			SStgui.close_uis(src)

			if(connected_blastdoor)
				blastdoor_interact()

			fire_at_area(A)

/obj/vehicle/droppod/proc/fire_at_area(var/area/A)

	var/list/area_turfs = get_area_turfs(A, null, 0, FALSE)
	var/list/turf_selection = list()

	for(var/turf/T in area_turfs)
		var/obstacle_found = FALSE
		if(!iswall(T))
			for(var/obj/O in T)
				if(istype(O, /obj/structure/grille) || istype(O, /obj/machinery/door/airlock/external) || istype(O, /obj/machinery/embedded_controller)) //This is to help prevent the pod from landing right on an exterior window or airlock.
					obstacle_found = TRUE
					break
			if(!obstacle_found)
				turf_selection += T
			else
				obstacle_found = FALSE

	if(!length(turf_selection)) //If the list of turfs is empty then the pick below would runtime and break the pod.
		pod_error()
		return

	var/target_turf = pick(turf_selection)
	if(!target_turf)
		pod_error()
		return
	fire(target_turf)

/obj/vehicle/droppod/proc/pod_error()
	playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
	visible_message(SPAN_WARNING("\The [src]'s screen displays an error: Targeting module malfunction. Attempt relaunch."))
	status = READY
	if(connected_blastdoor)
		blastdoor_interact(TRUE)

/obj/vehicle/droppod/proc/fire(var/turf/A)
	if(!isturf(A))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
		visible_message(SPAN_WARNING("\The [src]'s screen displays an error: Targeting module malfunction. Attempt relaunch."))
		status = READY
		if(connected_blastdoor)
			blastdoor_interact(TRUE)
		return

	var/turf/aboveturf = GetAbove(A)
	if(aboveturf)
		applyfalldamage(aboveturf)
		aboveturf.ChangeTurf(/turf/simulated/floor/foamedmetal)
		for(var/turf/T in range(1, aboveturf))
			if(turf_clear(T))
				new /obj/structure/foamedmetal(T, src)
	applyfalldamage(A)
	explosion(A, 0, 0, 2, 2)
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, A)
	S.start()
	if(humanload)
		var/mob/M = humanload
		shake_camera(M, 5, 1)
	forceMove(A)
	set_light(5,1,LIGHT_COLOR_EMERGENCY_SOFT)
	A.visible_message(SPAN_DANGER("\The [src] crashes through the roof!"))

	var/turf/belowturf = GetBelow(A)
	if(belowturf)
		belowturf.visible_message(SPAN_DANGER("You hear something crash into the ceiling above!"))
	status = USED

/obj/vehicle/droppod/proc/applyfalldamage(var/turf/A)
	for(var/mob/T in A)
		if(T.simulated)
			T.gib()
			T.visible_message(SPAN_DANGER("[T] is squished by the drop pod!"))
	for(var/obj/B in A)
		if(B.simulated && B.density)
			qdel(B)
			B.visible_message(SPAN_DANGER("[B] is destroyed by the drop pod!"))

/obj/vehicle/droppod/proc/blastdoor_interact(var/open)
	var/datum/wifi/sender/door/wifi_sender_blast = new(connected_blastdoor, src)
	if(open)
		wifi_sender_blast.activate("open")
	else
		wifi_sender_blast.activate("close")
		var/turf/T = src.loc
		T.ChangeTurf(/turf/space)

#undef READY
#undef USED
#undef LAUNCHING
