
// ---------------- map defs
/datum/map_template/ruin/away_site/crashed_elyran_tanker
	name = "crashed elyran tanker"
	description = "desc 1"
	suffix = "generic/crashed_elyran_tanker/crashed_elyran_tanker.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 1000000
	spawn_cost = 1
	id = "crashed_elyran_tanker"
    // A small tanker, emitting a very faint IFF signal of civilian vessels registered in Elyra. It seems to be partially embedded into a small asteroid, and appears to be completely cold.

/decl/submap_archetype/crashed_elyran_tanker
	map = "crashed_elyran_tanker"
	descriptor = "desc 2"

/obj/effect/overmap/visitable/crashed_elyran_tanker
	name = "crashed elyran tanker"
	desc = "desc 3"
	initial_generic_waypoints = list(
		"nav_crashed_elyran_tanker_dock_aft",
		"nav_crashed_elyran_tanker_dock_starboard",
		"nav_crashed_elyran_tanker_east",
		"nav_crashed_elyran_tanker_north",
		"nav_crashed_elyran_tanker_south",
		"nav_crashed_elyran_tanker_west",
	)
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_crashed_elyran_tanker_dock_aft_intrepid"),
	)

// ---------------- landmarks
/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/dock_aft
	name = "Crashed Tanker Aft Dock"
	landmark_tag = "nav_crashed_elyran_tanker_dock_aft"

/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/dock_aft_intrepid
	name = "Crashed Tanker Intrepid Aft Dock"
	landmark_tag = "nav_crashed_elyran_tanker_dock_aft_intrepid"

/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/dock_starboard
	name = "Crashed Tanker Aft Dock"
	landmark_tag = "nav_crashed_elyran_tanker_dock_starboard"

/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/east
	name = "Crashed Tanker Navpoint East"
	landmark_tag = "nav_crashed_elyran_tanker_east"

/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/north
	name = "Crashed Tanker Navpoint North"
	landmark_tag = "nav_crashed_elyran_tanker_north"

/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/south
	name = "Crashed Tanker Navpoint South"
	landmark_tag = "nav_crashed_elyran_tanker_south"

/obj/effect/shuttle_landmark/nav_crashed_elyran_tanker/west
	name = "Crashed Tanker Navpoint West"
	landmark_tag = "nav_crashed_elyran_tanker_west"

// ---------------- areas
/area/crashed_elyran_tanker/bridge
	name = "Crashed Elyran Tanker - Bridge"
	icon_state = "bridge"

/area/crashed_elyran_tanker/crew
	name = "Crashed Elyran Tanker - Crew Area"
	icon_state = "crew_area"

/area/crashed_elyran_tanker/engineering
	name = "Crashed Elyran Tanker - Engineering"
	icon_state = "engineering"

/area/crashed_elyran_tanker/thruster
	name = "Crashed Elyran Tanker - Thruster Maintenance"
	icon_state = "engine"

/area/crashed_elyran_tanker/tanks
	name = "Crashed Elyran Tanker - Tanks"
	icon_state = "atmos"
