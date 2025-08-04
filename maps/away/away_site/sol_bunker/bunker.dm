/datum/map_template/ruin/away_site/abandoned_bunker
	name = "lone asteroid"
	description = "A lone asteroid. Strange signals are coming from this one."

	prefix = "away_site/sol_bunker/"
	suffix = "bunker.dmm"

	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_WEEPING_STARS)
	spawn_weight = 1
	spawn_cost = 1
	id = "abandoned_bunker"

	unit_test_groups = list(2)

/singleton/submap_archetype/abandoned_bunker
	map = "lone asteroid"
	descriptor = "A lone asteroid. Strange signals are coming from this one."

/obj/effect/overmap/visitable/sector/abandoned_bunker
	name = "lone asteroid"
	desc = "A lone asteroid. Strange signals are coming from this one."

/obj/effect/map_effect/marker/airlock/sol_bunker
	name = "Entrance Airlock"
	master_tag = "airlock_sol_bunker"

/area/sol_bunker
	name = "ASSN Naval Installation"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	requires_power = FALSE
	ambience = AMBIENCE_RUINS
	base_turf = /turf/space
	icon_state = "bluenew"
