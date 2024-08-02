// --------------------- base type

/obj/effect/shuttle_landmark/tajara_mining_jack
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/tajara_mining_jack/hangar
	name = "Mining Jack Hangar"
	landmark_tag = "nav_hangar_tajara_mining_jack"
	docking_controller = "tajara_mining_jack_shuttle_dock"
	base_area = /area/mining_jack_outpost/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/tajara_mining_jack/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajara_mining_jack"
	base_turf = /turf/space/transit/north

// --------------------- docks

// ----

/obj/effect/shuttle_landmark/mining_jack/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_mining_jack_dock_port"
	docking_controller = "airlock_mining_jack_dock_port"

/obj/effect/map_effect/marker/airlock/docking/mining_jack/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_mining_jack_dock_port"
	master_tag = "airlock_mining_jack_dock_port"

// ----

/obj/effect/shuttle_landmark/mining_jack/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_mining_jack_dock_starboard"
	docking_controller = "airlock_mining_jack_dock_starboard"

/obj/effect/map_effect/marker/airlock/docking/mining_jack/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_mining_jack_dock_starboard"
	master_tag = "airlock_mining_jack_dock_starboard"
