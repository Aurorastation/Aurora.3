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
		/area/construction,
		/area/horizon/exterior
	)

	ut_apc_exempt_areas = list()

	ut_atmos_exempt_areas = list(
		/area/horizon/maintenance,
		/area/horizon/engineering/atmos/storage,
		/area/server,
		/area/horizon/tcommsat/chamber,
		/area/bridge/aibunker,
		/area/outpost/research/emergency_storage,
		/area/medical/cryo,
		/area/medical/surgery,
		/area/turret_protected/ai,
		/area/horizon/engineering/reactor/indra/smes,
		/area/rnd/isolation_a,
		/area/rnd/isolation_b,
		/area/rnd/isolation_c
	)

	ut_fire_exempt_areas = list(
		/area/horizon/maintenance,
		/area/construction,
		/area/bridge/aibunker,
		/area/medical/cryo,
		/area/horizon/crew/cryo/washroom,
		/area/rnd/isolation_a,
		/area/rnd/isolation_b,
		/area/rnd/isolation_c
	)

/datum/unit_test/zas_area_test/sccv_horizon
	map_path = "sccv_horizon"

/datum/unit_test/zas_area_test/sccv_horizon/storage
	name = "ZAS: Operations Bay"
	area_path = /area/horizon/operations/storage
