#define STAGE_IDLE 0
#define STAGE_EFFECT 1
#define STAGE_SUBEFFECT 2

var/datum/controller/process/effects/effect_master

/var/list/datum/effect_system/effects_objects = list()	// The effect-spawning objects. Shouldn't be many of these.
/var/list/obj/visual_effect/effects_visuals	= list()	// The visible component of an effect. Should be created by effect objects.

/datum/controller/process/effects
	var/tmp/list/processing_effects = list()
	var/tmp/list/processing_visuals = list()
	var/tmp/stage = STAGE_IDLE

/datum/controller/process/effects/setup()
	effect_master = src
	name = "effects"
	schedule_interval = 2
	tick_allowance = 15

/datum/controller/process/effects/doWork()
	if (stage == STAGE_IDLE)
		// Start a new work cycle.
		processing_effects = effects_objects
		effects_objects = list()
		stage = STAGE_EFFECT

	// These effects are likely to only exist for their first tick, optimize for EFFECT_HALT and EFFECT_DESTROY.
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

		F_SCHECK

	if (stage == STAGE_EFFECT)
		processing_visuals = effects_visuals
		stage = STAGE_SUBEFFECT

	// These effects are likely to exist for multiple ticks, optimize for EFFECT_CONTINUE.
	while (processing_visuals.len)
		var/obj/visual_effect/V = processing_visuals[processing_visuals.len]
		processing_visuals.len--

		if (!V || V.gcDestroyed)
			effects_visuals -= V
			continue

		switch (V.tick())
			if (EFFECT_HALT)
				effects_visuals -= V

			/*if (EFFECT_CONTINUE)
				effects_visuals += V*/

			if (EFFECT_DESTROY)
				effects_visuals -= V
				V.loc = null
				returnToPool(V)

	stage = STAGE_IDLE

	// We're done.
	if (!processing_effects.len && !processing_visuals.len && !effects_objects.len && !effects_visuals.len)
		world.log << "## DEBUG: Effects processor going to sleep."
		disable()

/datum/controller/process/effects/proc/queue(var/datum/effect_system/E)
	if (!E || E.gcDestroyed)
		return

	world.log << "## DEBUG: Queueing new effect: qelen=[effects_objects.len],pelen=[processing_effects.len],has_holder=[E.holder ? 1 : 0]"
		
	effects_objects += E
	enable()

/datum/controller/process/effects/statProcess()
	..()
	stat(null, "Effect process is [disabled ? "sleeping" : "processing"].")
	stat(null, "[effects_objects.len] effects queued, [processing_effects.len] processing")
	stat(null, "[effects_visuals.len] visuals queued, [processing_visuals.len] processing")
