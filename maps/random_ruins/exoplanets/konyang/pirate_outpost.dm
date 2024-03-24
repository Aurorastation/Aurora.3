/datum/map_template/ruin/exoplanet/pirate_outpost
	name = "Pirate Outpost"
	id = "konyang_pirate"
	description = "An outpost in the jungle home to a group of Konyang pirates."
	spawn_weight = 1
	spawn_cost = 2

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/pirate_outpost.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/konyang_pirate)


/area/konyang_pirate_outpost
	name = "Konyang Pirate Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/shuttle/konyang_pirate
	name = "Repaired Shuttle"

/obj/effect/overmap/visitable/ship/landable/konyang_pirate
	name = "Konyang Pirate Shuttle"
	desc = "The Minnow-class shuttle is an old design, not often seen in the modern Spur. Originally designed by Einstein Engines for refuelling and maintenance of larger craft, advances in aerospace engineering have rendered the Minnow largely obsolete."
	class = "ICV"
	designation = "Thresher"
	designer = "Einstein Engines"
	sizeclass = "Minnow-class transport shuttle"
	shiptype = "Short-range refuelling and maintenance operations."
	shuttle = "Konyang Pirate Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000 //Hard to move
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/konyang_pirate
	name = "shuttle control console"
	shuttle_tag = "Konyang Pirate Shuttle"

/datum/shuttle/autodock/overmap/konyang_pirate
	name = "Konyang Pirate Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/konyang_pirate)
	current_location = "nav_start_konyang_pirate"
	landmark_transition = "nav_transit_konyang_pirate"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_start_konyang_pirate"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/konyang_pirate/start
	name = "Konyang Pirate Outpost - Landing Pad"
	landmark_tag = "nav_start_konyang_pirate"
	docking_controller = "airlock_konyang_pirate"
	base_area = /area/konyang_pirate_outpost
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/konyang_pirate/transit
	name = "In transit"
	landmark_tag = "nav_transit_konyang_pirate"
	base_turf = /turf/space/transit/north

/datum/ghostspawner/human/konyang_pirate
	short_name = "konyang_pirate"
	name = "Konyang Pirate"
	desc = "Be a pirate dwelling in the jungles of Konyang - find some good targets, make a profit, and live another day. NOT AN ANTAGONIST! Do not act as such!"
	tags = list("External")
	welcome_message = "You are a pirate, hiding out in the jungles of Konyang. Your crew has managed to get a shuttle working, so you can hit juicier targets easier. Rob whoever you think you can take, but be careful of running up against people with bigger guns than you. Remember, you are not an antagonist and should not act as such - if you're unsure if something you'd like to do is toeing the line, you should ahelp first."

	extra_languages = list(LANGUAGE_SOL_COMMON)
	spawnpoints = list("konyang_pirate")
	max_count = 4

	outfit = /obj/outfit/admin/konyang/pirate
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Konyang Pirate"
	special_role = "Konyang Pirate"
	respawn_flag = null

/obj/outfit/admin/konyang/pirate
	name = "Konyang Pirate"
	uniform = list(
		/obj/item/clothing/under/konyang/pirate,
		/obj/item/clothing/under/konyang/pirate/tanktop
	)
	shoes = list(
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/sandals
	)
	head = /obj/item/clothing/head/bandana/pirate
	belt = /obj/item/material/knife/tacknife
	r_pocket = /obj/item/storage/wallet/random
	back  = /obj/item/storage/backpack/satchel/eng
	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = /obj/random/civgun
	id = null
	l_ear = null
