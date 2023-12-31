/datum/map_template/ruin/away_site/coc_scarab
	name = "Scarab Salvage Ship"
	description = "Scarab salvage ship."
	suffixes = list("ships/coc/coc_scarab/coc_scarab.dmm")
	sectors = list(SECTOR_COALITION, SECTOR_WEEPING_STARS, SECTOR_ARUSHA, SECTOR_LIBERTYS_CRADLE)
	spawn_weight = 1
	ship_cost = 1
	id = "coc_scarab"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scarab_gas_harvester, /datum/shuttle/autodock/overmap/scarab_shuttle)

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
	volume = "57 meters length, 48 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard fore ballistic armament, dual port flight craft."
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
		"scarab_dock1",
		"scarab_dock2",
		"scarab_dock3",
		"scarab_dock4",
		"scarab_dock5",
		"scarab_dock6"
	)
	initial_restricted_waypoints = list(
		"Scarab Shuttle" = list("nav_scarab_start"),
		"Scarab Gas Harvester" = list("nav_scarab_harvester_start")
	)

/obj/effect/overmap/visitable/ship/coc_scarab/New()
	designation = "[pick("Umphangi", "Umfuni", "Zibal", "Albahith", "Sikeo", "Chaj-a Hemaeda", "Khog Tseverlegch", "Khaigch")]"
	..()

/obj/effect/shuttle_landmark/coc_scarab
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/coc_scarab/nav1
	name = "Scarab Salvage Vessel - Fore"
	landmark_tag = "scarab_nav1"

/obj/effect/shuttle_landmark/coc_scarab/nav2
	name = "Scarab Salvage Vessel - Aft"
	landmark_tag = "scarab_nav2"

/obj/effect/shuttle_landmark/coc_scarab/nav3
	name = "Scarab Salvage Vessel - Port"
	landmark_tag = "scarab_nav3"

/obj/effect/shuttle_landmark/coc_scarab/nav4
	name = "Scarab Salvage Vessel - Starboard"
	landmark_tag = "scarab_nav4"

/obj/effect/shuttle_landmark/coc_scarab/dock1
	name = "Scarab Salvage Vessel - Port Dock #1"
	landmark_tag = "scarab_dock1"

/obj/effect/shuttle_landmark/coc_scarab/dock2
	name = "Scarab Salvage Vessel - Port Dock #2"
	landmark_tag = "scarab_dock2"

/obj/effect/shuttle_landmark/coc_scarab/dock3
	name = "Scarab Salvage Vessel - Starboard Dock #1"
	landmark_tag = "scarab_dock3"

/obj/effect/shuttle_landmark/coc_scarab/dock4
	name = "Scarab Salvage Vessel - Starboard Dock #2"
	landmark_tag = "scarab_dock4"

/obj/effect/shuttle_landmark/coc_scarab/dock5
	name = "Scarab Salvage Vessel - Starboard Dock #3"
	landmark_tag = "scarab_dock5"

/obj/effect/shuttle_landmark/coc_scarab/dock6
	name = "Scarab Salvage Vessel - Port Dock #3"
	landmark_tag = "scarab_dock6"

//Shuttles
/obj/effect/overmap/visitable/ship/landable/scarab_gas_harvester
	name = "Scarab Gas Harvester"
	desc = "An absolutely archaic skiff, the Triton-class is a highly specialised tool designed to harvest precious elements by sifting through the atmospheres of gas giants. While ubiquitous throughout human space some centuries ago, it dropped off sharply in popularity following the Interstellar War. This one appears to have been extensively modified, with abnormal internal readings that may imply particularly complex atmospheric systems."
	class = "SFV"
	designation = "Rubedo"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Scarab Gas Harvester"
	colors = list("#a400c1", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Einstein Engines"
	volume = "13 meters length, 11 meters beam/width, 6 meters vertical height"
	sizeclass = "Triton-class Gas Harvesting Shuttle"
	shiptype = "Gas mining operations"

/obj/machinery/computer/shuttle_control/explore/terminal/scarab_gas_harvester
	name = "shuttle control terminal"
	shuttle_tag = "Scarab Gas Harvester"

/datum/shuttle/autodock/overmap/scarab_gas_harvester
	name = "Scarab Gas Harvester"
	move_time = 20
	shuttle_area = list(/area/shuttle/scarab_harvester)
	current_location = "nav_scarab_harvester_start"
	landmark_transition = "nav_scarab_harvester_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scarab_harvester_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/coc_scarab/harvester_start
	name = "Scarab Salvage Vessel - Harvester Dock"
	landmark_tag = "nav_scarab_harvester_start"

/obj/effect/shuttle_landmark/coc_scarab/harvester_transit
	name = "In transit"
	landmark_tag = "nav_scarab_harvester_transit"
	base_turf = /turf/space/transit/north

/obj/effect/overmap/visitable/ship/landable/scarab_shuttle
	name = "Scarab Shuttle"
	desc = "An extremely early predecessor to the modern Pickaxe-class, the Mattock-class mining shuttle was a common sight throughout human space some centuries ago, prized for its reliability and simplicity. By the extremely irregular hull composition of this one, this appears to be a real-life Ship of Theseus - it is hard to determine how much of the original ship is even left."
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
	shuttle_area = list(/area/shuttle/coc_scarab)
	current_location = "nav_scarab_start"
	landmark_transition = "nav_scarab_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_scarab_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/coc_scarab/shuttle_start
	name = "Scarab Salvage Vessel - Shuttle Dock"
	landmark_tag = "nav_scarab_start"

/obj/effect/shuttle_landmark/coc_scarab/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_scarab_transit"
	base_turf = /turf/space/transit/north

// CUSTOM STUFF
// Dimmed yellow lights
/obj/machinery/light/floor/decayed
	brightness_color = "#fabd6d"
	randomize_color = FALSE
	brightness_power = 0.3

/obj/machinery/light/colored/decayed/dimmed
	brightness_power = 0.2

// Guide to the combustion engine
/obj/item/paper/fluff/scarab
	name = "Technician's Notice"
	info = "KEEP THIS NOTE ADJACENT TO THE ENGINE. This is our ship's combustion engine. We burn a fire in the chamber, let it fully burn out, and then run the superheated gas through a vent, into our thermoelectric generator, and back into the chamber. This produces a lot of power, and will be required to keep our SMES topped up in the long term. It will slowly cool down, and may occasionally need more burner mix to be injected to keep it hot enough for our needs. Repairing the inside of the chamber may occasionally become necessary, as a particularly hot burn will damage the walls and windows. GUIDE FOR USE: Step one: configure the mixer to output a 60% oxygen and 40% hydrogen mix. Inject a few hundred kPa of this mix into the chamber. Step 2: cut injection, and ignite the mix. Do not panic when the glass makes a noise, that is normal. Step 3: once the fire has fully burned out, enable combustion chamber injection and output, so the gas begins to circulate through the thermoelectric generator. Innovation upon this basic method is welcome! Do not leave injection on after ignition, and if you think the glass might break, immediately cut fuel injection and lower the blast doors!"

/obj/item/paper/fluff/scarab/Initialize()
	. = ..()
	var/languagetext = "\[lang=3\]"
	languagetext += "[info]\[/lang\]"
	info = parsepencode(languagetext)
	icon_state = "paper_words"

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
	color = "#424d72"
