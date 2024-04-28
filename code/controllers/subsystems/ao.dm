SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	init_order = SS_INIT_AO
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/queue = list()

/datum/controller/subsystem/ao/stat_entry(msg)
	msg = "P:[queue.len]"
	return ..()

/datum/controller/subsystem/ao/Initialize()
	fire(FALSE, TRUE)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/ao/fire(resumed = 0, no_mc_tick = FALSE)
	var/list/curr = queue
	while (curr.len)
		var/turf/target = curr[curr.len]
		curr.len--

		if (!QDELETED(target))
			if (target.ao_queued == AO_UPDATE_REBUILD)
				var/old_n = target.ao_neighbors
				var/old_z = target.ao_neighbors_mimic
				target.calculate_ao_neighbors()
				if (old_n != target.ao_neighbors || old_z != target.ao_neighbors_mimic)
					target.update_ao()
			else
				target.update_ao()
			target.ao_queued = AO_UPDATE_NONE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/ao/ExplosionStart()
	can_fire = FALSE

/datum/controller/subsystem/ao/ExplosionEnd()
	can_fire = TRUE
