/obj/visual_effect
	name = "effect"
	anchored = 1
	simulated = 0
	mouse_opacity = 0
	var/life_ticks			// How many ticks this effect will life before it stops processing.
	var/life_ticks_max		// The high limit for the random tick picker.
	var/life_ticks_min		// The low limit for the random tick picker.

/obj/visual_effect/New(var/life_min = 20, var/life_max = 30)
	..()
	life_ticks_min = life_min
	life_ticks_max = life_max
	setup()

/obj/visual_effect/proc/setup()
	life_ticks = rand(life_ticks_min, life_ticks_max)

/obj/visual_effect/resetVariables()
	..()
	setup()

// Called every effects processor tick. Return value determines what the process does to this object.
/obj/visual_effect/proc/tick()
	. = EFFECT_CONTINUE
	if (!life_ticks)	
		return EFFECT_DESTROY

	life_ticks--

/obj/visual_effect/Destroy()
	// ¯\_(ツ)_/¯
