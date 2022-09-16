/datum/map_template/ruin/away_site/racers
	name = "unregistered station"
	description = "A station that doesn't appear to have been legally registered. It has four large hangar bays and a small habitation module - and the signals emittered by its dying equipment seem to identify it as belonging to an underground racing group."
	suffix = list("generic/racers.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 1
	spawn_cost = 2
	id = "racers"

/decl/submap_archetype/racers
	map = "unregistered station"
	descriptor = "A unregistered station."

/obj/effect/overmap/visitable/sector/racers
	name = "unregistered station"
	desc = "A station that doesn't appear to have been legally registered. It has four large hangar bays and a small habitation module - and the signals emittered by its dying equipment seem to identify it as belonging to an underground racing group."

/area/racers
	name = "unregistered station"
	icon_state = "bar"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE