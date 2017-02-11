var/datum/subsystem/mobs/SSmob

/datum/subsystem/mobs
	name = "Mobs"
	flags = SS_NO_INIT

	var/list/currentrun = list()

/datum/subsystem/mobs/New()
	NEW_SS_GLOBAL(SSmob)

/datum/subsystem/mobs/stat_entry()
	..("P:[mob_list.len]")

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
