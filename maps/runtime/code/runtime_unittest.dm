/datum/map/runtime
	ut_environ_exempt_areas = list(
		/area/space,
		/area/exterior
	)

	ut_apc_exempt_areas = list(
		/area/storage/supply/package,
		/area/supply/dock,
		/area/centcom,
		)

	ut_atmos_exempt_areas = list(/area)

	ut_fire_exempt_areas = list(
		/area/maintenance/maintcentral,
		/area/shuttle/runtime,
		/area/space,
		/area/turbolift,
		/area/construction/storage,
		/area/turret_protected,
		/area/tcommsat,
		/area/construction/hallway,
		/area/storage/supply/package,
		/area/supply/dock,
		/area/centcom,
	)

	excluded_test_types = list(
		/datum/unit_test/zas_area_test,
		/datum/unit_test/foundation/step_shall_return_true_on_success
	)
