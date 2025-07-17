/obj/effect/shuttle_landmark/himeo_patrol
	base_turf = /turf/space/dynamic
	base_area = /area/space

//Deck 1 navpoints.
/obj/effect/shuttle_landmark/himeo_patrol/nav1
	name = "Himeo Planetary Guard Vessel - Deck One Fore"
	landmark_tag = "himeo_patrol_nav1"

/obj/effect/shuttle_landmark/himeo_patrol/nav2
	name = "Himeo Planetary Guard Vessel - Deck One Aft "
	landmark_tag = "himeo_patrol_nav2"

/obj/effect/shuttle_landmark/himeo_patrol/nav3
	name = "Himeo Planetary Guard Vessel - Deck One Port "
	landmark_tag = "himeo_patrol_nav3"

/obj/effect/shuttle_landmark/himeo_patrol/nav4
	name = "Himeo Planetary Guard Vessel - Deck One Starboard"
	landmark_tag = "himeo_patrol_nav4"

//Deck 2 navpoints.
/obj/effect/shuttle_landmark/himeo_patrol/dock1
	name = "Himeo Planetary Guard Vessel - Deck Two Starboard"
	landmark_tag = "himeo_patrol_dock1"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/himeo_patrol/dock2
	name = "Himeo Planetary Guard Vessel - Deck Two Fore"
	landmark_tag = "himeo_patrol_dock2"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/himeo_patrol/dock3
	name = "Himeo Planetary Guard Vessel - Deck Two Aft"
	landmark_tag = "himeo_patrol_dock3"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/himeo_patrol/dock4
	name = "Himeo Planetary Guard Vessel - Deck Two Port"
	landmark_tag = "himeo_patrol_dock4"
	base_turf = /turf/simulated/floor/reinforced/airless

// Airlock markers, Deck 1
/obj/effect/map_effect/marker/airlock/himeo_patrol/fore
	name = "Airlock, Fore"
	master_tag = "airlock_himeo_patrol_fore"

/obj/effect/map_effect/marker/airlock/himeo_patrol/aft
	name = "Airlock, Aft"
	master_tag = "airlock_himeo_patrol_aft"

/obj/effect/map_effect/marker/airlock/himeo_patrol/starboard
	name = "Airlock, Starboard"
	master_tag = "airlock_himeo_patrol_starboard"

// Airlock markers, Deck 2

/obj/effect/map_effect/marker/airlock/himeo_patrol/deck_2/starboard
	name = "Airlock, Starboard"
	master_tag = "airlock_himeo_patrol_deck_2_starboard"

// Docking airlock markers, Deck 2
/obj/effect/map_effect/marker/airlock/docking/himeo_patrol/aft_dock
	name = "Aft"
	master_tag = "airlock_himeo_patrol_aft_dock"
	landmark_tag = "himeo_patrol_aft_dock"

/obj/effect/map_effect/marker/airlock/docking/himeo_patrol/fore_dock
	name = "Fore"
	master_tag = "airlock_himeo_patrol_fore_dock"
	landmark_tag = "himeo_patrol_fore_dock"

/obj/effect/map_effect/marker/airlock/docking/himeo_patrol/port_dock
	name = "Port"
	master_tag = "airlock_himeo_patrol_port_dock"
	landmark_tag = "himeo_patrol_port_dock"

/obj/effect/map_effect/marker/airlock/docking/himeo_patrol/starboard_dock
	name = "Starboard"
	master_tag = "airlock_himeo_patrol_starboard_dock"
	landmark_tag = "himeo_patrol_starboard_dock"

// Mapmanip
// Northern storage compartment
/obj/effect/map_effect/marker/mapmanip/submap/extract/himeo_patrol_ship/storage_1
	name = "Himeo Patrol Ship - Cargo North"

/obj/effect/map_effect/marker/mapmanip/submap/insert/himeo_patrol_ship/storage_1
	name = "Himeo Patrol Ship - Cargo North"

// Southern storage compartment
/obj/effect/map_effect/marker/mapmanip/submap/extract/himeo_patrol_ship/storage_2
	name = "Himeo Patrol Ship - Cargo South"

/obj/effect/map_effect/marker/mapmanip/submap/insert/himeo_patrol_ship/storage_2
	name = "Himeo Patrol Ship - Cargo South"
