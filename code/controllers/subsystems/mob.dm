SUBSYSTEM_DEF(mobs)
	name = "Mobs - Life"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	var/list/currentrun = list()
	var/list/processing = list()

	var/list/all_rats = list()	// Contains all *living* rats.

	///Contains all mannequins used by character preview
	var/list/mob/living/carbon/human/dummy/mannequin/mannequins = list()

	var/list/greatworms = list()
	var/list/greatasses = list()

	var/list/ghost_darkness_images = list()	//this is a list of images for things ghosts should still be able to see when they toggle darkness
	var/list/ghost_sightless_images = list()	//this is a list of images for things ghosts should still be able to see even without ghost sight

	// Devour types (these are typecaches). Only simple_animals check these, other types are handled specially.
	var/list/mtl_synthetic = list(
		/mob/living/simple_animal/hostile/hivebot
	)

	var/list/mtl_weird = list(
		/mob/living/simple_animal/construct,
		/mob/living/simple_animal/shade,
		/mob/living/simple_animal/slime,
		/mob/living/simple_animal/hostile/faithless
	)

	// Actual human mobs are delibrately not in this list as they are handled elsewhere.
	var/list/mtl_humanoid = list(
		/mob/living/simple_animal/hostile/pirate,
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/syndicate
	)

	var/list/mtl_incorporeal = list(
		/mob/living/simple_animal/hostile/carp/holodeck,
		/mob/living/simple_animal/penguin/holodeck,
		/mob/living/simple_animal/corgi/puppy/holodeck,
		/mob/living/simple_animal/cat/kitten/holodeck
	)

	/**
	 * An associative list containing timer IDs associated with a mannequin that they're supposed to delete
	 */
	var/list/mannequins_del_timers = list()

/datum/controller/subsystem/mobs/Initialize()
	// Some setup work for the eat-types lists.
	mtl_synthetic = typecacheof(mtl_synthetic) + list(
		/mob/living/simple_animal/hostile/icarus_drone = TRUE,
		/mob/living/simple_animal/hostile/viscerator = TRUE,
		/mob/living/simple_animal/spiderbot = TRUE
	)

	mtl_weird = typecacheof(mtl_weird) + list(
		/mob/living/simple_animal/adultslime = TRUE
	)

	mtl_humanoid = typecacheof(mtl_humanoid)

	mtl_incorporeal = typecacheof(mtl_incorporeal)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/mobs/stat_entry(msg)
	msg = "P:[length(GLOB.mob_list)]"
	return ..()

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = GLOB.mob_list.Copy()
		src.currentrun += processing.Copy()

	//Mobs might have been removed between the previous and a resumed fire, yet we want to maintain the priority to process
	//the mobs that we didn't in the previous run, hence we have to pay the price of a list subtraction
	//with &= we say to remove any item in the first list that is not in the second one
	//of course, if we haven't resumed, this comparison would be useless, hence we skip it
	var/list/currentrun = resumed ? (src.currentrun &= (GLOB.mob_list + processing)) : src.currentrun

	var/seconds_per_tick = (1 SECONDS) / wait

	while(length(currentrun))
		var/datum/thing = currentrun[length(currentrun)]
		currentrun.len--
		if(!ismob(thing))
			if(!QDELETED(thing))
				if(thing.process(wait, times_fired) == PROCESS_KILL)
					stop_processing(thing)
			else
				processing -= thing
			if(MC_TICK_CHECK)
				return
			continue

		var/mob/M = thing

		if(QDELETED(M))
			LOG_DEBUG("SSmobs: QDELETED mob [DEBUG_REF(M)] left in processing list!")
			// We can just go ahead and remove them from all the mob lists.
			GLOB.mob_list -= M
			GLOB.dead_mob_list -= M
			GLOB.living_mob_list -= M

			if (MC_TICK_CHECK)
				return
			continue

		if (!M.frozen)
			M.Life(seconds_per_tick, times_fired)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/proc/get_mannequin(ckey)
	. = mannequins[ckey]
	if (!.)
		. = new /mob/living/carbon/human/dummy/mannequin
		mannequins[ckey] = .

	mannequins_del_timers[ckey] = addtimer(CALLBACK(src, PROC_REF(del_mannequin), ckey), 5 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/datum/controller/subsystem/mobs/proc/del_mannequin(ckey)
	var/mannequin = mannequins[ckey]
	mannequins[ckey] = null
	mannequins -= ckey

	//Remove the deletion timer, if it exists
	if(mannequins_del_timers[ckey])
		deltimer(mannequins_del_timers[ckey])
	mannequins_del_timers[ckey] = null
	mannequins_del_timers -= ckey

	qdel(mannequin)

/**
 * Used to dereference a mannequin, does not delete it per-se
 *
 * * the_mannequin - A `/mob/living/carbon/human/dummy/mannequin` to search for, and dereference if found
 */
/datum/controller/subsystem/mobs/proc/free_mannequin(mob/living/carbon/human/dummy/mannequin/the_mannequin)
	for(var/ckey in mannequins)
		if(mannequins[ckey] == the_mannequin)
			mannequins[ckey] = null
			mannequins -= ckey

			//Remove the deletion timer, if it exists
			if(mannequins_del_timers[ckey])
				deltimer(mannequins_del_timers[ckey])
			mannequins_del_timers[ckey] = null
			mannequins_del_timers -= ckey

// Helper so PROCESS_KILL works.
/datum/controller/subsystem/mobs/proc/stop_processing(datum/D)
	STOP_PROCESSING(src, D)
