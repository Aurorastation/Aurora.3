/datum/map_template/ruin/away_site/civilian_station
	name = "civilian station"
	description = "A modestly-sized independently-owned civilian space station. Many of these exist all throughout inhabited space, offering a place to rest, food to eat, shopping, and refueling - part mall, part motel. This one appears to have been active in the region long before Biesel took control, and an information lookup indicates that it is operated by a small company that is Solarian in origin. This one's transponder says it's open for business!"
	suffix = "away_site/civ_station/civilian_station.dmm"
	sectors = list(SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 2
	id = "civilian_station"

/singleton/submap_archetype/civilian_station
	map = "civilian station"
	descriptor = "A modestly-sized independently-owned civilian space station. Many of these exist all throughout inhabited space, offering a place to rest, food to eat, shopping, and refueling - part mall, part motel. This one appears to have been active in the region long before Biesel took control, and an information lookup indicates that it is operated by a small company that is Solarian in origin. This one's transponder says it's open for business!"

/obj/effect/overmap/visitable/sector/civilian_station
	name = "civilian station"
	desc = "A modestly-sized independently-owned civilian space station. Many of these exist all throughout inhabited space, offering a place to rest, food to eat, shopping, and refueling - part mall, part motel. This one appears to have been active in the region long before Biesel took control, and an information lookup indicates that it is operated by a small company that is Solarian in origin. This one's transponder says it's open for business!"
	comms_support = TRUE
	comms_name = "station"

/area/civilian_station
	name = "Civilian Station"
	icon_state = "bar"
	flags = RAD_SHIELDED | HIDE_FROM_HOLOMAP
	requires_power = FALSE
	base_turf = /turf/simulated/floor/plating
	no_light_control = TRUE

/area/civilian_station/hangar
	name = "Civilian Station Hangar"
	icon_state = "exit"
