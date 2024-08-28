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
	// designation = "Cuttlefish"
	desc = "A small independent spacecraft."
	icon_state = "generic"
	moving_state = "generic_moving"
	colors = list("#3c423c")
	scanimage = "unathi_freighter1.png"
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 7500
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	comms_name = "modified"
	use_mapped_z_levels = TRUE
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/landable/lone_spacer/New()
	designation = "[pick("Tuckerbag", "Do No Harm", "Volatile Cargo", "Stay Clear", "Entrepreneurial", "Good Things Only", "Worthless", "Skip This One", "Pay No Mind", "Customs-Cleared", "Friendly", "Reactor Leak", "Fool's Gold", "Cursed Cargo", "Guards Aboard")]"
	..()

// Shuttle control console
/obj/machinery/computer/shuttle_control/explore/terminal/lone_spacer
	name = "shuttle control console"
	shuttle_tag = "Independent Skiff"

// This controls how docking behaves
/datum/shuttle/autodock/overmap/lone_spacer
	name = "Independent Skiff"
	move_time = 35
	range = 2
	fuel_consumption = 2
	shuttle_area = list(/area/shuttle/lone_spacer/bridge, /area/shuttle/lone_spacer/bridge_foyer, /area/shuttle/lone_spacer/fore_hall, /area/shuttle/lone_spacer/washroom, /area/shuttle/lone_spacer/storage, /area/shuttle/lone_spacer/port_storage, /area/shuttle/lone_spacer/port_nacelle, /area/shuttle/lone_spacer/starboard_storage, /area/shuttle/lone_spacer/starboard_nacelle)
	current_location = "nav_lone_spacer_space"
	dock_target = "lone_spacer"
	landmark_transition = "nav_lone_spacer_transit"
	logging_home_tag = "nav_lone_spacer_space"
	defer_initialisation = TRUE

// Main shuttle landmark
/obj/effect/shuttle_landmark/ship/lone_spacer
	shuttle_name = "Independent Skiff"
	landmark_tag = "nav_lone_spacer_space"

// Transit landmark
/obj/effect/shuttle_landmark/lone_spacer_transit
	name = "In transit"
	landmark_tag = "nav_lone_spacer_transit"
	base_turf = /turf/space

// Custom stuff
/obj/machinery/light/colored/decayed/lone_spacer_dimmed
	brightness_power = 0.3

/obj/item/clothing/accessory/scarf/lone_spacer_green
	color = "#395340"
