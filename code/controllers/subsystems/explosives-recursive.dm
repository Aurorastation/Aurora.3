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

/datum/subsystem/explosives_recursive/stat_entry()
	..("QE:[queued_explosions.len] S:[start_points.len] PT:[processing_turfs.len] AT:[affected_turfs.len]")

/datum/subsystem/explosives_recursive/fire(resumed = FALSE)
	var/ex_sev	// This var is reused a lot because BYOND cannot into proper variable scoping.
	if (!resumed && !current_explosion)
		if (queued_explosions.len)
			current_explosion = queued_explosions[queued_explosions.len]
			queued_explosions.len--

			log_debug("ExR: Starting processing of new explosion with power [current_explosion.power].")

			// Seed the initial loop.
			var/turf/epicenter = current_explosion.epicenter

			power = current_explosion.power - epicenter.explosion_resistance
			for (var/dir in cardinal)
				var/turf/T = get_step(epicenter, dir)
				T.ex_dir = dir
				start_points += dir

			// Calculate the effect on the epicenter tile.
			ex_sev = round(max(min( 3, ((power - epicenter.explosion_resistance) / (max(3,(power/3)))) ) ,1), 1)
			epicenter.queued_ex_sev = ex_sev

			for (var/thing in epicenter)
				var/atom/movable/AM = thing
				AM.queued_ex_sev = ex_sev

		else
			disable()
			return

	var/current_power
	var/turf/next
	var/next_dir
	// Branch out each of the cardinal directions.
	while (start_points.len)
		var/start_dir = start_points[start_points.len]
		var/turf/start = get_step(current_explosion.epicenter, start_dir)

		current_power = power
		processing_turfs += start

		start.ex_dir = start_points[start_points.len]

		log_debug("ExR: Processing startpoint \ref[start] ([start]), current_power=[current_power],power=[power]")

		var/turfs_processed = 0

		// While this cardinal still has turfs and power...
		while (processing_turfs.len && current_power > 0) 
			var/turf/T = processing_turfs[processing_turfs.len]
			processing_turfs.len--
			turfs_processed++

			// If the turf doesn't exist, give up on it and continue.
			if (QDELETED(T))
				log_debug("ExR (Discovery): Found QDELETED turf! Skipping.")
				continue
			else
				log_debug("ExR: Processing \ref[T] ([T])...")

			affected_turfs |= T

			log_debug("ExR: current_power of \ref[T] ([T]) is [current_power].")

			// Handle explosion resistance of the turf and its contained atoms.
			current_power -= T.explosion_resistance

			for (var/obj/O in T)
				if (O.explosion_resistance)
					current_power -= T.explosion_resistance

			log_debug("ExR: adjusted power of \ref[T] ([T]) is [current_power].")

			// Calculate and queue the explosion severity...
			ex_sev = round(max(min( 3, ((current_power - T.explosion_resistance) / (max(3,(power/3)))) ) ,1), 1)

			log_debug("ExR: Calculated ex_sev is [ex_sev].")

			// If the turf has already been hit by a more powerful explosion, just give up.
			if (T.queued_ex_sev && ex_sev > T.queued_ex_sev)
				log_debug("ExR: Power below threshold ([ex_sev] > [T.queued_ex_sev]), giving up on \ref[T] ([T])!")
				current_power = 0
				if (MC_TICK_CHECK)
					return
				else
					continue

			T.queued_ex_sev = ex_sev

			log_debug("ExR: Power above threshold, applying value [current_power] to \ref[T] ([T])!")

			// and apply it to the contained atoms.
			for (var/thing in T)
				var/atom/movable/AM = thing
				if (AM.simulated && (!AM.queued_ex_sev || AM.queued_ex_sev > ex_sev))
					AM.queued_ex_sev = ex_sev
			
			// Spread left.
			if (!T.ex_dir)
				log_debug("ExR: ex_dir was null! Associated turf: \ref[T] (\the [T])")
			else
				next_dir = turn(T.ex_dir, 90)
				next = get_step(T, next_dir)
				next.ex_dir = next_dir
				log_debug("ExR: Spreading (left) to \the [next] (\ref[next]).")
				processing_turfs |= next

			// Spread right.
			if (!T.ex_dir)
				log_debug("ExR: ex_dir was null! Associated turf: \ref[T] (\the [T])")
			else
				next_dir = turn(T.ex_dir, -90)
				next = get_step(T, next_dir)
				next.ex_dir = next_dir
				log_debug("ExR: Spreading (right) to \the [next] (\ref[next]).")
				processing_turfs |= next

			if (MC_TICK_CHECK)
				return

		log_debug("ExR: Processed [turfs_processed] turfs.")
		processing_turfs = list()

		// Clear the cardinal and move on.
		start_points.len--

	log_debug("ExR: [affected_turfs.len] affected turfs found.")
	while (affected_turfs.len)
		var/turf/T = affected_turfs[affected_turfs.len]
		affected_turfs.len--

		if (QDELETED(T))
			log_debug("ExR (Apply): Found QDELETED turf! Skipping.")
			continue

		// Reset the explosion vars so we don't mess up future explosions.
		ex_sev = T.queued_ex_sev
		T.queued_ex_sev = 0
		T.ex_dir = null

		var/atom_sev = ""
		// Apply the explosion to the contained atoms...
		for (var/thing in T)
			var/atom/movable/AM = thing
			if (AM.simulated && AM.queued_ex_sev)
				//AM.ex_act(AM.queued_ex_sev)
				atom_sev += "\ref[AM] ([AM] - [AM.type]) - [AM.queued_ex_sev]<br>"

			
		// And finally, apply the explosion to the turf itself.
		if (istype(T, /turf/simulated))
			//T.ex_act(ex_sev)
			var/obj/item/toy/nanotrasenballoon/balloon = new
			balloon.name = "Severity: [ex_sev ? ex_sev : "None!"]"
			balloon.desc = "Atoms: <br>[length(atom_sev) ? atom_sev : "None!"]"
			balloon.desc += "This turf: [ex_sev ? ex_sev : "None!"]"
			balloon.forceMove(T)


		if (MC_TICK_CHECK)
			return

	// Clean up this explosion.
	qdel(current_explosion)
	current_explosion = null

/turf
	var/tmp/queued_ex_sev = 0
	var/tmp/ex_dir

/atom/movable
	var/tmp/queued_ex_sev = 0
