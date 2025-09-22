/datum/map_template/ruin/away_site/freebooter_salvager
	name = "Freebooter Salvager Ship"
	id = "freebooter_salvager_ship"
	description = "A heavily modified freighter of dubious origins."

	prefix = "ships/freebooter/freebooter_salvager/"
	suffix = "freebooter_salvager.dmm"

	traits = list(
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	ship_cost = 1
	spawn_weight = 0.5 // halved from 1 as this is a variation

	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freebooter_salvager, /datum/shuttle/autodock/multi/lift/freebooter_salvager)
	sectors = list(ALL_POSSIBLE_SECTORS)
	ban_ruins = list(/datum/map_template/ruin/away_site/freebooter_ship)

	unit_test_groups = list(1)

/singleton/submap_archetype/freebooter_salvager
	map = "Freebooter Salvager Ship"
	descriptor = "A heavily modified freighter of dubious origins."

/obj/effect/overmap/visitable/ship/freebooter_salvager
	name = "Freebooter Salvager Ship"
	desc = "Einstein Engines-manufactured Tartarus-class Bulk Haulers were a common sight in both well-charted and poorly-charted regions between systems. By design, they were made to endure most kinds of demanding trips, thanks to their thick hull and side thrusters, which decently shield the main section. However, the development of newer freighters left this class in the dust in terms of fuel efficiency and navigational support, putting it on the verge of becoming obsolete. It is not uncommon to see this model modified with improvised weaponry and other alterations in the hands of dubious actors."
	class = "ICV"
	icon_state = "tramp"
	moving_state = "tramp_moving"
	color = "#a0a8ec"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 10000 // very inefficient in terms of thrust
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	designer = "Einstein Engines"
	volume = "56 meters length, 39 meters beam/width, 22 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual improvised weapon arrays, underside shuttle docking compartment."
	sizeclass = "Tartarus-class Bulk Hauler"
	shiptype = "Long-term shipping utilities"
	initial_restricted_waypoints = list(
		"Freebooter Salvager Shuttle" = list("freebooter_salvager_nav_hangar")
	)
	initial_generic_waypoints = list(
		"freebooter_salvager_fore",
		"freebooter_salvager_aft",
		"freebooter_salvager_port",
		"freebooter_salvager_starboard",
		"freebooter_salvager_eva_port",
		"freebooter_salvager_eva_starboard",
		"freebooter_salvager_eva_aft_starboard",
		"freebooter_salvager_eva_aft_port",
		"freebooter_salvager_upfore"
	)

/obj/effect/overmap/visitable/ship/freebooter_salvager/New()
	designation = pick(/obj/effect/overmap/visitable/ship/freebooter_ship::designations)
	..()

//Shuttle
/obj/effect/overmap/visitable/ship/landable/freebooter_salvager_shuttle
	name = "Freebooter Salvager Shuttle"
	desc = "Einstein Engines-branded Typhon-class hauler shuttle is mostly seen attached to Tartarus-class vessels, resembling a tick on their hull. This class is typically constructed and equipped with low-end components in accordance with the Tartarus-class's price/performance ratio."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#9dc04c"
	class = "ICV"
	designation = "The Price is Wrong"
	shuttle = "Freebooter Salvager Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/freebooter_salvager
	name = "shuttle control console"
	shuttle_tag = "Freebooter Salvager Shuttle"

/datum/shuttle/autodock/overmap/freebooter_salvager
	name = "Freebooter Salvager Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/freebooter_salvager)
	current_location = "freebooter_salvager_nav_hangar"
	landmark_transition = "freebooter_salvager_nav_transit"
	dock_target = "airlock_freebooter_salvager_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "freebooter_salvager_nav_hangar"
	defer_initialisation = TRUE

// shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/freebooter_salvager
	name = "Freebooter Salvager Shuttle"
	shuttle_tag = "Freebooter Salvager Shuttle"
	master_tag = "airlock_freebooter_salvager_shuttle"
	cycle_to_external_air = TRUE

// docking airlock for shuttle
/obj/effect/map_effect/marker/airlock/docking/freebooter_salvager/shuttle_hangar
	name = "Shuttle Dock"
	landmark_tag = "freebooter_salvager_nav_hangar"
	master_tag = "freebooter_salvager_hangar"

/obj/effect/shuttle_landmark/freebooter_salvager_shuttle/hangar
	name = "Freebooter Salvager Ship - Hangar"
	landmark_tag = "freebooter_salvager_nav_hangar"
	docking_controller = "freebooter_salvager_hangar"
	base_turf = /turf/space
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/freebooter_salvager_shuttle/transit
	name = "In transit"
	landmark_tag = "freebooter_salvager_nav_transit"
	base_turf = /turf/space/transit/north

/obj/item/paper/fluff/freebooter_salvager/captain_note
	name = "old captain's note"
	info = "The ship's holdin together by pure spite! Load the weapons, patch up them starboard breaches, and while ye're at it, scrub the deck 'fore I toss ye out the airlock! Move it, ye rust-bitten void rats!"

/obj/item/paper/fluff/freebooter_salvager/teg_manual
	name = "crumpled TEG manual"
	desc = "A bundle of paper with instructions on how to safely run a thermoelectric generator. Watermark of Einstein Engines suggests this manual likely was stolen along with the engine itself. It's missing some pages."
	info = {"<hr><center><h2>Quick Introduction</h2></center><hr>
	<br><br>
	<h3>How does it work?</h3><hr>
	<br><br>
	This generator model has two circuits that receives the gas. As the gas flows, integrated turbine fans begin to spin and generate electricity. The principle behind this is
	that the greater the temperature difference between circuits is, the faster the fans will spin and subsequently the more energy is produced. Each time the gas flows through the circuits, the temperature difference
	(delta temperature) will decrease, this means in time the generator will produce less energy. The engine installed in your vessel has its hot loop on the port side and cold loop on
	the starboard side. If confused, the loops can be identified by determining which one is connected to the radiator array on your vessel's exterior.
	<br><br>
	<h3>Hot Loop</h3><hr>
	<br><br>
	Following is the steps of setting the hot flow successfully:
	<br><br>
	- Locate the gas mixer device in the aft-port side. Make sure it outputs the mixed gas to the west. Make sure that oxidizer (oxygen) and fuel (hydrogen) is connected to the relevant ports.
	The target ratio should be 60% oxidizer and 40% fuel. Turn on the mixer. <br><br>
	- Turn on the injection on the console (read the tag written on the console to identify it) in front of the combustion chamber. Make sure the fuel canister is spent and there's no residual burn mixture in
	the combustion chamber feed pipe. The recommended amount of fuels to inject is 2 canisters. Bear in mind the mixer will stop working if both inputs aren't receiving gas simultaneously. <br><br>
	- After the injection is complete, turn off the injection on the console. <b>Never start ignition sequence while injecting fuel into the chamber</b>. Hit the ignition button
	to start the combustion. <br><br>
	- After making sure that the combustion has finished, turn on the input in the console tagged 'Combustion Chamber Control' to maximum value and adjust the output rate to a value
	compensating power draw. The higher output rate the more power produced, at the cost of sustainability.
	<br><br>
	<h3>Cold Loop</h3><hr>
	<br><br>
	- Locate the pump tagged as 'Cold Loop Supply Pump' in the starboard side of the TEG. Turn it on at maximum transfer rate. <br><br>
	- (Optional) Add more gas to the cold loop by securing more canisters at the aft-starboard connectors. Do not overdo this. 1 or 2 more canisters is the ideal amount. <br><br>
	- Turn on the pump leading directly to the cold circuit, tagged as 'Cold Loop Flow Pump' and set the transfer rate to maximum.
	<br><br>
	<h3>Things to Note</h3><hr>
	<br><br>
	- If the combustion chamber cools below operational temperature, do <b>NOT</b> inject a new burn mixture until the chamber temperatures reaches below 400K. Otherwise the injected
	burn mix will ignite immediately on contact, preventing safe injection of the remaining mix. If it has to be replaced hastily, press the 'Emergency Chamber Vent' button to release
	combustion chamber contents. <br><br>
	- Any modifications to the setup made by parties other than Einstein Engines Inc. and its affiliates will void the warranty.
	<br><br>
	For the emergency procedures, see the next page."}

/obj/item/paper/fluff/freebooter_salvager/crew_note
	name = "stapled note"
	layer = ABOVE_ABOVE_HUMAN_LAYER // otherwise this would appear under the console
	info = {"...the number of installed thrusters isn't fully compatible with the vessel's structure. If you're planning to run all the engines at once, you better amplify
	the power input to the main grid or expect the lights to start flickering.
	<br><br>
	Until we have a more robust solution, the nacelle thruster feed valves will remain closed."}
