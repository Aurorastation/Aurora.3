/datum/map_template/ruin/away_site/kataphract_ship
	name = "kataphract ship"
	id = "awaysite_kataphract_ship"
	description = "Ship with lizard knights."
	suffix = "ships/kataphracts/kataphract_ship.dmm"
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_UUEOAESA)

/obj/effect/overmap/visitable/ship/kataphract_ship
	name = "kataphract chapter ship"
	desc = "A large corvette manufactured by a Hephaestus sponsered Hegemonic Guild. This is a Kataphract Chapter ship of the venerable 'Voidbreaker' class, a relative of the more common 'Foundation' class used by their counterparts in the Hegemon's navy. These vessels are rarely seen together and strive for maximum self-suffiency as they are the homes and primary means of transportation for questing Kataphracts and their Hopefuls. They carry enough firepower to deter the common pirate as well as a set of boarding pods." 
	class = "HKV" //Hegemony Kataphract Vessel 
	icon_state = "ship_green"
	moving_state = "ship_green_moving"
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_kataphract_1",
		"nav_kataphract_2",
		"nav_kataphract_3",
		"nav_kataphract_4",
		"nav_kataphract_5",
	)

/obj/effect/overmap/visitable/ship/kataphract_ship/New()
	designation = "[pick("Pious Avenger", "Persistent Conviction", "Solemn Retribution", "Old Ironscales", "Sword of Faith", "Glorious Succor", "Sacred Retribution", "Unflinching Soul", "Unrelenting", "Ascendant Absolution")]"
	..()

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav1
	name = "Kataphract Ship Navpoint #1"
	landmark_tag = "nav__kataphract_ship_1"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav2
	name = "Kataphract Ship Navpoint #2"
	landmark_tag = "nav__kataphract_ship_2"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav3
	name = "Kataphract Ship Navpoint #3"
	landmark_tag = "nav__kataphract_ship_3"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav4
	name = "Kataphract Ship Navpoint #4"
	landmark_tag = "nav__kataphract_ship_4"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav5
	name = "Kataphract Ship Navpoint #5"
	landmark_tag = "nav__kataphract_ship_5"

//shuttle 
/obj/effect/overmap/visitable/ship/landable/kataphract_transport
	name = "Kataphract Transport Shuttle"
	desc = "idk i transport jon its what I do."
	shuttle = "Kataphract Transport Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/kataphract_transport
	name = "shuttle control console"
	shuttle_tag = "Kataphract Transport Shuttle"
	req_access = list(access_kataphract)

/datum/shuttle/autodock/overmap/kataphract_transport
	name = "Elyran Naval Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/didntmapityet)
	current_location = "nav_hangar_kataphract"
	landmark_transition = "nav_transit_kataphract_transport"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_kataphract"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/kataphract_transport/hangar
	name = "Kataphract Transport Shuttle Hangar"
	landmark_tag = "nav_hangar_kataphract"
	docking_controller = "kataphract_shuttle_dock"
	base_area = /area/ship/morbius
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/elyran_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_elyran_shuttle"
	base_turf = /turf/space/transit/south
