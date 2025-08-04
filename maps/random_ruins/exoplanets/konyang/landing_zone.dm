/datum/map_template/ruin/exoplanet/konyang_landing_zone
	name = "SCC Expedition Command Center Landing Zone"
	id = "konyang_landing_zone"
	description = "An artificial orbitally-dropped prefab of flattened ground established for shuttle landing."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)

	prefix = "konyang/"
	suffix = "landing_zone.dmm"

	unit_test_groups = list(1)

/area/konyang_landing_zone
	name = "SCC Expedition Command Center"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/konyang_landing_zone/command_center
	name = "SCC Expedition Command Center"
	requires_power = TRUE
	is_outside = OUTSIDE_NO

/area/konyang_landing_zone/command_center/reactor
	name = "SCC Expedition Command Center Reactor"

/area/konyang_landing_zone/command_center/garage
	name = "SCC Expedition Command Center Garage"

/area/konyang_landing_zone/command_center/living
	name = "SCC Expedition Command Center Living Area"

/area/konyang_landing_zone/command_center/greenhouse
	name = "SCC Expedition Command Center Greenhouse"

/area/konyang_landing_zone/command_center/landing_pads
	name = "SCC Expedition Command Center Landing Pads"
	is_outside = OUTSIDE_YES

/obj/effect/shuttle_landmark/konyang_landing_zone_intrepid
	name = "SCC Expedition Command Center - Intrepid"
	landmark_tag = "nav_konyang_landing_zone_intrepid"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/konyang_landing_zone

/obj/effect/shuttle_landmark/konyang_landing_zone_canary
	name = "SCC Expedition Command Center - Canary"
	landmark_tag = "nav_konyang_landing_zone_canary"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/konyang_landing_zone

/obj/effect/shuttle_landmark/konyang_landing_zone_spark
	name = "SCC Expedition Command Center - Spark"
	landmark_tag = "nav_konyang_landing_zone_spark"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/konyang_landing_zone
