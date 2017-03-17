var/datum/controller/subsystem/explosives_simple/SSboom

/datum/controller/subsystem/explosives_simple
	name = "Explosives (S)"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 1 SECONDS

	var/list/queued_explosives = list()
	var/tmp/list/discovering_explosives = list()	// Explosives that still need to discover their affected turfs.
	var/tmp/list/exploding_explosives = list()		// Explosions that are ready to process their explosion.

/datum/controller/subsystem/explosives_simple/proc/queue(datum/explosion/circular/ex)
	if (!ex || !ex.epicenter)
		return

	queued_explosives |= ex
	enable()

/datum/controller/subsystem/explosives_simple/New()
	NEW_SS_GLOBAL(SSboom)

/datum/controller/subsystem/explosives_simple/stat_entry()
	..("D:[discovering_explosives.len] E:[exploding_explosives.len]")

/datum/controller/subsystem/explosives_simple/fire(resumed = FALSE)
	var/list/discover_queue = discovering_explosives
	var/list/explode_queue = exploding_explosives

	// Discover the turfs that we could potentially affect.
	while (discover_queue.len)
		var/datum/explosion/circular/E = discover_queue[discover_queue.len]
		discover_queue.len--

		if (QDELETED(E) || !E.epicenter || !istype(E))
			continue

		var/max_r = max(E.devastation_range, E.heavy_impact_range, E.light_impact_range)
		var/list/turf/turfs = RANGE_TURFS(max_r, E.epicenter)

		if (!turfs)
			CRASH("Explosion with no turfs!")

		for (var/theTurf in turfs)
			var/turf/T = theTurf
			LAZYINITLIST(T.associated_explosions)
			T.associated_explosions += E
		
		E.affecting_turfs = turfs
		exploding_explosives += E

		if (MC_TICK_CHECK)
			return

	// Blow shit up.
	while (explode_queue.len)
		var/datum/explosion/circular/E = explode_queue[explode_queue.len]
		explode_queue.len--

		var/start_time = world.time

		var/epiX = E.epicenter.x
		var/epiY = E.epicenter.y

		var/list/turfs = E.affecting_turfs
		while (turfs.len)
			var/turf/T = turfs[turfs.len]
			turfs.len--

			var/ex_sev = sqrt((T.x - epiX)**2 + (T.y - epiY)**2)
			if (ex_sev < E.devastation_range)
				ex_sev = 1
			else if (ex_sev < E.heavy_impact_range)
				ex_sev = 2
			else if (ex_sev < E.light_impact_range)
				ex_sev = 3
			else
				continue

			if (istype(T, /turf/simulated))
				T.ex_act(ex_sev)

			var/list/contents = T.contents.Copy()
			while (contents.len)
				var/atom/movable/AM = contents[contents.len]
				contents.len--

				AM.ex_act(ex_sev)

			var/took = world.time - start_time
			took /= 10

			for (var/D in doppler_arrays)
				var/obj/machinery/doppler_array/DA = D
				if (QDELETED(DA))
					continue

				DA.sense_explosion(epiX, epiY, E.epicenter.z, E.devastation_range, E.heavy_impact_range, E.light_impact_range, took)

			if (MC_TICK_CHECK)
				return

/turf
	var/list/datum/explosion/circular/associated_explosions
