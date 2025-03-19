// --------------------- base type

/obj/effect/shuttle_landmark/saniorios_outpost
	base_turf = /turf/space
	base_area = /area/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/saniorios_outpost/hangar
	name = "Sani'Orios Hangar"
	landmark_tag = "nav_hangar_saniorios_outpost"
	docking_controller = "tajara_saniorios_outpost_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/map_effect/marker/airlock/docking/saniorios_outpost
	name = "Sani'Orios Hangar"
	landmark_tag = "nav_hangar_saniorios_outpost"
	master_tag = "tajara_saniorios_outpost_dock"

// ----

/obj/effect/shuttle_landmark/saniorios_outpost/transit
	name = "In transit"
	landmark_tag = "nav_transit_saniorios_outpost"
	base_turf = /turf/space/transit/north

// --------------------- docks

// ----

/obj/effect/shuttle_landmark/saniorios_outpost/nav1
	name = "Sani'Orios Navpoint #1"
	landmark_tag = "nav_hsaniorios_outpost_1"

/obj/effect/shuttle_landmark/saniorios_outpost/nav2
	name = "Sani'OriosNavpoint #2"
	landmark_tag = "nav_hsaniorios_outpost_2"

/obj/effect/shuttle_landmark/saniorios_outpost/nav3
	name = "Sani'Orios Navpoint #3"
	landmark_tag = "nav_hsaniorios_outpost_3"
