/datum/map/sccv_horizon
	ut_environ_exempt_areas = list(
		/area/space,
		/area/solar,
		/area/shuttle,
		/area/horizon/holodeck,
		/area/supply/station,
		/area/tdome,
		/area/centcom,
		/area/supply/dock,
		/area/turbolift,
		/area/mine,
		/area/horizon/exterior,
		/area/template_noop,
		/area/horizon/shuttle/escape_pod
	)

	ut_apc_exempt_areas = list(
		// IF YOU ARE GOING TO ADD MORE EXEMPT AREAS, HAVE A GOOD REASON AND MOVE THIS MESSAGE DOWN A LINE.
	)

	ut_atmos_exempt_areas = list(
		/area/horizon/maintenance, // It's the maints, mate
		/area/horizon/engineering/atmos/storage, // Quasi-maints
		/area/horizon/engineering/atmos/storage_maintenance, // Quasi-maints
		/area/horizon/rnd/server, // Fancy local temp control
		/area/horizon/tcommsat/chamber, // Fancy local temp control
		/area/horizon/command/bridge/aibunker, // Fancy local temp control
		/area/horizon/medical/cryo, // Quasi-maints
		/area/horizon/medical/surgery/storage, //
		/area/horizon/ai, // Fancy local temp control
		/area/horizon/rnd/xenoarch/isolation_a, // Science bullshit
		/area/horizon/rnd/xenoarch/isolation_b, // Science bullshit
		/area/horizon/rnd/xenoarch/isolation_c, // Science bullshit
		/area/horizon/shuttle/escape_pod, // You're dead anyway if something goes wrong
		/area/horizon/operations/package_conveyors, // It's less maints+ and more maints-
		/area/horizon/shuttle/canary // Where the fuck are you gonna put them
		// IF YOU ARE GOING TO ADD MORE EXEMPT AREAS, HAVE A GOOD REASON AND MOVE THIS MESSAGE DOWN A LINE.
	)

	ut_fire_exempt_areas = list(
		/area/horizon/maintenance, // It's the maints, mate
		/area/horizon/command/bridge/aibunker, // Design
		/area/horizon/medical/cryo, // Quasi-maints
		/area/horizon/engineering/atmos/storage, // Quasi-maints
		/area/horizon/engineering/atmos/storage_maintenance, // Quasi-maints
		/area/horizon/rnd/xenoarch/isolation_a, // Science bullshit
		/area/horizon/rnd/xenoarch/isolation_b, // Science bullshit
		/area/horizon/rnd/xenoarch/isolation_c, // Science bullshit
		/area/horizon/shuttle/escape_pod, // You're dead anyway if something goes wrong
		/area/horizon/operations/package_conveyors, // It's less maints+ and more maints-
		/area/horizon/stairwell/engineering/deck_1, // Alarm on deck 2
		/area/horizon/stairwell/starboard/deck_1, // Alarm on deck 2
		/area/horizon/stairwell/starboard/deck_3 // Alarm on deck 2
		// IF YOU ARE GOING TO ADD MORE EXEMPT AREAS, HAVE A GOOD REASON AND MOVE THIS MESSAGE DOWN A LINE.
	)

/datum/unit_test/zas_area_test/sccv_horizon
	map_path = list("sccv_horizon")

/datum/unit_test/zas_area_test/sccv_horizon/storage
	name = "ZAS: Operations Bay"
	area_path = /area/horizon/operations/warehouse
