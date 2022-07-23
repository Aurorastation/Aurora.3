/datum/map_template/ruin/away_site/space_bar
	name = "space bar"
	description = "An abandoned space structure."
	suffix = "generic/space_bar.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 2
	id = "space_bar"

/decl/submap_archetype/space_bar
	map = "space bar"
	descriptor = "A space bar."

/obj/effect/overmap/visitable/sector/space_bar
	name = "space bar"
	desc = "A cozy meeting place floating on space."

/area/space_bar
	name = "Spacer Bar"
	icon_state = "bar"
	flags = RAD_SHIELDED
	requires_power = FALSE
	base_turf = /turf/simulated/floor/plating
	no_light_control = TRUE

/area/space_bar/hangar
	name = "Spacer Bar Hangar"
	icon_state = "exit"