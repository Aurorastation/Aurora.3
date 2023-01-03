/datum/map_template/ruin/away_site/hivebot_hub
	name = "derelict supply hub"
	description = "An abandoned supply hub. This one's releasing the telltale signals of a potential hivebot infestation."
	suffix = "away_site/hivebot_hub/hivebot_hub.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 1
	spawn_cost = 1
	id = "hivebot_hub"

/singleton/submap_archetype/hivebot_hub
	map = "derelict supply hub"
	descriptor = "A derelict supply hub."

/obj/effect/overmap/visitable/sector/hivebot_hub
	name = "derelict"
	desc = "An abandoned supply hub. This one's releasing the telltale signs of a potential hivebot infestation."

