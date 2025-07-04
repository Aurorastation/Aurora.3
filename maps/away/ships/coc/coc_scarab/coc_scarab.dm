/datum/map_template/ruin/away_site/coc_scarab
	name = "Scarab Salvage Ship"
	description = "Scarab salvage ship."

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	prefix = "ships/coc/coc_scarab/"
	suffix = "coc_scarab.dmm"

	sectors = list(SECTOR_COALITION, SECTOR_WEEPING_STARS, SECTOR_ARUSHA, SECTOR_LIBERTYS_CRADLE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_CRESCENT_EXPANSE_EAST)
	spawn_weight = 1
	ship_cost = 1
	id = "coc_scarab"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scarab_shuttle, /datum/shuttle/autodock/multi/lift/scarab)
	unit_test_groups = list(1)

/singleton/submap_archetype/coc_scarab
	map = "Scarab Salvage Ship"
	descriptor = "Scarab salvage ship."

/obj/effect/overmap/visitable/ship/coc_scarab
	name = "Scarab Salvage Ship"
	class = "SFV" //Scarab Fleet Vessel
	desc = "The Burrow-class is an archaic transport vessel, originally commissioned by the Solarian Department of Colonization for Colony Fleet SFE-528-RFS - in modern times, better known as the Scarab Fleet. This one has been modified to an incredibly extensive degree, with large swathes of the original design having been cannibalised, and many new systems having been retrofitted on. A large network of lattices and catwalks appears to have been installed on the exterior hull."
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#a400c1", "#4d61fc")
	designer = "Einstein Engines"
	volume = "56 meters length, 24 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard fore ballistic armament, underside flight craft."
	sizeclass = "Modified Burrow-class Transport."
	shiptype = "Salvage, fuel extraction and mineral exploitation."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	initial_generic_waypoints = list(
		"scarab_nav1",
		"scarab_nav2",
		"scarab_nav3",
		"scarab_nav4",
		"scarab_nav5",
		"scarab_nav6",
		"scarab_nav7",
		"scarab_nav8",
		"scarab_dock1",
		"scarab_dock2",
		"scarab_dock3",
		"scarab_dock4",
		"scarab_dock5",
		"scarab_dock6"
	)
	initial_restricted_waypoints = list(
		"Scarab Shuttle" = list("nav_scarab_start"),
	)

/obj/effect/overmap/visitable/ship/coc_scarab/New()
	designation = "[pick("Umphangi", "Umfuni", "Zibal", "Albahith", "Sikeo", "Chaj-a Hemaeda", "Khog Tseverlegch", "Khaigch")]"
	..()

/obj/effect/shuttle_landmark/coc_scarab
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/coc_scarab/nav1
	name = "Scarab Salvage Vessel - Deck Two Fore"
	landmark_tag = "scarab_nav1"

/obj/effect/shuttle_landmark/coc_scarab/nav2
	name = "Scarab Salvage Vessel - Deck Two Aft"
	landmark_tag = "scarab_nav2"

/obj/effect/shuttle_landmark/coc_scarab/nav3
	name = "Scarab Salvage Vessel - Deck Two Port"
	landmark_tag = "scarab_nav3"

/obj/effect/shuttle_landmark/coc_scarab/nav4
	name = "Scarab Salvage Vessel - Deck Two Starboard"
	landmark_tag = "scarab_nav4"

/obj/effect/shuttle_landmark/coc_scarab/nav5
	name = "Scarab Salvage Vessel - Deck One Fore"
	landmark_tag = "scarab_nav5"

/obj/effect/shuttle_landmark/coc_scarab/nav6
	name = "Scarab Salvage Vessel - Deck One Aft"
	landmark_tag = "scarab_nav6"

/obj/effect/shuttle_landmark/coc_scarab/nav7
	name = "Scarab Salvage Vessel - Deck One Port"
	landmark_tag = "scarab_nav7"

/obj/effect/shuttle_landmark/coc_scarab/nav8
	name = "Scarab Salvage Vessel - Deck One Starboard"
	landmark_tag = "scarab_nav8"

/obj/effect/shuttle_landmark/coc_scarab/dock1
	name = "Scarab Salvage Vessel - Port Dock #1"
	landmark_tag = "scarab_dock1"

/obj/effect/shuttle_landmark/coc_scarab/dock2
	name = "Scarab Salvage Vessel - Port Dock #2"
	landmark_tag = "scarab_dock2"

/obj/effect/shuttle_landmark/coc_scarab/dock3
	name = "Scarab Salvage Vessel - Port Dock #3"
	landmark_tag = "scarab_dock3"

/obj/effect/shuttle_landmark/coc_scarab/dock4
	name = "Scarab Salvage Vessel - Starboard Dock #1"
	landmark_tag = "scarab_dock4"

/obj/effect/shuttle_landmark/coc_scarab/dock5
	name = "Scarab Salvage Vessel - Starboard Dock #2"
	landmark_tag = "scarab_dock5"

/obj/effect/shuttle_landmark/coc_scarab/dock6
	name = "Scarab Salvage Vessel - Starboard Dock #3"
	landmark_tag = "scarab_dock6"

//Shuttle
/obj/effect/overmap/visitable/ship/landable/scarab_shuttle
	name = "Scarab Shuttle"
	desc = "An extremely early predecessor to the modern Pickaxe-class, the Mattock-class mining shuttle was a common sight throughout human space some centuries ago, prized for its reliability and simplicity. By the extremely irregular hull composition of this one, this appears to be a real-life Ship of Theseus - it is hard to determine how much of the original ship is even left. Abnormal internal readings suggest the presence of complex atmospheric systems inside."
	class = "SFV"
	designation = "Bazaar"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Scarab Shuttle"
	colors = list("#a400c1", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Einstein Engines"
	volume = "16 meters length, 13 meters beam/width, 8 meters vertical height"
	sizeclass = "Mattock-class Mining Shuttle"
	shiptype = "Mineral exploitation and salvage operations"

/obj/machinery/computer/shuttle_control/explore/terminal/scarab_shuttle
	name = "shuttle control terminal"
	shuttle_tag = "Scarab Shuttle"

/datum/shuttle/autodock/overmap/scarab_shuttle
	name = "Scarab Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/coc_scarab/central, /area/shuttle/coc_scarab/port, /area/shuttle/coc_scarab/starboard)
	dock_target = "airlock_scarab_shuttle"
	current_location = "nav_scarab_start"
	landmark_transition = "nav_scarab_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scarab_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/coc_scarab/shuttle_start
	name = "Scarab Salvage Vessel - Shuttle Dock"
	landmark_tag = "nav_scarab_start"
	docking_controller = "scarab_shuttle_dock"

/obj/effect/shuttle_landmark/coc_scarab/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_scarab_transit"
	base_turf = /turf/space/transit/north

// Lift
/datum/shuttle/autodock/multi/lift/scarab
	name = "Scarab Lift"
	current_location = "nav_scarab_lift_first_deck"
	shuttle_area = /area/turbolift/coc_scarab/scarab_lift
	destination_tags = list(
		"nav_scarab_lift_first_deck",
		"nav_scarab_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/scarab_first_deck
	name = "Scarab Salvager Lift - First Deck"
	landmark_tag = "nav_scarab_lift_first_deck"
	base_area = /area/ship/coc_scarab/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/scarab_second_deck
	name = "Scarab Salvager Lift - Second Deck"
	landmark_tag = "nav_scarab_lift_second_deck"
	base_area = /area/ship/coc_scarab/cargobay
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/scarab
	shuttle_tag = "Scarab Lift"

// CUSTOM STUFF
// Dimmed yellow lights
/obj/machinery/light/floor/decayed
	brightness_color = "#fabd6d"
	randomize_color = FALSE
	brightness_power = 0.3

/obj/machinery/light/colored/decayed/dimmed
	brightness_power = 0.2

// Guide to the combustion engine
/obj/item/paper/fluff/scarabengine
	name = "Burrow-class Freighter Engine Field Guide"
	desc = "A paper."
	info = "This is the field guide for the combustion engine of a Burrow-class freight vessel.<BR><BR>A combustion engine works by burning a fire in a combustion chamber, letting it burn out to 100% CO2, and then running the superheated gas through a vent, into a thermoelectric generator, and back into the chamber. This produces a lot of power, and will be required to keep the ship SMES topped up in the long term, but slowly cools down while in use. <BR><BR>GUIDE FOR USE:<BR><BR>Step 1: pressurise the cold loop with at least 2 canisters of hydrogen. The cold loop is the one that runs out into an external radiator array.<BR><BR>Step 2: configure the mixer to output a 60% oxygen and 40% hydrogen mix, and inject as much gas into the chamber as is available to you. <BR><BR>Step 3: cut injection, and ignite the mix. Do not panic when the glass makes a noise, that is normal and should stop after a short period.<BR><BR>Step 3: once the fire has fully burned out, enable combustion chamber injection at 700L/s and output at 1000kPa, so the gas begins to circulate through the thermoelectric generator. Lowering the output pressure will cause it to produce less power while causing the chamber to cool down slower, and raising the output pressure will cause the inverse. Do not generally raise the output above roughly 2000kPa, as this will cause it to cool down very quickly while generating more power than the engine SMES can actually intake, wasting heat. When you do not need power from it, disable the output and input to preserve the heat inside.<BR><BR>WARNING: Do not leave injection on after ignition, and if you think the glass might break, immediately cut fuel injection and lower the blast doors!"
	language = LANGUAGE_GUTTER

// Golden variant of the passblade, because it looks weird with the standard white
/obj/item/clothing/accessory/badge/passcard/scarab/gold
	color = "#C0B243"

// Drab offworlder clothing
/obj/item/clothing/under/offworlder/drab
	color = "#554444"

/obj/item/clothing/accessory/offworlder/drab
	color = "#554444"

/obj/item/clothing/accessory/offworlder/bracer/drab
	color = "#554444"

/obj/item/clothing/accessory/offworlder/bracer/neckbrace/drab
	color = "#554444"

/obj/item/clothing/gloves/offworlder/drab
	color = "#554444"

/obj/item/clothing/mask/offworlder/drab
	color = "#724e6f"
