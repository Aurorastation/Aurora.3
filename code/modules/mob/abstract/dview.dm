//DVIEW is a hack that uses a mob with darksight in order to find lists of viewable stuff while ignoring darkness
// Defines for dview are elsewhere.

GLOBAL_DATUM_INIT(dview_mob, /mob/abstract/dview, new)

/mob/abstract/dview
	see_in_dark = 1e6

/mob/abstract/dview/Initialize()
	. = ..()
	// We don't want to be in any mob lists; we're a dummy not a mob.
	GLOB.mob_list -= src
	if(stat == DEAD)
		GLOB.dead_mob_list -= src
	else
		GLOB.living_mob_list -= src

/mob/abstract/dview/Destroy(force = FALSE)
	SHOULD_CALL_PARENT(FALSE)
	crash_with("Some fuck [force ? "force-" : ""]qdeleted the dview mob.")
	if (!force)
		return QDEL_HINT_LETMELIVE

	world.log <<  "Dview was force-qdeleted, this should never happen!"

	GLOB.dview_mob = new
	return QDEL_HINT_QUEUE
