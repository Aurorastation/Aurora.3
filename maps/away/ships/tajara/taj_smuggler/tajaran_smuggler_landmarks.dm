// --------------------- base type

/obj/effect/shuttle_landmark/tajaran_smuggler
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/tajaran_smuggler_shuttle/hangar
	name = "Adhomian Freight Shuttle Hangar"
	landmark_tag = "nav_tajaran_smuggler_shuttle"
	docking_controller = "tajaran_smuggler_shuttle_dock"
	base_area = /area/tajaran_smuggler/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/tajaran_smuggler_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajaran_smuggler_shuttle"
	base_turf = /turf/space/transit/north

// --------------------- docks

/obj/effect/shuttle_landmark/tajaran_smuggler/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_tajaran_smuggler_dock_port"
	docking_controller = "airlock_tajaran_smuggler_dock_port"

/obj/effect/map_effect/marker/airlock/docking/tajaran_smuggler/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_tajaran_smuggler_dock_port"
	master_tag = "airlock_tajaran_smuggler_port"

// --------------------- cargo


/datum/shuttle/autodock/overmap/tajaran_smuggler_cargo
	name = "Adhomian Freight Cargo"
	move_time = 20
	shuttle_area = list(/area/shuttle/tajaran_smuggler_cargo)
	dock_target = "tajaran_smuggler_cargo"
	current_location = "nav_tajaran_smuggler_cargo"
	landmark_transition = "nav_transit_tajaran_smuggler_cargo"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_tajaran_smuggler_cargo"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tajaran_smuggler_cargo/hangar
	name = "Adhomian Freight Cargo Hangar"
	landmark_tag = "nav_tajaran_smuggler_cargo"
	docking_controller = "tajaran_smuggler_cargo_dock"
	base_area = /area/space
	base_turf = /turf/space/dynamic
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tajaran_smuggler_cargo/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajaran_smuggler_cargo"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/tajaran_smuggler_cargo/nav1
	name = "Cargo Hold - Port Side"
	landmark_tag = "nav_tajaran_smuggler_cargo_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tajaran_smuggler_cargo/nav2
	name = "Cargo Hold - Starboard Side"
	landmark_tag = "nav_tajaran_smuggler_cargo_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space
