/datum/map_template/ruin/away_site/hivebot_hub
	name = "derelict supply hub"
	description = "An abandoned supply hub. This one's releasing the telltale signals of a potential hivebot infestation."
	suffixes = list("away_site/hivebot_hub/hivebot_hub.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "hivebot_hub"

	unit_test_groups = list(1)

/area/hivebothub
	icon_state = "red"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED
	has_gravity = FALSE

/area/hivebothub/portdocks
	name = "Independent Supply Hub - Port Docks"

/area/hivebothub/starboarddocks
	name = "Independent Supply Hub - Starboard Docks"

/area/hivebothub/starboarddocks
	name = "Independent Supply Hub - Starboard Docks"

/area/hivebothub/centralhall
	name = "Independent Supply Hub - Central Hallway"

/area/hivebothub/engi
	name = "Independent Supply Hub - Engineering"

/area/hivebothub/atmos
	name = "Independent Supply Hub - Atmospherics"

/area/hivebothub/dorm1
	name = "Independent Supply Hub - Dormitory #1"

/area/hivebothub/dorm2
	name = "Independent Supply Hub - Dormitory #2"

/area/hivebothub/kitchen
	name = "Independent Supply Hub - Kitchen"

/area/hivebothub/washroom
	name = "Independent Supply Hub - Washroom"

/area/hivebothub/secure
	name = "Independent Supply Hub - Secure Storage"

/area/hivebothub/bridge
	name = "Independent Supply Hub - Bridge"

/area/hivebothub/exterior
	name = "Independent Supply Hub - Exterior"
	icon_state = "exterior"

/singleton/submap_archetype/hivebot_hub
	map = "derelict supply hub"
	descriptor = "A derelict supply hub."

/obj/effect/overmap/visitable/sector/hivebot_hub
	name = "derelict"
	desc = "An abandoned supply hub. This one's releasing the telltale signs of a potential hivebot infestation."

