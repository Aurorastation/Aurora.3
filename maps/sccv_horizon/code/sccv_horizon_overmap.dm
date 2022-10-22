/obj/effect/overmap/visitable/ship/sccv_horizon
	class = "SCCV"
	designation = "Horizon"
	desc = "A line without compare, the Venator-series consists of one vessel so far: the SCCV Horizon, the lead ship of its class. Designed to be an entirely self-sufficient general-purpose surveying ship and to carry multiple replacement crews simultaneously, the Venator is equipped with both a bluespace and a warp drive and two different engines. Defying typical cruiser dimensions, the Venator is home to a sizable residential deck below the operations deck of the ship, where the crew is housed. It also features weapon hardpoints in its prominent wing nacelles. This one's transponder identifies it, obviously, as the SCCV Horizon."
	fore_dir = SOUTH
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	base = TRUE

	initial_restricted_waypoints = list(
		"Spark" = list("nav_hangar_mining"), 	//can't have random shuttles popping inside the ship
		"Intrepid" = list("nav_hangar_intrepid")
	)

	initial_generic_waypoints = list(
	"nav_hangar_horizon_1",
	"nav_hangar_horizon_2",
	"nav_dock_horizon_1",
	"nav_dock_horizon_2",
	"deck_one_fore_of_horizon",
	"deck_one_starboard_side",
	"deck_one_port_side",
	"deck_one_aft_of_horizon",
	"deck_one_near_starboard_propulsion",
	"deck_one_near_port_propulsion",
	"deck_two_fore_of_horizon",
	"deck_two_starboard_fore",
	"deck_two_port_fore",
	"deck_two_aft_of_horizon",
	"deck_two_port_aft",
	"deck_two_starboard_aft",
	"deck_three_fore_of_horizon",
	"deck_three_starboard_of_horizon",
	"deck_three_port_of_horizon",
	"deck_three_aft_of_horizon"
	)


/obj/machinery/computer/shuttle_control/explore/intrepid
	name = "Intrepid control console"
	shuttle_tag = "Intrepid"
	req_access = list(access_intrepid)

/obj/effect/overmap/visitable/ship/landable/intrepid
	name = "Intrepid"
	desc = "A standard-sized unarmed exploration shuttle manufactured by Hephaestus, the Pathfinder-class is commonly used by the corporations of the SCC. Featuring well-rounded facilities and equipment, the Pathfinder is excellent, albeit pricey, platform. This one's transponder identifies it as the SCCV Intrepid."
	shuttle = "Intrepid"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/mining_shuttle
	name = "Spark"
	class = "SCCV"
	designation = "Spark"
	desc = "A common, modestly-sized short-range shuttle manufactured by Hephaestus. Most frequently used as a mining platform, the Pickaxe-class is entirely reliant on a reasonably-sized mothership for anything but short-term functionality. This one's transponder identifies it as belonging to the Stellar Corporate Conglomerate."
	shuttle = "Spark"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/mining_shuttle
	name = "spark control console"
	shuttle_tag = "Spark"
	req_access = list(access_mining)

/obj/effect/shuttle_landmark/horizon/nav1
	name = "Port Hangar Bay 1"
	landmark_tag = "nav_hangar_horizon_1"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

/obj/effect/shuttle_landmark/horizon/nav2
	name = "Port Hangar Bay 2"
	landmark_tag = "nav_hangar_horizon_2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

//external landmarks for overmap ships
/obj/effect/shuttle_landmark/horizon/dock1
	name = "Starboard Primary Docking Arm"
	landmark_tag = "nav_dock_horizon_1"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock2 //shares a spot with the TCFL ERT shuttle, but having multiple use cases is fine, ERTs are adminspawned only as well
	name = "Port Primary Docking Arm"
	landmark_tag = "nav_dock_horizon_2"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

//Deck one landmarks that overmap shuttles can go to
/obj/effect/shuttle_landmark/horizon/deckone
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/deckone/fore
	name = "Deck One, Fore of Horizon"
	landmark_tag = "deck_one_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/deckone/port
	name = "Deck One, Port of Horizon"
	landmark_tag = "deck_one_port_side"

/obj/effect/shuttle_landmark/horizon/deckone/starboard
	name = "Deck One, Starboard of Horizon"
	landmark_tag = "deck_one_starboard_side"

/obj/effect/shuttle_landmark/horizon/deckone/aft
	name = "Deck One, Aft of Horizon"
	landmark_tag = "deck_one_aft_of_horizon"

/obj/effect/shuttle_landmark/horizon/deckone/port_propulsion
	name = "Deck One, Near Port Propulsion"
	landmark_tag = "deck_one_near_port_propulsion"

/obj/effect/shuttle_landmark/horizon/deckone/starboard_propulsion
	name = "Deck One, Near Starboard Propulsion"
	landmark_tag = "deck_one_near_starboard_propulsion"


////Deck two landmarks that overmap shuttles can go to
/obj/effect/shuttle_landmark/horizon/decktwo
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/decktwo/fore
	name = "Deck Two, Fore of Horizon"
	landmark_tag = "deck_two_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/decktwo/starboard_fore
	name = "Deck Two, Starboard Fore of Horizon"
	landmark_tag = "deck_two_starboard_fore"

/obj/effect/shuttle_landmark/horizon/decktwo/port_fore
	name = "Deck Two, Port Fore of Horizon"
	landmark_tag = "deck_two_port_fore"

/obj/effect/shuttle_landmark/horizon/decktwo/aft
	name = "Deck Two, Aft of Horizon"
	landmark_tag = "deck_two_aft_of_horizon"

/obj/effect/shuttle_landmark/horizon/decktwo/starboard_aft
	name = "Deck One, Starboard Aft of horizon"
	landmark_tag = "deck_two_starboard_aft"

/obj/effect/shuttle_landmark/horizon/decktwo/port_aft
	name = "Deck One, Port Aft of Horizon"
	landmark_tag = "deck_two_port_aft"


////Deck three landmarks that overmap shuttles can go to
/obj/effect/shuttle_landmark/horizon/deckthree
	base_turf = /turf/space
	base_area = /area/space

//This is in front of the bridge, which I think deserves particular notice here
/obj/effect/shuttle_landmark/horizon/deckthree/fore
	name = "Deck Three, Fore of Horizon"
	landmark_tag = "deck_three_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/deckthree/starboard
	name = "Deck Three, Starboard of Horizon"
	landmark_tag = "deck_three_starboard_of_horizon"

/obj/effect/shuttle_landmark/horizon/deckthree/port
	name = "Deck Three, Port of Horizon"
	landmark_tag = "deck_three_port_of_horizon"

/obj/effect/shuttle_landmark/horizon/deckthree/aft
	name = "Deck Three, Aft of Horizon"
	landmark_tag = "deck_three_aft_of_horizon"
