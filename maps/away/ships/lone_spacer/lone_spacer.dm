/datum/map_template/ruin/away_site/lone_spacer
	name = "Independent Skiff"
	id = "lone_spacer"
	description = "A small independent spacecraft."

	prefix = "ships/lone_spacer/"
	suffix = "lone_spacer.dmm"

	spawn_weight = 1
	ship_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/lone_spacer)
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(1)

/singleton/submap_archetype/lone_spacer
	map = "Independent Skiff"
	descriptor = "A small independent spacecraft."

// Shuttle stuff!
/obj/effect/overmap/visitable/ship/landable/lone_spacer
	name = "Independent Skiff"
	class = "ICV"
	shuttle = "Independent Skiff"
	designation = "Cuttlefish"
	desc = "A small independent spacecraft."
	icon_state = "generic"
	moving_state = "generic_moving"
	colors = list("#3c423c")
	scanimage = "unathi_freighter1.png"
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	comms_name = "modified"
	use_mapped_z_levels = TRUE
	invisible_until_ghostrole_spawn = TRUE

/obj/machinery/computer/shuttle_control/explore/terminal/lone_spacer
	name = "shuttle control console"
	shuttle_tag = "Independent Skiff"

/datum/shuttle/autodock/overmap/lone_spacer
	name = "Independent Skiff"
	move_time = 35
	range = 2
	fuel_consumption = 6
	shuttle_area = list(/area/shuttle/lone_spacer/bridge, /area/shuttle/lone_spacer/bridge_foyer, /area/shuttle/lone_spacer/fore_hall, /area/shuttle/lone_spacer/washroom, /area/shuttle/lone_spacer/storage, /area/shuttle/lone_spacer/port_storage, /area/shuttle/lone_spacer/port_nacelle, /area/shuttle/lone_spacer/starboard_storage, /area/shuttle/lone_spacer/starboard_nacelle)
	current_location = "nav_lone_spacer_space"
	dock_target = "lone_spacer"
	landmark_transition = "nav_lone_spacer_transit"
	logging_home_tag = "nav_lone_spacer_space"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ship/lone_spacer
	shuttle_name = "Independent Skiff"
	landmark_tag = "nav_lone_spacer_space"

/obj/effect/shuttle_landmark/lone_spacer_transit
	name = "In transit"
	landmark_tag = "nav_lone_spacer_transit"
	base_turf = /turf/space

/area/shuttle/lone_spacer
	name = "Tramp Freighter"
	icon_state = "bluenew"
	requires_power = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/lone_spacer/bridge
	name = "Lone Spacer - Bridge"

/area/shuttle/lone_spacer/bridge_foyer
	name = "Lone Spacer - Bridge Foyer"

/area/shuttle/lone_spacer/fore_hall
	name = "Lone Spacer - Fore Hall"

/area/shuttle/lone_spacer/washroom
	name = "Lone Spacer - Washroom"

/area/shuttle/lone_spacer/storage
	name = "Lone Spacer - Storage Compartments"

/area/shuttle/lone_spacer/port_storage
	name = "Lone Spacer - Portside Storage"

/area/shuttle/lone_spacer/port_nacelle
	name = "Lone Spacer - Portside Nacelle"

/area/shuttle/lone_spacer/starboard_storage
	name = "Lone Spacer - Starboard Storage"

/area/shuttle/lone_spacer/starboard_nacelle
	name = "Lone Spacer - Starboard Nacelle"
