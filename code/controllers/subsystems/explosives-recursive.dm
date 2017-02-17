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

/datum/subsystem/explosives_recursive/New()
	NEW_SS_GLOBAL(SSkaboom)

/datum/subsystem/explosives_recursive/fire(resumed = FALSE)
	if (!resumed && !current_explosion)
		if (queued_explosions.len)
			current_explosion = queued_explosions[queued_explosions.len]
			queued_explosions.len--
			
			current_power = current_explosion.power

			// Seed the initial loop.
			var/epicenter = current_explosion.epicenter
			for (var/dir in cardinal)
				var/turf/T = get_step(epicenter, dir)
				T.ex_dir = dir
				start_points += T

		else
			disable()

	var/ex_sev
	var/current_power
	var/turf/next
	var/next_dir
	while (start_points.len)
		var/turf/start = start_points[start_points.len]

		current_power = power
		processing_turfs += start

		while (processing_turfs.len && current_power > 0)
			var/turf/T = processing_turfs[processing_turfs.len]
			processing_turfs.len--

			if (QDELETED(T))
				continue

			affected_turfs |= T

			if (current_power > T.last_ex_pow)
				T.last_ex_pow = power

			current_power -= T.explosion_resistance

			for (var/obj/O in T)
				if (O.explosion_resistance)
					current_power -= T.explosion_resistance

			ex_sev = round(max(min( 3, ((current_power) / (max(3,(power/3)))) ) ,1), 1)
			if (!T.queued_ex_sev || ex_sev < T.queued_ex_sev)
				T.queued_ex_sev = ex_sev

			for (var/atom/A in T)
				if (!A.queued_ex_sev || A.queued_ex_sev > ex_sev)
					A.queued_ex_sev = ex_sev
			
			next_dir = turn(T.ex_dir, 90)
			next = get_step(T, next_dir)
			next.ex_dir = next_dir
			processing_turfs += next

			next_dir = turn(T.ex_dir, -90)
			next = get_step(T, next_dir)
			next.ex_dir = next_dir
			processing_turfs += next

			if (MC_TICK_CHECK)
				return

		processing_turfs = list()

		start_points.len--

	while (affected_turfs.len)
		var/turf/T = affected_turfs[affected_turfs.len]
		affected_turfs.len--

		if (QDELETED(T))
			continue

		// Reset the explosion vars.
		var/ex_sev = T.queued_ex_sev
		T.queued_ex_sev = 0
		T.last_ex_pow = 0
		T.ex_dir = null

		for (var/thing in T)
			var/atom/movable/AM = thing
			AM.ex_act(ex_sev)

		if (istype(T, /turf/simulated))
			T.ex_act(queued_ex_sev)

		if (MC_TICK_CHECK)
			return

	qdel(current_explosion)
	current_explosion = null

/turf
	var/tmp/last_ex_pow = 0
	var/tmp/queued_ex_sev = 0
	var/tmp/ex_dir

/atom/movable
	var/tmp/queued_ex_sev = 0
