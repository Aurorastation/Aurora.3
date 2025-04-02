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
	spawn_weight = 1

	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freebooter_salvager, /datum/shuttle/autodock/multi/lift/fbs)
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
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	invisible_until_ghostrole_spawn = TRUE
	designer = "Einstein Engines"
	volume = "56 meters length, 39 meters beam/width, 25 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual improvised weapon arrays, underside shuttle docking compartment."
	sizeclass = "Tartarus-class Bulk Hauler"
	shiptype = "Long-term shipping utilities"
	initial_restricted_waypoints = list(
		"Freebooter Salvager Shuttle" = list("fbs_nav_hangar")
	)
	initial_generic_waypoints = list(
		"fbs_nav1",
		"fbs_nav2",
		"fbs_nav3",
		"fbs_nav4",
		"fbs_nav5",
		"fbs_nav6",
		"fbs_nav7",
		"fbs_nav8",
		"fbs_upfore"
	)

// copy-pasted from original freebooters
/obj/effect/overmap/visitable/ship/freebooter_salvager/New()
	designation = "[pick("Peaceful", "Charming", "Jackal", "Friendly", "Boar", "One and Done", "Nothing Suspicious", "Death Valley", "Scan Again", "Pickpocket", "Dashing Rogue", "Port Authority", "Customs Patrol Ship", "Pay Transit Tolls Here", "Immigration Inspector", "For Hire", "Ex-Military", "Eat Shit", "Fuck Off", "Big Brother", "Wrong Turn", "Claim Jumper", "Davy Jones", "Thenardier", "Killer Queen", "Gunpowder", "Dynamite", "Phoron Collection Service", "We Never Liked Working Anyway", "The Orphanage", "Undertaker", "Flip and Burn", "Emphasis on Independent", "Widowmaker", "Irregular", "Ned Kelly", "Pay Your Union Dues Here", "We Support You!", "Jean Valjean", "Not Pirates", "Let's Be Friends!", "Alms For The Poor", "REAL KILLERS", "A Single Grain Of Sand", "What's It Matter To You?", "IFF Broken", "Or Something", "Nitroglycerin", "The Ghost of Christmas Present", "God's With Us So You Better Back Off Pal", "Faster Than You", "our shift key is broken", "It Is What It Is", "Bases Loaded", "We Support Law Enforcement", "Cash-Rich, Credit-Poor", "Cunning", "We Never Liked Beauchamp Anyway", "Civilian Ship", "We Didn't Start The Fire, Honest!", "Arson", "Jaywalking", "Bail Bondsmen", "Bail Jumper", "On Parole", "Don't Tell My Probation Officer", "Quit Your Bitching", "And The Then Or Thank You", "Sensor Glitch", "Not My Problem", "Mind Your Business", "Private Vessel Of The Dread Pirate King With His Entire Fleet And Crew In Tow So Back Off", "Daisy", "Sally", "Jane", "Pretty Little Thing", "We Like To Party", "No Squares Here")]"
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

/obj/machinery/computer/shuttle_control/explore/terminal/freebooter_salvager
	name = "shuttle control console"
	shuttle_tag = "Freebooter Salvager Shuttle"

/datum/shuttle/autodock/overmap/freebooter_salvager
	name = "Freebooter Salvager Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/freebooter_salvager)
	current_location = "fbs_nav_hangar"
	landmark_transition = "fbs_nav_transit"
	dock_target = "airlock_fbs_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "fbs_nav_hangar"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/freebooter_salvager
	name = "Freebooter Salvager Shuttle"
	shuttle_tag = "Freebooter Salvager Shuttle"
	master_tag = "airlock_fbs_shuttle"
	cycle_to_external_air = TRUE

/obj/effect/map_effect/marker/airlock/docking/freebooter_salvager/shuttle_hangar
	name = "Shuttle Dock"
	landmark_tag = "fbs_nav_hangar"
	master_tag = "freebooter_salvager_hangar"

/obj/effect/shuttle_landmark/freebooter_salvager_shuttle/hangar
	name = "Freebooter Salvager Ship - Hangar"
	landmark_tag = "fbs_nav_hangar"
	docking_controller = "freebooter_salvager_hangar"
	base_turf = /turf/space
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/freebooter_salvager_shuttle/transit
	name = "In transit"
	landmark_tag = "fbs_nav_transit"
	base_turf = /turf/space/transit/north

/obj/item/paper/fluff/freebooter_salvager/captain_note
	name = "old captain's note"
	info = "The ship's holdin together by pure spite! Load the weapons, patch up them starboard breaches, and while ye're at it, scrub the deck 'fore I toss ye out the airlock! Move it, ye rust-bitten void rats!"

/obj/item/paper/fluff/freebooter_salvager/teg_manual
	name = "crumpled TEG manual"
	desc = "A bundle of paper with instructions on how to safely run a thermoelectric generator. Watermark of Einstein Engines suggests this manual likely was stolen along with the engine itself. It's missing some pages."
	info = {"<hr><center><h2>Introduction</h2></center><hr>
	<br><br>
	Firstly, a burn mixture is required to produce sufficiently hot gas to run the hot loop. This can be achieved via an omni-mixer. Attach a fuel canister (typically hydrogen)
	to one port, oxidizer (typically oxygen) to the other one. For an efficient burn reaction, universal value is 60% oxidizer and 40% fuel. Make sure correct ratio is set
	in the omni-mixer's configuration section. Then activate the omni-mixer and route your burn mix to the combustion chamber, start the injection with control console.
	Injected amount of canisters is up for discretion, advised amount for kickstarting the generator is two (2) fuels and two (2) oxidizers.
	It is advised to increase transfer rate for faster results.
	<br><br>
	While burn mix is in the process of injection, cold loop may be supplied. Any amount between two (2) to four (4) canisters would be sufficient. Higher heat capacity
	is bound to give better results, standard being hydrogen. After making sure the canisters are secured on relevant ports, supply pump alongside with flow pump may be activated.
	Check the tag written on the pumps of your setup to identify the function of the components.
	<br><br>
	After burn mix injection is complete, the ignition may begin. Locate the button next to the combustion chamber and press the button. If it wasn't oversupplied, provided chamber
	will be sufficient to endure the heat without melting down. In this state combustion chamber blast doors may be sealed, be careful not to press 'Emergency Chamber Vent'
	button. After burn is compelte the hot gas may be injected to hot loop via 'Combustion Chamber Control' console. Adjusting the transfer rate regarding to power demand
	would be advised. Higher output value will produce more energy in the cost of rather quickly decreased delta temperature, which means lower energy output.
	<br><br>
	For the emergency procedures, see the next page."}

/obj/item/paper/fluff/freebooter_salvager/crew_note
	name = "former crew's note"
	info = "...and as inevitable it was, the number of installed thrusters isn't fully compatible with the vessel's structure. If you're planning to run all the engines at once, you better amplify the power input to the main grid or expect the lights to start flickering."
