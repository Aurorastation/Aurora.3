/datum/map/aurora/setup_shuttles()
	var/datum/shuttle/ferry/shuttle
	var/list/shuttles = shuttle_controller.shuttles

	var/list/areas_p = list(
		list(
			/area/shuttle/escape_pod1/station, /area/shuttle/escape_pod1/centcom,
			/area/shuttle/escape_pod1/transit, /area/shuttle/escape_pod1/centcom/antag,
			/area/shuttle/escape_pod1/centcom/space, /area/shuttle/escape_pod1/crashed
		),
		list(
			/area/shuttle/escape_pod2/station, /area/shuttle/escape_pod2/centcom,
			/area/shuttle/escape_pod2/transit, /area/shuttle/escape_pod2/centcom/antag,
			/area/shuttle/escape_pod2/centcom/space, /area/shuttle/escape_pod2/crashed
		),
		list(
			/area/shuttle/escape_pod3/station, /area/shuttle/escape_pod3/centcom,
			/area/shuttle/escape_pod3/transit, /area/shuttle/escape_pod3/centcom/antag,
			/area/shuttle/escape_pod3/centcom/space, /area/shuttle/escape_pod3/crashed
		),
		list(
			/area/shuttle/escape_pod4/station, /area/shuttle/escape_pod4/centcom,
			/area/shuttle/escape_pod4/transit, /area/shuttle/escape_pod4/centcom/antag,
			/area/shuttle/escape_pod4/centcom/space, /area/shuttle/escape_pod4/crashed
		),
		list(
			/area/shuttle/escape_pod5/station, /area/shuttle/escape_pod5/centcom,
			/area/shuttle/escape_pod5/transit, /area/shuttle/escape_pod5/centcom/antag,
			/area/shuttle/escape_pod5/centcom/space, /area/shuttle/escape_pod5/crashed
		),
		list(
			/area/shuttle/escape_pod6/station, /area/shuttle/escape_pod6/centcom,
			/area/shuttle/escape_pod6/transit, /area/shuttle/escape_pod6/centcom/antag,
			/area/shuttle/escape_pod6/centcom/space, /area/shuttle/escape_pod6/crashed
		)
	)

	for(var/x = 1, x <= areas_p.len, x++)
		var/datum/shuttle/ferry/escape_pod/pod
		pod = new/datum/shuttle/ferry/escape_pod()
		pod.area_station = locate(areas_p[x][1])
		pod.area_offsite = locate(areas_p[x][2])
		pod.area_transition = locate(areas_p[x][3])
		pod.destinations[1] = areas_p[x][2]
		pod.destinations[2] = areas_p[x][5]
		pod.destinations[3] = areas_p[x][4]
		pod.destinations[4] = areas_p[x][6]
		pod.docking_controller_tag = "escape_pod_[x]"
		pod.dock_target_station = "escape_pod_[x]_berth"
		//pod.dock_target_offsite = "escape_pod_[x]_recovery"
		pod.transit_direction = NORTH
		pod.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
		shuttles["Escape Pod [x]"] = pod
		START_PROCESSING(shuttle_controller, pod)

	/*
	pod = new/datum/shuttle/ferry/escape_pod()
	pod.area_station = locate(/area/shuttle/escape_pod2/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod2/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod2/transit)
	pod.crashed_area = /area/shuttle/escape_pod2/crashed
	pod.docking_controller_tag = "escape_pod_2"
	pod.dock_target_station = "escape_pod_2_berth"
	//pod.dock_target_offsite = "escape_pod_2_recovery"
	pod.transit_direction = NORTH
	pod.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 2"] = pod
	START_PROCESSING(shuttle_controller, pod)

	pod = new/datum/shuttle/ferry/escape_pod()
	pod.area_station = locate(/area/shuttle/escape_pod3/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod3/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod3/transit)
	pod.crashed_area = /area/shuttle/escape_pod3/crashed
	pod.docking_controller_tag = "escape_pod_3"
	pod.dock_target_station = "escape_pod_3_berth"
	//pod.dock_target_offsite = "escape_pod_3_recovery"
	pod.transit_direction = NORTH
	pod.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 3"] = pod
	START_PROCESSING(shuttle_controller, pod)

	pod = new/datum/shuttle/ferry/escape_pod()
	pod.area_station = locate(/area/shuttle/escape_pod4/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod4/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod4/transit)
	pod.crashed_area = /area/shuttle/escape_pod4/crashed
	pod.docking_controller_tag = "escape_pod_4"
	pod.dock_target_station = "escape_pod_4_berth"
	//pod.dock_target_offsite = "escape_pod_4_recovery"
	pod.transit_direction = NORTH
	pod.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 4"] = pod
	START_PROCESSING(shuttle_controller, pod)

	pod = new/datum/shuttle/ferry/escape_pod()
	pod.area_station = locate(/area/shuttle/escape_pod5/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod5/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod5/transit)
	pod.crashed_area = /area/shuttle/escape_pod5/crashed
	pod.docking_controller_tag = "escape_pod_5"
	pod.dock_target_station = "escape_pod_5_berth"
	//pod.dock_target_offsite = "escape_pod_5_recovery"
	pod.transit_direction = NORTH
	pod.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 5"] = pod
	START_PROCESSING(shuttle_controller, pod)

	pod = new/datum/shuttle/ferry/escape_pod()
	pod.area_station = locate(/area/shuttle/escape_pod6/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod6/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod6/transit)
	pod.crashed_area = /area/shuttle/escape_pod6/crashed
	pod.docking_controller_tag = "escape_pod_6"
	pod.dock_target_station = "escape_pod_6_berth"
	//pod.dock_target_offsite = "escape_pod_6_recovery"
	pod.transit_direction = NORTH
	pod.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 6"] = pod
	START_PROCESSING(shuttle_controller, pod)
	*/
	//give the emergency shuttle controller it's shuttles
	emergency_shuttle.escape_pods = list(
		shuttles["Escape Pod 1"],
		shuttles["Escape Pod 2"],
		shuttles["Escape Pod 3"],
		shuttles["Escape Pod 4"],
		shuttles["Escape Pod 5"],
		shuttles["Escape Pod 6"]
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
	shuttle.area_station = locate(/area/shuttle/legion/docked)
	shuttle.area_transition = locate(/area/shuttle/legion/transit)
	shuttle.transit_direction = EAST
	shuttle.move_time = 75
	shuttle.docking_controller_tag = "legion_shuttle"
	shuttle.dock_target_station = "legion_shuttle_dock"
	shuttle.dock_target_offsite = "legion_hangar"
	shuttles["Tau Ceti Foreign Legion"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	//Away Site shuttle.

	shuttle = new()
	shuttle.location = 0
	shuttle.warmup_time = 10
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.area_offsite = locate(/area/shuttle/research/away)
	shuttle.docking_controller_tag = "science_shuttle"
	shuttle.dock_target_station = "science_bridge"
	shuttles["Research"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)