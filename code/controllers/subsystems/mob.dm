/datum/controller/subsystem/mobs
	name = "Mobs"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MOB

	var/list/currentrun = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P:[mob_list.len]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()

	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if (QDELETED(M))
			log_debug("SSmob: QDELETED mob [DEBUG_REF(M)] left in processing list!")
			mob_list -= M
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
