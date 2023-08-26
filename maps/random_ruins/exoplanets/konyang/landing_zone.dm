/datum/map_template/ruin/exoplanet/konyang_landing_zone
	name = "Wilderness Command Center Landing Zone"
	id = "konyang_landing_zone"
	description = "An artificial orbitally-dropped prefab of flattened ground established for shuttle landing."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/landing_zone.dmm")

/area/konyang_landing_zone
	name = "Wilderness Command Center"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	flags = HIDE_FROM_HOLOMAP

/area/konyang_landing_zone/command_center
	name = "Wilderness Command Center"
	requires_power = TRUE

/area/konyang_landing_zone/command_center/reactor
	name = "Wilderness Command Center Reactor"

/area/konyang_landing_zone/command_center/garage
	name = "Wilderness Command Center Garage"

/area/konyang_landing_zone/command_center/living
	name = "Wilderness Command Center Living Area"

/area/konyang_landing_zone/command_center/greenhouse
	name = "Wilderness Command Center Greenhouse"

/area/konyang_landing_zone/command_center/landing_pads
	name = "Wilderness Command Center Landing Pads"

/obj/effect/shuttle_landmark/konyang_landing_zone_intrepid
	name = "Wilderness Command Center - Intrepid"
	landmark_tag = "nav_konyang_landing_zone_intrepid"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/konyang_landing_zone

/obj/effect/shuttle_landmark/konyang_landing_zone_canary
	name = "Wilderness Command Center - Canary"
	landmark_tag = "nav_konyang_landing_zone_canary"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/konyang_landing_zone

/obj/effect/shuttle_landmark/konyang_landing_zone_spark
	name = "Wilderness Command Center - Spark"
	landmark_tag = "nav_konyang_landing_zone_spark"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/konyang_landing_zone
