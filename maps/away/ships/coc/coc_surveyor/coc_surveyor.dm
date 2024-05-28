/datum/map_template/ruin/away_site/coc_surveyor
	name = "COC Survey Ship"
	description = "Coalition science ship."

	prefix = "ships/coc/coc_surveyor/"
	suffixes = list("coc_surveyor.dmm")

	sectors = list(SECTOR_BADLANDS, ALL_COALITION_SECTORS, ALL_VOID_SECTORS)
	spawn_weight_sector_dependent = list(ALL_BADLAND_SECTORS = 0.5)
	sectors_blacklist = list(SECTOR_HANEUNIM, SECTOR_BURZSIA)
	spawn_weight = 1
	ship_cost = 1
	id = "coc_surveyor"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/coc_survey_shuttle)

	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/coc_surveyor
	map = "COC Survey Ship"
	descriptor = "Coalition science ship."

/obj/effect/overmap/visitable/ship/coc_surveyor
	name = "COC Survey Ship"
	class = "CCV"
	desc = "The Galga-class Surveyor is the newest design-by-committee exploratory ship, created in a joint venture between Xanu and Himeo. Initally, its design was tailored for the effort to better map out the Weeping Stars. However, thanks to a clever series of design choices and a highly efficent warp drive, its become an exploratory and survey workhorse. Intended to be largely self sufficient, its onboard refinery allows it to produce metal stock and retail ready minerals for market. The Galga class is armed with a 90mm flak battery straight from the factory. However, its heavy price tag, powerful thrusters, and large fuel tanks discourage the average captain from getting into a scrap."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#8492fd", "#4d61fc")
	designer = "Coalition of Colonies, Xanu Prime and Himeo"
	volume = "60 meters length, 58 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Single extruding starboard fore-mounted medium caliber armament, aft obscured shuttle dock."
	sizeclass = "Galga-class Surveyor"
	shiptype = "Exploration, mineral and artifact recovery"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	initial_generic_waypoints = list(
		"nav_surveyor_1",
		"nav_surveyor_2",
		"nav_surveyor_3",
		"nav_surveyor_4"
	)
	initial_restricted_waypoints = list(
		"COC Survey Shuttle" = list("nav_hangar_survey")
	)

/obj/effect/overmap/visitable/ship/coc_surveyor/New()
	designation = "[pick("Truffle Pig", "Sapphire", "Unto The Unknown", "Unto The Somewhat Known", "Carbon Hound", "Minerals For Days", "The Not-So-Final Frontier", "Phoron Hunter", "Bloodhound")]"
	..()


/obj/effect/overmap/visitable/ship/landable/coc_survey_shuttle
	name = "COC Survey Shuttle"
	desc = "The Minnow Superduty class is an upgraded and upsized civilian transport shuttle, home grown in the Coalition of Colonies. Boasting a large capacity for storage, a first aid suite, and exosuit charging station. These shuttles are the newest in a long line of industrial workhorses."
	class = "CCV"
	designation = "Minnow Superduty"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "COC Survey Shuttle"
	colors = list("#8492fd", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/coc_survey_shuttle
	name = "shuttle control console"
	shuttle_tag = "COC Survey Shuttle"

/datum/shuttle/autodock/overmap/coc_survey_shuttle
	name = "COC Survey Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/coc_survey_shuttle)
	current_location = "nav_hangar_survey"
	landmark_transition = "nav_transit_survey_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_survey"
	dock_target = "surveyor_shuttle"
	defer_initialisation = TRUE

