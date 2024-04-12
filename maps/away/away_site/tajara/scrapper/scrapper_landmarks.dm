// --------------------- base type

/obj/effect/shuttle_landmark/tajara_scrapper
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/tajara_scrapper/hangar
	name = "Scrapper Ship Hangar"
	landmark_tag = "nav_hangar_tajara_scrapper"
	docking_controller = "tajaran_scrapper_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/tajara_scrapper/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajara_scrapper"
	base_turf = /turf/space/transit/north
