/datum/map_template/ruin/away_site/hegemony_waypoint
	name = "hegemony waypoint"
	description = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels through potentially perilous routes, and to maintain a watchful eye for pirates. These are cramped facilities that tend only to be manned for days at a time as contracted technicians see to the maintenance of their systems in a short stay before leaving to the next installation. Many waypoints in Uueoa-Esa have fallen into disrepair since their initial constructions, prone to structural damage, electrical malfunctions, and infestations of dangerous pests. The Izweski Hegemony is known to offer financial compensation for third parties willing to return them to full operational capacity. The exact condition of this one is challenging to ascertain from sensor scans, but it is likely to be inactive."
	prefix = "away_site/uueoaesa/hegemony_waypoint/"
	suffixes = list("hegemony_waypoint.dmm")

	sectors = list(SECTOR_UUEOAESA)
	id = "hegemony_waypoint"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(1)

/singleton/submap_archetype/hegemony_waypoint
	map = "hegemony_waypoint"
	descriptor = "A hegemony waypoint."

/obj/effect/overmap/visitable/sector/hegemony_waypoint
	name = "hegemony waypoint"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "depot"
	color = COLOR_CHESTNUT
	desc = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels through potentially perilous routes, and to maintain a watchful eye for pirates. These are cramped facilities that tend only to be manned for days at a time as contracted technicians see to the maintenance of their systems in a short stay before leaving to the next installation. Many waypoints in Uueoa-Esa have fallen into disrepair since their initial constructions, prone to structural damage, electrical malfunctions, and infestations of dangerous pests. The Izweski Hegemony is known to offer financial compensation for third parties willing to return them to full operational capacity. The exact condition of this one is challenging to ascertain from sensor scans, but it is likely to be inactive."
	comms_support = TRUE
	comms_name = "Hegemony Waypoint"
	initial_generic_waypoints = list(
		"waypoint_dock_n",
		"waypoint_dock_e",
		"waypoint_dock_w",
		"waypoint_dock_s",
		"waypoint_n_space",
		"waypoint_e_space",
		"waypoint_w_space",
		"waypoint_s_space"
	)

// Areas
/area/hegemony_waypoint
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	requires_power = TRUE
	ambience = AMBIENCE_GENERIC
	base_turf = /turf/space
	icon_state = "green"

/area/hegemony_waypoint/monitoring
	name = "Hegemonic Waypoint Installation - Monitoring Station"

/area/hegemony_waypoint/hallway
	name = "Hegemonic Waypoint Installation - Central Hallway"

/area/hegemony_waypoint/kitchen
	name = "Hegemonic Waypoint Installation - Kitchen"

/area/hegemony_waypoint/custodial
	name = "Hegemonic Waypoint Installation - Laundry Chamber"

/area/hegemony_waypoint/washroom
	name = "Hegemonic Waypoint Installation - Washroom"

/area/hegemony_waypoint/hydroponics
	name = "Hegemonic Waypoint Installation - Hydroponics"

/area/hegemony_waypoint/eva
	name = "Hegemonic Waypoint Installation - Equipment Chamber"

/area/hegemony_waypoint/engineering
	name = "Hegemonic Waypoint Installation - Power Management Chamber"

/area/hegemony_waypoint/atmos
	name = "Hegemonic Waypoint Installation - Atmospherics Management Chamber"

/area/hegemony_waypoint/shrine
	name = "Hegemonic Waypoint Installation - Ritual Space"

/area/hegemony_waypoint/bunks
	name = "Hegemonic Waypoint Installation - Technicians Quarters"
