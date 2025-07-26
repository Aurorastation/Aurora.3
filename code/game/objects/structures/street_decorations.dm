/obj/structure/light_pole
	name = "light pole"
	desc = "A tall light source."
	icon = 'icons/effects/32x96.dmi'
	icon_state = "rustlamp_l"
	anchored = TRUE
	density = FALSE
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
	icon = 'icons/obj/structure/streetpoles_konyang.dmi'
	icon_state = "lamp"
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE
	light_color = "#FA644B"
	light_wedge = LIGHT_OMNI
	light_range = 6
	light_power = 1
	pixel_x = -32
	pixel_y = 8

/obj/structure/light_pole/konyang/left
	dir = NORTH

/obj/structure/utility_pole
	name = "tall pole"
	desc = "A very tall utility pole for urban infrastructure."
	icon = 'icons/obj/structure/streetpoles_konyang.dmi'
	icon_state = "junction"
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE
	pixel_x = -32
	pixel_y = 8

/obj/structure/utility_pole/gwok
	name = "Go Go Gwok street sign"
	desc = "A very tall street sign which alerts you of a Go Go Gwok eating establishment, where you can eat establishments."
	icon = 'icons/obj/structure/urban/konyang64x96.dmi'
	icon_state = "nice_gwok"

// street lights

/obj/structure/utility_pole/street
	name = "\improper street lamp"
	desc = "A tall light source. What more is there to say?"
	icon = 'icons/obj/structure/streetpoles.dmi'
	icon_state = "streetlight"

/obj/effect/overlay/street_light
	icon = 'icons/obj/structure/streetpoles.dmi'
	icon_state = "street_light"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE

/obj/structure/utility_pole/street/on
	light_wedge = LIGHT_OMNI
	light_color = "#e8ffeb"
	light_range = 8
	light_power = 1.9

/obj/structure/utility_pole/street/corner
	name = "\improper street lamp"
	desc = "A tall light source. What more is there to say?"
	icon_state = "streetlightcorner"

/obj/structure/utility_pole/street/corner/on
	light_wedge = LIGHT_OMNI
	light_color = "#e8ffeb"
	light_range = 8
	light_power = 1.9

/obj/structure/utility_pole/street/double
	name = "\improper street lamp"
	desc = "A tall light source. What more is there to say?"
	icon_state = "streetlightduo"

/obj/structure/utility_pole/street/double/on
	light_wedge = LIGHT_OMNI
	light_color = "#e8ffeb"
	light_range = 8
	light_power = 1.9

/obj/structure/utility_pole/street/on/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light)
	return

/obj/structure/utility_pole/street/konyang/classic
	name = "\improper stone lamp"
	desc = "A stone lamp commonly found in Konyang."
	icon = 'icons/obj/structure/streetpoles_konyang.dmi'
	icon_state = "classic_lamp"
	density = TRUE


/obj/effect/overlay/street_light/konyang/classic
	icon_state = "classic_lamp_light"

/obj/structure/utility_pole/street/konyang/classic/on
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_TUNGSTEN
	light_range = 8
	light_power = 1.9

/obj/structure/utility_pole/street/konyang/classic/on/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/konyang/classic)
	return

/obj/effect/overlay/street_light/crosswalk
	icon = 'icons/obj/structure/streetpoles.dmi'
	icon_state = "crosswalk_go"

/obj/structure/utility_pole/street/crosswalk
	name = "crosswalk indicator"
	desc = "A very tall crosswalk indicator which can be manually used to scan for danger, before letting the viewer know whether it's safe to cross the road or not."
	icon = 'icons/obj/structure/streetpoles.dmi'
	icon_state = "crosswalk"
	light_color = LIGHT_COLOR_GREEN
	light_range = 3.1
	light_power = 2.6

/obj/structure/utility_pole/street/crosswalk/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/crosswalk)
	return

/obj/structure/utility_pole/street/traffic
	name = "traffic indicator"
	desc = "A very tall crosswalk indicator which can be used to better run red lights."
	icon_state = "trafficlight"
	light_color = LIGHT_COLOR_HALOGEN
	light_range = 3.1
	light_power = 2.6

/obj/effect/overlay/street_light/traffic
	icon_state = "traffic_lights"

/obj/structure/utility_pole/street/traffic/base/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/traffic)
	return

/obj/effect/overlay/street_light/traffic/inverted
	icon_state = "traffic_lights_inverse"

/obj/structure/utility_pole/street/traffic/inverted/Initialize(mapload)
	. = ..()
	ClearOverlays()
	AddOverlays(/obj/effect/overlay/street_light/traffic/inverted)
	return

// Power poles

/obj/structure/utility_pole/power
	name = "power pole"
	desc = "A very tall utility pole for urban infrastructure. This one is a basis for power lines overhead."
	icon = 'icons/obj/structure/streetpoles_konyang.dmi'
	icon_state = "power"

/obj/structure/utility_pole/power/central
	icon_state = "central"

/obj/effect/overlay/overhead_line
	name = "overhead utility line"
	icon = 'icons/obj/structure/streetpoles_konyang.dmi'
	icon_state = "line"
	layer = ABOVE_HUMAN_LAYER
	pixel_x = -32
	pixel_y = 8

/obj/effect/overlay/overhead_line/end
	icon_state = "line_end"

// Street Signs

/obj/structure/street_sign
	name = "stop sign"
	desc = "A stop sign to direct traffic. Sometimes a demand."
	icon = 'icons/obj/structure/street_signs.dmi'
	icon_state = "stop"
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE

/obj/structure/street_sign/yield
	name = "yield sign"
	desc = "A yield sign which tells you to slow down, rather politely. Let's hope you listen."
	icon = 'icons/obj/structure/street_signs_konyang.dmi'
	icon_state = "yield"

/obj/structure/street_sign/warnings
	name = "warning sign"
	desc = "A sign. You think it's trying to warn you of something."
	icon_state = "warnings"

/obj/structure/street_sign/directional
	name = "turn ahead sign"
	desc = "A directional sign. How the turntables..."
	icon_state = "directional"

/obj/structure/street_sign/directional/blue
	icon = 'icons/obj/structure/street_signs_konyang.dmi'
	icon_state = "directional_blue"

/obj/structure/street_sign/street
	name = "street sign"
	desc = "A street sign. As common as they are, sometimes people still get lost."
	icon_state = "street"

	var/street_name = null

/obj/structure/street_sign/street/Initialize(mapload)
	. = ..()
	name = "[street_name]"
	desc = "A street sign for [street_name]. As common as they are, sometimes people still get lost."

/obj/structure/street_sign/street/both
	dir = NORTH

/obj/structure/street_sign/street/right
	dir = WEST

/obj/structure/street_sign/street/left
	dir = EAST

/obj/structure/ms13/street_sign/turning
	desc = "A stop sign. Looks like you've passed the point of no return."
	icon_state = "noturn"

/obj/structure/street_sign/parking
	desc = "A sign. No parking allowed."
	icon_state = "noparking"

/obj/structure/street_sign/one_way
	desc = "A sign. Apparently you can only go one direction..."
	icon_state = "direction"

/obj/structure/street_sign/bus
	desc = "A bus sign. If you had to guess, you have to wait for a bus here."
	icon_state = "busstop"

/obj/structure/street_sign/railroad
	desc = "A sign. This one is a big white X. Wonder what that entails?"
	icon_state = "railcrossing"

/obj/structure/street_sign/only_direction
	desc = "A sign. It's telling you to only go this way."
	icon_state = "onlydir"

/obj/structure/street_sign/speed
	desc = "A sign. Always trying to slow you down."
	icon_state = "speed"

/obj/structure/street_sign/turn
	desc = "A sign. It's pointing a direction with arrows on it. Cool."
	icon_state = "turn"

/obj/structure/street_sign/exit
	desc = "A sign. It's showing you to an exit."
	icon_state = "exit"

/obj/structure/street_sign/nopedestrian
	desc = "A sign. Only operators of heavy machinery allowed!"
	icon_state = "nopedestrian"

/obj/structure/street_sign/drive_thru
	name = "drive thru sign"
	desc = "A drive-thru sign."
	icon = 'icons/obj/structure/street_signs_konyang.dmi'
	icon_state = "drivethru"
