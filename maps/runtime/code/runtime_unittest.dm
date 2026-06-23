/datum/map/runtime
	ut_environ_exempt_areas = list(
		/area/space,
		/area/runtime/exterior
	)

	ut_apc_exempt_areas = list(
		/area/runtime/floor_one/warehouse/package,
		/area/supply/dock,
		/area/centcom,
		)

	ut_atmos_exempt_areas = list(/area)

	ut_fire_exempt_areas = list(
		/area/runtime/floor_one/main,
		/area/runtime/floor_one/construction,
		/area/runtime/floor_one/atmospherics,
		/area/runtime/floor_one/warehouse,
		/area/runtime/floor_one/warehouse/package,
		/area/runtime/floor_two/main,
		/area/runtime/floor_two/comms,
		/area/runtime/floor_two/bridge,
		/area/runtime/exterior,
		/area/shuttle/runtime,
		/area/space,
		/area/turbolift,
		/area/supply/dock,
		/area/centcom
	)

	excluded_test_types = list(
		/datum/unit_test/zas_area_test,
		/datum/unit_test/foundation/step_shall_return_true_on_success
	)
