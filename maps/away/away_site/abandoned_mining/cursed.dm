/datum/map_template/ruin/away_site/cursed
	name = "lone asteroid"
	description = "A lone asteroid with a hangar. Latest data from this sector shows it as a Hephaestus mining station, two years ago."
	suffix = "away_site/abandoned_mining/cursed.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "cursed"

/decl/submap_archetype/cursed
	map = "lone asteroid"
	descriptor = "A lone asteroid with a hangar. Latest data from this sector shows it was a Hephaestus mining station, two years ago."

/obj/effect/overmap/visitable/sector/cursed
	name = "lone asteroid"
	desc = "A lone asteroid with a hangar. Latest data from this sector shows it as a Hephaestus mining station, two years ago."


/area/cursed
	name="cursed station"
	icon_state = "outpost_mine_main"
	requires_power = TRUE
/area/cursed/hangar
	name="hangar"
	icon_state = "outpost_mine_main"
/area/cursed/living_area
	name="crew quarters"
	icon_state = "fitness"
/area/cursed/bridge
	name="mining outpost control"
	icon_state = "bridge"
/area/cursed/engineering
	name="mining outpost engineering"
	icon_state = "outpost_engine"
/area/cursed/computer_core
	name="computer core"
	icon_state = "ai"
/area/cursed/storage
	name="warehouse"
	icon_state = "storage"
/area/cursed/medical
	name="medical"
	icon_state = "exam_room"
/area/cursed/eva_storage
	name="eva storage"
	icon_state = "eva"
/area/cursed/mineral_processing
	name="mineral processing"
	icon_state = "mining"
