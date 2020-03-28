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

#define CREATE_ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod##NUMBER { \
	name = "Escape Pod " + #NUMBER; \
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
	landmark_tag = "escape_pod_"+ #NUMBER +"_interim"; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_out"; \
}

CREATE_ESCAPE_POD(1)
CREATE_ESCAPE_POD(2)
CREATE_ESCAPE_POD(3)

/datum/shuttle/autodock/ferry/emergency
	name = "Escape"
	location = 1
	warmup_time = 25
	shuttle_area = /area/shuttle/escape/centcom
	move_time = 20
	dock_target = "centcom_dock"

// Merchant Shuttle
/datum/shuttle/autodock/ferry/merchant
	name = "Merchant Shuttle"
	location = 1
	warmup_time = 5
	shuttle_area = /area/shuttle/merchant/start
	move_time = 20
	dock_target = "merchant_shuttle"

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

// Admin Shuttle
/datum/shuttle/autodock/ferry/admin
	name = "Crescent Shuttle"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	dock_target = "admin_shuttle"
	waypoint_station = "nav_admin_dock"
	waypoint_offsite = "nav_admin_start"

/obj/effect/shuttle_landmark/admin/start
	name = "Crescent Shuttle Base"
	landmark_tag = "nav_admin_start"
	docking_controller = "admin_shuttle_bay"

/obj/effect/shuttle_landmark/admin/dock
	name = "Crescent Shuttle Dock"
	landmark_tag = "nav_admin_dock"
	docking_controller = "admin_shuttle_dock_airlock"

// CCIA Shuttle
/datum/shuttle/autodock/ferry/autoreturn/ccia
	name = "Agent Shuttle"
	location = 1
	warmup_time = 10
	dock_target = "centcom_shuttle"
	waypoint_station = "nav_ccia_dock"
	waypoint_offsite = "nav_ccia_start"

/obj/effect/shuttle_landmark/ccia/start
	name = "Agent Shuttle Base"
	landmark_tag = "nav_ccia_start"
	docking_controller = "centcom_shuttle_bay"

/obj/effect/shuttle_landmark/ccia/dock
	name = "Agent Shuttle Dock"
	landmark_tag = "nav_ccia_dock"
	docking_controller = "centcom_shuttle_dock_airlock"

// ERT Shuttle (the NT one)
/datum/shuttle/autodock/ferry/specops/ert
	name = "Phoenix Shuttle"
	location = 0
	warmup_time = 10
	dock_target = "specops_shuttle_port"
	waypoint_station = "nav_ert_dock"
	waypoint_offsite = "specops_centcom_dock"

/obj/effect/shuttle_landmark/ert/start
	name = "Phoenix Base"
	landmark_tag = "nav_ert_start"
	docking_controller = "specops_centcom_dock"

/obj/effect/shuttle_landmark/ert/dock
	name = "ERT Dock"
	landmark_tag = "nav_ert_dock"
	docking_controller = "specops_dock_airlock"

//Skipjack.
/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	warmup_time = 15
	shuttle_area = /area/skipjack_station/start

	announcer = "NDV Icarus"
	arrival_message = "Attention, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Attention, your guests are pulling away - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."

//TODOMATT: Shuttle landmarks for merc/heist/maybe ninja

//Nuke Ops shuttle.
/datum/shuttle/autodock/multi/antag/merc
	name = "Mercenary Shuttle"
	current_location = "nav_merc_start"
	dock_target = "merc_shuttle"
	warmup_time = 15
	shuttle_area = /area/syndicate_station/start
	destination_tags = list(
		"nav_merc_dock",
		"nav_merc_start" //add as needed
		)

	landmark_transition = "nav_merc_interim"
	announcer = "NDV Icarus"
	arrival_message = "Attention, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Attention, your visitors are on their way out of the system, burning delta-v like it's nothing. Good riddance."

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_shuttle"

/obj/effect/shuttle_landmark/merc/interim
	name = "In Transit"
	landmark_tag = "nav_merc_interim"

/obj/effect/shuttle_landmark/merc/dock
	name = "Station Dock"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"

// Tau Ceti Foreign Legion
/datum/shuttle/autodock/ferry/legion
	name = "Legion Shuttle"
	location = 1
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/legion/centcom
	dock_target = "legion_shuttle"
	waypoint_offsite = "nav_legion_start"
	landmark_transition = "nav_legion_interim"
	waypoint_station = "nav_legion_dock"

/obj/effect/shuttle_landmark/legion/start
	name = "Legion Base"
	landmark_tag = "nav_legion_start"
	docking_controller = "legion_shuttle"

/obj/effect/shuttle_landmark/legion/interim
	name = "In Transit"
	landmark_tag = "nav_legion_interim"

/obj/effect/shuttle_landmark/legion/dock
	name = "Legion Dock"
	landmark_tag = "nav_legion_dock"


/datum/shuttle/autodock/ferry/research
	name = "Research Shuttle"
	location = 0
	warmup_time = 10
	move_time = 85
	waypoint_station = "nav_research_dock"
	landmark_transition = "nav_research_interim"
	waypoint_offsite = "nav_research_away"

/obj/effect/shuttle_landmark/research/start
	name = "Research Dock"
	landmark_tag = "nav_research_dock"
	docking_controller = "legion_shuttle"

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
	waypoint_offsite = "nav_distress_away"
	landmark_transition = "nav_distress_interim"
	waypoint_station = "nav_distress_dock"

/obj/effect/shuttle_landmark/distress/start
	name = "Distress Base"
	landmark_tag = "nav_distress_away"
	docking_controller = "distress_shuttle_aft"

/obj/effect/shuttle_landmark/distress/interim
	name = "In Transit"
	landmark_tag = "nav_distress_interim"

/obj/effect/shuttle_landmark/distress/dock
	name = "Distress Dock"
	landmark_tag = "nav_distress_dock"
	docking_controller = "distress_shuttle_fore"
