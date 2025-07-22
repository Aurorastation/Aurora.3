/datum/map_template/ruin/exoplanet/abandoned_listening_post
	name = "Abandoned Listening Post"
	id = "abandoned_listening_post"
	description = "An abandoned listening post."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(ALL_UNCHARTED_SECTORS)

	prefix = "asteroid/listening_post/"
	suffix = "listening_post_unique.dmm"

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_HOSTILE

	unit_test_groups = list(1)

/area/listening_post
	name = "Listening Post Installation"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = TRUE
	is_outside = OUTSIDE_NO

/area/listening_post/entrance
	name = "Listening Post Installation - Entrance"

/area/listening_post/quarters
	name = "Listening Post Installation - Technician's Quarters"

/area/listening_post/washroom
	name = "Listening Post Installation - Washroom"

/area/listening_post/atmospherics
	name = "Listening Post Installation - Atmospherics"

/area/listening_post/power
	name = "Listening Post Installation - Generators"

/area/listening_post/servers
	name = "Listening Post Installation - Server Room"

/obj/effect/map_effect/marker/airlock/listening_post
	name = "Entrance"
	master_tag = "airlock_listening_post_ruin"
	cycle_to_external_air = TRUE
