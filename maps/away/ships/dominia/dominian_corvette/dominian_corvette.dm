/datum/map_template/ruin/away_site/dominian_corvette
	name = "Dominian Corvette"
	description = "One of the most common ships in the Imperial Fleet, Lammergeier-class corvettes are often used as the vanguard of battlefleets entering a system marked for annexation into the glorious Empire as it is tasked to find and scout routes for the larger fleet. Though intended for scouting and screening work the Lammergeier is, like its larger counterparts, quite heavily armed and armored for a typical corvette. Any frontier savages who attempt to meet one with force of arms will soon find themselves staring down the barrels of Zhurong’s finest weaponry, and the Fleet-trained Ma’zals entrusted to operate it. The heavy armament and sensors of the Lammergeier-class come at a cost: it lacks a shield generator and is much larger than a typical Solarian corvette, thus requiring a larger crew. Lammergeier-class captains are generally loyal Ma’zals, such as the citizens of Novi Jadran, and are authorized to take whatever measures are necessary to ensure their crew remains loyal to both Empire and Goddess. This one’s transponder marks it as belonging to the Empire’s First Battlefleet – a battle-hardened formation responsible for patrolling the region of the northern Sparring Sea between the Empire, Izweski Hegemony, and Republic of Elyra."

	prefix = "ships/dominia/dominian_corvette/"
	suffix = "dominian_corvette.dmm"

	traits = list(
		// Deck one
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck two
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/dominian_shuttle, /datum/shuttle/autodock/multi/lift/dominia)

	unit_test_groups = list(2)

/singleton/submap_archetype/dominian_corvette
	map = "Dominian Corvette"
	descriptor = "One of the most common ships in the Imperial Fleet, Lammergeier-class corvettes are often used as the vanguard of battlefleets entering a system marked for annexation into the glorious Empire as it is tasked to find and scout routes for the larger fleet. Though intended for scouting and screening work the Lammergeier is, like its larger counterparts, quite heavily armed and armored for a typical corvette. Any frontier savages who attempt to meet one with force of arms will soon find themselves staring down the barrels of Zhurong’s finest weaponry, and the Fleet-trained Ma’zals entrusted to operate it. The heavy armament and sensors of the Lammergeier-class come at a cost: it lacks a shield generator and is much larger than a typical Solarian corvette, thus requiring a larger crew. Lammergeier-class captains are generally loyal Ma’zals, such as the citizens of Novi Jadran, and are authorized to take whatever measures are necessary to ensure their crew remains loyal to both Empire and Goddess. This one’s transponder marks it as belonging to the Empire’s First Battlefleet – a battle-hardened formation responsible for patrolling the region of the northern Sparring Sea between the Empire, Izweski Hegemony, and Republic of Elyra."

/obj/effect/overmap/visitable/ship/dominian_corvette
	name = "Dominian Corvette"
	class = "HIMS"
	desc = "One of the most common ships in the Imperial Fleet, Lammergeier-class corvettes are often used as the vanguard of battlefleets entering a system marked for annexation into the glorious Empire as it is tasked to find and scout routes for the larger fleet. Though intended for scouting and screening work the Lammergeier is, like its larger counterparts, quite heavily armed and armored for a typical corvette. Any frontier savages who attempt to meet one with force of arms will soon find themselves staring down the barrels of Zhurong’s finest weaponry, and the Fleet-trained Ma’zals entrusted to operate it. The heavy armament and sensors of the Lammergeier-class come at a cost: it lacks a shield generator and is much larger than a typical Solarian corvette, thus requiring a larger crew. Lammergeier-class captains are generally loyal Ma’zals, such as the citizens of Novi Jadran, and are authorized to take whatever measures are necessary to ensure their crew remains loyal to both Empire and Goddess. This one’s transponder marks it as belonging to the Empire’s First Battlefleet – a battle-hardened formation responsible for patrolling the region of the northern Sparring Sea between the Empire, Izweski Hegemony, and Republic of Elyra."
	icon_state = "lammergeier"
	moving_state = "lammergeier_moving"
	colors = list("#df1032", "#d4296b")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "dominian_corvette.png"
	designer = "Zhurong Naval Arsenal, Empire of Dominia"
	volume = "42 meters length, 75 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual wingtip-mounted extruding medium-caliber naval batteries, fore low-caliber rotary cannon"
	sizeclass = "Lammergeier-class Corvette"
	shiptype = "Military patrol and combat utility"

	initial_restricted_waypoints = list(
		"Dominian Shuttle" = list("nav_hangar_dominia")
	)

	initial_generic_waypoints = list(
		"nav_dominian_corvette_1",
		"nav_dominian_corvette_2",
		"nav_dominian_corvette_3",
		"nav_dominian_corvette_4",
		"nav_dominian_corvette_starboard_dock",
		"nav_dominian_corvette_port_dock",
		"nav_dominian_corvette_aft_dock",
		"nav_dominian_corvette_fore_dock"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/dominian_corvette/New()
	designation = "[pick("Lammergeier", "Eagle", "Hawk", "Owl", "Vulture", "Sparrowhawk", "Falcon", "Peregrine", "Condor", "Harrier", "Kestrel", "Osprey", "Yastr", "Merlin", "Kite", "Seriema", "Caracaras")]"
	..()

/obj/effect/overmap/visitable/ship/dominian_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "dominian_corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image
