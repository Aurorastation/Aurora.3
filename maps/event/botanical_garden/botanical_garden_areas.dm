/area/botanical_garden
	name = "Botanical Garden"
	icon_state = "purple"
	requires_power = 0
	no_light_control = 1
	is_outside = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS

//	area_has_base_lighting = TRUE
//	base_lighting_alpha = 100
//	base_lighting_color = COLOR_MUZZLE_FLASH
	ambience = AMBIENCE_JUNGLE
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

	var/special_lighting = TRUE
	var/special_light_color = LIGHT_COLOUR_WARM
	var/special_light_brightness = 5
	var/special_light_power = 5
	var/special_light_range = MINIMUM_USEFUL_LIGHT_RANGE

	needs_starlight = TRUE

/*
/area/botanical_garden/Initialize(mapload)
	. = ..()
	update_base_lighting()

	if(special_lighting)
		for(var/turf/T in src)
			T.set_light(special_light_range, special_light_power, special_light_color)
			T.set_light_on(TRUE)
			T.update_light()
*/

/area/botanical_garden/building
	name = "Botanical Garden - Building"
	icon_state = "green"
	luminosity = 0
	static_lighting = TRUE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	ambience = AMBIENCE_GENERIC
	needs_starlight = FALSE

/area/botanical_garden/building/ice_rink
	name = "Botanical Garden - Ice Rink"
	icon_state = "dk_yellow"
	music = list('sound/music/lobby/konyang/konyang-2.ogg', 'sound/music/regional/venus/artificially_sweetened.ogg', 'sound/music/regional/venus/billy_ocean.ogg', 'sound/music/audioconsole/Amsterdam.ogg', 'sound/music/title3mk2.ogg', )
	static_lighting = TRUE
	needs_starlight = FALSE

/area/botanical_garden/building/basement
	name = "Botanical Garden - Basement"
	icon_state = "bluenew"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	static_lighting = TRUE

/area/botanical_garden/city
	name = "Mendell City"
	icon_state = "blue"
	requires_power = 0
	no_light_control = 1
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = TRUE
	area_has_base_lighting = TRUE
	static_lighting = FALSE
	base_lighting_alpha = 80
	base_lighting_color = COLOR_BLUE_GRAY
	holomap_color = HOLOMAP_AREACOLOR_HANGAR
	ambience = list(AMBIENCE_KONYANG_TRAFFIC, AMBIENCE_WINDY)
	needs_starlight = FALSE
