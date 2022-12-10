/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *
 *
 */

#define UT_NORMAL 1                   // Standard one atmosphere 20celsius
#define UT_VACUUM 2                   // Vacume on simulated turfs
#define UT_NORMAL_COLD 3              // Cold but standard atmosphere.
#define UT_NORMAL_COOL 4              // Cool (5C) but standard atmosphere.

#define FAILURE 0
#define SUCCESS 1

//
// Generic check for an area.
//

datum/unit_test/zas_area_test
	name = "ZAS: Area Test Template"
	var/area_path = null                    // Put the area you are testing here.
	var/expectation = UT_NORMAL             // See defines above.

datum/unit_test/zas_area_test/start_test()
	var/list/test = test_air_in_area(area_path, expectation)

	if(isnull(test))
		fail("Check Runtimed")

	if(test["result"] == SUCCESS)
		pass(test["msg"])
	else
		fail(test["msg"])
	return 1

// ==================================================================================================

//
//	The primary helper proc.
//
proc/test_air_in_area(var/test_area, var/expectation = UT_NORMAL)
	var/test_result = list("result" = FAILURE, "msg"    = "")

	var/area/A = locate(test_area)

	if(!istype(A, test_area))
		test_result["msg"] = "Unable to get [test_area]"
		return test_result

	var/list/GM_checked = list()

	for(var/turf/simulated/T in A)

		if(!istype(T) || isnull(T.zone) || istype(T, /turf/simulated/floor/airless))
			continue
		if(T.zone.air in GM_checked)
			continue

		var/t_msg = "Turf: [T] |  Location: [T.x] // [T.y] // [T.z]"

		var/datum/gas_mixture/GM = T.return_air()
		var/pressure = GM.return_pressure()
		var/temp = GM.temperature

		switch(expectation)

			if(UT_VACUUM)
				if(pressure > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result


			if(UT_NORMAL || UT_NORMAL_COLD || UT_NORMAL_COOL)
				if(abs(pressure - ONE_ATMOSPHERE) > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

				if(expectation == UT_NORMAL)
					if(abs(temp - T20C) > 10)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

				if(expectation == UT_NORMAL_COLD)
					if(temp > 120)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

				if(expectation == UT_NORMAL_COOL)
					if(temp > 283)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

		GM_checked.Add(GM)

	if(GM_checked.len)
		test_result["result"] = SUCCESS
		test_result["msg"] = "Checked [GM_checked.len] zones"
	else
		test_result["msg"] = "No zones checked."

	return test_result


// ==================================================================================================

datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentComm)"
	area_path = /area/supply/dock

datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/turret_protected/ai
	expectation = UT_NORMAL_COOL

datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology

/*
datum/unit_test/zas_area_test/mining_area
	name = "ZAS: Mining Area (Vacuum)"
	area_path = /area/mine/explored
	expectation = UT_VACUUM
	disabled = 1
	why_disabled = "Asteroid Generation disabled"
 */

// ==================================================================================================


// Here we move a shuttle then test it's area once the shuttle has arrived.

/datum/unit_test/zas_supply_shuttle_moved
	name = "ZAS: Supply Shuttle (When Moved)"
	async = TRUE				// We're moving the shuttle using built in procs.

	var/datum/shuttle/autodock/ferry/supply/shuttle = null

	var/testtime = 0	//Used as a timer.

/datum/unit_test/zas_supply_shuttle_moved/start_test()
	if(!SSshuttle)
		fail("The shuttle controller is not setup at time of test.")
		return 1
	if(!SSshuttle.shuttles.len)
		if(length(current_map.map_shuttles))
			fail("This map should have shuttles, but it doesn't!")
			return 1
		else
			pass("This map is not supposed to have any shuttles.")
			return 1

	shuttle = SScargo.shuttle
	if(isnull(shuttle))
		return 1

	// Initiate the Move.
	SScargo.movetime = 5 // Speed up the shuttle movement.
	shuttle.short_jump(shuttle.get_location_waypoint(!shuttle.location))

	return 1

/datum/unit_test/zas_supply_shuttle_moved/check_result()
	if(!shuttle)
		pass("This map has no supply shuttle.")
		return 1
	if(shuttle.moving_status == SHUTTLE_IDLE && !shuttle.at_station())
		fail("Shuttle Did not Move")
		return 1

	if(!shuttle.at_station())
		return 0

	if(!testtime)
		testtime = world.time+40                // Wait another 2 ticks then proceed.

	if(world.time < testtime)
		return 0


	for(var/area/A in shuttle.shuttle_area)
		var/list/test = test_air_in_area(A.type)
		if(isnull(test))
			fail("Check Runtimed")
			return 1

		switch(test["result"])
			if(SUCCESS) pass(test["msg"])
			else        fail(test["msg"])
	return 1

/datum/unit_test/zas_active_edges
	name = "ZAS: Roundstart Active Edges"

/datum/unit_test/zas_active_edges/start_test()
	if(SSair.active_edges.len)
		fail("[SSair.active_edges.len] edges active at round-start!")
	else
		pass("No active ZAS edges at round-start.")
		return TRUE
	for(var/connection_edge/E in SSair.active_edges)
		var/connection_edge/unsimulated/U = E
		if(istype(U))
			var/turf/T = U.B
			if(istype(T))
				log_unit_test("[ascii_red]---- [U.A.name] and [T.name] ([T.x], [T.y], [T.z]) have mismatched gas mixtures![ascii_reset]")
			else
				log_unit_test("[ascii_red]----[U.A.name] and [U.B] have mismatched gas mixtures![ascii_reset]")

			var/zone/A = U.A
			var/offending_turfs = "Problem turfs: "
			for(var/turf/simulated/S in A.contents)
				if(S.oxygen || S.nitrogen)
					offending_turfs += "[S] ([S.x], [S.y], [S.z]) "

			log_unit_test("[ascii_red]-------- [offending_turfs][ascii_reset]")
		else
			var/connection_edge/zone/Z = E
			var/zone/problem
			if(!istype(Z))
				return
			log_unit_test("[ascii_red]---- [Z.A.name] and [Z.B.name] have mismatched gas mixtures![ascii_reset]")
			if(Z.A.air.gas.len && Z.B.air.gas.len)
				log_unit_test("[ascii_red]-------- Both zones have gas mixtures defined; either one is a normally vacuum zone exposed to a breach, or two differing gases are mixing at round-start.[ascii_reset]")
				continue
			else if(Z.A.air.gas.len)
				problem = Z.A
			else if(Z.B.air.gas.len)
				problem = Z.B

			if(!istype(problem))
				continue

			var/offending_turfs = "Problem turfs: "
			for(var/turf/simulated/S in problem.contents)
				if(S.oxygen || S.nitrogen)
					offending_turfs += "[S] ([S.x], [S.y], [S.z]) "

			log_unit_test("[ascii_red]-------- [offending_turfs][ascii_reset]")


	return FALSE

#undef UT_NORMAL
#undef UT_VACUUM
#undef UT_NORMAL_COLD
#undef UT_NORMAL_COOL
#undef SUCCESS
#undef FAILURE
