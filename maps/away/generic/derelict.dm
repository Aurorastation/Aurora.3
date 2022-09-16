/datum/map_template/ruin/away_site/space_derelict
	name = "space derelict"
	description = "An abandoned space structure."
	suffix = list("generic/derelict.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 1
	spawn_cost = 2
	id = "space_derelict"

/decl/submap_archetype/space_derelict
	map = "space derelict"
	descriptor = "A space derelict."

/obj/effect/overmap/visitable/sector/space_derelict
	name = "derelict"
	desc = "An abandoned space structure."

