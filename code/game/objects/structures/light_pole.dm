/obj/structure/light_pole
	name = "light pole"
	desc = "A tall light source."
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

/obj/structure/light_pole/decayed
	desc = "A tall light source. The bulb appears to be decayed."
	light_color = LIGHT_COLOR_DECAYED

/obj/structure/light_pole/decayed/r
	icon_state = "rustlamp_r"

/obj/structure/light_pole/konyang
	name = "dangling lamp"
	desc = "A flame-lit lamp dangling precariously from a tall pole."
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "right_lamp"
	layer = 9.1
	anchored = TRUE
	density = FALSE
	light_color = "#FA644B"
	light_wedge = LIGHT_OMNI
	light_range = 6
	light_power = 1

/obj/structure/light_pole/konyang/left
	icon_state = "left_lamp"

/obj/structure/utility_pole
	name = "tall pole"
	desc = "A very tall utility pole for urban infrastructure."
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "junction"
	layer = 9
	anchored = TRUE

/obj/structure/utility_pole/gwok
	name = "Go Go Gwok street sign"
	desc = "A very tall street sign which alerts you of a Go Go Gwok eating establishment, where you can eat establishments."
	icon = 'icons/obj/structure/urban/konyang64x96.dmi'
	icon_state = "nice_gwok"

/obj/structure/utility_pole/street
	desc = "A tall light source. This one seems to be off."
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "street"

/obj/effect/overlay/street_light
	icon = 'icons/obj/structure/urban/poles.dmi'
	icon_state = "street_light"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE

/obj/effect/overlay/street_light/classic
	icon_state = "classic_lamp_light"
	density = 1

/obj/structure/utility_pole/street/on
	desc = "A tall light source. This one shines brightly."
	light_wedge = LIGHT_OMNI
	light_color = "#e8ffeb"
	light_range = 8
	light_power = 1.9

/obj/structure/utility_pole/street/on/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light)
	return

/obj/structure/utility_pole/street/classic
	icon_state = "classic_lamp"

/obj/structure/utility_pole/street/classic/on
	desc = "A tall light source. This one shines brightly."
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_TUNGSTEN
	light_range = 8
	light_power = 1.9

/obj/structure/utility_pole/street/classic/on/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/classic)
	return

/obj/effect/overlay/street_light/crosswalk
	icon_state = "crosswalk_go"

/obj/structure/utility_pole/street/crosswalk
	name = "crosswalk indicator"
	desc = "A very tall crosswalk indicator which can be manually used to scan for danger, before letting the viewer know whether it's safe to cross the road or not."
	icon_state = "crosswalk"
	light_color = LIGHT_COLOR_GREEN
	light_range = 3.1
	light_power = 2.6

/obj/structure/utility_pole/street/crosswalk/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/crosswalk)
	return

/obj/effect/overlay/street_light/traffic
	icon_state = "traffic_lights"

/obj/effect/overlay/street_light/traffic/inverted
	icon_state = "traffic_lights_inverse"

/obj/structure/utility_pole/street/traffic
	name = "traffic indicator"
	desc = "A very tall crosswalk indicator which can be used to better run red lights."
	icon_state = "traffic"
	light_color = LIGHT_COLOR_HALOGEN
	light_range = 3.1
	light_power = 2.6

/obj/structure/utility_pole/street/traffic/base/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/traffic)
	return

/obj/structure/utility_pole/street/traffic/inverted/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/traffic/inverted)
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
