// These are objects you can use inside special maps (like PoIs), or for adminbuse.
// Players cannot see or interact with these.
/obj/effect/map_effect
	anchored = TRUE
	invisibility = 99 // So a badmin can go view these by changing their see_invisible.
	icon = 'icons/effects/map_effects.dmi'

	// Below vars concern check_for_player_proximity() and is used to not waste effort if nobody is around to appreciate the effects.
	var/always_run = FALSE				// If true, the game will not try to suppress this from firing if nobody is around to see it.
	var/proximity_needed = 12			// How many tiles a mob with a client must be for this to run.
	var/ignore_ghosts = FALSE			// If true, ghosts won't satisfy the above requirement.
	var/ignore_afk = TRUE				// If true, AFK people (5 minutes) won't satisfy it as well.
	var/retry_delay = 5 SECONDS			// How long until we check for players again.
	var/next_attempt = 0				// Next time we're going to do ACTUAL WORK

/obj/effect/map_effect/ex_act()
	return

/obj/effect/map_effect/singularity_pull()
	return

/obj/effect/map_effect/singularity_act()
	return

// Base type for effects that run on variable intervals.
/obj/effect/map_effect/interval
	var/interval_lower_bound = 5 SECONDS // Lower number for how often the map_effect will trigger.
	var/interval_upper_bound = 5 SECONDS // Higher number for above.

/obj/effect/map_effect/interval/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/effect/map_effect/interval/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

// Override this for the specific thing to do.
/obj/effect/map_effect/interval/proc/trigger()
	return

// Handles the delay and making sure it doesn't run when it would be bad.
/obj/effect/map_effect/interval/process()
	//Not yet!
	if(world.time < next_attempt)
		return

	// Check to see if we're useful first.
	if(!always_run && !check_for_player_proximity(src, proximity_needed, ignore_ghosts, ignore_afk))
		next_attempt = world.time + retry_delay
	// Hey there's someone nearby.
	else
		next_attempt = world.time + rand(interval_lower_bound, interval_upper_bound)
		trigger()

// Helper proc to optimize the use of effects by making sure they do not run if nobody is around to perceive it.
/proc/check_for_player_proximity(var/atom/proximity_to, var/radius = 12, var/ignore_ghosts = FALSE, var/ignore_afk = TRUE)
	if(!proximity_to)
		return FALSE

	for(var/thing in GLOB.player_list)
		var/mob/M = thing // Avoiding typechecks for more speed, player_list will only contain mobs anyways.
		if(ignore_ghosts && isobserver(M))
			continue
		if(ignore_afk && M.client && M.client.is_afk(5 MINUTES))
			continue
		if(M.z == proximity_to.z && get_dist(M, proximity_to) <= radius)
			return TRUE
	return FALSE
