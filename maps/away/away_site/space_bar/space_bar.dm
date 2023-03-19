/datum/map_template/ruin/away_site/space_bar
	name = "space bar"
	description = "An abandoned space structure."
	suffixes = list("away_site/space_bar/space_bar.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	ship_cost = 2
	id = "space_bar"

/singleton/submap_archetype/space_bar
	map = "space bar"
	descriptor = "A space bar."

/obj/effect/overmap/visitable/sector/space_bar
	name = "space bar"
	desc = "A cozy meeting place floating on space."
	comms_support = TRUE
	comms_name = "station"
	use_common = TRUE

/area/space_bar
	name = "Spacer Bar"
	icon_state = "bar"
	flags = RAD_SHIELDED | HIDE_FROM_HOLOMAP
	requires_power = FALSE
	base_turf = /turf/simulated/floor/plating
	no_light_control = TRUE

/area/space_bar/hangar
	name = "Spacer Bar Hangar"
	icon_state = "exit"
