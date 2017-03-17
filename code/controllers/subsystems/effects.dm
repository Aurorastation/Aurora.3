var/datum/controller/subsystem/effects/SSeffects

/datum/controller/subsystem/effects
	name = "Effects Master"
	wait = 2
	flags = SS_BACKGROUND | SS_NO_INIT

	var/list/datum/effect_system/effects_objects = list()	// The effect-spawning objects. Shouldn't be many of these.
	var/list/obj/visual_effect/effects_visuals	= list()	// The visible component of an effect. May be created without an effect object.

	var/tmp/list/processing_effects = list()
	var/tmp/list/processing_visuals = list()

/datum/controller/subsystem/effects/New()
	NEW_SS_GLOBAL(SSeffects)

/datum/controller/subsystem/effects/fire(resumed = FALSE)
	if (!resumed)
		processing_effects = effects_objects
		effects_objects = list()
		processing_visuals = effects_visuals.Copy()

	var/list/current_effects = processing_effects
	var/list/current_visuals = processing_visuals

	while (current_effects.len)
		var/datum/effect_system/E = current_effects[current_effects.len]
		current_effects.len--

		if (QDELETED(E))
			continue

		switch (E.process())
			if (EFFECT_CONTINUE)
				effects_objects += E

			if (EFFECT_DESTROY)
				qdel(E)

		if (MC_TICK_CHECK)
			return

	while (current_visuals.len)
		var/obj/visual_effect/V = current_visuals[current_visuals.len]
		current_visuals.len--

		if (!V || V.gcDestroyed)
			effects_visuals -= V
			continue

		switch (V.tick())
			if (EFFECT_HALT)
				effects_visuals -= V

			if (EFFECT_DESTROY)
				effects_visuals -= V
				qdel(V)
		
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/effects/proc/queue(var/datum/effect_system/E)
	if (QDELETED(E))
		return
		
	effects_objects += E

/datum/controller/subsystem/effects/proc/queue_simple(var/obj/visual_effect/V)
	if (QDELETED(V))
		return

	effects_visuals += V

/datum/controller/subsystem/effects/stat_entry()
	..("E:[effects_objects.len] V:[effects_visuals.len]")

/datum/controller/subsystem/effects/Recover()
	if (istype(SSeffects))
		src.effects_objects = SSeffects.effects_objects
		src.effects_visuals = SSeffects.effects_visuals

		src.effects_objects |= SSeffects.processing_effects
		src.effects_visuals |= SSeffects.processing_visuals
