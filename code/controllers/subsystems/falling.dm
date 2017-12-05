#define REMOVE_AND_CONTINUE			\
	falling -= victim;				\
	victim.multiz_falling = 0;		\
	if (MC_TICK_CHECK) return;		\
	continue;

/var/datum/controller/subsystem/falling/SSfalling

/datum/controller/subsystem/falling
	name = "Falling"
	flags = SS_NO_INIT
	wait = 1

	var/list/falling = list()
	var/list/currentrun

/datum/controller/subsystem/falling/New()
	NEW_SS_GLOBAL(SSfalling)

/datum/controller/subsystem/falling/stat_entry()
	..("F:[falling.len]")

/datum/controller/subsystem/falling/fire(resumed = 0)
	if (!resumed)
		currentrun = falling.Copy()

	var/list/curr = currentrun

	while (curr.len)
		var/atom/movable/victim = curr[curr.len]
		curr.len--

		if (QDELETED(victim))
			falling -= victim
			if (MC_TICK_CHECK)
				return
			continue

		// The call_fall checks that are executed for every atom forever. These
		// should not be overwritten/there shouldn't be a need to overwrite them.
		// For specialty conditions, edit CanZPass and can_fall procs.
		if (!isturf(victim.loc))
			REMOVE_AND_CONTINUE

		// Get the below turf.
		var/turf/below = GetBelow(victim)
		if (!below)
			REMOVE_AND_CONTINUE

		// Check if we can fall through the current tile and onto the next one.
		if (!victim.loc:CanZPass(victim, DOWN) || !below.CanZPass(victim, DOWN))
			REMOVE_AND_CONTINUE

		// Check if the victim's current position is affected by gravity.
		if (!victim.loc.loc:has_gravity())
			REMOVE_AND_CONTINUE

		// Thrown objects don't fall, generally speaking.
		if (victim.throwing)
			REMOVE_AND_CONTINUE

		// can_fall check to see if we can fall. Current position is accessible
		// via src.loc, destination by the param. So should be customizable enough.
		if (!victim.can_fall(below))
			// In case the stop is called in a situation when we're already falling.
			// The still want to call fall_impact, due to the fact they've fallen.
			if (falling[victim])
				victim.fall_impact(falling[victim], TRUE)
				victim.fall_collateral(falling[victim], TRUE)

			REMOVE_AND_CONTINUE

		// Iterate the falling counter. This is how many levels the mob has fallen
		// thus far.
		falling[victim]++

		// Open turfs. Handle falling through them.
		// Invokes fall_through() after the atom is moved to
		// its new destination this cycle. Immediately invokes fall_impact and
		// fall_collateral if the next turf is not open space.
		if (isopenturf(victim.loc) && victim.loc:is_hole)
			victim.forceMove(below)

			if (locate(/obj/structure/stairs) in victim.loc)	// If there's stairs, we're probably going down them.
				if (falling[victim] <= 1)	// Just moving down a flight, skip damage.
					victim.multiz_falling = 0
					falling -= victim
				else
					// Falling more than a level, fuck 'em up.
					victim.fall_impact(falling[victim], FALSE)
					victim.fall_collateral(falling[victim], FALSE)
					victim.multiz_falling = 0
					falling -= victim

			else if (isopenturf(victim.loc))
				victim.fall_through()
			else
				// This is a lookahead. It removes any lag from being moved onto
				// the destination turf, and calling fall_impact.
				victim.fall_impact(falling[victim], FALSE)
				victim.fall_collateral(falling[victim], FALSE)
				victim.multiz_falling = 0
				falling -= victim

			if (MC_TICK_CHECK)
				return
			continue

		// This shouldn't actually happen. But for safety, here it is.
		victim.fall_impact(falling[victim], FALSE)
		victim.fall_collateral(falling[victim], FALSE)
		victim.multiz_falling = 0
		falling -= victim

		if (MC_TICK_CHECK)
			return

#undef REMOVE_AND_CONTINUE
