/datum/map_template/ruin/away_site/space_derelict
	name = "space derelict"
	description = "An abandoned space structure."
	suffix = "generic/derelict.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1

/decl/submap_archetype/space_derelict
	descriptor = "space derelict"

/obj/effect/overmap/visitable/sector/space_derelict
	name = "derelict"
	desc = "An abandoned space structure."