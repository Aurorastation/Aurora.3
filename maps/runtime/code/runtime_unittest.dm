/datum/map/runtime
	ut_environ_exempt_areas = list(
		/area/space,
		/area/turbolift
	)
	ut_apc_exempt_areas = list(/area/maintenance/maintcentral)
	ut_atmos_exempt_areas = list(/area)
	ut_fire_exempt_areas = list(
		/area/maintenance/maintcentral,
		/area/shuttle/runtime,
		/area/space,
		/area/turbolift,
		/area/construction/storage,
		/area/turret_protected/ai_upload_foyer,
		/area/turret_protected/ai,
		/area/tcommsat/chamber,
		/area/tcommsat/computer,
		/area/construction/hallway
	)
	excluded_test_types = list(
		/datum/unit_test/zas_area_test,
		/datum/unit_test/foundation/step_shall_return_true_on_success
	)
