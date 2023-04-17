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

/datum/unit_test/zas_area_test/sccv_horizon
	map_path = "sccv_horizon"

/datum/unit_test/zas_area_test/sccv_horizon/storage
	name = "ZAS: Operations Bay"
	area_path = /area/operations/storage
