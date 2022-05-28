/datum/map_template/ruin/away_site/big_derelict
	name = "large derelict"
	description = "A large abandoned space structure."
	suffix = "generic/bigderelict.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 2
	id = "big_derelict"

/decl/submap_archetype/big_derelict
	map = "space derelict"
	descriptor = "A space derelict."

/obj/effect/overmap/visitable/sector/big_derelict
	name = "derelict"
	desc = "An abandoned space structure."

