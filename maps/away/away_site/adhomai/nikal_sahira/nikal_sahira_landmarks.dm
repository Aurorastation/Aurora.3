// ---------- General Store Lift

/datum/shuttle/autodock/multi/lift/crevus_general_store
	name = "Nikal Sahira - General Store Lift"
	current_location = "nav_crevus_general_store_floor1"
	shuttle_area = /area/turbolift/crevus/general_store
	destination_tags = list(
		"nav_crevus_general_store_basement",
		"nav_crevus_general_store_floor1",
		)

/obj/effect/shuttle_landmark/lift/crevus_general_store_basement
	name = "Nikal Sahira - General Store Basement"
	landmark_tag = "nav_crevus_general_store_basement"
	base_area = /area/crevus/general_store/storage
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/crevus_general_store_floor1
	name = "Nikal Sahira - General Store Floor 1"
	landmark_tag = "nav_crevus_general_store_floor1"
	base_area = /area/crevus/general_store
	base_turf = /turf/simulated/open

/obj/structure/machinery/computer/shuttle_control/multi/lift/crevus_general_store
	shuttle_tag = "Nikal Sahira - General Store Lift"
