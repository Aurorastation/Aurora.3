/datum/map_template/ruin/away_site/kataphract_ship
	name = "kataphract ship"
	id = "awaysite_kataphract_ship"
	description = "Ship with lizard knights."
	suffixes = list("ships/kataphracts/kataphract_ship.dmm")
	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/kataphract_transport)
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_UUEOAESA, SECTOR_WEEPING_STARS)

	unit_test_groups = list(3)

/obj/effect/overmap/visitable/ship/kataphract_ship
	name = "kataphract chapter ship"
	desc = "A large corvette manufactured by a Hephaestus sponsored Hegemonic Guild. This is a heavily armoured Kataphract Chapter ship of the venerable 'Voidbreaker' class, a relative of the more common 'Foundation' \
	class used by their counterparts in the Hegemony Navy. These vessels are rarely seen together and strive for maximum self-suffiency as they are the homes and primary means of transportation \
	for questing Kataphracts and their followers. They usually carry enough firepower to deter the common pirate as well as a set of boarding pods for offensive actions. This ship however has no weapon hardpoints detected. It remains capable due to its sturdy design."
	class = "IHKV" //Izweski Hegemony Kataphract Vessel
	icon_state = "voidbreaker"
	moving_state = "voidbreaker_moving"
	colors = list("#e38222", "#f0ba3e")
	scanimage = "unathi_corvette.png"
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "65 meters length, 45 meters beam/width, 21 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Not apparent, port obscured flight craft bay"
	sizeclass = "Voidbreaker-class Armored Corvette"
	shiptype = "Specialist long-distance extended-duration combat utility"
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nav_kataphract_ship_1",
		"nav_kataphract_ship_2",
		"nav_kataphract_ship_3",
		"nav_kataphract_ship_4",
		"nav_kataphract_ship_5",
		"nav_kataphract_ship_portdock",
	)
	initial_restricted_waypoints = list(
		"Kataphract Transport" = list("nav_hangar_kataphract_shuttle"),
		"Intrepid" = list("nav_kataphract_ship_dockintrepid")
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/kataphract_ship/New()
	designation = "[pick("Pious Avenger", "Persistent Conviction", "Solemn Retribution", "Venerable Ironscales", "Blade of Faith", "Glorious Succor", "Sacred Retribution", "Unflinching Soul", "Unrelenting Fervor", "Ascendant Absolution")]"
	..()

/obj/effect/shuttle_landmark/nav_kataphract_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav1
	name = "Kataphract Ship Navpoint #1"
	landmark_tag = "nav_kataphract_ship_1"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav2
	name = "Kataphract Ship Navpoint #2"
	landmark_tag = "nav_kataphract_ship_2"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav3
	name = "Kataphract Ship Navpoint #3"
	landmark_tag = "nav_kataphract_ship_3"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav4
	name = "Kataphract Ship Navpoint #4"
	landmark_tag = "nav_kataphract_ship_4"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav5
	name = "Kataphract Ship Navpoint #5"
	landmark_tag = "nav_kataphract_ship_5"

/obj/effect/shuttle_landmark/nav_kataphract_ship/starboarddock //any ship with a docking port on their left side assuming they have their landmark mapped in properly
	name = "Kataphract Ship Starboard Docking"
	landmark_tag = "nav_kataphract_ship_starboarddock"

/obj/effect/shuttle_landmark/nav_kataphract_ship/dockintrepid // restricted for the intrepid only or else other ships will be able to use this point, and not properly dock
	name = "Kataphract Ship Intrepid Starboard Docking"
	landmark_tag = "nav_kataphract_ship_dockintrepid"

//shuttle
/obj/effect/overmap/visitable/ship/landable/kataphract_transport
	name = "Kataphract Transport"
	class = "IHKV"
	designation = "Sasuna"
	desc = "A small egg shaped shuttle of the 'Spearhead' class, commonly seen carried by Izweski Hegemony vessels. They're never far from their motherships and are a telltale sign of an Unathi presence within a sector. Affectionately called the 'Hatchling' by its operators. The transponder for this vessel identifies it as belonging to a traveling Kataphract Guild of the Hegemony."
	shuttle = "Kataphract Transport"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#e38222", "#f0ba3e")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 6000 //Ship has a lot of thrusters, so if its too low the shuttle goes too fast. Also, imagine a hard egg flying towards you.
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/kataphract_transport
	name = "shuttle control console"
	shuttle_tag = "Kataphract Transport"
	req_access = list(access_kataphract)

/datum/shuttle/autodock/overmap/kataphract_transport
	name = "Kataphract Transport"
	move_time = 20
	shuttle_area = list(/area/shuttle/kataphract_shuttle/main_compartment, /area/shuttle/kataphract_shuttle/engine_compartment)
	current_location = "nav_hangar_kataphract_shuttle"
	dock_target = "kataphract_transport"
	landmark_transition = "nav_kataphract_transport_transit"
	range = 2 // It's a big boy
	fuel_consumption = 4
	logging_home_tag = "nav_hangar_kataphract_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/kataphract_transport/hangar
	name = "Kataphract Transport Shuttle Hangar"
	landmark_tag = "nav_hangar_kataphract_shuttle"
	docking_controller = "kataphract_dock"
	base_area = /area/kataphract_chapter/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/kataphract_transport/transit
	name = "In transit"
	landmark_tag = "nav_kataphract_transport_transit"
	base_turf = /turf/space/transit/east
