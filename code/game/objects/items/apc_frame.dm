// APC HULL

/obj/item/frame/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	obj_flags = OBJ_FLAG_CONDUCTABLE

/obj/item/frame/apc/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.iswrench())
		new /obj/item/stack/material/steel( get_turf(src.loc), 2 )
		qdel(src)
		return TRUE
	return ..()

/obj/item/frame/apc/try_build(turf/on_wall, mob/user)
	if(!istype(user))
		stack_trace("APC being built by a non-mob, somehow!")
		return

	if(get_dist(on_wall, user) > 1)
		return

	var/ndir = get_dir(user, on_wall)
	if(!(ndir in GLOB.cardinals))
		to_chat(user, SPAN_WARNING("You need to stand in front of the wall, directly, to build an APC!"))
		return

	var/turf/user_turf = get_turf(user)
	var/area/A = get_area(user)

	if(!istype(user_turf, /turf/simulated/floor))
		to_chat(user, SPAN_WARNING("APC cannot be placed on this spot."))
		return

	if(A.requires_power == 0 || istype(A, /area/space) || istype(A, /area/mine/unexplored) || istype(A, /area/mine/explored))
		to_chat(user, SPAN_WARNING("APC cannot be placed in this area."))
		return

	if(A.get_apc())
		to_chat(user, SPAN_WARNING("This area already has an APC."))
		return //only one APC per area

	for(var/obj/machinery/power/terminal/T in user_turf)
		if (T.master)
			to_chat(user, SPAN_WARNING("There is another network terminal here."))
			return
		else
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(user_turf)
			C.amount = 10
			to_chat(user, "You cut the cables and disassemble the unused power terminal.")
			qdel(T)

	//Select the correct prefab path based on where the mob is facing
	var/apc_path
	switch(ndir)
		if(NORTH)
			apc_path = /obj/machinery/power/apc/north
		if(SOUTH)
			apc_path = /obj/machinery/power/apc/south
		if(EAST)
			apc_path = /obj/machinery/power/apc/east
		if(WEST)
			apc_path = /obj/machinery/power/apc/west

	if(!apc_path)
		stack_trace("APC being built by a non-mob, or somehow the direction grabbing or the cardinal directions are fucked!")
		return

	new apc_path(user_turf, ndir, TRUE)
	qdel(src)
