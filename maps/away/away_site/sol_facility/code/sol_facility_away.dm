/datum/map_template/ruin/away_site/sol_facility
	name = "facility embedded in an asteroid"
	description = "A facility embedded in an asteroid."
	id = "sol_facility"
	suffix = "away_site/sol_facility/sol_facility.dmm"
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/decl/submap_archetype/sol_facility
	map = "facility embedded in an asteroid"
	descriptor = "A facility embedded in an asteroid."

/obj/effect/overmap/visitable/sector/sol_facility
	name = "facility embedded in an asteroid"
	desc = "Sensors detect a facility embedded in an asteroid."
	icon = 'maps/away/away_site/sol_facility/icons/overmap_icon.dmi'
	icon_state = "object"

	initial_generic_waypoints = list(
		"nav_sol_facility_1",
		"nav_sol_facility_2"
	)

/obj/effect/shuttle_landmark/nav_sol_facility/nav1
	name = "Facility Navpoint #1"
	landmark_tag = "nav_sol_facility_1"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/sol_facility/arrivals_hangar

/obj/effect/shuttle_landmark/nav_sol_facility/nav2
	name = "Facility Navpoint #2"
	landmark_tag = "nav_sol_facility_2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/sol_facility/arrivals_hangar