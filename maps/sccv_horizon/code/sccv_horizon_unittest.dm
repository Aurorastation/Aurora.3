/datum/map/sccv_horizon

	// This is formatted strangely because it fails the indentation test if it's formatted properly.
	// ¯\_(ツ)_/¯

	ut_environ_exempt_areas = list(/area/space
		,/area/solar
		,/area/shuttle
		,/area/holodeck
		,/area/supply/station
		,/area/tdome
		,/area/centcom
		,/area/beach
		,/area/prison
		,/area/supply/dock
		,/area/turbolift
		,/area/mine
		,/area/horizonexterior
	)
	ut_apc_exempt_areas = list(/area/construction
		,/area/medical/genetics
		,/area/horizonexterior
	)
	ut_atmos_exempt_areas = list(/area/maintenance
		,/area/storage
		,/area/engineering/atmos/storage
		,/area/rnd/test_area
		,/area/construction
		,/area/server
		,/area/security/nuke_storage
		,/area/tcommsat/chamber
		,/area/bridge/aibunker
		,/area/engineering/cooling
		,/area/outpost/research/emergency_storage
		,/area/bridge/selfdestruct
		,/area/medical/cryo
		,/area/medical/patient_c
		,/area/turret_protected/ai
		,/area/engineering/engine_monitoring/tesla
		,/area/engineering/smes
		,/area/horizonexterior
		,/area/tcommsat/mainlvl_tcomms__relay
		,/area/tcommsat/mainlvl_tcomms__relay/second
		,/area/medical/surgery
		,/area/rnd/isolation_a
		,/area/rnd/isolation_b
		,/area/rnd/isolation_c
	)

/datum/unit_test/zas_area_test/sccv_horizon
	map_path = "sccv_horizon"
/datum/unit_test/zas_area_test/sccv_horizon/storage
	name = "ZAS: Operations Bay"
	area_path = /area/operations/storage
