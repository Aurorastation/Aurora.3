/obj/structure/light_pole
	name = "light pole"
	desc = "A tall light source."
	light_color = COLOR_ORANGE
	icon = 'icons/effects/32x96.dmi'
	icon_state = "rustlamp_l"
	anchored = TRUE
	density = TRUE
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_HALOGEN
	light_range = 8
	light_power = 8

/obj/structure/light_pole/r
	icon_state = "rustlamp_r"

/obj/structure/utility_pole
	name = "tall pole"
	desc = "A very tall utility pole for urban infrastructure."
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "junction"
	layer = 9
	anchored = TRUE
	density = TRUE

/obj/structure/utility_pole/street
	desc = "A tall light source. This one seems to be off."
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "street"

/obj/effect/overlay/street_light
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "street_light"
	layer = EFFECTS_ABOVE_LIGHTING_LAYER
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_TUNGSTEN
	light_range = 8
	light_power = 5

/obj/structure/utility_pole/street/on
	desc = "A tall light source. This one shines brightly."

/obj/structure/utility_pole/street/on/Initialize(mapload)
	. = ..()
	cut_overlays()
	overlays += /obj/effect/overlay/street_light
	return

/obj/effect/overlay/street_light/crosswalk
	icon_state = "crosswalk_go"
	light_color = LIGHT_COLOR_GREEN
	light_range = 3.1
	light_power = 2.6

/obj/structure/utility_pole/street/crosswalk
	name = "crosswalk indicator"
	desc = "A very tall crosswalk indicator which can be manually used to scan for danger, before letting the viewer know whether it's safe to cross the road or not."
	icon_state = "crosswalk"

/obj/structure/utility_pole/street/crosswalk/Initialize(mapload)
	. = ..()
	cut_overlays()
	overlays += /obj/effect/overlay/street_light/crosswalk
	return

/obj/structure/utility_pole/power
	name = "power pole"
	desc = "A very tall utility pole for urban infrastructure. This one is a basis for power lines overhead."
	icon_state = "power"

/obj/structure/utility_pole/power/central
	icon_state = "central"

/obj/effect/overlay/overhead_line
	name = "overhead utility line"
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "line"
	layer = 9.1

/obj/effect/overlay/overhead_line/end
	icon_state = "line_end"
