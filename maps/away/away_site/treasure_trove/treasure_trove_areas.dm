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
	area_blurb = "You can hear the sound of waves hitting the shore. Something at the back of your mind makes you think the beauty of the area hides something darker."

/area/trove/ocean
	name = "Treasure Trove Ocean"
	icon_state =  "purple"
	lighting = TRUE
	is_outside = OUTSIDE_YES
	ambience = 'sound/ambience/konyang/konyang-water.ogg'
	area_blurb = "Endless blue in all directions broken by the occasional jutting rock."

/area/trove/jungle
	name = "Treasure Trove Jungle"
	icon_state = "green"
	lighting = TRUE
	is_outside = OUTSIDE_YES
	ambience = 'sound/ambience/eeriejungle1.ogg'
	area_blurb = "Lush foliage and the sounds of distant animals... and something larger."

// ----- Interior

/area/trove/tunnels
	name = "Treasure Trove Tunnels"
	icon_state = "blue"
	requires_power = 0
	ambience = AMBIENCE_LAVA
	area_blurb = "You don't belong here. The dead are piled high, will you join them?"

/area/trove/vault
	name = "Treasure Trove Vault"
	icon_state = "storage"
	requires_power = 0
	area_blurb = "The end?"
