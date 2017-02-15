/obj/visual_effect
	name = "effect"
	anchored = 1
	simulated = 0
	mouse_opacity = 0
	var/life_ticks			// How many ticks this effect will life before it stops processing.
	var/life_ticks_max		// The high limit for the random tick picker.
	var/life_ticks_min		// The low limit for the random tick picker.

/obj/visual_effect/New(var/life_min = 3 SECONDS, var/life_max = 5 SECONDS)
	..()
	life_ticks_min = life_min
	life_ticks_max = life_max
	life_ticks = rand(life_ticks_min, life_ticks_max)
	// Reset the animation.
	flick(icon_state, src)

// Called when the visual_effect is manifested.
/obj/visual_effect/proc/start()
	return

// Called every effects processor tick. Return value determines what the process does to this object.
/obj/visual_effect/proc/tick()
	if (!life_ticks)	
		return EFFECT_DESTROY

	life_ticks--
	return EFFECT_CONTINUE

/obj/visual_effect/Destroy()
	// ¯\_(ツ)_/¯
	// This runtimes in expansions.dm if ..() is called.
	SSeffects.effects_visuals -= src
	return ..()
