/area/abandoned_skrell_ship
	icon_state = "purple"
	requires_power = FALSE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/abandoned_skrell_ship/exterior
	icon_state = "exterior"
	always_unpowered = TRUE
	needs_starlight = TRUE
	has_gravity = FALSE
	ambience = AMBIENCE_SPACE
	base_turf = /turf/space

