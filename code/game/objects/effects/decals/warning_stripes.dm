/obj/effect/decal/warning_stripes
	icon = 'icons/effects/warning_stripes.dmi'
	layer = DECAL_LAYER

/obj/effect/decal/warning_stripes/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	var/image/I = image(icon, icon_state = icon_state, dir = dir)
	I.color = color
	T.add_overlay(I, TRUE)	// Register it as priority so we don't lose it on icon update.
	qdel(src)
