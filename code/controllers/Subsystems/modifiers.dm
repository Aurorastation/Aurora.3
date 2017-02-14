/datum/subsystem/modifiers
	name = "Modifiers"
	wait = 1 SECONDS	// Surely this doesn't need to tick this fast.

	var/list/current_work = list()

/datum/subsystem/modifiers/fire(resumed = FALSE)
	if (!resumed)
		current_work = processing_modifiers.Copy()
	
	while (current_work.len)
		var/datum/modifier/M = current_work[current_work.len]
		current_work.len--

		if (QDELETED(M))
			processing_modifiers -= M
			continue

		if (MC_TICK_CHECK)
			return

/datum/subsystem/modifiers/stat_entry()
	..("P:[processing_modifiers.len]")
