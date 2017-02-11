/datum/subsystem/mobs
	name = "Mobs"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MOB

	var/list/currentrun = list()

/datum/subsystem/mobs/stat_entry()
	..()
	stat(null, "[mob_list.len] mobs")

/datum/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()

	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || M.gcDestroyed)
			mob_list -= M
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
