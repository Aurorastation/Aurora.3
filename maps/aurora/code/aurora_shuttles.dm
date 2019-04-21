/datum/map/aurora/setup_shuttles()
	var/datum/shuttle/ferry/shuttle
	var/list/shuttles = shuttle_controller.shuttles

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod1/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod1/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod1/transit)
	shuttle.docking_controller_tag = "escape_pod_1"
	shuttle.dock_target_station = "escape_pod_1_berth"
	//shuttle.dock_target_offsite = "escape_pod_1_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 1"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod2/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod2/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod2/transit)
	shuttle.docking_controller_tag = "escape_pod_2"
	shuttle.dock_target_station = "escape_pod_2_berth"
	//shuttle.dock_target_offsite = "escape_pod_2_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 2"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod3/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod3/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod3/transit)
	shuttle.docking_controller_tag = "escape_pod_3"
	shuttle.dock_target_station = "escape_pod_3_berth"
	//shuttle.dock_target_offsite = "escape_pod_3_recovery"
	shuttle.transit_direction = EAST
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 3"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	//give the emergency shuttle controller it's shuttles
	emergency_shuttle.escape_pods = list(
		shuttles["Escape Pod 1"],
		shuttles["Escape Pod 2"],
		shuttles["Escape Pod 3"]
	)

	// Admin shuttles.
	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttle.docking_controller_tag = "centcom_shuttle"
	shuttle.dock_target_station = "centcom_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "centcom_shuttle_bay"
	shuttles["Centcom"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10	//want some warmup time so people can cancel.
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttle.docking_controller_tag = "admin_shuttle"
	shuttle.dock_target_station = "admin_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "admin_shuttle_bay"
	shuttles["Administration"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	// Merchant Shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/merchant_ship/start)
	shuttle.area_station = locate(/area/merchant_ship/docked)
	shuttle.docking_controller_tag = "merchant_shuttle"
	shuttle.dock_target_station = "merchant_shuttle_dock"
	shuttle.dock_target_offsite = "merchant_station"
	shuttles["Merchant"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	// ERT Shuttle
	var/datum/shuttle/ferry/multidock/specops/ERT = new()
	ERT.location = 0
	ERT.warmup_time = 10
	ERT.area_offsite = locate(/area/shuttle/specops/station)	//centcom is the home station, the Exodus is offsite
	ERT.area_station = locate(/area/shuttle/specops/centcom)
	ERT.docking_controller_tag = "specops_shuttle_port"
	ERT.docking_controller_tag_station = "specops_shuttle_port"
	ERT.docking_controller_tag_offsite = "specops_shuttle_fore"
	ERT.dock_target_station = "specops_centcom_dock"
	ERT.dock_target_offsite = "specops_dock_airlock"
	shuttles["Special Operations"] = ERT
	START_PROCESSING(shuttle_controller, ERT)

	//Skipjack.
	var/datum/shuttle/multi_shuttle/VS = new/datum/shuttle/multi_shuttle()
	VS.origin = locate(/area/skipjack_station/start)

	VS.destinations = list(
		"Surface of the station" = locate(/area/skipjack_station/surface),
		"Under the station" = locate(/area/skipjack_station/under),
		"Above the station" = locate(/area/skipjack_station/above),
		"Mining caverns" = locate(/area/skipjack_station/cavern)
	)

	VS.announcer = "NDV Icarus"
	VS.arrival_message = "Attention, [station_short], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	VS.departure_message = "Your guests are pulling away, [station_short] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	VS.interim = locate(/area/skipjack_station/transit)

	VS.warmup_time = 0
	shuttles["Skipjack"] = VS

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = locate(/area/syndicate_station/start)
	MS.start_location = "Mercenary Base"

	MS.destinations = list(
		"Surface of the station" = locate(/area/syndicate_station/surface),
		"Above the station" = locate(/area/syndicate_station/above),
		"Under the station" = locate(/area/syndicate_station/under),
		"Mining caverns" = locate(/area/syndicate_station/caverns),
		"Arrivals dock" = locate(/area/syndicate_station/arrivals_dock)
	)

	MS.docking_controller_tag = "merc_shuttle"
	MS.destination_dock_targets = list(
		"Mercenary Base" = "merc_base",
		"Arrivals dock" = "nuke_shuttle_dock_airlock"
	)

	MS.announcer = "NDV Icarus"
	MS.arrival_message = "Attention, [station_short], you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	MS.departure_message = "Your visitors are on their way out of the system, [station_short], burning delta-v like it's nothing. Good riddance."
	MS.interim = locate(/area/syndicate_station/transit)

	MS.warmup_time = 0
	shuttles["Mercenary"] = MS

	// Tau Ceti Foreign Legion

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/legion/centcom)
	shuttle.area_station = locate(/area/shuttle/legion/station)
	shuttles["Tau Ceti Foreign Legion"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	//Away Site shuttle.

	shuttle = new()
	shuttle.location = 0
	shuttle.warmup_time = 10
	shuttle.area_station = locate(/area/shuttle/research_shuttle)
	shuttle.area_offsite = locate(/area/shuttle/research_shuttle/away)
	shuttle.docking_controller_tag = "science_shuttle"
	shuttle.dock_target_station = "science_bridge"
	shuttles["Research Away Shuttle"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)