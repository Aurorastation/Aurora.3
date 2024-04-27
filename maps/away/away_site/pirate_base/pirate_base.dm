/datum/map_template/ruin/away_site/pirate_base
	name = "pirate base"
	description = "An asteroid with a occupied hangar carved into it."

	prefix = "away_site/pirate_base/"
	suffixes = list("pirate_base.dmm")

	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "pirate"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/pirate_ship)
	unit_test_groups = list(2)

/singleton/submap_archetype/pirate
	map = "pirate base"
	descriptor = "An asteroid with a occupied hangar carved into it."

/obj/effect/overmap/visitable/sector/pirate
	name = "asteroid lair"
	desc = "Scans reveal that there is a unregistered structure within this asteroid, as well as an unpowered vessel docked in a makeshift hangar on the south outer layer. Scans of the vessel indicate that it was reported as stolen several months ago."
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_pirate_1",
		"nav_pirate_2",
		"nav_pirate_3"
	)
	initial_restricted_waypoints = list(
		"Wanted Vessel" = list("nav_hangar_pirate_ship")
	)

/obj/effect/shuttle_landmark/pirate_ship
	base_turf = /turf/space
	base_area = /area/space

//ship stuff
/obj/effect/overmap/visitable/ship/landable/pirate_ship
	name = "Wanted Vessel"
	class = "ICV"
	desc = "\
		A Leapfrog model multi-purpose vessel. \
		An old, rudimentary Hephaestus manufactured vessel that sees use by all sorts of factions and organization. \
		This one has a bounty placed on it by the Coalition of Colonies for piracy and kidnapping.\
		"
	shuttle = "Wanted Vessel"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Hephaestus Industries"
	sizeclass = "Multi-purpose Civilian Leapfrog"
	shiptype = "Multi-purpose"
	volume = "27 meters length, 19 meters beam/width, 14 meters vertical height"
	colors = list("#CD4A4C")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/pirate_ship/New()
	designation = "[pick("Black Betty", "Bastard's Home", "Super Glue Tank", "Battering Ram", "Desperado", "Scimitar", "Arrow's End", "Rustbucket", "Flintlock")]"
	..()

/obj/machinery/computer/shuttle_control/explore/pirate_ship
	name = "shuttle control console"
	shuttle_tag = "Wanted Vessel"

/datum/shuttle/autodock/overmap/pirate_ship
	name = "Wanted Vessel"
	move_time = 20
	shuttle_area = list(/area/shuttle/pirate_shuttle/bridge, /area/shuttle/pirate_shuttle/storage, /area/shuttle/pirate_shuttle/med,
						/area/shuttle/pirate_shuttle/starboard, /area/shuttle/pirate_shuttle/port, /area/shuttle/pirate_shuttle/living)
	current_location = "nav_hangar_pirate_ship"
	landmark_transition = "nav_transit_pirate_ship"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_pirate_ship"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/pirate_ship/hangar
	name = "Asteroid Lair Hangar"
	landmark_tag = "nav_hangar_pirate_ship"
	docking_controller = "pirate_ship_shuttle_dock"
	base_area = /area/mine
	base_turf = /turf/unsimulated/floor/asteroid/ash/rocky
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/pirate_ship/transit
	name = "In Transit"
	landmark_tag = "nav_transit_pirate_ship"
	base_turf = /turf/space
