/mob/abstract/observer/shuttle
	name = "shuttle coordinates"
	var/datum/shuttle/S
	var/list/Turfs_changed
	var/datum/weakref/mainbody
	var/usedView = FALSE
	see_in_dark = 100

/mob/abstract/observer/shuttle/verb/view_shuttle()
	set category = "Shuttle"
	set name = "Display shuttle dimensions"
	if(!S)
		return

	var/turf/source_T = get_turf(src)
	if(!source_T)
		return
	Turfs_changed = list()
	view_shuttle_clear()

	var/icon/blue = new('icons/misc/debug_group.dmi', "blue")
	var/icon/red = new('icons/misc/debug_group.dmi', "red")
	
	for(var/v in S.exterior_walls_and_engines)
		var/list/l = v
		var/turf/T = get_turf(locate(source_T.x + l[1] - S.center[1], source_T.y + l[2] - S.center[2], source_T.z))
		var/airlock = FALSE
		for(var/x in get_turf(locate(l[1], l[2], l[3])))
			if(istype(x, /obj/machinery/door/airlock/external))
				client.images += image(red, T,"shuttle", TURF_LAYER)
				airlock = TRUE
				break
		if(!airlock)
			client.images += image(blue, T,"shuttle", TURF_LAYER)
		Turfs_changed += T

		CHECK_TICK
	
	if(!usedView)
		to_chat(usr, "Shuttle Landing site")
		to_chat(usr, "Blue = Shuttle dimensions")
		to_chat(usr, "Red = Shuttle Airlocks")
		usedView = 1

/mob/abstract/observer/shuttle/verb/exit_view()
	set category = "Shuttle"
	set name = "Exit Shuttle view"
	if(!mainbody)
		return
	
	var/mob/living/ref = mainbody.resolve()
	if(!ref)
		to_chat(src, "You do not have a body to return to.")
		return

	ref.client = src.client
	ref.client.view = world.view
	qdel(src)

/mob/abstract/observer/shuttle/proc/view_shuttle_clear()
	if(client.images.len)
		for(var/image/i in client.images)
			if(i.icon_state == "shuttle")
				client.images.Remove(i)

/mob/abstract/observer/shuttle/updateghostsight()
	sight &= ~(SEE_MOBS | SEE_OBJS)
	see_in_dark = 100
	updateghostimages()