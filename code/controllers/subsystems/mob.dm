/var/datum/controller/subsystem/mobs/SSmob

/datum/controller/subsystem/mobs
	name = "Mobs"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MOB

	var/list/slept = list()

	var/list/currentrun = list()
	var/list/all_mice = list()	// Contains all *living* mice.
	var/list/mannequins = list()	//Contains all mannequins used by character preview
	var/list/greatworms = list()
	var/list/greatasses = list()

/datum/controller/subsystem/mobs/New()
	NEW_SS_GLOBAL(SSmob)

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
			// We can just go ahead and remove them from all the mob lists.
			mob_list -= M
			dead_mob_list -= M
			living_mob_list -= M

			if (MC_TICK_CHECK)
				return
			continue

		var/time = world.time

		if (!M.frozen)
			M.Life()

		if (time != world.time && !slept[M.type])
			slept[M.type] = TRUE
			var/diff = world.time - time
			log_debug("SSmob: Type '[M.type]' slept for [diff] ds in Life()! Suppressing further warnings.")

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/proc/get_mannequin(ckey)
	. = mannequins[ckey]
	if (!.)
		. = new /mob/living/carbon/human/dummy/mannequin
		mannequins[ckey] = .

	addtimer(CALLBACK(src, .proc/del_mannequin, ckey), 5 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/controller/subsystem/mobs/proc/del_mannequin(ckey)
	var/mannequin = mannequins[ckey]
	qdel(mannequin)
	mannequins -= ckey
