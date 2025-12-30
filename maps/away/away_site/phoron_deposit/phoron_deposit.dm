/datum/map_template/ruin/away_site/phoron_deposit
	name = "phoron deposit"
	description = "An asteroid with a phoron deposit."

	prefix = "away_site/phoron_deposit/"
	suffix = "phoron_deposit.dmm"

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_VALLEY_HALE, SECTOR_TABITI)
	spawn_weight = 1
	spawn_cost = 2
	id = "deposit"
	unit_test_groups = list(3)

/singleton/submap_archetype/deposit
	map = "phoron deposit"
	descriptor = "An asteroid with a phoron deposit."

/obj/effect/overmap/visitable/sector/deposit
	name = "phoron deposit"
	desc = "Sensors have detected a rare high yield subsurface phoron deposit within a canyon on this asteroid. Additional scanning of the area reveals that there's a large underground cavern system surrounding it, with a plethora of lifesigns within, likely being aggressive fauna. Expeditionary personnel are advised to fortify the area before commencing drilling, as the process may attract intense hostile attention from the caverns."
	icon_state = "object"
	in_space = FALSE
	initial_generic_waypoints = list(
		"landing_point_a",
		"landing_point_b",
		"landing_point_c",
		"landing_point_d",
	)

/area/phoron_deposit_shuttle
	name = "Einstein Engines Shuttle"
	icon_state = "yellow"

//Landmarks

/obj/effect/shuttle_landmark/phoron_deposit
	base_area = /area/mine
	base_turf = /turf/simulated/floor/exoplanet/asteroid/ash/rocky

/obj/effect/shuttle_landmark/phoron_deposit/alpha
	name = "Landing Point Alpha"
	landmark_tag = "landing_point_a"

/obj/effect/shuttle_landmark/phoron_deposit/bravo
	name = "Landing Point Bravo"
	landmark_tag = "landing_point_b"

/obj/effect/shuttle_landmark/phoron_deposit/charlie
	name = "Landing Point Charlie"
	landmark_tag = "landing_point_c"

/obj/effect/shuttle_landmark/phoron_deposit/delta
	name = "Landing Point Delta"
	landmark_tag = "landing_point_d"
