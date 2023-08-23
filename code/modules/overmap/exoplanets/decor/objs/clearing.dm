/obj/structure/clearing
	name = "clearing"
	desc = "A small clearing from surrounding terrain or foliage."
	icon = 'icons/obj/flora/clearing.dmi'
	icon_state = "smooth"
	blend_mode = BLEND_MULTIPLY
	density = FALSE
	anchored = TRUE
	smooth = SMOOTH_MORE
	canSmoothWith = list(
		/obj/structure/clearing,
		/obj/structure/lattice/catwalk,
		/obj/structure/lattice/catwalk/indoor,
		/turf/simulated/floor/concrete,
		/turf/simulated/floor/plating,
		/turf/simulated/floor/tiled,
		/turf/simulated/floor/wood,
		/turf/simulated/wall
	)

/obj/structure/clearing/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/material/minihoe))
		visible_message(SPAN_NOTICE("\The [user] starts adjusting the \the [src]"))
		if(W.use_tool(src, user, 50, volume = 50))
			visible_message(SPAN_NOTICE("\The [user] adjusts \the [src]!"))
			qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You stop adjusting the terrain."))
		return

/obj/structure/clearing/update_icon()
	if(istype(loc,/turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/E = loc
		if(E.dirt_color)
			color = E.dirt_color
