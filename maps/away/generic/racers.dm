/datum/map_template/ruin/away_site/racers
	name = "racer club"
	description = "A station apparently home to an underground racing group."
	suffix = "generic/racers.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "racers"

/decl/submap_archetype/racers
	map = "racer club"
	descriptor = "A racer club."

/obj/effect/overmap/visitable/sector/racers
	name = "racer club"
	desc = "A station apparently home to an underground racing group."

/area/racers
	name = "Racer Club"
	icon_state = "bar"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE