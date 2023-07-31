/datum/map_template/ruin/away_site/wrecked_nt_ship
	name = "wrecked NT ship"
	description = "A wrecked ship once owned by NanoTrasen."
	suffixes = list("away_site/wrecked_nt_ship/wrecked_nt_ship.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	spawn_weight = 1
	spawn_cost = 2
	id = "wrecked_nt_ship"

/singleton/submap_archetype/wrecked_nt_ship
	map = "wrecked_nt_ship"
	descriptor = "A wrecked ship once owned by NanoTrasen."

/obj/effect/overmap/visitable/wrecked_nt_ship
	name = "wrecked NT ship"
	desc = "A wrecked ship once owned by NanoTrasen."

/area/wrecked_nt_ship
	name = "wrecked NT ship"
	icon_state = "wrecked_nt_ship"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE
	flags = HIDE_FROM_HOLOMAP
