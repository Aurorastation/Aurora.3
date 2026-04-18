/datum/map_template/ruin/away_site/ssrm_corvette
	name = "Solarian Navy Reconnaissance Corvette"
	description = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."

	prefix = "ships/sol/sol_ssrm/"
	suffix = "ssrm_ship.dmm"

	sectors = list(SECTOR_BADLANDS, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 1
	id = "ssrm_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ssrm_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/ssrm_corvette
	map = "Sol Recon Corvette"
	descriptor = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."

// Ship stuff

/obj/effect/overmap/visitable/ship/ssrm_corvette
	name = "Solarian Navy Reconnaissance Corvette"
	class = "SAMV"
	desc = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#9dc04c", "#52c24c")
	scanimage = "corvette.png"
	designer = "Solarian Navy"
	volume = "41 meters length, 43 meters beam/width, 19 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore caliber ballistic armament, fore obscured flight craft bay"
	sizeclass = "Uhlan-class Corvette"
	shiptype = "Military reconnaissance and extended-duration combat utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 6500
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"SSRM Shuttle" = list("nav_ssrm_dock")
	)

	initial_generic_waypoints = list(
		"nav_ssrm_corvette_1",
		"nav_ssrm_corvette_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/ssrm_corvette/New()
	designation = "[pick("Asparuh", "Magyar", "Hussar", "Black Army", "Hunyadi", "Piast", "Hussite", "Tepes", "Komondor", "Turul", "Vistula", "Sikorski", "Mihai", "Blue Army", "Strzyga", "Leszy", "Danube", "Sokoly", "Patriotism", "Duty", "Loyalty", "Florian Geyer", "Pilsudski", "Chopin", "Levski", "Valkyrie", "Tresckow", "Olbricht", "Dubcek", "Kossuth", "Nagy", "Clausewitz", "Poniatowski", "Orzel", "Turul", "Skanderbeg", "Ordog", "Perun", "Poroniec", "Klobuk", "Cavalryman", "Szalai's Own", "Upior", "Szalai's Pride", "Kuvasz", "Fellegvar", "Nowa Bratislawa", "Zbior", "Stadter", "Homesteader", "Premyslid", "Bohemia", "Discipline", "Cavalryman", "Order", "Law", "Tenacity", "Diligence", "Valiant", "Konik", "Victory", "Triumph", "Vanguard", "Jager", "Grenadier", "Honor Guard", "Visegrad", "Nil", "Warsaw", "Budapest", "Prague", "Sofia", "Bucharest", "Home Army", "Kasimir", "Veles", "Blyskawica", "Kubus")]"
	..()

/obj/effect/overmap/visitable/ship/ssrm_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image
