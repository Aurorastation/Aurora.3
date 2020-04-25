//Pods. Credit to Chinsky for this macro that saved me from hell.

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

#define AURORA_ESCAPE_POD(NUMBER) \
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

AURORA_ESCAPE_POD(1)
AURORA_ESCAPE_POD(2)
AURORA_ESCAPE_POD(3)

//-// Transfer Shuttle //-//

/datum/shuttle/autodock/ferry/emergency/aurora
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

//-// Arrival Shuttle //-//

/datum/shuttle/autodock/ferry/arrival/aurora
	name = "Arrival Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/arrival/centcom
	move_time = 60
	dock_target = "arrival_shuttle"
	waypoint_station = "nav_arrival_dock"
	landmark_transition = "nav_arrival_interim"
	waypoint_offsite = "nav_arrival_start"

/obj/effect/shuttle_landmark/arrival/start
	name = "Arrival Shuttle Centcom Dock"
	landmark_tag = "nav_arrival_start"
	docking_controller = "centcom_setup"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/arrival/interim
	name = "In Transit"
	landmark_tag = "nav_arrival_interim"

/obj/effect/shuttle_landmark/arrival/dock
	name = "Arrival Shuttle Dock"
	landmark_tag = "nav_arrival_dock"
	docking_controller = "arrival_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Supply Shuttle //-//

/datum/shuttle/autodock/ferry/supply/aurora
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


// Merchant Shuttle

/datum/shuttle/autodock/ferry/merchant_aurora
	name = "Merchant Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant/start
	move_time = 20
	dock_target = "merchant_shuttle"
	waypoint_station = "nav_merchant_dock"
	landmark_transition = "nav_merchant_interim"
	waypoint_offsite = "nav_merchant_start"

/obj/effect/shuttle_landmark/merchant/start
	name = "Merchant Shuttle Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station"

/obj/effect/shuttle_landmark/merchant/interim
	name = "In Transit"
	landmark_tag = "nav_merchant_interim"

/obj/effect/shuttle_landmark/merchant/dock
	name = "Merchant Shuttle Dock"
	landmark_tag = "nav_merchant_dock"
	docking_controller = "merchant_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Admin Shuttle
/datum/shuttle/autodock/ferry/admin
	name = "Crescent Shuttle"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	ceiling_type = /turf/simulated/shuttle_roof/dark
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

// ERT Shuttle (the NT one)
/datum/shuttle/autodock/ferry/specops/ert_aurora
	name = "Phoenix Shuttle"
	location = 1
	warmup_time = 10
	ceiling_type = /turf/simulated/shuttle_roof/dark
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
/datum/shuttle/autodock/multi/antag/skipjack_aurora
	name = "Skipjack"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_interim"
	warmup_time = 10
	move_time = 75
	ceiling_type = /turf/simulated/shuttle_roof/dark
	shuttle_area = /area/skipjack_station/start
	destination_tags = list(
		"nav_skipjack_start",
		"nav_skipjack_surface",
		"nav_skipjack_above",
		"nav_skipjack_under",
		"nav_skipjack_caverns",
		"nav_skipjack_pool"
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

/obj/effect/shuttle_landmark/skipjack/surface
	name = "Surface Aft of Cargo"
	landmark_tag = "nav_skipjack_surface"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/above
	name = "Above the station by Telecomms"
	landmark_tag = "nav_skipjack_above"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/under
	name = "Under the Station"
	landmark_tag = "nav_skipjack_under"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/caverns
	name = "Caverns by Mining"
	landmark_tag = "nav_skipjack_caverns"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/pool
	name = "Above the Pool"
	landmark_tag = "nav_skipjack_pool"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//Nuke Ops shuttle.
/datum/shuttle/autodock/multi/antag/merc_aurora
	name = "Mercenary Shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_interim"
	dock_target = "merc_shuttle"
	warmup_time = 10
	move_time = 75
	ceiling_type = /turf/simulated/shuttle_roof/dark
	shuttle_area = /area/syndicate_station/start
	destination_tags = list(
		"nav_merc_dock",
		"nav_merc_start",
		"nav_merc_surface",
		"nav_merc_above",
		"nav_merc_under",
		"nav_merc_caverns"
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

/obj/effect/shuttle_landmark/merc/surface
	name = "Surface by Command"
	landmark_tag = "nav_merc_surface"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/above
	name = "Above the Station"
	landmark_tag = "nav_merc_above"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/under
	name = "Under the Station"
	landmark_tag = "nav_merc_under"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/caverns
	name = "Caverns Fore of the Station"
	landmark_tag = "nav_merc_caverns"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Tau Ceti Foreign Legion
/datum/shuttle/autodock/ferry/legion
	name = "Legion Shuttle"
	location = 1
	warmup_time = 10
	move_time = 75
	ceiling_type = /turf/simulated/shuttle_roof/legion
	shuttle_area = /area/shuttle/legion/centcom
	dock_target = "legion_shuttle"
	waypoint_offsite = "nav_legion_start"
	landmark_transition = "nav_legion_interim"
	waypoint_station = "nav_legion_dock"

/obj/effect/shuttle_landmark/legion/start
	name = "Legion Base"
	landmark_tag = "nav_legion_start"
	docking_controller = "legion_hangar"
	base_turf = /turf/unsimulated/floor/plating

/obj/effect/shuttle_landmark/legion/interim
	name = "In Transit"
	landmark_tag = "nav_legion_interim"

/obj/effect/shuttle_landmark/legion/dock
	name = "Legion Dock"
	landmark_tag = "nav_legion_dock"
	docking_controller = "legion_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/datum/shuttle/autodock/ferry/research_aurora
	name = "Research Shuttle"
	location = 0
	warmup_time = 10
	move_time = 85
	shuttle_area = /area/shuttle/research/station
	dock_target = "science_shuttle"
	waypoint_station = "nav_research_dock"
	landmark_transition = "nav_research_interim"
	waypoint_offsite = "nav_research_away"

/obj/effect/shuttle_landmark/research/start
	name = "Research Dock"
	landmark_tag = "nav_research_dock"
	docking_controller = "science_bridge"
	base_turf = /turf/unsimulated/floor/asteroid/ash

/obj/effect/shuttle_landmark/research/interim
	name = "In Transit"
	landmark_tag = "nav_research_interim"

/obj/effect/shuttle_landmark/research/dock
	name = "Away Site"
	landmark_tag = "nav_research_away"

// Distress Team Shuttle

/datum/shuttle/autodock/ferry/distress
	name = "Distress Shuttle"
	location = 1
	warmup_time = 10
	move_time = 45
	dock_target = "distress_shuttle_aft"
	ceiling_type = /turf/simulated/shuttle_roof/dark
	shuttle_area = /area/shuttle/distress/centcom
	waypoint_offsite = "nav_distress_away"
	landmark_transition = "nav_distress_interim"
	waypoint_station = "nav_distress_dock"

/obj/effect/shuttle_landmark/distress/start
	name = "Distress Base"
	landmark_tag = "nav_distress_away"
	docking_controller = "distress_shuttle_origin"

/obj/effect/shuttle_landmark/distress/interim
	name = "In Transit"
	landmark_tag = "nav_distress_interim"

/obj/effect/shuttle_landmark/distress/dock
	name = "Distress Dock"
	landmark_tag = "nav_distress_dock"
	docking_controller = "distress_shuttle_dock"
	special_dock_targets = list("Distress Shuttle" = "distress_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET
