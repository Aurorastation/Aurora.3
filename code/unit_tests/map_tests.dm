/*
 *
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent.
 *
 *
 */

#define FAILURE 0
#define SUCCESS 1


datum/unit_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents (Station)"

datum/unit_test/apc_area_test/start_test()
	var/list/bad_areas = list()
	var/area_test_count = 0

	if (!current_map)
		return

	// This is formatted strangely because it fails the indentation test if it's formatted properly.
	// ¯\_(ツ)_/¯
	var/list/exempt_areas = typecacheof(current_map.ut_environ_exempt_areas)
	var/list/exempt_from_atmos = typecacheof(current_map.ut_atmos_exempt_areas)
	var/list/exempt_from_apc = typecacheof(current_map.ut_apc_exempt_areas)

	for(var/area/A in typecache_filter_list_reverse(all_areas, exempt_areas))
		if(A.z in current_map.station_levels)
			area_test_count++
			var/area_good = 1
			var/bad_msg = "[ascii_red]--------------- [A.name]([A.type])"


			if(!A.apc && !is_type_in_typecache(A, exempt_from_apc))
				log_unit_test("[bad_msg] lacks an APC.[ascii_reset]")
				area_good = 0

			if(!A.air_scrub_info.len && !is_type_in_typecache(A, exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air scrubber.[ascii_reset]")
				area_good = 0

			if(!A.air_vent_info.len && !is_type_in_typecache(A, exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air vent.[ascii_reset]")
				area_good = 0

			if(!area_good)
				bad_areas += A

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas lacked APCs, Air Scrubbers, or Air vents.")
	else
		pass("All \[[area_test_count]\] areas contained APCs, Air scrubbers, and Air vents.")

	return 1

//=======================================================================================

datum/unit_test/wire_test
	name = "MAP: Cable Test (Station)"

datum/unit_test/wire_test/start_test()
	var/wire_test_count = 0
	var/bad_tests = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	for(C in world)
		T = get_turf(C)
		if(T && T.z in current_map.station_levels)
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


/datum/unit_test/roof_test
	name = "MAP: Roof Test (Station)"

/datum/unit_test/roof_test/start_test()
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

/datum/unit_test/ladder_test
	name = "MAP: Ladder Test (Station)"

/datum/unit_test/ladder_test/start_test()
	var/ladders_total = 0
	var/ladders_incomplete = 0
	var/ladders_blocked = 0

	for (var/obj/structure/ladder/ladder in world)
		if (ladder.z in current_map.admin_levels)
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

#undef SUCCESS
#undef FAILURE
