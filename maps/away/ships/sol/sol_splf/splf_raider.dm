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

	unit_test_groups = list(3)

/singleton/submap_archetype/splf_raider
	map = "SPLF Auxiliary Vessel"
	descriptor = "A repurposed hauler operated by the Solarian People's Liberation Fleet, sent to raid corporate holdings in the CRZ."

/obj/effect/overmap/visitable/ship/splf_raider
	name = "SPLF Auxiliary Vessel"
	class = "SPLFV" // Solarian People's Liberation Fleet Vessel. This is not an anonymous or 'undercover' ship, they openly fly their colours.
	desc = "The Laksamana-class hauling vessel is a relatively unusual sighting in the wider spur, native almost exclusively to the shipyards of Hang Tuah's Rest and the surrounding space. Unlike its more successful competitors, it vests less of its space in its cargo capacity and more of its space in crew compartments - though, despite this, it remains quite cramped. This one appears to have been substantially modified, boasting a heavily armed gunnery pod slotted into its starboard cargo pod port, apparently feeding two moderately sized ballistic cannons. The hull also appears to have been strengthened, and the exterior has been painted a dull military green."
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#5a644e", "#6a7e53")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "tramp_freighter.png" // Looks close enough.
	designer = "Einstein Engines, Hang Tuah's Rest Orbital Shipyards"
	volume = "50 meters length, 36 meters beam/width, 13 meters vertical height"
	weapons = "Heavily modified ballistic gunnery pod starboard, shuttle bay portside"
	sizeclass = "Laksamana-class hauler"
	shiptype = "Remote hauling operations, long-term crew habitation"

	initial_restricted_waypoints = list(
		"SPLF Shuttle" = list("nav_hangar_splf")
	)

	initial_generic_waypoints = list(
		"splf_raider_nav1",
		"splf_raider_nav2",
		"splf_raider_nav3",
		"splf_raider_nav4",
		"splf_raider_starboard_dock",
		"splf_raider_port_dock",
		"splf_raider_aft_dock",
		"splf_raider_fore_dock"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/splf_raider/New()
	designation = "[pick("Not A Fan Of The Government", "National Liberation", "Free Spirit", "Not Wanted Here", "Tight-knit", "Silat", "Sejarah Melayu", "As They Were Before", "Hand of Cabanas", "Justice for Mictlan", "Not One Step More", "Fraternity", "Culpability", "Magistrate", "Equity", "Sic Semper Tyrannis")]"
	..()

// Using the freighter sprite.
/obj/effect/overmap/visitable/ship/splf_raider/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tramp_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/// So people know how to use the engine. There's also a pre-wired spare PACMAN.
/obj/item/paper/fluff/splf_raider_engine_guide
	name = "Laksamana-class engine operational notes"
	desc = "This is a series of harshly written notes on how to operate the combustion engine of a Laksamana-class hauling vessel."
	info = "<font face=\"Verdana\"><b>Follow these notes and you should be fine. Don't burn the ship down again, yeah? Christ.<BR>\
	<BR>Step one: Enable the connectors to cold loop pump and the cooling array to generator pump. This circulates the cold look through the turbine.<BR>\
	<BR>Step two: Set the gas mixer to output south, enable the pump, enable fuel injection. This will inject fuel mix into the chamber. \
	Feel free to put in as many canisters as you like, just make sure they're being mixed at a ratio of 60% oxidiser to 40% fuel. \
	The more burning mix you inject into there, the longer it'll last before you need to vent the inject more.<BR>\
	<BR>Step three: Disable injection on the fuel injection console. If you leave injection on, we'll have a bad time.<BR>\
	<BR>Step four: Ignition! Wait for the fire to fully burn out before proceeding to the next step. \
	If the glass makes a weird noise, that's normal.<BR>\
	<BR>Step five: After the fire has stopped, the contents of the chamber should be entirely carbon dioxidie. At this point, \
	enable circulation: 700L/s input and 1500kpa output should suffice. The higher you raise the output, \
	the more power it produces, but the quicker it cools.<BR>\
	<BR>If you get the feeling the glass will break, immediately vent the chamber and report to your commanding officer.</b></font>"
	language = LANGUAGE_SOL_COMMON
