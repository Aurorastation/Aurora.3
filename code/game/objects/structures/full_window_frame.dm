/obj/structure/window_frame
	name = "window frame"
	desc = "An empty window frame."
	icon = 'icons/obj/smooth/full_window.dmi'
	icon_state = "window_frame"
	build_amt = 4
	anchored = TRUE
	var/glass_needed = 4

/obj/structure/window_frame/unanchored
	anchored = FALSE

/obj/structure/window_frame/attackby(obj/item/W, mob/user)
	if((W.isscrewdriver()) && (istype(loc, /turf/simulated) || anchored))
		var/obj/item/screwdriver/S = W
		if(do_after(user, 20/S.toolspeed))
			playsound(src, S.usesound, 50, TRUE)
			anchored = !anchored
			user.visible_message(
				SPAN_NOTICE("\The [user] [anchored ? "fastens" : "unfastens"] \the [src]."),
				SPAN_NOTICE("You have [anchored ? "fastened" : "unfastened"] \the [src]."),
				"You hear deconstruction."
			)
			return

	else if(W.iswelder())
		if(anchored)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be unanchored to be able to be welded apart."))
			return
		var/obj/item/weldingtool/WT = W
		if(WT.welding)
			to_chat(user, SPAN_NOTICE("You are already welding apart \the [src]."))
			return
		if(!WT.isOn())
			to_chat(user, SPAN_NOTICE("\The [WT] isn't turned on."))
			return
		user.visible_message(
			SPAN_WARNING("\The [user] starts welding \the [src] apart!"),
			SPAN_NOTICE("You start welding \the [src] apart..."),
			"You hear deconstruction."
		)
		playsound(src, 'sound/items/welder.ogg', 50, TRUE)
		if(do_after(user, 20/WT.toolspeed))
			if(!src || !WT.isOn())
				return
			if(WT.remove_fuel(0, user))
				to_chat(user, SPAN_NOTICE("You use \the [WT] to weld apart \the [src]."))
				playsound(src, WT.usesound, 50, 1)
				new /obj/item/stack/material/steel(get_turf(src), 4)
				qdel(src)
				return

	else if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS_REINFORCED && anchored)
		var/obj/item/stack/material/G = W
		if(do_after(user, 20))
			if(G.use(glass_needed))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You place the [MATERIAL_GLASS_REINFORCED] in the window frame."))
				new /obj/structure/window/full/reinforced(get_turf(src), constructed = TRUE)
				qdel(src)
				return
		else
			to_chat(user, SPAN_NOTICE("You need at least [glass_needed] sheets of [MATERIAL_GLASS_REINFORCED] to install a window in \the [src]."))

	else if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS_REINFORCED_PHORON && anchored)
		var/obj/item/stack/material/G = W
		if(do_after(user, 20))
			if(G.use(glass_needed))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_WARNING("You place the [MATERIAL_GLASS_REINFORCED_PHORON] in the window frame."))
				new /obj/structure/window/full/phoron/reinforced(get_turf(src), constructed = TRUE)
				qdel(src)
				return
		else
			to_chat(user, SPAN_WARNING("You need at least [glass_needed] sheets of [MATERIAL_GLASS_REINFORCED_PHORON] to finished the window."))