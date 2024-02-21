/datum/map_template/ruin/away_site/first_aurora
	name = "space station derelict"
	description = "An abandoned space station."
	suffixes = list("away_site/first_aurora/first_aurora.dmm")
	sectors = list(SECTOR_ROMANOVICH)
	spawn_weight = 1
	spawn_cost = 2
	id = "first_aurora"

	unit_test_groups = list(1)

/singleton/submap_archetype/first_aurora
	map = "space station derelict"
	descriptor = "A space derelict."

/obj/effect/overmap/visitable/sector/first_aurora
	name = "space station derelict"
	desc = "An abandoned space structure."

