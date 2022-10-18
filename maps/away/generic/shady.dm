/datum/map_template/ruin/away_site/shady
	name = "lone asteroid"
	description = "A lone asteroid with a hangar carved out inside it. Scans detect a structure within, with multiple lifeforms present."
	suffix = "generic/shady.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "shady"

/decl/submap_archetype/shady
	map = "lone asteroid"
	descriptor = "A lone asteroid with a hangar carved out inside it. Scans detect a structure within, with multiple lifeforms present."

/obj/effect/overmap/visitable/sector/shady
	name = "lone asteroid"
	desc = "A lone asteroid with a hangar carved out inside it. Scans detect a structure within, with multiple lifeforms present."
	icon_state = "object"


/area/hideout
	name="hideout outpost"
	icon_state = "outpost_mine_main"
	requires_power = FALSE