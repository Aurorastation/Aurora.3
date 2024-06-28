/datum/map_template/ruin/away_site/hegemony_waypoint
	name = "hegemony waypoint"
	description = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels throughout the system."
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
	desc = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels throughout the system."
	comms_support = TRUE
	comms_name = "Hegemony Waypoint"
	initial_generic_waypoints = list(
	)
