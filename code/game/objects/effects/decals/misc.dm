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


/obj/effect/decal/fake_object/spacestuff
	name = "object"
	icon = 'icons/obj/spacestuff.dmi'
	icon_state = "a2"
	density = 0
	anchored = 1
	layer = ON_TURF_LAYER
	mouse_opacity = FALSE

/obj/effect/decal/fake_object/spacestuff/rocks/Initialize()
	.=..()
	icon_state = "a[rand(2,10)]"

/obj/effect/decal/fake_object/spacestuff/bigrock
	icon = 'icons/obj/bigrock.dmi'
	icon_state = "bigrock"

/obj/effect/decal/fake_object/spacestuff/nebula
	icon = 'icons/obj/nebula.dmi'
	icon_state = "nebula"