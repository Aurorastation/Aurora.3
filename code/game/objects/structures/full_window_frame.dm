/obj/structure/window_frame
	name = "steel window frame"
	desc = "A steel window frame."
	icon = 'icons/obj/smooth/window/full_window_frame_color.dmi'
	icon_state = "window_frame"
	color = COLOR_GRAY20
	build_amt = 4
	layer = WINDOW_FRAME_LAYER
	anchored = TRUE
	density = TRUE
	climbable = TRUE
	smoothing_flags = SMOOTH_MORE
	breakable = TRUE
	can_be_unanchored = TRUE
	canSmoothWith = list(
		/turf/simulated/wall,
		/turf/simulated/wall/r_wall,
		/turf/simulated/wall/shuttle/scc_space_ship,
		/turf/unsimulated/wall/steel, // Centcomm wall.
		/turf/unsimulated/wall/darkshuttlewall, // Centcomm wall.
		/turf/unsimulated/wall/riveted, // Centcomm wall.
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty,
		/obj/machinery/door
	)
	blend_overlay = "wall"
	can_blend_with = list(
		/turf/simulated/wall,
		/obj/machinery/door
	)
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/should_check_mapload = TRUE
	var/has_glass_installed = FALSE
	var/has_grille_installed = FALSE
	var/glass_needed = 4
	var/rods_needed = 2

/obj/structure/window_frame/cardinal_smooth(adjacencies, var/list/dir_mods)
	dir_mods = handle_blending(adjacencies, dir_mods)
	return ..(adjacencies, dir_mods)

/obj/structure/window_frame/Initialize(mapload) // If the window frame is mapped in, it should be considered to have glass spawned in it by a window spawner.
	. = ..()
	if(mapload && should_check_mapload)
		has_glass_installed = TRUE

/obj/structure/window_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height == 0))
		return TRUE
	if(istype(mover, /obj/structure/closet/crate))
		return TRUE
	if(istype(mover) && mover.pass_flags & PASSTABLE)
		return TRUE
	if(locate(/obj/structure/window_frame) in get_turf(mover))
		return TRUE
	return FALSE

/obj/structure/window_frame/attackby(obj/item/attacking_item, mob/user)
	if((attacking_item.isscrewdriver()) && (istype(loc, /turf/simulated) || anchored))
		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("You can't unfasten \the [src] if it has glass installed."))
			return
		if(anchored)
			if(attacking_item.use_tool(src, user, 2 SECONDS, volume = 50))
				anchored = FALSE
				to_chat(user, SPAN_NOTICE("You unfasten \the [src]."))
				update_icon()
				update_nearby_icons()
				return
		else
			if(attacking_item.use_tool(src, user, 2 SECONDS, volume = 50))
				anchored = TRUE
				to_chat(user, SPAN_NOTICE("You fasten \the [src]."))
				dir = 2
				update_icon()
				update_nearby_icons()
				return

	else if(attacking_item.iswelder())
		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("You can't disassemble \the [src] if it has glass installed."))
			return
		if(anchored)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be unanchored to be able to be welded apart."))
			return
		var/obj/item/weldingtool/WT = attacking_item
		if(!WT.isOn())
			to_chat(user, SPAN_NOTICE("\The [WT] isn't turned on."))
			return
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_WARNING("\The [user] starts welding \the [src] apart!"),
			SPAN_NOTICE("You start welding \the [src] apart..."),
			"You hear deconstruction."
		)
		if(attacking_item.use_tool(src, user, 2 SECONDS, volume = 50))
			if(!src || !WT.isOn())
				return
			if(WT.use(0, user))
				to_chat(user, SPAN_NOTICE("You use \the [WT] to weld apart \the [src]."))
				WT.play_tool_sound(get_turf(src), 50)
				new /obj/item/stack/material/steel(get_turf(src), 4)
				qdel(src)
				return

	else if(istype(attacking_item, /obj/item/stack/material))
		if(!anchored)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be anchored."))
			return

		var/material_name = attacking_item.get_material_name()
		if(material_name in list(MATERIAL_GLASS_REINFORCED, MATERIAL_GLASS_REINFORCED_PHORON))
			if(has_glass_installed)
				to_chat(user, SPAN_NOTICE("\The [src] already has glass installed."))
				return

			var/obj/item/stack/material/glass_stack = attacking_item

			if(!do_after(user, 2 SECONDS))
				return

			if(!glass_stack.use(glass_needed))
				var/message = "You need at least [glass_needed] sheets of " \
					+ "[material_name] to install a window in \the [src]."
				to_chat(user, SPAN_NOTICE(message))
				return

			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You place the [material_name] in the window frame."))

			switch(material_name)
				if(MATERIAL_GLASS_REINFORCED)
					new /obj/structure/window/full/reinforced(get_turf(src), constructed = TRUE)
				if(MATERIAL_GLASS_REINFORCED_PHORON)
					new /obj/structure/window/full/phoron/reinforced(get_turf(src), constructed = TRUE)

			has_glass_installed = TRUE
			return

	else if(istype(attacking_item, /obj/item/stack/rods))
		if(!anchored)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be anchored."))
			return

		if(has_glass_installed)
			to_chat(user, SPAN_NOTICE("You can't install the grille, the glass is in the way!"))
			return

		if(has_grille_installed)
			to_chat(user, SPAN_NOTICE("\The [src] already has grille installed."))
			return

		var/obj/item/stack/rods/rods_stack = attacking_item

		if(!do_after(user, 3 SECONDS))
			return

		if(!rods_stack.use(rods_needed))
			var/message = "You need at least [rods_needed] rods to install the grille in \the [src]."
			to_chat(user, SPAN_NOTICE(message))
			return

		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You place the grille in the window frame."))
		var/obj/structure/grille/over/new_grille = new /obj/structure/grille/over(get_turf(src))
		new_grille.shock(user, 70) // You haven't forgotten your precautions, have you?
		has_grille_installed = TRUE
		return

/obj/structure/window_frame/hitby(atom/movable/AM, speed)
	. = ..()
	var/obj/structure/window/W = locate() in get_turf(src)
	if(istype(W))
		W.hitby(AM)

/obj/structure/window_frame/wood
	color = "#8f5847"

/obj/structure/window_frame/unanchored // Used during in-game construction.
	should_check_mapload = FALSE // No glass.
	anchored = FALSE

/obj/structure/window_frame/empty
	should_check_mapload = FALSE // No glass.

/obj/structure/window_frame/shuttle
	icon = 'icons/obj/smooth/window/full_window_frame_color.dmi'
	color = null
	smoothing_flags = SMOOTH_MORE
	canSmoothWith = list(
		/turf/simulated/wall/shuttle,
		/turf/simulated/wall/shuttle/cardinal,
		/turf/simulated/wall/shuttle/dark,
		/turf/simulated/wall/shuttle/dark/cardinal,
		/obj/structure/window_frame/shuttle,
		/obj/machinery/door
	)

	can_blend_with = list(
		/turf/simulated/wall/shuttle,
		/turf/simulated/wall/shuttle/cardinal,
		/obj/machinery/door
	)

/obj/structure/window_frame/shuttle/merc
	color = "#8b7d86"
/obj/structure/window_frame/shuttle/khaki
	color = "#ac8b78"

/obj/structure/window_frame/shuttle/purple
	color = "#7846b1"

/obj/structure/window_frame/shuttle/red
	color = "#c24f4f"

/obj/structure/window_frame/shuttle/blue
	color = "#6176a1"
