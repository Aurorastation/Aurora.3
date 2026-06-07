/area/beach_episode
	name = "LES YT-U 13029 'Sandbox'"
	requires_power = FALSE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	icon_state = "bluenew"
	ambience = AMBIENCE_JUNGLE
	sound_environment = SOUND_ENVIRONMENT_FOREST
	is_outside = OUTSIDE_YES

/area/beach_episode/beach
	icon_state = "green"
	ambience = AMBIENCE_KONYANG_WATER

/area/beach_episode/indoors
	icon_state = "red"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	requires_power = TRUE
	is_outside = OUTSIDE_NO

/area/beach_episode/caves
	icon_state = "white128a"
	is_outside = OUTSIDE_NO
