/var/datum/controller/subsystem/ao/SSocclusion

/datum/controller/subsystem/ao
	name = "Ambient Occlusion"
	flags = SS_FIRE_IN_LOBBY
	init_order = SS_INIT_AO
	wait = 1
	priority = SS_PRIORITY_LIGHTING

	var/list/queue = list()

/datum/controller/subsystem/ao/New()
	NEW_SS_GLOBAL(SSocclusion)

/datum/controller/subsystem/ao/stat_entry()
	..("P:[queue.len]")

/datum/controller/subsystem/ao/Initialize()
	fire(FALSE, TRUE)
	..()

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
	suspend()

/datum/controller/subsystem/ao/ExplosionEnd()
	wake()
