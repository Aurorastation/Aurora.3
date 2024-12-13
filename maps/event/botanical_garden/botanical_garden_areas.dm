/area/botanical_garden
	name = "Botanical Garden"
	icon_state = "purple"
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 1
	is_outside = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	var/lighting = 1
	var/lighting_brightness = 5
	var/lighting_color = COLOR_MUZZLE_FLASH
	ambience = AMBIENCE_JUNGLE

/area/botanical_garden/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(MINIMUM_USEFUL_LIGHT_RANGE, lighting_brightness, lighting_color)

/area/botanical_garden/building
	name = "Botanical Garden - Building"
	icon_state = "green"
	luminosity = 0
	lighting = 0
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	ambience = AMBIENCE_GENERIC

/area/botanical_garden/building/ice_rink
	name = "Botanical Garden - Ice Rink"
	music = list(
		'sound/music/lobby/konyang/konyang-1.ogg',
		'sound/music/lobby/konyang/konyang-2.ogg',
		'sound/music/lobby/konyang/konyang-3.ogg',
		)
	icon_state = "dk_yellow"

/area/botanical_garden/building/basement
	name = "Botanical Garden - Basement"
	icon_state = "bluenew"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/botanical_garden/city
	name = "Mendell City"
	icon_state = "blue"
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 1
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = TRUE
	lighting_brightness = 2
	lighting_color = COLOR_BLUE_GRAY
	holomap_color = HOLOMAP_AREACOLOR_HANGAR
	ambience = list(AMBIENCE_KONYANG_TRAFFIC, AMBIENCE_WINDY)
