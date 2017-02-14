var/datum/subsystem/effects/SSeffects

/datum/subsystem/effects
	name = "Effects Master"
	wait = 2
	flags = SS_BACKGROUND | SS_NO_INIT
	display_order = SS_DISPLAY_EFFECTS

	var/list/datum/effect_system/effects_objects = list()	// The effect-spawning objects. Shouldn't be many of these.
	var/list/obj/visual_effect/effects_visuals	= list()	// The visible component of an effect. May be created without an effect object.

	var/tmp/list/processing_effects = list()
	var/tmp/list/processing_visuals = list()

/datum/subsystem/effects/New()
	NEW_SS_GLOBAL(SSeffects)

/datum/subsystem/effects/fire(resumed = FALSE)
	if (!resumed)
		processing_effects = effects_objects
		effects_objects = list()
		processing_visuals = effects_visuals
		effects_visuals = list()

	while (processing_effects.len)
		var/datum/effect_system/E = processing_effects[processing_effects.len]
		processing_effects.len--

		if (QDELETED(E))
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
				qdel(V)
		
		if (MC_TICK_CHECK)
			return

	if (!effects_objects.len && !effects_visuals.len && !processing_effects.len && !processing_visuals.len)
		disable()

/datum/subsystem/effects/proc/queue(var/datum/effect_system/E)
	if (QDELETED(E))
		return
		
	effects_objects += E
	enable()

/datum/subsystem/effects/proc/queue_simple(var/obj/visual_effect/V)
	if (QDELETED(V))
		return

	effects_visuals += V
	enable()

/datum/subsystem/effects/stat_entry()
	..()
	stat(null, "[effects_objects.len] effects queued, [processing_effects.len] processing")
	stat(null, "[effects_visuals.len] visuals queued, [processing_visuals.len] processing")

/datum/subsystem/effects/Recover()
	src.effects_objects = SSeffects.effects_objects
	src.effects_visuals = SSeffects.effects_visuals
