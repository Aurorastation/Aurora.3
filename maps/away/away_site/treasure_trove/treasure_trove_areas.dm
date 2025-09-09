// ------------------------- base/parent

/area/trove
	name = "Treasure Trove (base/abstract)"
	requires_power = 1
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	is_outside = OUTSIDE_NO

	var/lighting = FALSE

/area/trove/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(MINIMUM_USEFUL_LIGHT_RANGE, 50, COLOR_WHITE)

// ----- exterior

/area/trove/beach
	name = "Treasure Trove Beach"
	icon_state = "yellow"
	lighting = TRUE
	is_outside = OUTSIDE_YES
	ambience = 'sound/ambience/konyang/konyang-water.ogg'

/area/trove/ocean
	name = "Treasure Trove Ocean"
	icon_state =  "purple"
	lighting = TRUE
	is_outside = OUTSIDE_YES
	ambience = 'sound/ambience/konyang/konyang-water.ogg'

/area/trove/jungle
	name = "Treasure Trove Jungle"
	icon_state = "green"
	lighting = TRUE
	is_outside = OUTSIDE_YES
	ambience = 'sound/ambience/eeriejungle1.ogg'

// ----- Interior

/area/trove/tunnels
	name = "Treasure Trove Tunnels"
	icon_state = "blue"
	requires_power = 0
	ambience = AMBIENCE_LAVA
