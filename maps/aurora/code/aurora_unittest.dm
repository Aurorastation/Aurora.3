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

	// Tests that work off typesof / don't change with the map loaded only run on runtime
	whitelisted_test_types = list(
		/datum/unit_test/map_test/apc_area_test,
		/datum/unit_test/map_test/wire_test,
		/datum/unit_test/map_test/roof_test,
		/datum/unit_test/map_test/ladder_test,
		/datum/unit_test/map_test/bad_doors,
		/datum/unit_test/map_test/bad_firedoors,
		/datum/unit_test/map_test/bad_piping,
		/datum/unit_test/map_test/mapped_products,
		/datum/unit_test/map_test/all_station_areas_shall_be_on_station_zlevels,
		/datum/unit_test/map_test/miscellaneous_map_checks,
		/datum/unit_test/machinery_global_test,
		/datum/unit_test/roundstart_cable_connectivity,
		/datum/unit_test/areas_apc_uniqueness,
		/datum/unit_test/area_power_tally_accuracy,
		/datum/unit_test/timer_sanity, // technically map-agnostic but we want to check for any causes
		/datum/unit_test/zas_supply_shuttle_moved,
		/datum/unit_test/zas_active_edges,
		/datum/unit_test/zas_area_test/aurora/arrival_maint,
		/datum/unit_test/zas_area_test/aurora/emergency_shuttle,
		/datum/unit_test/zas_area_test/aurora/cargo_bay,
		/datum/unit_test/zas_area_test/aurora/cargo_maint
	)

/datum/unit_test/zas_area_test/aurora
	map_path = "aurora"
/datum/unit_test/zas_area_test/aurora/arrival_maint
	name = "ZAS: Arrival Maintenance"
	area_path = /area/maintenance/arrivals

/datum/unit_test/zas_area_test/aurora/emergency_shuttle
	name = "ZAS: Emergency Shuttle"
	area_path = /area/shuttle/escape

/datum/unit_test/zas_area_test/aurora/cargo_bay
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage

/datum/unit_test/zas_area_test/aurora/cargo_maint
	name = "ZAS: Cargo Maintenance"
	area_path = /area/maintenance/cargo
