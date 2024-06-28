/datum/map_template/ruin/away_site/hegemony_waypoint
	name = "hegemony waypoint"
	description = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels through potentially perilous routes, and to maintain a watchful eye for pirates. These are cramped facilities that tend only to be manned for days at a time as contracted technicians see to the maintenance of their systems in a short stay before leaving to the next installation. Many waypoints in Uueoa-Esa have fallen into disrepair since their initial constructions, prone to structural damage, electrical malfunctions, and infestations of dangerous pests. The Izweski Hegemony is known to offer financial compensation for third parties willing to return them to full operational capacity. The condition of this one is challenging to ascertain from sensor scans, but it appears likely to be inactive."
	prefix = "away_site/uueoaesa/hegemony_waypoint/"
	suffixes = list("hegemony_waypoint.dmm")

	sectors = list(SECTOR_UUEOAESA)
	id = "hegemony_waypoint"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(1)

/singleton/submap_archetype/hegemony_waypoint
	map = "hegemony_waypoint"
	descriptor = "A hegemony waypoint."

/obj/effect/overmap/visitable/sector/sensor_relay
	name = "hegemony waypoint"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "depot"
	color = COLOR_CHESTNUT
	description = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels through potentially perilous routes, and to maintain a watchful eye for pirates. These are cramped facilities that tend only to be manned for days at a time as contracted technicians see to the maintenance of their systems in a short stay before leaving to the next installation. Many waypoints in Uueoa-Esa have fallen into disrepair since their initial constructions, prone to structural damage, electrical malfunctions, and infestations of dangerous pests. The Izweski Hegemony is known to offer financial compensation for third parties willing to return them to full operational capacity. The condition of this one is challenging to ascertain from sensor scans, but it appears likely to be inactive."
	comms_support = TRUE
	comms_name = "Hegemony Waypoint"
	initial_generic_waypoints = list(
	)
