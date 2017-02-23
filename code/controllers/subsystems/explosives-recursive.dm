var/datum/subsystem/explosives_recursive/SSkaboom

/datum/subsystem/explosives_recursive
	name = "Explosives (R)"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 1 SECONDS

	var/list/queued_explosions = list()
	var/datum/explosion/recursive/current_explosion = null

	var/tmp/list/start_points = list()
	var/tmp/list/turf/processing_turfs = list()
	var/tmp/list/turf/affected_turfs = list()
	var/tmp/power = 0

/datum/subsystem/explosives_recursive/proc/queue(datum/explosion/recursive/ex)
	if (!ex || !ex.epicenter)
		return
	
	queued_explosions |= ex
	enable()

/datum/subsystem/explosives_recursive/New()
	NEW_SS_GLOBAL(SSkaboom)

/datum/subsystem/explosives_recursive/fire(resumed = FALSE)
	var/ex_sev	// This var is reused a lot because BYOND cannot into proper variable scoping.
	if (!resumed && !current_explosion)
		if (queued_explosions.len)
			current_explosion = queued_explosions[queued_explosions.len]
			queued_explosions.len--

			var/power = current_explosion.power

			// Seed the initial loop.
			var/turf/epicenter = current_explosion.epicenter
			for (var/dir in cardinal)
				var/turf/T = get_step(epicenter, dir)
				T.ex_dir = dir
				start_points += T

			// Calculate the effect on the epicenter tile.
			ex_sev = round(max(min( 3, ((power) / (max(3,(power/3)))) ) ,1), 1)
			epicenter.queued_ex_sev = ex_sev

			for (var/thing in epicenter)
				var/atom/movable/AM = thing
				AM.queued_ex_sev = ex_sev

		else
			disable()

	var/current_power
	var/turf/next
	var/next_dir
	// Branch out each of the cardinal directions.
	while (start_points.len)
		var/turf/start = start_points[start_points.len]

		current_power = power
		processing_turfs += start


		// While this cardinal still has turfs and power...
		while (processing_turfs.len && current_power > 0)
			var/turf/T = processing_turfs[processing_turfs.len]
			processing_turfs.len--

			// If the turf doesn't exist, give up on it and continue.
			if (QDELETED(T))
				continue

			affected_turfs |= T

			// Handle explosion resistance of the turf and its contained atoms.
			current_power -= T.explosion_resistance

			for (var/obj/O in T)
				if (O.explosion_resistance)
					current_power -= T.explosion_resistance

			// If the current power is greater than any previous one that has acted on this object this explosion...
			if (current_power > T.last_ex_pow)
				T.last_ex_pow = power

				// Calculate and queue the explosion severity...
				ex_sev = round(max(min( 3, ((current_power) / (max(3,(power/3)))) ) ,1), 1)
				// Queue the explosion severity, but only if it's more effective.
				if (!T.queued_ex_sev || ex_sev < T.queued_ex_sev)
					T.queued_ex_sev = ex_sev

					// and apply it to the contained atoms.
					for (var/thing in T)
						var/atom/movable/AM = thing
						if (!AM.queued_ex_sev || AM.queued_ex_sev > ex_sev)
							AM.queued_ex_sev = ex_sev
			
			// Spread left.
			next_dir = turn(T.ex_dir, 90)
			next = get_step(T, next_dir)
			next.ex_dir = next_dir
			processing_turfs += next

			// Spread right.
			next_dir = turn(T.ex_dir, -90)
			next = get_step(T, next_dir)
			next.ex_dir = next_dir
			processing_turfs += next

			if (MC_TICK_CHECK)
				return

		processing_turfs = list()

		// Clear the cardinal and move on.
		start_points.len--

	while (affected_turfs.len)
		var/turf/T = affected_turfs[affected_turfs.len]
		affected_turfs.len--

		if (QDELETED(T))
			continue

		// Reset the explosion vars so we don't mess up future explosions.
		ex_sev = T.queued_ex_sev
		T.queued_ex_sev = 0
		T.last_ex_pow = 0
		T.ex_dir = null

		// Apply the explosion to the contained atoms...
		for (var/thing in T)
			var/atom/movable/AM = thing
			AM.ex_act(ex_sev)

		
		// And finally, apply the explosion to the turf itself.
		if (istype(T, /turf/simulated))
			T.ex_act(ex_sev)

		if (MC_TICK_CHECK)
			return

	// Clean up this explosion.
	qdel(current_explosion)
	current_explosion = null

/turf
	var/tmp/last_ex_pow = 0
	var/tmp/queued_ex_sev = 0
	var/tmp/ex_dir

/atom/movable
	var/tmp/queued_ex_sev = 0
