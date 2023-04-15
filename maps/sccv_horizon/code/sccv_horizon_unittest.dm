/datum/map/sccv_horizon
	ut_environ_exempt_areas = list(
		/area/space,
		/area/solar,
		/area/shuttle,
		/area/horizon/holodeck,
		/area/supply/station,
		/area/tdome,
		/area/centcom,
		/area/prison,
		/area/supply/dock,
		/area/turbolift,
		/area/mine,
		/area/construction,
		/area/horizon/exterior
	)

	ut_apc_exempt_areas = list()

	ut_atmos_exempt_areas = list(
		/area/maintenance,
		/area/horizon/maintenance,
		/area/engineering/atmos/storage,
		/area/server,
		/area/tcommsat/chamber,
		/area/bridge/aibunker,
		/area/outpost/research/emergency_storage,
		/area/medical/cryo,
		/area/medical/surgery,
		/area/turret_protected/ai,
		/area/engineering/smes/tesla,
		/area/tcommsat/mainlvl_tcomms__relay,
		/area/tcommsat/mainlvl_tcomms__relay/second,
		/area/rnd/isolation_a,
		/area/rnd/isolation_b,
		/area/rnd/isolation_c
	)

	ut_fire_exempt_areas = list(
		/area/maintenance,
		/area/horizon/maintenance,
		/area/construction,
		/area/bridge/aibunker,
		/area/medical/cryo,
		/area/horizon/crew_quarters/cryo/washroom,
		/area/rnd/isolation_a,
		/area/rnd/isolation_b,
		/area/rnd/isolation_c
	)

/datum/unit_test/zas_area_test/sccv_horizon
	map_path = "sccv_horizon"

/datum/unit_test/zas_area_test/sccv_horizon/storage
	name = "ZAS: Operations Bay"
	area_path = /area/operations/storage