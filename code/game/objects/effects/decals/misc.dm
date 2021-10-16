/obj/effect/decal/tesla_act()
	return

/obj/effect/decal/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "arrow"
	layer = 16.0
	anchored = 1
	mouse_opacity = 0

	var/qdel_timer

/obj/effect/decal/point/Initialize(mapload, var/mob/M)
	invisibility = M.invisibility
	. = ..()
	var/turf/T1
	var/atom/A
	if(isturf(loc))
		T1 = loc
	else
		A = loc
		T1 = get_turf(loc)
		forceMove(T1)
	var/turf/T2 = M.loc

	if(T2.x && T2.y)
		var/dist_x = (T2.x - T1.x)
		var/dist_y = (T2.y - T1.y)

		pixel_x = dist_x * 32
		pixel_y = dist_y * 32

		animate(src, pixel_x = A ? A.get_pixel_x() : 0, pixel_y = A ? A.get_pixel_y() : 0, time = 0.5 SECONDS, easing = QUAD_EASING)

	qdel_timer = QDEL_IN(src, 2.5 SECONDS)

/obj/effect/decal/point/Destroy()
	deltimer(qdel_timer)
	qdel_timer = null
	return ..()

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/effect/decal/spraystill
	density = 0
	anchored = 1
	layer = 50

//Used for imitating an object's sprite for decorative purposes.
/obj/effect/decal/fake_object
	name = "object"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"
	density = 0
	anchored = 1
	layer = 3

/obj/effect/decal/fake_object/light_source
	name = "light source"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "glowstick-on"
	light_power = 1
	light_range = 5
	light_color = LIGHT_COLOR_HALOGEN

/obj/effect/decal/fake_object/light_source/Initialize()
	.=..()
	set_light()

/obj/effect/decal/fake_object/light_source/invisible
	simulated = 0
	invisibility = 101
