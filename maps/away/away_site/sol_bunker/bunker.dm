/datum/map_template/ruin/away_site/abandoned_bunker
	name = "lone asteroid"
	description = "A lone asteroid. Strange signals are coming from this one."
	suffixes = list("away_site/sol_bunker/bunker.dmm")
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
