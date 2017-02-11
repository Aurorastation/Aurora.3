var/datum/subsystem/modifiers/SSmodifiers

/datum/subsystem/modifiers
	name = "Modifiers"
	wait = 1 SECONDS	// Surely this doesn't need to tick this fast.

	var/list/current_work = list()

/datum/subsystem/modifiers/New()
	NEW_SS_GLOBAL(SSmodifiers)

/datum/subsystem/modifiers/fire(resumed = FALSE)
	if (!resumed)
		current_work = processing_modifiers.Copy()
	
	while (current_work.len)
		var/datum/modifier/M = current_work[current_work.len]
		current_work.len--

		if (!M || M.gcDestroyed)
			processing_modifiers -= M
			continue

		if (MC_TICK_CHECK)
			return

/datum/subsystem/modifiers/stat_entry()
	..("P:[processing_modifiers.len]")
