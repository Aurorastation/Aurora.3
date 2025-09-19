/*
 *
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent.
 *
 *
 */

#define FAILURE 0
#define SUCCESS 1

/datum/unit_test/map_test
	name = "MAP TEST template"
	groups = list("map")

/datum/unit_test/map_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents / Alarms (Station)"

/datum/unit_test/map_test/apc_area_test/start_test()
	var/area_test_count = 0
	var/bad_apc = 0
	var/bad_airs = 0
	var/bad_airv = 0
	var/bad_fire = 0

	var/fail_message = ""

	if (!SSatlas.current_map)
		return

	// This is formatted strangely because it fails the indentation test if it's formatted properly.
	// ¯\_(ツ)_/¯
	var/list/exempt_areas = typecacheof(SSatlas.current_map.ut_environ_exempt_areas)
	var/list/exempt_from_atmos = typecacheof(SSatlas.current_map.ut_atmos_exempt_areas)
	var/list/exempt_from_apc = typecacheof(SSatlas.current_map.ut_apc_exempt_areas)
	var/list/exempt_from_fire = typecacheof(SSatlas.current_map.ut_fire_exempt_areas)

	for(var/area/A in typecache_filter_list_reverse(get_sorted_areas(), exempt_areas))
		if(is_station_level(A.z))
			area_test_count++
			var/bad_msg = TEST_OUTPUT_RED("--------------- [A.name] ([A.type])")

			if(!A.apc && !is_type_in_typecache(A, exempt_from_apc))
				TEST_FAIL(TEST_OUTPUT_RED("[bad_msg] lacks an APC."))
				bad_apc++

			if(!A.air_scrub_info.len && !is_type_in_typecache(A, exempt_from_atmos))
				TEST_FAIL(TEST_OUTPUT_RED("[bad_msg] lacks an air scrubber."))
				bad_airs++

			if(!A.air_vent_info.len && !is_type_in_typecache(A, exempt_from_atmos))
				TEST_FAIL(TEST_OUTPUT_RED("[bad_msg] lacks an air vent."))
				bad_airv++

			if(!(locate(/obj/machinery/firealarm) in A) && !is_type_in_typecache(A, exempt_from_fire))
				TEST_FAIL(TEST_OUTPUT_RED("[bad_msg] lacks a fire alarm."))
				bad_fire++

	if(bad_apc)
		fail_message += "\[[bad_apc]/[area_test_count]\] areas lacked an APC.\n"
	if(bad_airs)
		fail_message += "\[[bad_airs]/[area_test_count]\] areas lacked an air scrubber.\n"
	if(bad_airv)
		fail_message += "\[[bad_airv]/[area_test_count]\] areas lacked an air vent.\n"
	if(bad_fire)
		fail_message += "\[[bad_fire]/[area_test_count]\] areas lacked a fire alarm.\n"

	if(length(fail_message))
		TEST_FAIL(fail_message)
	else
		TEST_PASS("All \[[area_test_count]\] areas contained APCs, air scrubbers, air vents, and fire alarms.")

	return TRUE

//=======================================================================================

/datum/unit_test/map_test/wire_test
	name = "MAP: Cable Test (Station)"

/datum/unit_test/map_test/wire_test/start_test()
	var/wire_test_count = 0
	var/bad_tests = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	for(C in world)
		T = get_turf(C)
		if(T && is_station_level(T.z))
			cable_turfs |= get_turf(C)

	for(T in cable_turfs)
		var/bad_msg = TEST_OUTPUT_RED("--------------- [T.name] \[[T.x] / [T.y] / [T.z]\]")
		dirs_checked.Cut()
		for(C in T)
			wire_test_count++
			var/combined_dir = "[C.d1]-[C.d2]"
			if(combined_dir in dirs_checked)
				bad_tests++
				TEST_FAIL("[bad_msg] Contains multiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

	if(bad_tests)
		TEST_FAIL("\[[bad_tests] / [wire_test_count]\] Some turfs had overlapping wires going the same direction.")
	else
		TEST_PASS("All \[[wire_test_count]\] wires had no overlapping cables going the same direction.")

	return 1

#define BLOCKED_UP   1
#define BLOCKED_DOWN 2

/datum/unit_test/map_test/ladder_test
	name = "MAP: Ladder Test (Station)"

/datum/unit_test/map_test/ladder_test/start_test()
	var/ladders_total = 0
	var/ladders_incomplete = 0
	var/ladders_blocked = 0

	for (var/obj/structure/ladder/ladder in world)
		if (isAdminLevel(ladder.z))
			continue

		ladders_total++

		if (!ladder.target_up && !ladder.target_down)
			ladders_incomplete++
			TEST_FAIL("[ladder.name] \[[ladder.x] / [ladder.y] / [ladder.z]\] Is incomplete.")
			continue

		var/bad = 0
		var/turf/T = get_turf(ladder)
		if (ladder.target_up && !isopenturf(GET_TURF_ABOVE(T)))
			bad |= BLOCKED_UP

		if (ladder.target_down && !isopenturf(ladder.loc))
			bad |= BLOCKED_DOWN

		if (bad)
			ladders_blocked++
			TEST_FAIL("[ladder.name] \[[ladder.x] / [ladder.y] / [ladder.z]\] Is blocked in dirs:[(bad & BLOCKED_UP) ? " UP" : ""][(bad & BLOCKED_DOWN) ? " DOWN" : ""].")

	if (ladders_blocked || ladders_incomplete)
		TEST_FAIL("\[[ladders_blocked + ladders_incomplete] / [ladders_total]\] ladders were bad.[ladders_blocked ? " [ladders_blocked] blocked." : ""][ladders_incomplete ? " [ladders_incomplete] incomplete." : ""]")
	else
		TEST_PASS("All [ladders_total] ladders were okay.")

	return 1

#undef BLOCKED_UP
#undef BLOCKED_DOWN

/datum/unit_test/map_test/bad_doors
	name = "MAP: Check for bad doors"

/datum/unit_test/map_test/bad_doors/start_test()
	var/checks = 0
	var/failed_checks = 0
	for(var/obj/machinery/door/airlock/A in world)
		var/turf/T = get_turf(A)
		checks++
		TEST_ASSERT_NOTNULL(T, "A turf does not exist under the door at [A.x],[A.y],[A.z]")
		if(istype(T, /turf/space) || istype(T, /turf/simulated/floor/exoplanet/asteroid) || isopenturf(T) || T.density)
			failed_checks++
			TEST_FAIL("Airlock [A] with bad turf at ([A.x],[A.y],[A.z]) in [T.loc].")

	if(failed_checks)
		TEST_FAIL("\[[failed_checks] / [checks]\] Some doors had improper turfs below them.")
	else
		TEST_PASS("All \[[checks]\] doors have proper turfs below them.")

	return 1

/datum/unit_test/map_test/bad_firedoors
	name = "MAP: Check for bad firedoors"

/datum/unit_test/map_test/bad_firedoors/start_test()
	var/checks = 0
	var/failed_checks = 0
	for(var/obj/machinery/door/firedoor/F in world)
		var/turf/T = get_turf(F)
		checks++
		var/firelock_increment = 0
		for(var/obj/machinery/door/firedoor/FD in T)
			firelock_increment += 1
		if(firelock_increment > 1)
			failed_checks++
			TEST_FAIL("Double firedoor [F] at ([F.x],[F.y],[F.z]) in [T.loc].")
		else if(istype(T, /turf/space) || istype(T, /turf/simulated/floor/exoplanet/asteroid) || isopenturf(T) || T.density)
			failed_checks++
			TEST_FAIL("Firedoor with bad turf at ([F.x],[F.y],[F.z]) in [T.loc].")

	if(failed_checks)
		TEST_FAIL("\[[failed_checks] / [checks]\] Some firedoors were doubled up or had bad turfs below them.")
	else
		TEST_PASS("All \[[checks]\] firedoors have proper turfs below them and are not doubled up.")

	return 1

/datum/unit_test/map_test/bad_piping
	name = "MAP: Check for bad piping"

/datum/unit_test/map_test/bad_piping/start_test()
	var/checks = 0
	var/failed_checks = 0

	//all plumbing - yes, some things might get stated twice, doesn't matter.
	for (var/obj/machinery/atmospherics/plumbing in world)
		if(!is_station_level(plumbing.z))
			continue
		checks++
		if (plumbing.nodealert)
			failed_checks++
			TEST_FAIL("Unconnected [plumbing.name] located at [plumbing.x],[plumbing.y],[plumbing.z] ([get_area(plumbing.loc)])")

	//Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold/pipe in world)
		if(!is_station_level(pipe.z))
			continue
		checks++
		if (!pipe.node1 || !pipe.node2 || !pipe.node3)
			failed_checks++
			TEST_FAIL("Unconnected [pipe.name] located at [pipe.x],[pipe.y],[pipe.z] ([get_area(pipe.loc)])")

	//Pipes
	for (var/obj/machinery/atmospherics/pipe/simple/pipe in world)
		if(!is_station_level(pipe.z))
			continue
		checks++
		if (!pipe.node1 || !pipe.node2)
			failed_checks++
			TEST_FAIL("Unconnected [pipe.name] located at [pipe.x],[pipe.y],[pipe.z] ([get_area(pipe.loc)])")

	next_turf:
		for(var/turf/T in world)
			for(var/dir in GLOB.cardinals)
				var/list/connect_types = list(1 = 0, 2 = 0, 3 = 0)
				for(var/obj/machinery/atmospherics/pipe in T)
					checks++
					if(dir & pipe.initialize_directions)
						for(var/connect_type in pipe.connect_types)
							connect_types[connect_type] += 1
						if(connect_types[1] > 1 || connect_types[2] > 1 || connect_types[3] > 1)
							TEST_FAIL("Overlapping pipe ([pipe.name]) located at [T.x],[T.y],[T.z] ([get_area(T)])")
							continue next_turf
	if(failed_checks)
		TEST_FAIL("\[[failed_checks] / [checks]\] Some pipes are not properly connected or doubled up.")
	else
		TEST_PASS("All \[[checks]\] pipes are properly connected and not doubled up.")

	return 1

/datum/unit_test/map_test/mapped_products
	name = "MAP: Check for mapped vending products"

/datum/unit_test/map_test/mapped_products/start_test()
	var/checks = 0
	var/failed_checks = 0
	var/list/obj/machinery/vending/V_to_test = list()

	for(var/obj/machinery/vending/T in world)
		checks++
		V_to_test += T
	for(var/obj/machinery/vending/V in V_to_test)
		var/obj/machinery/vending/temp_V = new V.type
		if(length(difflist(V.products, temp_V.products)) || length(difflist(V.contraband, temp_V.contraband)) || length(difflist(V.premium, temp_V.premium)))
			failed_checks++

			TEST_FAIL("Vending machine [V] at ([V.x],[V.y],[V.z] on [V.loc] has mapped-in products, contraband, or premium items.")

	if(failed_checks)
		TEST_FAIL("\[[failed_checks] / [checks]\] Some vending machines have mapped-in product lists.")
	else
		TEST_PASS("All \[[checks]\] vending machines have valid product lists.")

	return 1

/datum/unit_test/map_test/all_station_areas_shall_be_on_station_zlevels
	name = "MAP: Station areas shall be on station z-levels"
	var/list/exclude = list(
		/area/holodeck, // These are necessarily mapped on a non-station z-level so they can be copied over to the holodeck on the station z-levels
		/area/horizon/holodeck
		)

/datum/unit_test/map_test/all_station_areas_shall_be_on_station_zlevels/start_test()
	var/checks = 0
	var/failed_checks = 0
	var/list/exclude_types = list()

	for(var/excluded in exclude)
		exclude_types += typesof(excluded)

	for(var/area/A as anything in list_keys(GLOB.the_station_areas))
		if(A.type in exclude_types)
			continue
		checks++

		var/list/turf/invalid_turfs = get_area_turfs(A, list(/proc/is_station_turf)) ^ get_area_turfs(A)
		if(invalid_turfs.len)
			failed_checks++
			var/list/failed_area_zlevels = list()
			for(var/turf/T as anything in invalid_turfs)
				failed_area_zlevels |= T.z
			TEST_FAIL("Station area [A]: [invalid_turfs.len] turfs are not entirely mapped on station z-levels. Found turfs on non-station levels: [english_list(failed_area_zlevels)]")

	if(failed_checks)
		TEST_FAIL("\[[failed_checks] / [checks]\] Some station areas had turfs mapped outside station z-levels.")
	else
		TEST_PASS("All \[[checks]\] station areas are correctly mapped only on station z-levels.")

	return 1

/datum/unit_test/map_test/stairs_mapped
	name = "MAP: Stairs"

/datum/unit_test/map_test/stairs_mapped/start_test()
	var/test_status = UNIT_TEST_PASSED

	//Loop through all the stairs in the map
	for(var/obj/structure/stairs/a_stair in world)

		//See if there is any other stair in the same turf
		for(var/obj/structure/stairs/possibly_another_stair in get_turf(a_stair))
			if(a_stair != possibly_another_stair)
				test_status = TEST_FAIL("Duplicate stairs located in [a_stair.x]X - [a_stair.y]Y - [a_stair.z]Z! \
											Only one stair should exist inside a turf.")

		if(is_abstract(a_stair))
			test_status = TEST_FAIL("The stairs located in [a_stair.x]X - [a_stair.y]Y - [a_stair.z]Z are of an abstract type ([a_stair.type]) that should never be mapped!")

		//Check that noone changed the bounds in the map editor
		if(a_stair.bound_height != initial(a_stair.bound_height) || a_stair.bound_width != initial(a_stair.bound_width) || \
			a_stair.bound_x != initial(a_stair.bound_x) || a_stair.bound_y != initial(a_stair.bound_y))

			test_status = TEST_FAIL("The stairs at [a_stair.x]X - [a_stair.y]Y - [a_stair.z]Z have map-defined bounds!")

	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All the mapped stairs are valid.")
	else
		TEST_FAIL("Some mapped stairs are invalid!")

	return test_status

/datum/unit_test/map_test/no_dirty_vars
	name = "MAP: No Dirty Vars"

/datum/unit_test/map_test/no_dirty_vars/start_test()
	var/test_status

#if defined(TESTING)

	if(length(GLOB.dirty_vars))
		test_status = TEST_FAIL("There are dirty vars in the map! Read the logs above!")
		TEST_DEBUG(json_encode(GLOB.dirty_vars))
	else
		test_status = TEST_PASS("No dirty vars in the map.")

#else

	test_status = TEST_FAIL("This test was run without the TESTING define set, which isn't supported")

#endif


	return test_status

/datum/unit_test/map_test/areas_in_station_zlevels_must_be_marked_as_station_areas
	name = "MAP: Areas in station z-levels must be marked as station areas"

	/**
	 * A list of types of areas that we do not want to check
	 */
	var/list/do_not_check_areas_types = list(
		/area/space,
		/area/shuttle,
		/area/template_noop,
	)

/datum/unit_test/map_test/areas_in_station_zlevels_must_be_marked_as_station_areas/start_test()
	var/test_status = UNIT_TEST_PASSED

	for(var/area/possible_station_area in GLOB.areas)

		if(is_type_in_list(possible_station_area, do_not_check_areas_types))
			TEST_DEBUG("Skipping area [possible_station_area] ([possible_station_area.type]) as it is in the do not check list.")
			continue

		//We get a turf from the area, to see if we are in the "station"
		var/list/turf/area_turfs = get_area_turfs(possible_station_area)
		if(!length(area_turfs))
			TEST_NOTICE("Skipping area [possible_station_area] ([possible_station_area.type]) as it has no turfs.")
			continue

		var/turf/turf_to_get_z = pick(area_turfs)

		//See if the turf is in a station z-level, if not abort
		if(!is_station_turf(turf_to_get_z))
			TEST_DEBUG("Skipping area [possible_station_area] ([possible_station_area.type]) as it is not in a station z-level (picked check turf: [turf_to_get_z] on Z [turf_to_get_z.z]).")
			continue

		/* At this point, we know the area must be checked and is present in the station z-level */

		if(!possible_station_area.station_area)
			test_status = TEST_FAIL("Area [possible_station_area] ([possible_station_area.type]) is not marked as a station area, despite being in a station z-level.")
		else
			TEST_DEBUG("Area [possible_station_area] ([possible_station_area.type]) is marked as a station area.")


	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All areas in station z-levels are marked as station areas.")
	else
		TEST_FAIL("Some areas in station z-levels are not marked as station areas.")

	return test_status

/datum/unit_test/map_test/no_map_spawn_guaranteed_flag
	name = "MAP: Check for Spawn Guaranteed flag"
	/// Away sites that are allowed to always populate. Usually sector-specific locations only.
	var/list/do_not_check_site_types = list(
		/datum/map_template/ruin/away_site/hegemony_waypoint
	)

/datum/unit_test/map_test/no_map_spawn_guaranteed_flag/start_test()
	var/test_status = UNIT_TEST_PASSED

	for (var/site_id in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/site = SSmapping.away_sites_templates[site_id]

		if(is_type_in_list(site, do_not_check_site_types))
			TEST_DEBUG("Skipping away site [site.name] as it is in the do not check list.")
			continue

		if (site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED)
			test_status = TEST_FAIL("Away site [site.name] has the debug flag TEMPLATE_FLAG_SPAWN_GUARANTEED set.")
		else
			TEST_DEBUG("Away site [site.name] does not have the flag set.")

	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All away sites are free of offending debug flags.")
	else
		TEST_FAIL("Some away sites have the offending debug flag TEMPLATE_FLAG_SPAWN_GUARANTEED set.")

	return test_status

#undef SUCCESS
#undef FAILURE
