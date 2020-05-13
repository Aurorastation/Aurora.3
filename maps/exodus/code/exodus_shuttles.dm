/datum/shuttle/autodock/ferry/escape_pod/pod
	category = /datum/shuttle/autodock/ferry/escape_pod/pod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	warmup_time = 10

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"

#define EXODUS_ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod##NUMBER { \
	name = "Escape Pod " + #NUMBER; \
	shuttle_area = /area/shuttle/escape_pod##NUMBER/station; \
	location = 0; \
	dock_target = "escape_pod_" + #NUMBER; \
	arming_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	waypoint_station = "escape_pod_"+ #NUMBER +"_start"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_interim"; \
	waypoint_offsite = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_start"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_berth"; \
} \
/obj/effect/shuttle_landmark/escape_pod/out/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_interim"; \
}

EXODUS_ESCAPE_POD(1)
EXODUS_ESCAPE_POD(2)
EXODUS_ESCAPE_POD(3)
EXODUS_ESCAPE_POD(5)

//-// Transfer Shuttle //-//

/datum/shuttle/autodock/ferry/emergency/exodus
	name = "Escape Shuttle"
	location = 1
	move_time = 20
	warmup_time = 10
	shuttle_area = /area/shuttle/escape/centcom
	dock_target = "escape_shuttle"
	waypoint_station = "nav_emergency_dock"
	landmark_transition = "nav_emergency_interim"
	waypoint_offsite = "nav_emergency_start"

/obj/effect/shuttle_landmark/emergency/start
	name = "Escape Shuttle Centcom Dock"
	landmark_tag = "nav_emergency_start"
	docking_controller = "centcom_dock"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/emergency/interim
	name = "In Transit"
	landmark_tag = "nav_emergency_interim"

/obj/effect/shuttle_landmark/emergency/dock
	name = "Escape Shuttle Dock"
	landmark_tag = "nav_emergency_dock"
	docking_controller = "escape_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Supply Shuttle //-//

/datum/shuttle/autodock/ferry/supply/exodus
	name = "Supply Shuttle"
	location = 1
	shuttle_area = /area/supply/dock
	dock_target = "supply_shuttle"
	waypoint_station = "nav_supply_dock"
	waypoint_offsite = "nav_supply_start"

/obj/effect/shuttle_landmark/supply/start
	name = "Supply Centcom Dock"
	landmark_tag = "nav_supply_start"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/supply/dock
	name = "Supply Shuttle Dock"
	landmark_tag = "nav_supply_dock"
	docking_controller = "cargo_bay"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Admin Shuttle
/datum/shuttle/autodock/ferry/admin
	name = "Crescent Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/administration/centcom
	dock_target = "admin_shuttle"
	waypoint_station = "nav_admin_dock"
	waypoint_offsite = "nav_admin_start"

/obj/effect/shuttle_landmark/admin/start
	name = "Crescent Shuttle Base"
	landmark_tag = "nav_admin_start"
	docking_controller = "admin_shuttle_bay"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/admin/dock
	name = "Crescent Shuttle Dock"
	landmark_tag = "nav_admin_dock"
	docking_controller = "admin_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// CCIA Shuttle
/datum/shuttle/autodock/ferry/autoreturn/ccia
	name = "Agent Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/transport1/centcom
	dock_target = "centcom_shuttle"
	waypoint_station = "nav_ccia_dock"
	waypoint_offsite = "nav_ccia_start"
	category = /datum/shuttle/autodock/ferry/autoreturn

/obj/effect/shuttle_landmark/ccia/start
	name = "Agent Shuttle Base"
	landmark_tag = "nav_ccia_start"
	docking_controller = "centcom_shuttle_bay"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/ccia/dock
	name = "Agent Shuttle Dock"
	landmark_tag = "nav_ccia_dock"
	docking_controller = "centcom_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Engineering Shuttle
/datum/shuttle/autodock/ferry/engi
	name = "Engineering Shuttle"
	location = 0
	warmup_time = 10
	shuttle_area = /area/shuttle/constructionsite/station
	dock_target = "engineering_shuttle"
	waypoint_station = "nav_engi_start"
	waypoint_offsite = "nav_engi_dock"

/obj/effect/shuttle_landmark/engi/start
	name = "Engineering Shuttle Exodus"
	landmark_tag = "nav_engi_start"
	docking_controller = "engineering_dock_airlock"

/obj/effect/shuttle_landmark/engi/dock
	name = "Engineering Shuttle Asteroid"
	landmark_tag = "nav_engi_dock"
	docking_controller = "edock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Mining Shuttle
/datum/shuttle/autodock/ferry/mining
	name = "Mining Shuttle"
	location = 0
	warmup_time = 10
	shuttle_area = /area/shuttle/mining/station
	dock_target = "mining_shuttle"
	waypoint_station = "nav_mining_start"
	waypoint_offsite = "nav_mining_dock"

/obj/effect/shuttle_landmark/mining/start
	name = "Mining Shuttle Exodus"
	landmark_tag = "nav_mining_start"
	docking_controller = "mining_dock_airlock"

/obj/effect/shuttle_landmark/mining/dock
	name = "Mining Shuttle Asteroid"
	landmark_tag = "nav_mining_dock"
	docking_controller = "mining_outpost_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Research Shuttle
/datum/shuttle/autodock/ferry/research_exodus
	name = "Research Shuttle"
	location = 0
	warmup_time = 10
	shuttle_area = /area/shuttle/research/station
	dock_target = "research_shuttle"
	waypoint_station = "nav_research_start"
	waypoint_offsite = "nav_research_dock"

/obj/effect/shuttle_landmark/research_exodus/start
	name = "Research Shuttle Exodus"
	landmark_tag = "nav_research_start"
	docking_controller = "research_dock_airlock"

/obj/effect/shuttle_landmark/research_exodus/dock
	name = "Research Shuttle Asteroid"
	landmark_tag = "nav_research_dock"
	docking_controller = "research_outpost_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// ERT Shuttle (the NT one)
/datum/shuttle/autodock/ferry/specops/ert_exodus
	name = "Phoenix Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/specops/centcom
	dock_target = "specops_shuttle_port"
	waypoint_station = "nav_ert_dock"
	waypoint_offsite = "nav_ert_start"

/obj/effect/shuttle_landmark/ert/start
	name = "Phoenix Base"
	landmark_tag = "nav_ert_start"
	docking_controller = "specops_centcom_dock"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/ert/dock
	name = "ERT Dock"
	landmark_tag = "nav_ert_dock"
	docking_controller = "specops_dock_airlock"
	special_dock_targets = list("Phoenix Shuttle" = "specops_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//Skipjack.
/datum/shuttle/autodock/multi/antag/skipjack_exodus
	name = "Skipjack"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_interim"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/skipjack_station/start
	destination_tags = list(
		"nav_skipjack_start",
		"nav_skipjack_northeast_solars",
		"nav_skipjack_northwest_solars",
		"nav_skipjack_southeast_solars",
		"nav_skipjack_southwest_solars",
		"nav_skipjack_mining_asteroid"
		)

	landmark_transition = "nav_skipjack_interim"
	announcer = "NDV Icarus"
	arrival_message = "Attention, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Attention, your guests are pulling away - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."

/obj/effect/shuttle_landmark/skipjack/start
	name = "Pirate Hideout"
	landmark_tag = "nav_skipjack_start"

/obj/effect/shuttle_landmark/skipjack/interim
	name = "In Transit"
	landmark_tag = "nav_skipjack_interim"

/obj/effect/shuttle_landmark/skipjack/northeast_solars
	name = "North-East Solars"
	landmark_tag = "nav_skipjack_northeast_solars"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/northwest_solars
	name = "North-West Solars"
	landmark_tag = "nav_skipjack_northwest_solars"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/southeast_solars
	name = "South-East Solars"
	landmark_tag = "nav_skipjack_southeast_solars"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/southwest_solars
	name = "South-West Solars"
	landmark_tag = "nav_skipjack_southwest_solars"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/mining_asteroid
	name = "Mining Asteroid"
	landmark_tag = "nav_skipjack_mining_asteroid"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//Nuke Ops shuttle.
/datum/shuttle/autodock/multi/antag/merc_exodus
	name = "Mercenary Shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_interim"
	dock_target = "merc_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/syndicate_station/start
	destination_tags = list(
		"nav_merc_dock",
		"nav_merc_start",
		"nav_merc_northwest",
		"nav_merc_north",
		"nav_merc_northeast",
		"nav_merc_southwest",
		"nav_merc_south",
		"nav_merc_southeast",
		"nav_merc_telecomms",
		"nav_merc_mining_asteroid"
		)

	landmark_transition = "nav_merc_interim"
	announcer = "NDV Icarus"
	arrival_message = "Attention, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Attention, your visitors are on their way out of the system, burning delta-v like it's nothing. Good riddance."

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/interim
	name = "In Transit"
	landmark_tag = "nav_merc_interim"

/obj/effect/shuttle_landmark/merc/dock
	name = "Station Dock"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/northwest
	name = "North-West of the Station"
	landmark_tag = "nav_merc_northwest"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/north
	name = "North of the Station"
	landmark_tag = "nav_merc_north"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/northeast
	name = "North-East of the Station"
	landmark_tag = "nav_merc_northeast"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/southwest
	name = "South-West of the Station"
	landmark_tag = "nav_merc_southwest"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/south
	name = "South of the Station"
	landmark_tag = "nav_merc_south"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/southeast
	name = "South-East of the Station"
	landmark_tag = "nav_merc_southeast"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/telecomms
	name = "Telecommunications"
	landmark_tag = "nav_merc_telecomms"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/mining_asteroid
	name = "Mining Asteroid"
	landmark_tag = "nav_merc_mining_asteroid"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// TCFL Shuttle
/datum/shuttle/autodock/ferry/legion_exodus
	name = "Legion Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/legion/centcom
	dock_target = "Legion Shuttle"
	waypoint_station = "nav_legion_dock"
	waypoint_offsite = "nav_legion_start"

/obj/effect/shuttle_landmark/legion_exodus/start
	name = "Legion Base"
	landmark_tag = "nav_legion_start"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/legion_exodus/dock
	name = "Legion Station"
	landmark_tag = "nav_legion_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Merchant Shuttle

/datum/shuttle/autodock/ferry/merchant/exodus
	name = "Merchant Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant/start
	dock_target = "merchant_shuttle"
	waypoint_station = "nav_merchant_dock"
	waypoint_offsite = "nav_merchant_start"

/obj/effect/shuttle_landmark/merchant/start
	name = "Merchant Shuttle Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station"

/obj/effect/shuttle_landmark/merchant/dock
	name = "Merchant Shuttle Dock"
	landmark_tag = "nav_merchant_dock"
	docking_controller = "merchant_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
