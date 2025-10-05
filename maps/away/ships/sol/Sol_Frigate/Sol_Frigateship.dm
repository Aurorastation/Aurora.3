/datum/map_template/ruin/away_site/Sol_Frigate
	name = "Solarian Navy Frigate"
	description = "A long-range frigate currently seeing extensive service in the Solarian Navy, the Curiassier-Class Frigate was a inexpensive pre-civil war design that was only intended to perform common anti-piracy tasks and to provide escort for ships of minor importance to the Navy. The stressors of the Solarian Civil War, however, had forced many shipyards still loyal to the Alliance to perform emergency refits to loyalist Frigates that simpily weren't fit for peer-on-peer conflicts with mixed results, and Cuirassiers were no exception. \
	After facing high losses in the Civil War, most surviving Cuirassier hulls post-unification are that of a 'revised' version of the design that was produced mid-war, featuring modest improvements to it's survivability and sensors at the cost of crew comfort. But despite there being a grimly high number of Cuirassier wrecks still floating in the void; there are just as many operational ships of this class still serving in almost every fleet in Solarian Navy today, with even more being built."

	prefix = "ships/sol/Sol_Frigate/"
	suffix = "Sol_Frigate.dmm"

	sectors = list(SECTOR_BADLANDS, SECTOR_CRESCENT_EXPANSE_WEST, SECTOR_VALLEY_HALE) 
	spawn_weight = 0.75
	ship_cost = 1
	id = "Sol_frigate"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/Solfrig_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/Sol_Frigate
	map = "Solarian Navy Frigate"
	descriptor = "A long-range frigate currently seeing extensive service in the Solarian Navy, the Curiassier-Class Frigate was a inexpensive pre-civil war design that was only intended to perform common anti-piracy tasks and to provide escort for ships of minor importance to the Navy. The stressors of the Solarian Civil War, however, had forced many shipyards still loyal to the Alliance to perform emergency refits to loyalist Frigates that simpily weren't fit for peer-on-peer conflicts with mixed results, and Cuirassiers were no exception. \
	After facing high losses in the Civil War, most surviving Cuirassier hulls post-unification are that of a 'revised' version of the design that was produced mid-war, featuring modest improvements to it's survivability and sensors at the cost of crew comfort. But despite there being a grimly high number of Cuirassier wrecks still floating in the void; there are just as many operational ships of this class still serving in almost every fleet in Solarian Navy today, with even more being built."

// Ship stuff
/obj/effect/overmap/visitable/ship/Sol_Frigate
	name = "Solarian Navy Frigate"
	class = "SAMV"
	desc = "A long-range frigate currently seeing extensive service in the Solarian Navy, the Curiassier-Class Frigate was a inexpensive pre-civil war design that was only intended to perform common anti-piracy tasks and to provide escort for ships of minor importance to the Navy. The stressors of the Solarian Civil War, however, had forced many shipyards still loyal to the Alliance to perform emergency refits to loyalist Frigates that simpily weren't fit for peer-on-peer conflicts with mixed results, and Cuirassiers were no exception. \ After facing high losses in the Civil War, most surviving Cuirassier hulls post-unification are that of a 'revised' version of the design that was produced mid-war, featuring modest improvements to it's survivability and sensors at the cost of crew comfort. But despite there being a grimly high number of Cuirassier wrecks still floating in the void; there are just as many operational ships of this class still serving in almost every fleet in Solarian Navy today, with even more being built."
	icon_state = "xanu_frigate"
	moving_state = "xanu_frigate_moving"
	colors = list("#9dc04c", "#52c24c")
	scanimage = "corvette.png"
	designer = "Solarian Navy"
	volume = "80 meters length, 42 meters beam/width, 37 meters vertical height"
	drive = "Medum-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore caliber ballistic armament, fore unobscured docking arm and catwalk"
	sizeclass = "Cuirassier-Class Frigate (Revised)"
	shiptype = "Naval Frigate"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 6200
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_LARGE
	initial_restricted_waypoints = list("Solarian Frigate Shuttle" = list("nav_hangar_solfrig") )
	initial_generic_waypoints = list(
	"Sol_Frigate_nav1",
	"Sol_Frigate_nav2",
	"Sol_Frigate_nav3",
	"Sol_Frigate_nav4",
	"Sol_Frigate_port_dock",
	"Sol_Frigate_starboard_dock")
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/Sol_Frigate/New()
	designation = "[pick("Defender", "Gladiator", "Greyhound", "Vanguard", "Undaunted", "Unchallenged", "Triumphant", "Indefatigable", "Excellent", "Unrelenting", "Furious", "Senate", "Constitution", "Pride and Glory", "Unity", "Superior", "Hunter", "Repulse", "Warspite", "Valiant", "Turner", "Nimitz", "Halsey", "Spurance", "Ingram", "Persistance", "Endurance", "Sprinter")]"
	..()

