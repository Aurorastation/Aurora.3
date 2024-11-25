/datum/map_template/ruin/away_site/splf_raider
	name = "SPLF Auxiliary Vessel"
	description = "A repurposed hauler operated by the Solarian People's Liberation Fleet, sent to raid corporate holdings in the CRZ."

	prefix = "ships/sol/sol_splf/"
	suffix = "splf_raider.dmm"

	sectors = list(SECTOR_CORP_ZONE)
	spawn_weight = 1
	ship_cost = 1
	id = "splf_raider"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/splf_shuttle)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(3)

/singleton/submap_archetype/splf_raider
	map = "SPLF Auxiliary Vessel"
	descriptor = "A repurposed hauler operated by the Solarian People's Liberation Fleet, sent to raid corporate holdings in the CRZ."

/obj/effect/overmap/visitable/ship/splf_raider
	name = "SPLF Auxiliary Vessel"
	class = "SPLFV" // Solarian People's Liberation Fleet Vessel. This is not an anonymous or 'undercover' ship, they openly fly their colours.
	desc = ""
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#5a644e", "#6a7e53")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "tramp_freighter.png" // Looks close enough.
	designer = "Einstein Engines, Hang Tuah Rest Orbital Shipyards"
	volume = "50 meters length, 36 meters beam/width, 13 meters vertical height"
	weapons = "Heavily modified ballistic gunnery pod starboard, shuttle bay portside"
	sizeclass = "Laksamana-class hauler"
	shiptype = "Remote hauling operations, long-term crew habitation"

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/splf_raider/New()
	designation = "[pick("Not A Fan Of The Government")]"
	..()

// Using the freighter sprite.
/obj/effect/overmap/visitable/ship/splf_raider/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tramp_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image
