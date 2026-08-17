/datum/map_template/ruin/away_site/tcaf_corvette
	name = "Republic Astroforce Patrol Vessel"
	description = "A patrol vessel of the Republic of Biesel's Republic Astroforce."

	prefix = "ships/biesel/tcaf_corvette/"
	suffix = "tcaf_corvette.dmm"

	traits = list(
		// Deck one
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck two
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	spawn_weight_sector_dependent = list(
	SECTOR_TAU_CETI = 2, // Home turf and well-policed
	SECTOR_VALLEY_HALE = 1.33, // most patrolled border territory
	SECTOR_CORP_ZONE = 0.5, // minimal patrols, bulk of security handled by corporate asset protection
	SECTOR_ROMANOVICH = 1.5 // Home turf (but a bit distal)
	)

	ship_cost = 1
	id = "tcaf_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tcaf_shuttle, /datum/shuttle/autodock/multi/lift/tcaf)

	unit_test_groups = list(3)

/singleton/submap_archetype/tcaf_corvette
	map = "Republic Astroforce Patrol Vessel"
	descriptor = "A patrol vessel of the Republic of Biesel's Republic Astroforce."

/obj/effect/overmap/visitable/ship/tcaf_corvette
	name = "Republic Astroforce Patrol Vessel"
	class = "RAFV" // (R)epublic (A)stro(f)orce (V)essel
	desc = "A staple of the Away Fleets and the quintessential Patrol Vessel rate, the Antlion-class is a retrofitted variant of the Solarian Hainan-class corvette designed by Zavodskoi Interstellar. They are fitted with strong power configurations and Fjolsvin phoronic quantum sensor arrays, capable of surveying the full breadth of a system — a necessity with how much territory one Away Fleet must cover. Vessels of this class often spend months on single patrol routes, provisioned to last longer than other ships of its size. While capable of engaging other similarly sized vessels, the Antlion-class is not designed to withstand heavy fire power, and is intended for hit-and-run engagements."
	icon_state = "tcaf"
	moving_state = "tcaf_moving"
	colors = list("#5d68c8", "#70a2e7")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "tcfl_cetus.png" // Reusing the TCFL sprite.
	designer = "Zavodskoi Interstellar, Republic Astroforce"
	volume = "73 meters length, 41 meters beam/width, 20 meters vertical height"
	drive = "Low Power Bluespace Drive"
	weapons = "Dual ballistic gunnery pods, underside flight craft hangar"
	sizeclass = "Antlion-class corvette"
	shiptype = "Military reconnaissance and extended-duration patrols"
	initial_restricted_waypoints = list(
		"TCAF Gunship" = list("nav_hangar_tcaf")
	)

	initial_generic_waypoints = list(
		"tcaf_corvette_nav1",
		"tcaf_corvette_nav2",
		"tcaf_corvette_nav3",
		"tcaf_corvette_nav4",
		"tcaf_corvette_starboard_dock",
		"tcaf_corvette_port_dock",
		"tcaf_corvette_aft_dock",
		"tcaf_corvette_fore_dock"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tcaf_corvette/New()
	designation = "[pick("Shining Liberty", "Zoleth's Lance", "Live Free or Die", "Watchman", "Velazco", "Valkyrian Dream", "Astraeus", "Caxamalca", "Vezdukh", "Independence", "Light of Liberty", "Bright Tomorrow", "Chandras", "Retribution", "Myrmidon", "Wide Flock", "Old Neopolymus", "Captivity and Freedom", "Home at Last")]"
	..()

// Shape doesn't fit particularly well, but it'd be a shame to leave the sprite unused.
/obj/effect/overmap/visitable/ship/tcaf_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tcfl_corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/overmap/visitable/ship/landable/tcaf_shuttle
	name = "TCAF Armed Transport Shuttle"
	class = "RAFV"
	desc = "A small, armed transport shuttle used by the Republic Astroforce for inter-ship transport and boarding operations."
	shuttle = "TCAF Armed Transport Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Zavodskoi Interstellar, Republic Astroforce"
	weapons = "Fore ballistic weapon mount."
	sizeclass = "Reaver-class Armed Transport Shuttle"
	colors = list("#5d68c8", "#70a2e7")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 2500 // Same as the SCCV Canary. Lower than usual to compensate for only having two thrusters.
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/tcaf_shuttle/New()
	designation = "[pick("Firestorm", "Romanovich", "Hawk of Caprice", "Reade of the Heavens", "Dumas", "As'dak'ii", "Three Served", "Frostfire", "Burning Blue", "2458 Never Again", "Dark Night", "Long Days")]"
	..()

/obj/structure/machinery/computer/shuttle_control/explore/terminal/tcaf_shuttle
	name = "shuttle control console"
	shuttle_tag = "TCAF Armed Transport Shuttle"
	req_access = list(ACCESS_TCAF)

/datum/shuttle/autodock/overmap/tcaf_shuttle
	name = "TCAF Armed Transport Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tcaf)
	current_location = "nav_hangar_tcaf"
	landmark_transition = "nav_transit_tcaf_shuttle"
	dock_target = "airlock_tcaf_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tcaf"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tcaf_shuttle/hangar
	name = "Armed Transport Shuttle Hangar"
	landmark_tag = "nav_hangar_tcaf"
	docking_controller = "tcaf_shuttle_dock"
	base_area = /area/tcaf_corvette/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tcaf_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tcaf_shuttle"
	base_turf = /turf/space/transit/north

/// So people know how to use the engine. There's also a pre-wired spare PACMAN.
/obj/item/paper/fluff/tcaf_corvette_engine_guide
	name = "Antlion-class engine operational notes"
	desc = "This is a handwritten list of steps to operating the combustion engine of an Antlion-class scout corvette."
	info = "<font face=\"Verdana\"><b>Obey these instructions! I swear to god, \
	if we have one single more 'mishap' I am going to see you all assigned to the Zoleth line while I pray for another Solarian invasion.<BR>\
	<BR>STEP 1: Enable the connectors to cold loop pump, and the cooling array to generator pump, to get the cold loop circulating.<BR>\
	<BR>STEP 2: Configure the gas mixer to output north, and inject the contents of as many hydrogen and oxygen tanks into the combustion chamber as you wish, \
	at the pre-set ratio of 60% oxygen and 40% hydrogen.<BR>\
	<BR>STEP 3: Disable injection! Do not leave injection on!<BR>\
	<BR>STEP 4: Ignite the mix inside the combustion chamber, and wait for it to fully burn out. \
	Some strain on the glass at this step is expected.<BR>\
	<BR>STEP 5: Once the fire has stopped and the contents of the tank are 100% CO2, \
	enable circulation: I recommend 700L/s input and 1000kpa output. The higher you put the output, more power it generates, raise as necessary.<BR>\
	<BR>WARNING: If you feel it's going to break the glass, lower the blast doors and vent the chamber immediately! \
	We have a portable generator in the back if we run out of fuel or suffer another mishap.</b></font>"
