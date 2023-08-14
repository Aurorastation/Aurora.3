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
		visible_message("<span class='notice'>\The [user] starts adjusting the \the [src]</span>")
		if(W.use_tool(src, user, 50, volume = 50))
			visible_message("<span class='notice'>\The [user] adjusts \the [src]!</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You stop adjusting the terrain.</span>")
		return

/obj/structure/clearing/update_icon()
	if(istype(loc,/turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/E = loc
		if(E.dirt_color)
			color = E.dirt_color
