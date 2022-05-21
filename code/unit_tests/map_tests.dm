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

/datum/unit_test/map_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents / Alarms (Station)"

/datum/unit_test/map_test/apc_area_test/start_test()
	var/area_test_count = 0
	var/bad_apc = 0
	var/bad_airs = 0
	var/bad_airv = 0
	var/bad_fire = 0

	var/fail_message = ""

	if (!current_map)
		return

	// This is formatted strangely because it fails the indentation test if it's formatted properly.
	// ¯\_(ツ)_/¯
	var/list/exempt_areas = typecacheof(current_map.ut_environ_exempt_areas)
	var/list/exempt_from_atmos = typecacheof(current_map.ut_atmos_exempt_areas)
	var/list/exempt_from_apc = typecacheof(current_map.ut_apc_exempt_areas)
	var/list/exempt_from_fire = typecacheof(current_map.ut_fire_exempt_areas)

	for(var/area/A in typecache_filter_list_reverse(all_areas, exempt_areas))
		if(isStationLevel(A.z))
			area_test_count++
			var/bad_msg = "[ascii_red]--------------- [A.name] ([A.type])"

			if(!A.apc && !is_type_in_typecache(A, exempt_from_apc))
				log_unit_test("[bad_msg] lacks an APC.[ascii_reset]")
				bad_apc++

			if(!A.air_scrub_info.len && !is_type_in_typecache(A, exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an air scrubber.[ascii_reset]")
				bad_airs++

			if(!A.air_vent_info.len && !is_type_in_typecache(A, exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an air vent.[ascii_reset]")
				bad_airv++

			if(!(locate(/obj/machinery/firealarm) in A) && !is_type_in_typecache(A, exempt_from_fire))
				log_unit_test("[bad_msg] lacks a fire alarm.[ascii_reset]")
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
		fail(fail_message)
	else
		pass("All \[[area_test_count]\] areas contained APCs, air scrubbers, air vents, and fire alarms.")

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
		if(T && isStationLevel(T.z))
			cable_turfs |= get_turf(C)

	for(T in cable_turfs)
		var/bad_msg = "[ascii_red]--------------- [T.name] \[[T.x] / [T.y] / [T.z]\]"
		dirs_checked.Cut()
		for(C in T)
			wire_test_count++
			var/combined_dir = "[C.d1]-[C.d2]"
			if(combined_dir in dirs_checked)
				bad_tests++
				log_unit_test("[bad_msg] Contains multiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

	if(bad_tests)
		fail("\[[bad_tests] / [wire_test_count]\] Some turfs had overlapping wires going the same direction.")
	else
		pass("All \[[wire_test_count]\] wires had no overlapping cables going the same direction.")

	return 1


/datum/unit_test/map_test/roof_test
	name = "MAP: Roof Test (Station)"

/datum/unit_test/map_test/roof_test/start_test()
	var/bad_tiles = 0
	var/tiles_total = 0
	var/turf/above
	var/area/A
	var/thing
	for (thing in the_station_areas)
		A = thing

		for (var/turf/T in A)	// Areas don't just contain turfs, so typed loop it is.
			T = thing
			tiles_total++
			above = GetAbove(T)

			if (above && above.is_hole)
				bad_tiles++
				log_unit_test("[ascii_red]--------------- [T.name] \[[T.x] / [T.y] / [T.z]\] Has no roof.[ascii_reset]")

	if (bad_tiles)
		fail("\[[bad_tiles] / [tiles_total]\] station turfs had no roof.")
	else
		pass("All \[[tiles_total]\] station turfs had a roof.")

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
			log_unit_test("[ascii_red]--------------- [ladder.name] \[[ladder.x] / [ladder.y] / [ladder.z]\] Is incomplete.[ascii_reset]")
			continue

		var/bad = 0
		if (ladder.target_up && !isopenturf(GetAbove(ladder)))
			bad |= BLOCKED_UP

		if (ladder.target_down && !isopenturf(ladder.loc))
			bad |= BLOCKED_DOWN

		if (bad)
			ladders_blocked++
			log_unit_test("[ascii_red]--------------- [ladder.name] \[[ladder.x] / [ladder.y] / [ladder.z]\] Is blocked in dirs:[(bad & BLOCKED_UP) ? " UP" : ""][(bad & BLOCKED_DOWN) ? " DOWN" : ""].[ascii_reset]")

	if (ladders_blocked || ladders_incomplete)
		fail("\[[ladders_blocked + ladders_incomplete] / [ladders_total]\] ladders were bad.[ladders_blocked ? " [ladders_blocked] blocked." : ""][ladders_incomplete ? " [ladders_incomplete] incomplete." : ""]")
	else
		pass("All [ladders_total] ladders were okay.")

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
		if(istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T) || T.density)
			failed_checks++
			log_unit_test("Airlock [A] with bad turf at ([A.x],[A.y],[A.z]) in [T.loc].")

	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Some doors had improper turfs below them.")
	else
		pass("All \[[checks]\] doors have proper turfs below them.")

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
			log_unit_test("Double firedoor [F] at ([F.x],[F.y],[F.z]) in [T.loc].")
		else if(istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T) || T.density)
			failed_checks++
			log_unit_test("Firedoor with bad turf at ([F.x],[F.y],[F.z]) in [T.loc].")

	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Some firedoors were doubled up or had bad turfs below them.")
	else
		pass("All \[[checks]\] firedoors have proper turfs below them and are not doubled up.")

	return 1

/datum/unit_test/map_test/bad_piping
	name = "MAP: Check for bad piping"

/datum/unit_test/map_test/bad_piping/start_test()
	set background = 1
	var/checks = 0
	var/failed_checks = 0

	//all plumbing - yes, some things might get stated twice, doesn't matter.
	for (var/obj/machinery/atmospherics/plumbing in world)
		if(isNotStationLevel(plumbing.z))
			continue
		checks++
		if (plumbing.nodealert)
			failed_checks++
			log_unit_test("Unconnected [plumbing.name] located at [plumbing.x],[plumbing.y],[plumbing.z] ([get_area(plumbing.loc)])")

	//Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold/pipe in world)
		if(isNotStationLevel(pipe.z))
			continue
		checks++
		if (!pipe.node1 || !pipe.node2 || !pipe.node3)
			failed_checks++
			log_unit_test("Unconnected [pipe.name] located at [pipe.x],[pipe.y],[pipe.z] ([get_area(pipe.loc)])")

	//Pipes
	for (var/obj/machinery/atmospherics/pipe/simple/pipe in world)
		if(isNotStationLevel(pipe.z))
			continue
		checks++
		if (!pipe.node1 || !pipe.node2)
			failed_checks++
			log_unit_test("Unconnected [pipe.name] located at [pipe.x],[pipe.y],[pipe.z] ([get_area(pipe.loc)])")

	next_turf:
		for(var/turf/T in turfs)
			for(var/dir in cardinal)
				var/list/connect_types = list(1 = 0, 2 = 0, 3 = 0)
				for(var/obj/machinery/atmospherics/pipe in T)
					checks++
					if(dir & pipe.initialize_directions)
						for(var/connect_type in pipe.connect_types)
							connect_types[connect_type] += 1
						if(connect_types[1] > 1 || connect_types[2] > 1 || connect_types[3] > 1)
							log_unit_test("Overlapping pipe ([pipe.name]) located at [T.x],[T.y],[T.z] ([get_area(T)])")
							continue next_turf
	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Some pipes are not properly connected or doubled up.")
	else
		pass("All \[[checks]\] pipes are properly connected and not doubled up.")

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

			log_unit_test("Vending machine [V] at ([V.x],[V.y],[V.z] on [V.loc] has mapped-in products, contraband, or premium items.")

	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Some vending machines have mapped-in product lists.")
	else
		pass("All \[[checks]\] vending machines have valid product lists.")

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

	for(var/area/A as anything in list_keys(the_station_areas))
		if(A.type in exclude_types)
			continue
		checks++

		var/list/turf/invalid_turfs = get_area_turfs(A, list(/proc/is_station_turf)) ^ get_area_turfs(A)
		if(invalid_turfs.len)
			failed_checks++
			var/list/failed_area_zlevels = list()
			for(var/turf/T as anything in invalid_turfs)
				failed_area_zlevels |= T.z
			log_unit_test("Station area [A]: [invalid_turfs.len] turfs are not entirely mapped on station z-levels. Found turfs on non-station levels: [english_list(failed_area_zlevels)]")

	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Some station areas had turfs mapped outside station z-levels.")
	else
		pass("All \[[checks]\] station areas are correctly mapped only on station z-levels.")

	return 1

#undef SUCCESS
#undef FAILURE
