// ---------- Base Type Shuttle Landmark

/obj/effect/shuttle_landmark/crevus
	auto_register = TRUE
	base_turf = /turf/simulated/floor/exoplanet/concrete/square
	base_area = /area/crevus/outside

// ---------- Intrepid Landing Pad

/obj/effect/shuttle_landmark/crevus/intrepid_lp
	name = "Landing Pad - 7#L2"
	shuttle_restricted = "Intrepid"
	landmark_tag = "nav_crevus_intrepid_lp"

// ---------- Generic Landing Pads

// Pad - 1
/obj/effect/shuttle_landmark/crevus/landing_pad_1a
	name = "Landing Pad - 5#L1"
	landmark_tag = "nav_crevus_lp_1a"

/obj/effect/shuttle_landmark/crevus/landing_pad_1b
	name = "Landing Pad - 5#L1"
	landmark_tag = "nav_crevus_lp_1b"

/obj/effect/shuttle_landmark/crevus/landing_pad_1c
	name = "Landing Pad - 5#L1"
	landmark_tag = "nav_crevus_lp_1c"

/obj/effect/shuttle_landmark/crevus/landing_pad_1d
	name = "Landing Pad - 5#L1"
	landmark_tag = "nav_crevus_lp_1d"

// Pad - 2
/obj/effect/shuttle_landmark/crevus/landing_pad_2a
	name = "Landing Pad - 5#L2"
	landmark_tag = "nav_crevus_lp_2a"

/obj/effect/shuttle_landmark/crevus/landing_pad_2b
	name = "Landing Pad - 5#L2"
	landmark_tag = "nav_crevus_lp_2b"

/obj/effect/shuttle_landmark/crevus/landing_pad_2c
	name = "Landing Pad - 5#L2"
	landmark_tag = "nav_crevus_lp_2c"

/obj/effect/shuttle_landmark/crevus/landing_pad_2d
	name = "Landing Pad - 5#L2"
	landmark_tag = "nav_crevus_lp_2d"

// Pad - 3
/obj/effect/shuttle_landmark/crevus/landing_pad_3a
	name = "Landing Pad - 6#L1"
	landmark_tag = "nav_crevus_lp_3a"

/obj/effect/shuttle_landmark/crevus/landing_pad_3b
	name = "Landing Pad - 6#L1"
	landmark_tag = "nav_crevus_lp_3b"

/obj/effect/shuttle_landmark/crevus/landing_pad_3c
	name = "Landing Pad - 6#L1"
	landmark_tag = "nav_crevus_lp_3c"

/obj/effect/shuttle_landmark/crevus/landing_pad_3d
	name = "Landing Pad - 6#L1"
	landmark_tag = "nav_crevus_lp_3d"

// Pad - 4
/obj/effect/shuttle_landmark/crevus/landing_pad_4a
	name = "Landing Pad - 6#L2"
	landmark_tag = "nav_crevus_lp_4a"

/obj/effect/shuttle_landmark/crevus/landing_pad_4b
	name = "Landing Pad - 6#L2"
	landmark_tag = "nav_crevus_lp_4b"

// ---------- General Store Lift

/datum/shuttle/autodock/multi/lift/crevus_general_store
	name = "Nikal Sahira - General Store Lift"
	current_location = "nav_crevus_general_store_floor1"
	shuttle_area = /area/turbolift/crevus/inside/general_store
	destination_tags = list(
		"nav_crevus_general_store_basement",
		"nav_crevus_general_store_floor1",
		)

/obj/effect/shuttle_landmark/lift/crevus_general_store_basement
	name = "Nikal Sahira - General Store Basement"
	landmark_tag = "nav_crevus_general_store_basement"
	base_area = /area/crevus/inside/general_store/storage
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/crevus_general_store_floor1
	name = "Nikal Sahira - General Store Floor 1"
	landmark_tag = "nav_crevus_general_store_floor1"
	base_area = /area/crevus/inside/general_store
	base_turf = /turf/simulated/open

/obj/structure/machinery/computer/shuttle_control/multi/lift/crevus_general_store
	shuttle_tag = "Nikal Sahira - General Store Lift"
