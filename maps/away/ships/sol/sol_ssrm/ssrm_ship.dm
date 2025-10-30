/datum/map_template/ruin/away_site/ssrm_corvette
	name = "Malebranche"
	description = "A century old, Solarian Bahzong-class light attack cruiser, since resurrected with cobbled together scrap, laden with ill-advised modifications, and only equipped with a variety of souped up mining blasters and PDCs. There is absolutely no taking this on alone. However, being outdated and mostly salvaged parts, it moves at a sluggish pace and has a weak sensor range — it can be out-run or skirted around."

	prefix = "ships/sol/sol_ssrm/"
	suffix = "ssrm_ship.dmm"

	sectors = list(SECTOR_CRESCENT_EXPANSE_FAR)
	spawn_weight = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	ship_cost = 3 // to claim all the awaysite spots to reduce lag
	id = "ssrm_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ssrm_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/ssrm_corvette
	map = "Malebranche"
	descriptor = "A century old, Solarian Bahzong-class light attack cruiser, since resurrected with cobbled together scrap, laden with ill-advised modifications, and only equipped with a variety of souped up mining blasters and PDCs. There is absolutely no taking this on alone. However, being outdated and mostly salvaged parts, it moves at a sluggish pace and has a weak sensor range — it can be out-run or skirted around."

// Ship stuff

/obj/effect/overmap/visitable/ship/ssrm_corvette
	name = "Malebranche"
	desc = "A century old, Solarian Bahzong-class light attack cruiser, since resurrected with cobbled together scrap, laden with ill-advised modifications, and only equipped with a variety of souped up mining blasters and PDCs. There is absolutely no taking this on alone. However, being outdated and mostly salvaged parts, it moves at a sluggish pace and has a weak sensor range — it can be out-run or skirted around."
	icon = 'icons/obj/overmap/malebranche.dmi'
	icon_state = "malebranche"
	moving_state = "malebranche_moving"
	colors = list("#c04c4c")
	designer = "ASSN, c.2282; heavily modified since."
	drive = "Heavy-duty Warp Drive (Modified)"
	weapons = "3x HI-M96 Mining Blasters (Forward-facing Hardpoints; Modified), 1x KA-2461 Goshawk Autocannon (Modified)"
	sizeclass = "Bahzong-class Light Cruiser"
	shiptype = "Piracy"
	burn_delay = 1 SECONDS
	fore_dir = SOUTH
	vessel_size = 4
	vessel_mass = 15000
	initial_restricted_waypoints = list(
		"Malebranche Shuttle" = list("nav_ssrm_dock")
	)

	initial_generic_waypoints = list(
		"nav_ssrm_corvette_1",
		"nav_ssrm_corvette_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/ssrm_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "line_cruiser")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image
