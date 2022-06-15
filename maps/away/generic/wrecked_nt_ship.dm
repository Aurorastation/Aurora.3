/datum/map_template/ruin/away_site/wrecked_nt_ship
	name = "wrecked NT ship"
	description = "A wrecked ship once owned by the Nanotrasen"
	suffix = "generic/wrecked_nt_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 2
	id = "wrecked_nt_ship"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/decl/submap_archetype/wrecked_nt_ship
	map = "wwrecked_nt_ship"
	descriptor = "A wrecked  ship once owned by the Nanotrasen"

/obj/effect/overmap/visitable/wrecked_nt_ship
	name = "wrecked nt ship"
	desc = "A wrecked ship once owend by NanoTrasen."

/area/wrecked_nt_ship
	name = "wrecked NT ship"
	icon_state = "wrecked_nt_ship"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE