/datum/map/home
	ut_environ_exempt_areas = list(
		/area/space,
		/area/turbolift
	)
	ut_apc_exempt_areas = list(/area/maintenance/maintcentral)
	ut_atmos_exempt_areas = list(/area)
	excluded_test_types = list(
		/datum/unit_test/zas_area_test,
		/datum/unit_test/foundation/step_shall_return_true_on_success
	)