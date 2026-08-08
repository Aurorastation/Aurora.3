/datum/map_template/ruin/away_site/dominian_corvette
	name = "Dominian Privateer Corvette"
	description = "An extremely eccentric design even by the standards of the Imperial Fleet, the Condor-Class Pursuit Corvette was the purported product of a radical experiment by several minor nobles and shipwrights within the Great House Zhao. Who sought to introduce the Condor as the solution to the Imperial Fleet's woes against it's more mobile enemies (pirates, Elyrans, etc.) who could harrass and 'fix' it's lumbering ships of the line in place until the opposition can defeat them in detail. \
	Armed with the typical ensemble of heavy weaponry commonly equiped to Dominian Escorts, the Condor's entire arsenal is arranged and emplaced all to the extremely well-armored 'gunnery-deck' located well forward of the ship. It was theorized that, with this bristling array of heavy weaponry and the addition of an extremely powerful (and possibly Solarian-Imported) propulsion array. The Condor could deter and chase away the Goddess' enemies before they can even get a chance to strike at the main body of what really matters to the Imperial Fleet. \
	These capabilites, however, would not come without significant sacarfices to everything else. As was it was found during it's inital deployments, such a design can simply be flanked by two or even a singular opponent, who would simply aim for it's extremely exposed sides (quarterdeck included). living conditions aboard a Condor were also said to have been fairly poor and cramped. And the arrangement of such heavy firepower aboard such a cramped space quickly transformed routine maintainence and cleaning procedures of said weaponry into a claustraphobic nightmare. Not to mention the concerns of the superstructure buckling under the stress of continious firing. \
	After several proposed refits to the class in the mid-2450s that never really came to reality, the Condor-Class was ultimately retired by the turn of the decade. It is rumored, however, that virtually all of the class has since been hushed out of retirement and comissioned into service by the Goddess' Flotilla, the Empire of Dominia's privateering force."

	prefix = "ships/dominia/dominian_corvette/"
	suffix = "dominian_corvette.dmm"

	traits = list(
		// Deck one
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck two
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(SECTOR_BADLANDS, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/dominian_shuttle, /datum/shuttle/autodock/multi/lift/dominia)

	unit_test_groups = list(2)

/singleton/submap_archetype/dominian_corvette
	map = "Dominian Corvette"
	descriptor = "An extremely eccentric design even by the standards of the Imperial Fleet, the Condor-Class Pursuit Corvette was the purported product of a radical experiment by several minor nobles and shipwrights within the Great House Zhao. Who sought to introduce the Condor as the solution to the Imperial Fleet's woes against it's more mobile enemies (pirates, Elyrans, etc.) who could harrass and 'fix' it's lumbering ships of the line in place until the opposition can defeat them in detail. \
	Armed with the typical ensemble of heavy weaponry commonly equiped to Dominian Escorts, the Condor's entire arsenal is arranged and emplaced all to the extremely well-armored 'gunnery-deck' located well forward of the ship. It was theorized that, with this bristling array of heavy weaponry and the addition of an extremely powerful (and possibly Solarian-Imported) propulsion array. The Condor could deter and chase away the Goddess' enemies before they can even get a chance to strike at the main body of what really matters to the Imperial Fleet. \
	These capabilites, however, would not come without significant sacarfices to everything else. As was it was found during it's inital deployments, such a design can simply be flanked by two or even a singular opponent, who would simply aim for it's extremely exposed sides (quarterdeck included). living conditions aboard a Condor were also said to have been fairly poor and cramped. And the arrangement of such heavy firepower aboard such a cramped space quickly transformed routine maintainence and cleaning procedures of said weaponry into a claustraphobic nightmare. Not to mention the concerns of the superstructure buckling under the stress of continious firing. \
	After several proposed refits to the class in the mid-2450s that never really came to reality, the Condor-Class was ultimately retired by the turn of the decade. It is rumored, however, that virtually all of the class has since been hushed out of retirement and comissioned into service by the Goddess' Flotilla, the Empire of Dominia's privateering force."

/obj/effect/overmap/visitable/ship/dominian_corvette
	name = "Dominian Corvette"
	class = "HIMS"
	desc = "An extremely eccentric design even by the standards of the Imperial Fleet, the Condor-Class Pursuit Corvette was the purported product of a radical experiment by several minor nobles and shipwrights within the Great House Zhao. Who sought to introduce the Condor as the solution to the Imperial Fleet's woes against it's more mobile enemies (pirates, Elyrans, etc.) who could harrass and 'fix' it's lumbering ships of the line in place until the opposition can defeat them in detail. \
	Armed with the typical ensemble of heavy weaponry commonly equiped to Dominian Escorts, the Condor's entire arsenal is arranged and emplaced all to the extremely well-armored 'gunnery-deck' located well forward of the ship. It was theorized that, with this bristling array of heavy weaponry and the addition of an extremely powerful (and possibly Solarian-Imported) propulsion array. The Condor could deter and chase away the Goddess' enemies before they can even get a chance to strike at the main body of what really matters to the Imperial Fleet. \
	These capabilites, however, would not come without significant sacarfices to everything else. As was it was found during it's inital deployments, such a design can simply be flanked by two or even a singular opponent, simply who would aim for it's extremely exposed sides (quarterdeck included). living conditions aboard a Condor were also said to have been fairly poor and cramped. And the arrangement of such heavy firepower aboard such a cramped space quickly transformed routine maintainence and cleaning procedures of said weaponry into a claustraphobic nightmare. Not to mention the concerns of the superstructure buckling under the stress of continious firing. \
	After several proposed refits to the class in the mid-2450s that never really came to reality, the Condor-Class was ultimately retired by the turn of the decade. It is rumored, however, that virtually all of the class has since been hushed out of retirement and comissioned into service by the Goddess' Flotilla, the Empire of Dominia's privateering force."
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
