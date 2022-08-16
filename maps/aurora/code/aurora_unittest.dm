/datum/map/aurora

	// This is formatted strangely because it fails the indentation test if it's formatted properly.
	// ¯\_(ツ)_/¯

	ut_environ_exempt_areas = list(/area/space
		,/area/solar
		,/area/shuttle
		,/area/holodeck
		,/area/supply/station
		,/area/tdome
		,/area/centcom
		,/area/antag
		,/area/prison
		,/area/supply/dock
		,/area/turbolift
		,/area/mine
	)
	ut_apc_exempt_areas = list(/area/construction
		,/area/medical/genetics
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
		,/area/security/penal_colony
	)
	ut_fire_exempt_areas = list(
		/area/maintenance,
		/area/rnd/isolation_a,
		/area/rnd/isolation_b,
		/area/rnd/isolation_c,
		/area/rnd/test_area,
		/area/rnd/xenobiology/cells,
		/area/security/penal_colony,
		/area/turret_protected/tcomsat
	)

/datum/unit_test/zas_area_test/aurora
	map_path = "aurora"
/datum/unit_test/zas_area_test/aurora/arrival_maint
	name = "ZAS: Arrival Maintenance"
	area_path = /area/maintenance/arrivals

/datum/unit_test/zas_area_test/aurora/emergency_shuttle
	name = "ZAS: Emergency Shuttle"
	area_path = /area/shuttle/escape

/datum/unit_test/zas_area_test/aurora/zas_area_test
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage

/datum/unit_test/zas_area_test/aurora/cargo_maint
	name = "ZAS: Cargo Maintenance"
	area_path = /area/maintenance/cargo
