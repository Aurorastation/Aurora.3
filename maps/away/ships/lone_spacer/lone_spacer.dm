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

	unit_test_groups = list(1)

/singleton/submap_archetype/lone_spacer
	map = "Independent Skiff"
	descriptor = "A small independent spacecraft."

// Shuttle stuff!
/obj/effect/overmap/visitable/ship/landable/lone_spacer
	name = "Independent Skiff"
	class = "ICV"
	shuttle = "Independent Skiff"
	desc = "Of all of the most ubiquitous ships in the spur today, the Minnow-class skiff has perhaps seen one of the most meteoric rises. Designed in 2443 by Hephaestus Industries as a short-distance hauling craft intended to be operated by only one or two crewmates, the Minnow-class quickly caught on with virtually every demographic imaginable - logisticians appreciated its standardised design and expansive cargo holds, scientists its ease of use and modification, smugglers its nimble speed and ability to dodge patrols with its warp drive, and pirates its discreet and inexpensive nature. Due to this, it's challenging to make any reliable precursory judgement on how a Minnow-class hauler pays back its costs, and it's even harder to predict the character of its pilots. Some caution is advised."
	icon_state = "spacer"
	moving_state = "spacer_moving"
	colors = list("#70a170")
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 7500
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	use_mapped_z_levels = TRUE
	invisible_until_ghostrole_spawn = TRUE
	designer = "Hephaestus Industries"
	volume = "30 meters length, 20 meters beam/width, 7 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard low-end ballistic cannon"
	sizeclass = "Minnow-class Hauler"
	shiptype = "Eclectic short-distance shipping utilities"

/obj/effect/overmap/visitable/ship/landable/lone_spacer/New()
	designation = "[pick("Roach", "Moonskipper", "Thunder", "Firefly", "Starfarer", "Workhorse", "Light-in-the-Dark", "Gift Horse", "Rain", "Mirth", "Ever-Lucky", "Tin-and-Copper", "Bright Burning", "Bird-of-the-Heavens", "Ruby", "Old Story", "Fardancer", "Albedo", "Lightchaser", "Sooner-than-Later", "Sunlight", "Pearl-of-the-Morning", "Endless", "Finity", "Calm Drift", "Mercury's Hand")]"
	..()

// Shuttle control console
/obj/machinery/computer/shuttle_control/explore/terminal/lone_spacer
	name = "shuttle control console"
	shuttle_tag = "Independent Skiff"

// This controls how docking behaves
/datum/shuttle/autodock/overmap/lone_spacer
	name = "Independent Skiff"
	move_time = 20
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
	name = "faded green scarf"
	desc = "A soft green scarf, worn at the edges. You see faint embroidery, faded with time beyond recognition."

// Feels bad to develop around bugs, but I don't see myself fixing the telecommunications bug imminently so it'll have to do.
/obj/item/paper/fluff/lone_spacer_note
	name = "scrawled note"
	desc = "A paper. It's a little crumpled."
	info = "<font face=\"Verdana\"><b>NOTE TO SELF: MUST CLEAR FILTERING FREQUENCIES IN SERVER.</b></center></font>"
