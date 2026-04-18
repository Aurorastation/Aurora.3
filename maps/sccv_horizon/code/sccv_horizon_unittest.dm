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
		/area/horizon/exterior
	)

	ut_apc_exempt_areas = list()

	ut_atmos_exempt_areas = list(
		/area/horizon/maintenance,
		/area/horizon/engineering/atmos/storage,
		/area/horizon/rnd/server,
		/area/horizon/tcommsat/chamber,
		/area/horizon/command/bridge/aibunker,
		/area/horizon/medical/cryo,
		/area/horizon/medical/surgery/storage,
		/area/horizon/ai,
		/area/horizon/engineering/reactor/indra/smes,
		/area/horizon/rnd/xenoarch/isolation_a,
		/area/horizon/rnd/xenoarch/isolation_b,
		/area/horizon/rnd/xenoarch/isolation_c
	)

	ut_fire_exempt_areas = list(
		/area/horizon/maintenance,
		/area/horizon/command/bridge/aibunker,
		/area/horizon/medical/cryo,
		/area/horizon/crew/washroom/deck_3,
		/area/horizon/rnd/xenoarch/isolation_a,
		/area/horizon/rnd/xenoarch/isolation_b,
		/area/horizon/rnd/xenoarch/isolation_c
	)

/datum/unit_test/zas_area_test/sccv_horizon
	map_path = "sccv_horizon"

/datum/unit_test/zas_area_test/sccv_horizon/storage
	name = "ZAS: Operations Bay"
	area_path = /area/horizon/operations/warehouse
