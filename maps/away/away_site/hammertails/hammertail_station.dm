/datum/map_template/ruin/away_site/hammertail_station
	name = "Hammertail Station"
	description = "A station owned by the Hammertail smiths."
	suffixes = list("away_site/hammertails/hammertail_station.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_VALLEY_HALE, SECTOR_CORP_ZONE, SECTOR_ROMANOVICH) //Sectors in the Hammertails' area of operation that aren't super well-patrolled
	ship_cost = 1
	spawn_weight = 1
	id = "hammertail_station"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/hammertail_shuttle,
		/datum/shuttle/autodock/overmap/hammertail_pod
	)

/singleton/submap_archetype/hammertail_station
	map = "Hammertail Station"
	descriptor = "A station owned by the Hammertail smiths."

/obj/effect/overmap/visitable/sector/hammertail_station
	name = "large asteroid"
	desc = "A large asteroid with few signs of surface minerals. Faint energy readings can be detected from the surface."
	icon_state = "asteroid1"
	color = "#47413c"
	comms_support = TRUE
	comms_name = "Hammertail Station"
	initial_generic_waypoints = list(
		"hammertail_fore",
		"hammertail_aft",
		"hammertail_port",
		"hammertail_starboard"
	)
	initial_restricted_waypoints = list(
		"Hammertail Shuttle" = list("nav_hangar_hammertail"),
		"Hammertail Escape Pod" = list("nav_home_hammertail_pod")
	)
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/shuttle_landmark/hammertail_station
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/hammertail_station/fore
	name = "Fore"
	landmark_tag = "hammertail_fore"

/obj/effect/shuttle_landmark/hammertail_station/aft
	name = "Aft"
	landmark_tag = "hammertail_aft"

/obj/effect/shuttle_landmark/hammertail_station/port
	name = "Port"
	landmark_tag = "hammertail_port"

/obj/effect/shuttle_landmark/hammertail_station/starboard
	name = "Starboard"
	landmark_tag = "hammertail_starboard"

//Main shuttle
/obj/effect/overmap/visitable/ship/landable/hammertail_shuttle
	name = "Hammertail Shuttle"
	class = "ICV"
	desc = "A Sparrow-class transport skipjack, often seen in the hands of miners, prospectors or smugglers across the Orion Spur."
	shuttle = "Hammertail Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#801313", "#136909", "#ea7b1a")
	designer = "Hephaestus Industries"
	weapons = "Dual fore-mounted weapon arrays"
	sizeclass = "Sparrow-class transport"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/hammertail_shuttle/New()
	designation = "[pick("Entrepreneur", "Fellow Traveler", "Safe & Legal", "Who Wants To Live Forever", "Cash On Delivery", "No Refunds", "Fat Tails Fat Wallets", "Not Taking Commissions", "Ask Me About My HI-M96", "Not'zar's Backup Limousine", "Grenade Enthusiast", "Stop Fucking With The IFF", "Honor Fire Burn Someone Else", "Phoron Sticks To Hatchlings", "Sensor Malfunction, Please Restart System", "I Think The Lands Are OK, Actually", "Dedicated To The Brave Yizarus Brigade of Gakal'zaal", "Open For Business", "Please Insert Credits")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/hammertail_shuttle
	name = "shuttle control console"
	shuttle_tag = "Hammertail Shuttle"
	req_access = list(ACCESS_HAMMERTAILS)

/datum/shuttle/autodock/overmap/hammertail_shuttle
	name = "Hammertail Shuttle"
	move_time = 40
	shuttle_area = list(/area/shuttle/hammertail)
	current_location = "nav_hangar_hammertail"
	landmark_transition = "nav_transit_hammertail"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_hammertail"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/hammertail_hangar
	name = "Shuttle Hangar"
	landmark_tag = "nav_hangar_hammertail"
	docking_controller = "hammertail_dock"
	base_area = /area/hammertail_station/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/hammertail_transit
	name = "In transit"
	landmark_tag = "nav_transit_hammertail"
	base_turf = /turf/space/transit/north

//Escape pod
/obj/effect/overmap/visitable/ship/landable/hammertail_pod
	name = "Hammertail Escape Pod"
	class = "IEP" //Independent Evacuation Pod
	designation = "Last Hope"
	desc = "A tiny Salvation-class escape pod of Einstein manufacture, usually seen aboard large corporate or civilian vessels."
	shuttle = "Hammertail Escape Pod"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#801313", "#136909", "#ea7b1a")
	designer = "Einstein Engines"
	sizeclass = "Salvation-class escape pod"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 1500 //small pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/hammertail_pod
	name = "Hammertail Escape Pod"
	move_time = 30
	shuttle_area = list(/area/shuttle/hammertail_pod)
	current_location = "nav_home_hammertail_pod"
	landmark_transition = "nav_transit_hammertail_pod"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_home_hammertail_pod"
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/explore/terminal/hammertail_pod
	name = "escape pod control console"
	shuttle_tag = "Hammertail Escape Pod"
	req_access = list(ACCESS_HAMMERTAILS)

/obj/effect/shuttle_landmark/hammertail_pod
	name = "Escape Pod Berth"
	landmark_tag = "nav_home_hammertail_pod"
	base_area = /area/space
	base_turf = /turf/simulated/floor/airless/ceiling
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/hammertail_pod_transit
	name = "In transit"
	landmark_tag = "nav_transit_hammertail_pod"
	base_turf = /turf/space/transit/north

//Fluff items
/obj/item/paper/fluff/hammertail_escape
	name = "escape pod notes"
	info = "The wall next to the vent leads to the escape pod. Fuelled it myself the other day. Remember, thing has worthless fuel efficiency, so it's not going to get you far. Best bet is to try latch onto a bigger ship and hitch a ride out of the system, or just hide until whoever's after you gets bored and goes home. Should fit the station's full crew, but it'll be a tight squeeze. Hope no one's molting."
	//language = LANGUAGE_UNATHI

/obj/item/paper/fluff/hammertail_range
	name = "FIRE SAFETY AND YOU"
	info = "Yet again, another warning is needed, because certain people who shall remain nameless keep lighing themselves on fire with napalm, flamethrowers, incendiary rounds, et cetera. WEAR A FIRESUIT WHEN YOU ARE TESTING INCENDIARIES ON THE RANGE. No one wants to buy merchandise that smells of slow-roasted Sinta, and I'm getting tired of wasting all our dermaline on you half-wits."
	//language = LANGUAGE_UNATHI
