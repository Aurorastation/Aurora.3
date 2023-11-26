/datum/map_template/ruin/away_site/overgrown_mining_station
	name = "overgrown_mining_station"
	description = "An abandoned mining station with a dionae growing into it"
	suffixes = list("away_site/overgrown_mining_station/overgrown_mining_station.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 2
	id = "overgrown_mining_station"

	unit_test_groups = list(1)

/singleton/submap_archetype/overgrown_mining_station
	map = "overgrown_mining_station"
	descriptor = "A derelict mining station."

/obj/effect/overmap/visitable/sector/overgrown_mining_station
	name = "derelict mining station"
	desc = "An abandoned space structure."

/area/overgrown_mining_station
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	name = "Overgrown Mining Station"
	icon_state = "overgrown_mining_station"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE
