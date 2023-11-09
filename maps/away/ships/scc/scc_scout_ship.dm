/datum/map_template/ruin/away_site/scc_scout_ship
	name = "SCCV XYZ Scout Ship"
	description = "SCCV XYZ Desc."
	suffixes = list("ships/scc/scc_scout_ship.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "scc_scout_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scc_scout_shuttle)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/scc_scout_ship
	map = "SCCV XYZ Scout Ship"
	descriptor = "SCCV XYZ Desc."

//ship stuff

/obj/effect/overmap/visitable/ship/scc_scout_ship
	name = "SCCV XYZ Scout Ship"
	class = "SCCV"
	desc = "SCCV XYZ Desc."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	initial_restricted_waypoints = list(
		"SCCV XYZ Scout Shuttle" = list("nav_hangar_scc_scout")
	)

	initial_generic_waypoints = list(
		"nav_scc_scout_ship_1",
		"nav_scc_scout_ship_2"
	)

/obj/effect/overmap/visitable/ship/scc_scout_ship/New()
	designation = "[pick("Foo", "Bar")]"
	..()

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle
	name = "SCC Scout Shuttle"
	desc = "SCC Shuttle Desc."
	shuttle = "SCC Scout Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY
	// name = "Freebooter Shuttle"
	// class = "ICV"
	// designation = "Sheep's Clothing"
	// desc = "The Plough-class tender is an utterly unremarkable engineering vessel, manufactured by Hephaestus and commonly seen attached to Ox-class ships. Scarcely capable of much except short-distance cargo hauling and loading."
	// shuttle = "Freebooter Shuttle"
	// icon_state = "shuttle"
	// moving_state = "shuttle_moving"
	// colors = list("#9dc04c", "#52c24c")
	// max_speed = 1/(3 SECONDS)
	// burn_delay = 2 SECONDS
	// vessel_mass = 3000 //very inefficient pod
	// fore_dir = NORTH
	// vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/scc_scout_shuttle
	name = "shuttle control console"
	shuttle_tag = "SCC Scout Shuttle"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "mass_driver"
	icon_keyboard = "tech_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/datum/shuttle/autodock/overmap/scc_scout_shuttle
	name = "SCCV Scout Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/scc_scout_shuttle)
	dock_target = "airlock_scc_scout_shuttle"
	current_location = "nav_hangar_scc_scout"
	landmark_transition = "nav_transit_scc_scout_ship"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_scc_scout"
