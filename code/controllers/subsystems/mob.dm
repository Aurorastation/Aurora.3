/var/datum/controller/subsystem/mobs/SSmob

/datum/controller/subsystem/mobs
	name = "Mobs - Life"
	init_order = SS_INIT_MISC	// doesn't really matter when we init
	priority = SS_PRIORITY_MOB

	var/list/slept = list()

	var/list/currentrun = list()
	var/list/all_mice = list()	// Contains all *living* mice.
	var/list/mannequins = list()	//Contains all mannequins used by character preview
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
		/mob/living/simple_animal/penguin/holodeck
	)

/datum/controller/subsystem/mobs/New()
	NEW_SS_GLOBAL(SSmob)

/datum/controller/subsystem/mobs/Initialize()
	// Some setup work for the eat-types lists.
	mtl_synthetic = typecacheof(mtl_synthetic) + list(
		/mob/living/simple_animal/hostile/retaliate/malf_drone = TRUE,
		/mob/living/simple_animal/hostile/viscerator = TRUE,
		/mob/living/simple_animal/spiderbot = TRUE
	)

	mtl_weird = typecacheof(mtl_weird) + list(
		/mob/living/simple_animal/adultslime = TRUE
	)

	mtl_humanoid = typecacheof(mtl_humanoid)

	mtl_incorporeal = typecacheof(mtl_incorporeal)

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
