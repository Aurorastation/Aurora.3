/datum/map_template/ruin/away_site/pra_satellite
	name = "hadiist satellite"
	description = "A People's Republic of Adhomai satellite used to survey the system."
	suffix = "away_site/tajara/pra_satellite/pra_satellite.dmm"
	sectors = list(SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)
	spawn_weight = 1
	spawn_cost = 1
	id = "pra_satellite"

/singleton/submap_archetype/pra_satellite
	map = "hadiist satellite"
	descriptor = "A People's Republic of Adhomai satellite used to survey the system."

/obj/effect/overmap/visitable/sector/pra_satellite
	name = "hadiist satellite"
	desc = "A People's Republic of Adhomai satellite used to survey the system."
	initial_generic_waypoints = list(
		"nav_hadiist_satellite_1",
		"nav_hadiist_satellite_2",
		"nav_hadiist_satellite_3"
	)

	comms_support = TRUE
	comms_name = "pra satellite"

/obj/effect/shuttle_landmark/pra_satellite
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/pra_satellite/nav1
	name = "Hadiist Satellite Navpoint #1"
	landmark_tag = "nav_hadiist_satellite_1"

/obj/effect/shuttle_landmark/pra_satellite/nav2
	name = "Hadiist Satellite Navpoint #2"
	landmark_tag = "nav_hadiist_satellite_2"

/obj/effect/shuttle_landmark/pra_satellite/nav3
	name = "Hadiist Satellite Navpoint #3"
	landmark_tag = "nav_hadiist_satellite_3"

/area/pra_satellite
	name = "Hadiist Satellite"
	icon_state = "research"
	flags = RAD_SHIELDED
	requires_power = TRUE
	base_turf = /turf/simulated/floor/plating
	no_light_control = TRUE