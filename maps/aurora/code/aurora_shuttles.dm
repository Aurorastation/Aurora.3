//Pods. Credit to Chinsky for this macro that saved me from hell.

/datum/shuttle/autodock/ferry/escape_pod/pod
	category = /datum/shuttle/autodock/ferry/escape_pod/pod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	warmup_time = 10

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"
	base_turf = /turf/space/dynamic

#define AURORA_ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod##NUMBER { \
	name = "Escape Pod " + #NUMBER; \
	shuttle_area = /area/shuttle/escape_pod/pod##NUMBER; \
	location = 0; \
	dock_target = "escape_pod_" + #NUMBER; \
	arming_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	waypoint_station = "escape_pod_"+ #NUMBER +"_start"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_interim"; \
	waypoint_offsite = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_start"; \
	docking_controller = "escape_pod_" + #NUMBER +"_berth"; \
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
	warmup_time = 10
	shuttle_area = /area/shuttle/escape
	dock_target = "escape_shuttle"
	waypoint_station = "nav_emergency_dock"
	landmark_transition = "nav_emergency_interim"
	waypoint_offsite = "nav_emergency_start"

/obj/effect/shuttle_landmark/emergency/start
	name = "Escape Shuttle Centcom Dock"
	landmark_tag = "nav_emergency_start"
	docking_controller = "centcom_dock"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/evac

/obj/effect/shuttle_landmark/emergency/interim
	name = "In Transit"
	landmark_tag = "nav_emergency_interim"
	base_turf = /turf/space/transit/south

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
	shuttle_area = /area/shuttle/arrival
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
	base_area = /area/centcom/spawning

/obj/effect/shuttle_landmark/arrival/interim
	name = "In Transit"
	landmark_tag = "nav_arrival_interim"
	base_turf = /turf/space/transit/west

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
	base_area = /area/centcom

/obj/effect/shuttle_landmark/supply/dock
	name = "Supply Shuttle Dock"
	landmark_tag = "nav_supply_dock"
	docking_controller = "cargo_bay"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Merchant Shuttle //-//

/datum/shuttle/autodock/ferry/merchant_aurora
	name = "Merchant Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant
	move_time = 20
	dock_target = "merchant_shuttle"
	waypoint_station = "nav_merchant_dock"
	landmark_transition = "nav_merchant_interim"
	waypoint_offsite = "nav_merchant_start"

/obj/effect/shuttle_landmark/merchant/start
	name = "Merchant Shuttle Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/merchant/interim
	name = "In Transit"
	landmark_tag = "nav_merchant_interim"
	base_turf = /turf/space/transit/west

/obj/effect/shuttle_landmark/merchant/dock
	name = "Merchant Shuttle Dock"
	landmark_tag = "nav_merchant_dock"
	docking_controller = "merchant_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Admin Corvette //-//

/datum/shuttle/autodock/multi/admin
	name = "Crescent Shuttle"
	current_location = "nav_admin_start"
	warmup_time = 10
	shuttle_area = /area/shuttle/administration
	dock_target = "admin_shuttle"
	destination_tags = list(
		"nav_admin_start",
		"nav_admin_green",
		"nav_admin_command"
		)

/obj/effect/shuttle_landmark/admin/start
	name = "Corvette Hangar"
	landmark_tag = "nav_admin_start"
	docking_controller = "admin_shuttle_bay"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/effect/shuttle_landmark/admin/green
	name = "Emergency Services Dock"
	landmark_tag = "nav_admin_green"
	docking_controller = "green_dock_north"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/admin/command
	name = "Command Surface Dock"
	landmark_tag = "nav_admin_command"
	docking_controller = "admin_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// CCIA Shuttle //-//

/datum/shuttle/autodock/ferry/autoreturn/ccia
	name = "Agent Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/transport1
	dock_target = "centcom_shuttle"
	waypoint_station = "nav_ccia_dock"
	waypoint_offsite = "nav_ccia_start"
	category = /datum/shuttle/autodock/ferry/autoreturn

/obj/effect/shuttle_landmark/ccia/start
	name = "Agent Shuttle Base"
	landmark_tag = "nav_ccia_start"
	docking_controller = "centcom_shuttle_bay"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/ferry

/obj/effect/shuttle_landmark/ccia/dock
	name = "Agent Shuttle Dock"
	landmark_tag = "nav_ccia_dock"
	docking_controller = "centcom_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// ERT Shuttle (the NT one) //-//

/datum/shuttle/autodock/ferry/specops/ert_aurora
	name = "Phoenix Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/specops
	dock_target = "specops_shuttle_port"
	waypoint_station = "nav_ert_dock"
	waypoint_offsite = "nav_ert_start"

/obj/effect/shuttle_landmark/ert/start
	name = "Phoenix Base"
	landmark_tag = "nav_ert_start"
	docking_controller = "specops_centcom_dock"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/specops

/obj/effect/shuttle_landmark/ert/dock
	name = "ERT Dock"
	landmark_tag = "nav_ert_dock"
	docking_controller = "specops_dock_airlock"
	special_dock_targets = list("Phoenix Shuttle" = "specops_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Burglar Shuttle //-//

/datum/shuttle/autodock/multi/antag/burglar_aurora
	name = "Burglar Pod"
	current_location = "nav_burglar_start"
	landmark_transition = "nav_burglar_interim"
	dock_target = "burglar_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/burglar
	destination_tags = list(
		"nav_burglar_start",
		"nav_burglar_surface",
		"nav_burglar_under",
		"nav_burglar_caverns",
		"nav_burglar_blue"
		)

	announcer = "NDV Icarus"
	arrival_message = "Attention, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Attention, your guests are pulling away - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."

/obj/effect/shuttle_landmark/burglar/start
	name = "Hideout"
	landmark_tag = "nav_burglar_start"
	docking_controller = "burglar_hideout"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/antag/burglar

/obj/effect/shuttle_landmark/burglar/interim
	name = "In Transit"
	landmark_tag = "nav_burglar_interim"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/burglar/surface
	name = "Exposed Hull, Surface Aft of Cargo"
	landmark_tag = "nav_burglar_surface"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/burglar/under
	name = "Under the Station, By Radiators"
	landmark_tag = "nav_burglar_under"
	base_turf = /turf/space
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/burglar/caverns
	name = "Caverns, Fore of Mining"
	landmark_tag = "nav_burglar_caverns"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/burglar/blue
	name = "Blue Dock"
	landmark_tag = "nav_burglar_blue"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	docking_controller = "distress_shuttle_dock"

//-// Raider Skipjack //-//

/datum/shuttle/autodock/multi/antag/skipjack_aurora
	name = "Skipjack"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_interim"
	dock_target = "raider_east_control"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/skipjack
	destination_tags = list(
		"nav_skipjack_start",
		"nav_skipjack_surface",
		"nav_skipjack_under",
		"nav_skipjack_caverns",
		"nav_skipjack_interstitial",
		"nav_skipjack_toxins"
		)

	landmark_transition = "nav_skipjack_interim"
	announcer = "NDV Icarus"
	arrival_message = "Attention, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Attention, your guests are pulling away - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."

/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Hideout"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "pirate_hideout"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/skipjack/interim
	name = "In Transit"
	landmark_tag = "nav_skipjack_interim"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/skipjack/surface
	name = "Surface, Aft of Cargo"
	landmark_tag = "nav_skipjack_surface"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/under
	name = "Under the Station, By Radiators"
	landmark_tag = "nav_skipjack_under"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_turf = /turf/space/dynamic

/obj/effect/shuttle_landmark/skipjack/caverns
	name = "Caverns, Aft of Mining"
	landmark_tag = "nav_skipjack_caverns"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/interstitial
	name = "Interstitial, Exposed Hull by Medical"
	landmark_tag = "nav_skipjack_interstitial"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack/toxins
	name = "Caverns, By Bombrange"
	landmark_tag = "nav_skipjack_toxins"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Mercenary Shuttle //-//

/datum/shuttle/autodock/multi/antag/merc_aurora
	name = "Mercenary Shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_interim"
	dock_target = "merc_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/mercenary
	destination_tags = list(
		"nav_merc_dock",
		"nav_merc_start",
		"nav_merc_surface",
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
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/merc/interim
	name = "In Transit"
	landmark_tag = "nav_merc_interim"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/merc/dock
	name = "Yellow Dock"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/surface
	name = "Surface, Aft of Command"
	landmark_tag = "nav_merc_surface"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc/under
	name = "Under the Station, At Radiators"
	landmark_tag = "nav_merc_under"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_turf = /turf/space/dynamic

/obj/effect/shuttle_landmark/merc/caverns
	name = "Caverns, Fore of Security"
	landmark_tag = "nav_merc_caverns"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Merc Elite Shuttle //-//

/datum/shuttle/autodock/multi/merc_aurora_elite
	name = "Merc Elite"
	current_location = "nav_mercelite_start"
	warmup_time = 10
	shuttle_area = /area/shuttle/syndicate_elite
	dock_target = "elite_shuttle_starboard"
	destination_tags = list(
		"nav_mercelite_start",
		"nav_mercelite_command",
		"nav_mercelite_merchant",
		"nav_mercelite_yellow",
		"nav_mercelite_green"
		)

/obj/effect/shuttle_landmark/merc_elite/start
	name = "Shuttle Hangar"
	landmark_tag = "nav_mercelite_start"
	docking_controller = "elite_shuttle_origin"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/antag/mercenary

/obj/effect/shuttle_landmark/merc_elite/command
	name = "Command Surface - Maintenance"
	landmark_tag = "nav_mercelite_command"
	docking_controller = "command_surface_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc_elite/merchant
	name = "Merchant Dock"
	landmark_tag = "nav_mercelite_merchant"
	docking_controller = "merchant_shuttle_dock"
	special_dock_targets = list("Merc Elite" = "elite_shuttle_port")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc_elite/yellow
	name = "Yellow Dock"
	landmark_tag = "nav_mercelite_yellow"
	docking_controller = "nuke_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc_elite/green
	name = "Emergency Services Dock"
	landmark_tag = "nav_mercelite_green"
	docking_controller = "green_dock_west"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// TCFL Dropship //-//

/datum/shuttle/autodock/multi/legion
	name = "Legion Shuttle"
	current_location = "nav_legion_start"
	warmup_time = 10
	move_time = 75
	ceiling_type = /turf/simulated/shuttle_roof/legion
	shuttle_area = /area/shuttle/legion
	dock_target = "legion_shuttle"
	landmark_transition = "nav_legion_interim"
	destination_tags = list(
		"nav_legion_start",
		"nav_legion_green",
		"nav_legion_merchant",
		"nav_legion_medical"
		)

/obj/effect/shuttle_landmark/legion/start
	name = "BLV The Tower"
	landmark_tag = "nav_legion_start"
	docking_controller = "legion_hangar"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/legion/hangar5

/obj/effect/shuttle_landmark/legion/interim
	name = "In Transit"
	landmark_tag = "nav_legion_interim"
	base_turf = /turf/space/transit/west

/obj/effect/shuttle_landmark/legion/green
	name = "Emergency Services Dock (Main Entrypoint)"
	landmark_tag = "nav_legion_green"
	docking_controller = "legion_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/legion/merchant
	name = "Merchant Dock"
	landmark_tag = "nav_legion_merchant"
	docking_controller = "merchant_shuttle_dock"
	special_dock_targets = list("Legion Shuttle" = "legion_shuttle_aft_airlock")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/legion/medical
	name = "External Airlock by Medical"
	landmark_tag = "nav_legion_medical"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Research Shuttle //-//

/datum/shuttle/autodock/multi/research_aurora
	name = "Research Shuttle"
	current_location = "nav_research_dock"
	warmup_time = 10
	move_time = 60
	shuttle_area = /area/shuttle/research
	dock_target = "science_shuttle"
	landmark_transition = "nav_research_interim"
	destination_tags = list(
		"nav_research_dock",
		"nav_research_yellow",
		"nav_research_away"
		)

/obj/effect/shuttle_landmark/research/start
	name = "Research Dock"
	landmark_tag = "nav_research_dock"
	docking_controller = "science_bridge"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/research/yellow
	name = "Yellow Dock"
	landmark_tag = "nav_research_yellow"
	docking_controller = "yellow_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/research/interim
	name = "In Transit"
	landmark_tag = "nav_research_interim"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/research/dock
	name = "Away Site"
	landmark_tag = "nav_research_away"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Distress Team Shuttle //-//

/datum/shuttle/autodock/multi/distress
	name = "Distress Shuttle"
	current_location = "nav_distress_away"
	warmup_time = 10
	move_time = 45
	dock_target = "distress_shuttle_aft"
	shuttle_area = /area/shuttle/distress
	landmark_transition = "nav_distress_interim"
	destination_tags = list(
		"nav_distress_away",
		"nav_distress_green",
		"nav_distress_blue"
		)

/obj/effect/shuttle_landmark/distress/start
	name = "Distress Preparation Wing"
	landmark_tag = "nav_distress_away"
	docking_controller = "distress_shuttle_origin"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/distress_prep

/obj/effect/shuttle_landmark/distress/interim
	name = "In Transit"
	landmark_tag = "nav_distress_interim"
	base_turf = /turf/space/transit/west

/obj/effect/shuttle_landmark/distress/green
	name = "Emergency Services Dock"
	landmark_tag = "nav_distress_green"
	docking_controller = "green_dock_west"
	special_dock_targets = list("Distress Shuttle" = "distress_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/distress/blue
	name = "Blue Dock"
	landmark_tag = "nav_distress_blue"
	docking_controller = "distress_shuttle_dock"
	special_dock_targets = list("Distress Shuttle" = "distress_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET
