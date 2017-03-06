//DVIEW is a hack that uses a mob with darksight in order to find lists of viewable stuff while ignoring darkness
// Defines for dview are elsewhere.

var/mob/dview/dview_mob = new

/mob/dview
	invisibility = 101
	density = 0

	anchored = 1
	simulated = 0

	see_in_dark = 1e6

/mob/dview/New()
	..()
	// We don't want to be in any mob lists; we're a dummy not a mob.
	mob_list -= src
	if(stat == DEAD)
		dead_mob_list -= src
	else
		living_mob_list -= src

/mob/dview/Destroy(force = FALSE)
	stack_trace("Some idiot deleted the dview.")
	if (!force)
		return QDEL_HINT_LETMELIVE

	world.log << "Some idiot force-deleted dview."
	
	dview_mob = new
	return QDEL_HINT_QUEUE
