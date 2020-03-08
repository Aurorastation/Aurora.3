//DVIEW is a hack that uses a mob with darksight in order to find lists of viewable stuff while ignoring darkness
// Defines for dview are elsewhere.

var/mob/abstract/dview/dview_mob = new

/mob/abstract/dview
	see_in_dark = 1e6

/mob/abstract/dview/Initialize()
	. = ..()
	// We don't want to be in any mob lists; we're a dummy not a mob.
	mob_list -= src
	if(stat == DEAD)
		dead_mob_list -= src
	else
		living_mob_list -= src

/mob/abstract/dview/Destroy(force = FALSE)
	SHOULD_CALL_PARENT(FALSE)
	crash_with("Some fuck [force ? "force-" : ""]qdeleted the dview mob.")
	if (!force)
		return QDEL_HINT_LETMELIVE

	world.log <<  "Dview was force-qdeleted, this should never happen!"

	dview_mob = new
	return QDEL_HINT_QUEUE
