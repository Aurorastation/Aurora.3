/datum/map/aurora/setup_shuttles()
	var/datum/shuttle/ferry/shuttle
	var/list/shuttles = shuttle_controller.shuttles
	var/list/settings = list()

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
		settings = list(
					1, 10, locate(areas_p[x][1]), locate(areas_p[x][5]), locate(areas_p[x][3]), NORTH, SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60),
					locate(areas_p[x][1]),	null, "escape_pod_[x]", "escape_pod_[x]_berth", null,
					areas_p[x][2], areas_p[x][5], areas_p[x][4], areas_p[x][6]
		)
		pod.init_shuttle(settings)
		shuttles["Escape Pod [x]"] = pod
		START_PROCESSING(shuttle_controller, pod)

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
	settings = list(
					1, 10, locate(/area/shuttle/transport1/centcom), locate(/area/shuttle/transport1/station), null, EAST, 0,
					locate(/area/shuttle/transport1/centcom),	/area/shuttle/transport1/crashed, "centcom_shuttle",
					"centcom_shuttle_dock_airlock", "centcom_shuttle_bay"
	)
	shuttle.init_shuttle(settings)
	shuttles["Centcom"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	shuttle = new()
	settings = list(
					1, 10, locate(/area/shuttle/administration/centcom), locate(/area/shuttle/administration/station), null, NORTH, 0,
					locate(/area/shuttle/administration/centcom),	/area/shuttle/administration/crashed, "admin_shuttle",
					"admin_shuttle_dock_airlock", "admin_shuttle_bay"
	)
	shuttle.init_shuttle(settings)
	shuttles["Administration"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	// Merchant Shuttle

	shuttle = new()
	settings = list(
					1, 10, locate(/area/merchant_ship/start), locate(/area/merchant_ship/docked), null, EAST, 0,
					locate(/area/merchant_ship/start),	/area/merchant_ship/crashed, "merchant_shuttle",
					"merchant_shuttle_dock", "merchant_station"
	)
	shuttle.init_shuttle(settings)
	shuttles["Merchant"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	// ERT Shuttle
	var/datum/shuttle/ferry/multidock/specops/ERT = new()
	settings = list(
					0, 10, locate(/area/shuttle/specops/station), locate(/area/shuttle/specops/centcom), null, WEST, 0,
					locate(/area/shuttle/specops/station),	/area/shuttle/specops/crashed, "specops_shuttle_port",
					"specops_shuttle_port", "specops_shuttle_fore"
	)
	ERT.init_shuttle(settings)
	shuttles["Special Operations"] = ERT
	START_PROCESSING(shuttle_controller, ERT)

	//Skipjack.
	var/datum/shuttle/multi_shuttle/VS = new/datum/shuttle/multi_shuttle()
	VS.origin = locate(/area/skipjack_station/start)

	VS.destinations = list(
		"Surface of the station - Aft of Cargo" = locate(/area/skipjack_station/surface),
		"Under the station - By the Engine Radiator" = locate(/area/skipjack_station/under),
		"Above the station - By Telecomms" = locate(/area/skipjack_station/above),
		"Above the station - By the Pool" = locate(/area/skipjack_station/above2),
		"Mining caverns" = locate(/area/skipjack_station/cavern)
	)

	VS.announcer = "NDV Icarus"
	VS.arrival_message = "Attention, [station_short], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	VS.departure_message = "Your guests are pulling away, [station_short] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	VS.interim = locate(/area/skipjack_station/transit)
	VS.area_current = locate(/area/skipjack_station/start)
	VS.scan_shuttle()

	VS.warmup_time = 0
	shuttles["Skipjack"] = VS

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = locate(/area/syndicate_station/start)
	MS.start_location = "Mercenary Base"

	MS.destinations = list(
		"Surface of the station - By Cargo Dock" = locate(/area/syndicate_station/surface),
		"Above the station - By Command Roof" = locate(/area/syndicate_station/above),
		"Under the station - By the Engine Radiator" = locate(/area/syndicate_station/under),
		"Mining caverns - Fore of Security" = locate(/area/syndicate_station/caverns),
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
	MS.area_current = locate(/area/syndicate_station/start)
	MS.scan_shuttle()
	shuttles["Mercenary"] = MS

	// Tau Ceti Foreign Legion

	shuttle = new()
	settings = list(
					1, 10, locate(/area/shuttle/legion/centcom), locate(/area/shuttle/legion/docked),
					locate(/area/shuttle/legion/transit), EAST, 75, locate(/area/shuttle/legion/centcom),
					/area/shuttle/legion/crashed, "legion_shuttle", "legion_shuttle_dock", "legion_hangar"
	)
	shuttle.init_shuttle(settings)
	shuttles["Tau Ceti Foreign Legion"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	//Away Site shuttle.

	shuttle = new()
	settings = list(
					1, 10, locate(/area/shuttle/research/station), locate(/area/shuttle/research/away),
					null, EAST, 0, locate(/area/shuttle/research/station),
					/area/shuttle/research/crashed, "science_shuttle", "science_bridge", null
	)
	shuttle.init_shuttle(settings)
	shuttles["Research"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	// Distress Team Shuttle

	var/datum/shuttle/ferry/multidock/distress = new()
	distress.location = 1
	distress.warmup_time = 10
	distress.area_offsite = locate(/area/shuttle/distress/centcom)
	distress.area_station = locate(/area/shuttle/distress/station)
	distress.area_transition = locate(/area/shuttle/distress/transit)
	distress.transit_direction = EAST
	distress.move_time = 45
	distress.docking_controller_tag = "distress_shuttle_aft"
	distress.docking_controller_tag_station = "distress_shuttle_fore"
	distress.docking_controller_tag_offsite = "distress_shuttle_aft"
	distress.dock_target_station = "distress_shuttle_dock"
	distress.dock_target_offsite = "distress_shuttle_origin"

	shuttles["Distress"] = distress
	START_PROCESSING(shuttle_controller, distress)