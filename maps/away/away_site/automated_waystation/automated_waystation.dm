/datum/map_template/ruin/away_site/automated_waystation
	name = "Automated Waystation"
	description = "Automated Waystation."
	unit_test_groups = list(1)

	id = "automated_waystation"
	spawn_cost = 1
	spawn_weight = 1
	prefix = "away_site/automated_waystation/"
	suffixes = list("automated_waystation.dmm")

	sectors = list(ALL_COALITION_SECTORS)

/singleton/submap_archetype/automated_waystation
	map = "automated waystation"
	descriptor = "Automated Waystation."

/obj/effect/overmap/visitable/sector/automated_waystation
	name = "Automated Waystation"
	desc = "An automated Waystation, set up by the Solarian Alliance’s Department of Colonization, and now maintained by the Coalition of Colonies, to act as stationary rest points. It appears to be pressurized, but inactive."
	icon_state = "sensor_relay"

	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "automated_waystation"
	color = "#3f4b81"
	designer = "ASSN Department of Colonization"
	volume = "44 meters length, 44 meters width, 10 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Waystation"

	initial_generic_waypoints = list(
		"nav_automated_waystation_north",
		"nav_automated_waystation_east",
		"nav_automated_waystation_south",
		"nav_automated_waystation_west"
	)

/obj/effect/shuttle_landmark/automated_waystation/nav_north
	name = "North Beacon"
	landmark_tag = "nav_automated_waystation_north"

/obj/effect/shuttle_landmark/automated_waystation/nav_east
	name = "East Beacon"
	landmark_tag = "nav_automated_waystation_east"

/obj/effect/shuttle_landmark/automated_waystation/nav_south
	name = "South Beacon"
	landmark_tag = "nav_automated_waystation_south"

/obj/effect/shuttle_landmark/automated_waystation/nav_west
	name = "West Beacon"
	landmark_tag = "nav_automated_waystation_west"

// -------------------------------- areas

/area/automated_waystation
	name= "automated waystation"
	icon_state = "away"
	requires_power = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED
	dynamic_lighting = TRUE
	no_light_control = TRUE
	has_gravity = FALSE

/area/automated_waystation/engineering
	name="Waystation Engineering Module"
	icon_state = "engineering"
	area_blurb = "\
	You hear a robotic voice coming from cheap ceiling-mounted speakers: \
	'This is an Automated Waystation, operated by the Coalition of Colonies. You are welcome to use any of the facilities provided, but are required to clean up after. Any attempt to vandalize this Waystation will have a bounty placed on your ship and crew. Your IFF was logged upon docking.'\
	"
/area/automated_waystation/sensors
	name="Waystation Sensor Suite"
	icon_state = "observatory"
/area/automated_waystation/medical
	name="Waystation Medical Module"
	icon_state = "medbay"
/area/automated_waystation/bathroom
	name="Waystation Lavatory Module"
	icon_state = "restrooms"
/area/automated_waystation/bedroom
	name="Waystation Rest and Recreation Module"
	icon_state = "crew_quarters"
/area/automated_waystation/canteen
	name="Waystation Canteen and Hydroponics Module"
	icon_state = "kitchen"
/area/automated_waystation/atmospherics
	name="Waystation Atmospherics Module"
	icon_state = "atmos"
	area_blurb = "\
	You hear a robotic voice coming from cheap ceiling-mounted speakers: \
	'This is an Automated Waystation, operated by the Coalition of Colonies. You are welcome to use any of the facilities provided, but are required to clean up after. Any attempt to vandalize this Waystation will have a bounty placed on your ship and crew. Your IFF was logged upon docking.'\
	"
/area/automated_waystation/exterior
    name = "Exterior"
    icon_state = "space"
