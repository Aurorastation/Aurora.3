/datum/map_template/ruin/away_site/elyran_strike_craft
	name = "Elyran Naval Strike Craft"
	description = "The Aslan-class Strike Craft is among the oldest designs in the Elyran naval arsenal, and is one of the ship classes slated to be retired in the ongoing Elyran military modernization plan. Not an independent vessel in of itself, it is instead an oversized attack craft designed to be launched from the General Abd Al-Hamid-class Carrier, a type of Elyran capital ship, named after the Republic's foremost national hero. As such, it has limited crew facilities and life support capabilities, and is instead reliant on its mothership for long-term operation. This ship is an interdiction variant, with its torpedo bay and railgun hardpoint replaced by a hangar and a boarding pod launch room, respectively. This one's transponder identifies it as an Elyran Naval Infantry interdiction vessel."
	suffix = "ships/elyra/elyran_strike_craft.dmm"
	sectors = list(SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ)
	spawn_weight = 1
	spawn_cost = 1
	id = "elyran_strike_craft"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/elyran_shuttle)

/decl/submap_archetype/elyran_strike_craft
	map = "Elyran Naval Strike Craft"
	descriptor = "The Aslan-class Strike Craft is among the oldest designs in the Elyran naval arsenal, and is one of the ship classes slated to be retired in the ongoing Elyran military modernization plan. Not an independent vessel in of itself, it is instead an oversized attack craft designed to be launched from the General Abd Al-Hamid-class Carrier, a type of Elyran capital ship, named after the Republic's foremost national hero. As such, it has limited crew facilities and life support capabilities, and is instead reliant on its mothership for long-term operation. This ship is an interdiction variant, with its torpedo bay and railgun hardpoint replaced by a hangar and a boarding pod launch room, respectively. This one's transponder identifies it as an Elyran Naval Infantry interdiction vessel."

//areas
/area/ship/elyran_strike_craft
	name = "Elyran Naval Strike Craft"

/area/shuttle/elyran_shuttle
	name = "Elyran Naval Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/elyran_strike_craft
	name = "Elyran Naval Strike Craft"
	class = "ENV"
	desc = "The Aslan-class Strike Craft is among the oldest designs in the Elyran naval arsenal, and is one of the ship classes slated to be retired in the ongoing Elyran military modernization plan. Not an independent vessel in of itself, it is instead an oversized attack craft designed to be launched from the General Abd Al-Hamid-class Carrier, a type of Elyran capital ship, named after the Republic's foremost national hero. As such, it has limited crew facilities and life support capabilities, and is instead reliant on its mothership for long-term operation. This ship is an interdiction variant, with its torpedo bay and railgun hardpoint replaced by a hangar and a boarding pod launch room, respectively. This one's transponder identifies it as an Elyran Naval Infantry interdiction vessel."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Elyran Naval Shuttle" = list("nav_hangar_elyra")
	)

	initial_generic_waypoints = list(
		"nav_elyran_strike_craft_1",
		"nav_elyran_strike_craft_2"
	)

/obj/effect/overmap/visitable/ship/elyran_strike_craft/New()
	designation = "[pick("Persepolis", "Damascus", "Medina", "Aemaq", "New Suez", "Bursa", "Republican", "Falcon", "Gelin", "Sphinx", "Takam", "Dandan", "Anqa", "Falak", "Uthra", "Djinn", "Roc", "Shadhavar", "Karkadann")]"
	..()

/obj/effect/shuttle_landmark/elyran_strike_craft/nav1
	name = "Elyran Naval Strike Craft - Port Side"
	landmark_tag = "nav_elyran_strike_craft_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_strike_craft/nav2
	name = "Elyran Naval Strike Craft - Port Airlock"
	landmark_tag = "nav_elyran_strike_craft_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_strike_craft/transit
	name = "In transit"
	landmark_tag = "nav_transit_elyran_strike_craft"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/elyran_shuttle
	name = "Elyran Naval Shuttle"
	class = "ENV"
	designation = "Colibri"
	desc = "Easily mistaken for a Wisp-class (which it is almost identical to), this shuttle is in fact an Elyran Dromedary-class, which is an unlicensed copy of the Hephaestus Wisp-class, and one of the designs slated for retirement in the ongoing military modernization program. Hephaestus Industries has attempted to sue the Elyran government many times for the navy's unlicensed production of its intellectual property, and Elyran courts have, unsurprisingly, always ruled in favor of the government - much to the frustration of the megacorporation, which has no other method of recourse. An inefficient design of ultra-light shuttle. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. This one's transponder identifies it as an Elyran Naval Infantry recovery shuttle."
	shuttle = "Elyran Naval Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/elyran_shuttle
	name = "shuttle control console"
	shuttle_tag = "Elyran Naval Shuttle"
	req_access = list(access_elyran_naval_infantry_ship)

/datum/shuttle/autodock/overmap/elyran_shuttle
	name = "Elyran Naval Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/elyran_shuttle)
	current_location = "nav_hangar_elyra"
	landmark_transition = "nav_transit_elyran_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_elyra"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/elyran_shuttle/hangar
	name = "Elyran Naval Shuttle Hangar"
	landmark_tag = "nav_hangar_elyra"
	docking_controller = "elyran_shuttle_dock"
	base_area = /area/ship/elyran_strike_craft
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/elyran_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_elyran_shuttle"
	base_turf = /turf/space/transit/north
