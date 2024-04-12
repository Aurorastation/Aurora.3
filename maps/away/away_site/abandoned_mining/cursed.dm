/datum/map_template/ruin/away_site/cursed
	name = "lone asteroid"
	description = "A lone asteroid with a hangar. Latest data from this sector shows it as a Hephaestus mining station, two years ago."
	suffixes = list("away_site/abandoned_mining/cursed.dmm")
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	sectors_blacklist = list(SECTOR_HANEUNIM, SECTOR_BURZSIA, SECTOR_TAU_CETI) //you're not gonna have a station left alone for 2 years in the middle of inhabited space
	spawn_weight = 1
	spawn_cost = 1
	id = "cursed"

	unit_test_groups = list(1)

/singleton/submap_archetype/cursed
	map = "lone asteroid"
	descriptor = "A lone asteroid with a hangar. Latest data from this sector shows it was a Hephaestus mining station, two years ago."

/obj/effect/overmap/visitable/sector/cursed
	name = "lone asteroid"
	desc = "A lone asteroid with a hangar. Latest data from this sector shows it as a Hephaestus mining station, two years ago."


/area/cursed
	name="cursed station"
	icon_state = "outpost_mine_main"
	requires_power = TRUE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

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
