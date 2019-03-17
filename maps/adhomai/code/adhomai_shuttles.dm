/datum/map/adhomai/setup_shuttles()
	var/list/shuttles = shuttle_controller.shuttles

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = locate(/area/syndicate_station/start)
	MS.start_location = "Mercenary Base"

	MS.destinations = list(
		"South-east of the station" = locate(/area/syndicate_station/adhomai)
	)

	MS.docking_controller_tag = "merc_shuttle"
	MS.destination_dock_targets = list(
		"Mercenary Base" = "merc_base"
	)

	MS.interim = locate(/area/syndicate_station/transit)

	MS.warmup_time = 0
	shuttles["Mercenary"] = MS
