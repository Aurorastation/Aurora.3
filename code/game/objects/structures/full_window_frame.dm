/obj/structure/window_frame
	name = "steel window frame"
	desc = "A steel window frame."
	icon = 'icons/obj/smooth/full_window_frame.dmi'
	icon_state = "window_frame"
	build_amt = 4
	anchored = TRUE
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/simulated/wall,
		/turf/simulated/wall/r_wall,
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty
	)
	var/glass_needed = 4
	var/has_glass_installed = FALSE

/obj/structure/window_frame/cardinal_smooth(adjacencies, var/list/dir_mods)
	LAZYINITLIST(dir_mods)
	var/north_wall = FALSE
	var/east_wall = FALSE
	var/south_wall = FALSE
	var/west_wall = FALSE
	if(adjacencies & N_NORTH)
		var/turf/T = get_step(src, NORTH)
		if(iswall(T))
			dir_mods["[N_NORTH]"] = "-wall"
			north_wall = TRUE
	if(adjacencies & N_EAST)
		var/turf/T = get_step(src, EAST)
		if(iswall(T))
			dir_mods["[N_EAST]"] = "-wall"
			east_wall = TRUE
	if(adjacencies & N_SOUTH)
		var/turf/T = get_step(src, SOUTH)
		if(iswall(T))
			dir_mods["[N_SOUTH]"] = "-wall"
			south_wall = TRUE
	if(adjacencies & N_WEST)
		var/turf/T = get_step(src, WEST)
		if(iswall(T))
			dir_mods["[N_WEST]"] = "-wall"
			west_wall = TRUE
	if(((adjacencies & N_NORTH) && (adjacencies & N_WEST)) && (north_wall || west_wall))
		dir_mods["[N_NORTH][N_WEST]"] = "-n[north_wall ? "wall" : "win"]-w[west_wall ? "wall" : "win"]"
	if(((adjacencies & N_NORTH) && (adjacencies & N_EAST)) && (north_wall || east_wall))
		dir_mods["[N_NORTH][N_EAST]"] = "-n[north_wall ? "wall" : "win"]-e[east_wall ? "wall" : "win"]"
	if(((adjacencies & N_SOUTH) && (adjacencies & N_WEST)) && (south_wall || west_wall))
		dir_mods["[N_SOUTH][N_WEST]"] = "-s[south_wall ? "wall" : "win"]-w[west_wall ? "wall" : "win"]"
	if((adjacencies & N_SOUTH) && (adjacencies & N_EAST) && (south_wall || east_wall))
		dir_mods["[N_SOUTH][N_EAST]"] = "-s[south_wall ? "wall" : "win"]-e[east_wall ? "wall" : "win"]"
	return ..(adjacencies, dir_mods)

/obj/structure/window_frame/proc/update_nearby_icons()
	queue_smooth_neighbors(src)

/obj/structure/window_frame/update_icon()
	queue_smooth(src)

/obj/structure/window_frame/Initialize(mapload) // If the window frame is mapped in, it should be considered to have glass spawned in it by a window spawner.
	if(mapload)
		has_glass_installed = TRUE

/obj/structure/window_frame/unanchored/Initialize() // The unanchored variant should not be considered to have glass in it.
	return

/obj/structure/window_frame/empty/Initialize() // The empty variant should not be considered to have glass in it.
	return

/obj/structure/window_frame/unanchored // Used during in-game construction.
	anchored = FALSE

/obj/structure/window_frame/empty
	// Intentionally left empty.

/obj/structure/window_frame/attackby(obj/item/W, mob/user)
	if((W.isscrewdriver()) && (istype(loc, /turf/simulated) || anchored))
		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("You can't unfasten \the [src] if it has glass installed."))
			return
		var/obj/item/screwdriver/S = W
		if(do_after(user, 2 SECONDS/S.toolspeed))
			playsound(src, S.usesound, 50, TRUE)
			anchored = !anchored
			to_chat(user, SPAN_NOTICE("You [anchored ? "fasten" : "unfasten"] \the [src]."))
			dir = 2
			update_icon()
			update_nearby_icons()
			return

	else if(W.iswelder())
		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("You can't disassemble \the [src] if it has glass installed."))
			return
		if(anchored)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be unanchored to be able to be welded apart."))
			return
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, SPAN_NOTICE("\The [WT] isn't turned on."))
			return
		user.visible_message(
			SPAN_WARNING("\The [user] starts welding \the [src] apart!"),
			SPAN_NOTICE("You start welding \the [src] apart..."),
			"You hear deconstruction."
		)
		playsound(src, 'sound/items/welder.ogg', 50, TRUE)
		if(do_after(user, 2 SECONDS/WT.toolspeed))
			if(!src || !WT.isOn())
				return
			if(WT.remove_fuel(0, user))
				to_chat(user, SPAN_NOTICE("You use \the [WT] to weld apart \the [src]."))
				playsound(src, WT.usesound, 50, 1)
				new /obj/item/stack/material/steel(get_turf(src), 4)
				qdel(src)
				return

	else if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS_REINFORCED && anchored)
		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("\The [src] already has glass installed."))
			return
		var/obj/item/stack/material/G = W
		if(do_after(user, 2 SECONDS))
			if(G.use(glass_needed))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You place the [MATERIAL_GLASS_REINFORCED] in the window frame."))
				new /obj/structure/window/full/reinforced(get_turf(src), constructed = TRUE)
				desc = "A steel window frame."
				has_glass_installed = TRUE
				return
		else
			to_chat(user, SPAN_NOTICE("You need at least [glass_needed] sheets of [MATERIAL_GLASS_REINFORCED] to install a window in \the [src]."))

	else if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS_REINFORCED_PHORON && anchored)
		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("\The [src] already has glass installed."))
			return
		var/obj/item/stack/material/G = W
		if(do_after(user, 2 SECONDS))
			if(G.use(glass_needed))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_WARNING("You place the [MATERIAL_GLASS_REINFORCED_PHORON] in the window frame."))
				new /obj/structure/window/full/phoron/reinforced(get_turf(src), constructed = TRUE)
				desc = "A steel window frame."
				has_glass_installed = TRUE
				return
		else
			to_chat(user, SPAN_WARNING("You need at least [glass_needed] sheets of [MATERIAL_GLASS_REINFORCED_PHORON] to finished the window."))