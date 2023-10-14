/datum/map_template/ruin/away_site/einstein_shuttle
	name = "clear sector"
	id = "einstein_shuttle"
	description = "An empty sector."
	suffixes = list("away_site/konyang/einstein_shuttle/einstein_shuttle.dmm")
	spawn_weight = 1
	ship_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/einstein_shuttle)
	sectors = list(SECTOR_HANEUNIM)

/singleton/submap_archetype/einstein_shuttle
	map = "clear sector"
	descriptor = "An empty sector."

/obj/effect/overmap/visitable/sector/einstein_shuttle
	name = "empty sector"
	desc = "An empty sector."
	icon_state = null //this away site only exists so the shuttle can spawn and doesn't need to be seen. Invisible var causes issues when used for this purpose.
	initial_restricted_waypoints = list(
		"Einstein Shuttle" = list("nav_start_einstein")
	)

//Areas
/area/shuttle/einstein_shuttle
	name = "Einstein Engines Transport Shuttle"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	flags = RAD_SHIELDED

/area/shuttle/einstein_shuttle/helm
	name = "Einstein Shuttle - Helm"
	icon_state = "bridge"

/area/shuttle/einstein_shuttle/main
	name = "Einstein Shuttle - Passenger Lounge"
	icon_state = "crew_quarters"

/area/shuttle/einstein_shuttle/room
	name = "Einstein Shuttle - Room #1"
	icon_state = "Sleep"
/area/shuttle/einstein_shuttle/room/two
	name = "Einstein Shuttle - Room #2"
/area/shuttle/einstein_shuttle/room/three
	name = "Einstein Shuttle - Room #3"
/area/shuttle/einstein_shuttle/room/four
	name = "Einstein Shuttle - Room #4"

/area/shuttle/einstein_shuttle/conference
	name = "Einstein Shuttle - Conference Room"
	icon_state = "conference"

/area/shuttle/einstein_shuttle/bathroom
	name = "Einstein Shuttle - Bathroom"
	icon_state = "showers"

/area/shuttle/einstein_shuttle/porteng
	name = "Einstein Shuttle - Port Propulsion"
	icon_state = "engineering"

/area/shuttle/einstein_shuttle/starbeng
	name = "Einstein Shuttle - Starboard Propulsion"
	icon_state = "engineering"

/area/shuttle/einstein_shuttle/dock
	name = "Einstein Shuttle - Docking Port"
	icon_state = "exit"

//Actual overmap stuff
/obj/effect/overmap/visitable/ship/landable/einstein_shuttle
	name = "Einstein Shuttle"
	class = "EEV"
	shuttle = "Einstein Shuttle"
	designation = "Ferryman"
	desc = "The Chariot-class Executive Transport is an older Einstein Engines design for localised luxury transport. These days, it is largely used by Einstein corporate personnel for short-range business journeys, as well as occasionally being attached to larger Einstein vessels."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#18e9b5", "#6aa9dd")
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH

/obj/machinery/computer/shuttle_control/explore/einstein_shuttle
	name = "shuttle control console"
	shuttle_tag = "Einstein Shuttle"
	req_access = list(access_ee_spy_ship)

/datum/shuttle/autodock/overmap/einstein_shuttle
	name = "Einstein Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/einstein_shuttle, /area/shuttle/einstein_shuttle/helm, /area/shuttle/einstein_shuttle/main, /area/shuttle/einstein_shuttle/room, /area/shuttle/einstein_shuttle/room/two, /area/shuttle/einstein_shuttle/room/three, /area/shuttle/einstein_shuttle/room/four, /area/shuttle/einstein_shuttle/conference, /area/shuttle/einstein_shuttle/bathroom, /area/shuttle/einstein_shuttle/porteng, /area/shuttle/einstein_shuttle/starbeng, /area/shuttle/einstein_shuttle/dock)
	current_location = "nav_start_einstein"
	landmark_transition = "nav_transit_einstein"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_start_einstein"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/einstein_shuttle/start
	name = "Empty Space"
	landmark_tag = "nav_start_einstein"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/einstein_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_einstein"
	base_turf = /turf/space/transit/north

//Ghostroles
/datum/ghostspawner/human/einstein_crew
	short_name = "einstein_pilot"
	name = "Einstein Engines Pilot"
	desc = "Pilot an Einstein Engines shuttle near Konyang, carrying two mid-ranking corporate employees on a business trip."
	tags = list("External")

	spawnpoints = list("einstein_pilot")
	max_count = 1

	outfit = /datum/outfit/admin/einstein_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_SHELL, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Einstein Engines Pilot"
	special_role = "Einstein Engines Pilot"
	respawn_flag = null


/datum/outfit/admin/einstein_crew
	name = "Einstein Shuttle Pilot"

	uniform = /obj/item/clothing/under/rank/einstein
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	accessory = /obj/item/clothing/accessory/storage/pouches/black
	r_pocket = /obj/item/storage/wallet/random

	id = /obj/item/card/id/einstein

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/einstein_crew/get_id_access()
	return list(access_ee_spy_ship, access_external_airlocks)

/datum/ghostspawner/human/einstein_crew/suit
	short_name = "einstein_suit"
	name = "Einstein Engines Corporate Representative"
	desc = "You are a representative of minor importance working for Einstein Engines, one of the Spur's largest megacorporations. Currently, you are on a business trip via shuttle in the vicinity of Konyang."
	tags = list("External")

	spawnpoints = list("einstein_suit")
	max_count = 2

	outfit = /datum/outfit/admin/einstein_crew/suit
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Einstein Engines Corporate Representative"
	special_role = "Einstein Engines Corporate Representative"
	respawn_flag = null

/datum/outfit/admin/einstein_crew/suit
	uniform = /obj/item/clothing/under/suit_jacket/navy
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	accessory = null
	belt = null
