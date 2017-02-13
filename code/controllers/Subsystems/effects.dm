var/datum/subsystem/effects/effect_master

/var/list/datum/effect_system/effects_objects = list()	// The effect-spawning objects. Shouldn't be many of these.
/var/list/obj/visual_effect/effects_visuals	= list()	// The visible component of an effect. May be created without an effect object.

/datum/subsystem/effects
	name = "Effects Master"
	wait = 2
	flags = SS_BACKGROUND | SS_NO_INIT

	var/tmp/list/processing_effects = list()
	var/tmp/list/processing_visuals = list()

/datum/subsystem/effects/New()
	NEW_SS_GLOBAL(effect_master)

/datum/subsystem/effects/fire(resumed = FALSE)
	if (!resumed)
		processing_effects = effects_objects
		effects_objects = list()
		processing_visuals = effects_visuals
		effects_visuals = list()

	while (processing_effects.len)
		var/datum/effect_system/E = processing_effects[processing_effects.len]
		processing_effects.len--

		if (!E || E.gcDestroyed)
			continue

		switch (E.process())
			if (EFFECT_CONTINUE)
				effects_objects += E

			if (EFFECT_DESTROY)
				qdel(E)

		if (MC_TICK_CHECK)
			return

	while (processing_visuals.len)
		var/obj/visual_effect/V = processing_visuals[processing_visuals.len]
		processing_visuals.len--

		if (!V || V.gcDestroyed)
			effects_visuals -= V
			continue

		switch (V.tick())
			if (EFFECT_CONTINUE)
				effects_visuals += V

			if (EFFECT_DESTROY)
				effects_visuals -= V
				V.end()
				qdel(V)
		
		if (MC_TICK_CHECK)
			return

	if (!effects_objects.len && !effects_visuals.len && !processing_effects.len && !processing_visuals.len)
		can_fire = FALSE

/datum/subsystem/effects/proc/queue(var/datum/effect_system/E)
	if (!E || E.gcDestroyed)
		return
		
	effects_objects += E
	can_fire = TRUE
	next_fire = world.time + wait

/datum/controller/process/effects/proc/queue_simple(var/obj/visual_effect/V)
	if (!V || V.gcDestroyed)
		return

	effects_visuals += V
	can_fire = TRUE
	next_fire = world.time + wait

/datum/controller/process/effects/statProcess()
	..()
	stat(null, "Effect process is [disabled ? "sleeping" : "processing"].")
	stat(null, "[effects_objects.len] effects queued, [processing_effects.len] processing")
	stat(null, "[effects_visuals.len] visuals queued, [processing_visuals.len] processing")
