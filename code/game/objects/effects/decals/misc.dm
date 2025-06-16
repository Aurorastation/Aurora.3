/obj/effect/decal
	layer = DECAL_LAYER

/obj/effect/decal/tesla_act()
	return

/obj/effect/decal/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "arrow"
	layer = POINTER_LAYER
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/effect/decal/spraystill
	density = 0
	anchored = 1
	layer = PROJECTILE_LAYER

//Used for imitating an object's sprite for decorative purposes.
/obj/effect/decal/fake_object
	name = "object"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"
	density = 0
	anchored = 1
	layer = OBJ_LAYER

/obj/effect/decal/fake_object/Initialize(mapload)
	.=..()
	appearance_flags &= ~TILE_BOUND

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
