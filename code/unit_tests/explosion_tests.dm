// Keep the regression local to its epicenter; the production vertical path is unchanged.
/datum/automata_cell/explosion/unit_test_z/get_propagation_dirs(reflected)
	return list()

/datum/unit_test/cellular_explosion_z
	name = "EXPLOSIONS: Floors block cross-deck blasts and vertical range decays"
	groups = list("generic", "cellular explosion z")
	map_path = list("runtime")

/datum/unit_test/cellular_explosion_z/start_test()
	var/turf/lower
	var/turf/upper
	for(var/z_level in 1 to world.maxz)
		lower = locate(world.maxx - 2, world.maxy - 2, z_level)
		upper = GET_TURF_ABOVE(lower)
		if(upper)
			break
	if(!upper)
		return TEST_FAIL("No connected decks available for the explosion regression.")

	var/lower_type = lower.type
	var/upper_type = upper.type
	lower = lower.ChangeTurf(/turf/simulated/floor)
	upper = upper.ChangeTurf(/turf/simulated/floor)
	var/list/saved_queue = SSexplosives.work_queue
	var/saved_can_fire = SSexplosives.can_fire
	SSexplosives.work_queue = list()
	. = UNIT_TEST_PASSED
	var/datum/automata_cell/explosion/unit_test_z/cell = new(upper)
	cell.power = 300
	cell.power_falloff = 30
	cell.devastation_range = 4
	cell.heavy_impact_range = 6
	cell.light_impact_range = 8
	cell.max_damage_range = 8
	cell.z_transfer = DOWN
	cell.source_name = "vertical regression"
	cell.propagate_z()
	if(length(SSexplosives.work_queue))
		. = TEST_FAIL("A blast passed down through solid flooring/plating.")
	SSexplosives.work_queue.Cut()

	// A devastating hit must open the floor before it can seed the lower deck.
	upper.baseturf = /turf/space
	cell.update_state()
	upper = GET_TURF_ABOVE(lower)
	if(!upper.is_open() || length(SSexplosives.work_queue) != 1)
		. = TEST_FAIL("A blast which opened its floor did not propagate through the breach.")
	else
		var/datum/explosiondata/child = SSexplosives.work_queue[1]
		if(child.epicenter != lower || child.devastation_range != 2 || child.heavy_impact_range != 4 || child.light_impact_range != 6 || child.max_damage_range != 6)
			. = TEST_FAIL("Cross-deck propagation did not reduce each damage range by two tiles.")
		if(child.rec_pow >= 300 || child.z_transfer != DOWN || child.source_name != "vertical regression")
			. = TEST_FAIL("Cross-deck propagation lost its attenuation, direction, or attribution.")
	SSexplosives.work_queue.Cut()

	// These are light-only weapon impacts, drop pods, and ordinary power-cell blasts.
	cell = new(upper)
	cell.z_transfer = DOWN
	for(var/list/ranges as anything in list(list(-1, -1, 3), list(0, 0, 2), list(-1, 1, 3), list(-1, 2, 4)))
		cell.devastation_range = ranges[1]
		cell.heavy_impact_range = ranges[2]
		cell.light_impact_range = ranges[3]
		cell.max_damage_range = ranges[3]
		cell.power = ranges[2] > 0 ? 199 : 99
		cell.propagate_z()
	if(length(SSexplosives.work_queue))
		. = TEST_FAIL("A small blast crossed a deck even through an existing opening.")
	SSexplosives.work_queue.Cut()
	qdel(cell)

	upper = upper.ChangeTurf(/turf/simulated/floor)
	cell = new(lower)
	cell.power = 300
	cell.devastation_range = 4
	cell.heavy_impact_range = 6
	cell.light_impact_range = 8
	cell.max_damage_range = 8
	cell.z_transfer = UP
	cell.propagate_z()
	if(length(SSexplosives.work_queue))
		. = TEST_FAIL("A blast passed up through the intact floor above it.")
	SSexplosives.work_queue.Cut()
	upper = upper.ChangeTurf(/turf/space)
	cell.propagate_z()
	if(length(SSexplosives.work_queue) != 1)
		. = TEST_FAIL("A sufficiently large blast failed to travel upward through an opening.")
	SSexplosives.work_queue.Cut()
	cell.z_transfer = 0
	cell.propagate_z()
	if(length(SSexplosives.work_queue))
		. = TEST_FAIL("A blast ignored its disabled z-transfer flag.")
	qdel(cell)
	SSexplosives.work_queue = saved_queue
	SSexplosives.can_fire = saved_can_fire
	lower.ChangeTurf(lower_type)
	upper.ChangeTurf(upper_type)
	if(. == UNIT_TEST_PASSED)
		return TEST_PASS("Solid decks block blasts, breaches permit attenuated transfer, and small explosions stay on one deck.")
