/datum/event/grav_anomaly
	announceWhen = 5
	ic_name = "a gravitational anomaly"
	var/list/valid_victims
	var/nausea_mild_organic = list(
		"You feel a sudden lurching in your guts and inner ear.",
		"You suddenly feel a nauseating sense of vertigo.",
		"An overwhelming sense of nausea briefly makes you dizzy."
		)
	var/nausea_mild_ipc = list(
		"Your proprioceptive faculties briefly surge with misinputs.",
		"With a lurch, it feels like you briefly lose any sense of gyroscopic orientation.",
		"Your visual input registers normal, but your cognition insists the room is spinning rapidly."
		)
	var/nausea_strong_organic = list(
		"A huge surge of a sick feeling rises in your gorge.",
		"You suddenly feel like you've been spinning in circles for an hour straight.",
		"Your inner ear and your brain are screaming at you to stop rotating, but you're not."
		)
	var/nausea_strong_ipc = list(
		"ERR: GYROSCOPIC ARRAY COMPILER RETURNING VALUES OF INVALID TYPE",
		"ERR: CRITICAL DESYNCHRONIZATION IN PRIMARY AND SECONDARY MOTOR FUNCTIONAL POSITIONAL FEEDBACK",
		"ERR: SENSORY FACULTIES ENCOUNTERING MULTIPLE VALUE DISCONTINUITIES"
		)

/datum/event/grav_anomaly/setup()
	endWhen = rand(120, 180)

/datum/event/grav_anomaly/announce()
	command_announcement.Announce(
		"Feedback surge detected in gravity generation systems due to unexpected influx of dark matter. Instability to be expected until clear of the effect; gravity generator shutdown recommended for the duration of the effect.",
		"Dark Matter Influx",
		zlevels = affecting_z
		)

/datum/event/grav_anomaly/start()
	..()
	valid_victims = list()
	for(var/mob/living/carbon/human/victim in GLOB.player_list)
		// We don't bother excluding players not on the Horizon here; we check for that whenever we're going to potentially shove them around.
		// This way, someone entering or leaving the Horizon z-levels will be affected by the event appropriately.
		valid_victims += victim
		if(!(victim.z in affecting_z))
			continue
		if(isipc(victim))
			to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_mild_ipc)))
		else
			to_chat(victim, SPAN_WARNING(pick(nausea_mild_organic)))

/datum/event/grav_anomaly/end(faked)
	..()
	valid_victims = null

/datum/event/grav_anomaly/tick()
	..()

	var/current_victims
	var/current_effect
	var/dice_roll = rand(1,100)
	/// Check if we're going to even do anything this tick. If not, don't bother checking for current victims.
	/// Ditto if the gravity generator is off.
	switch(dice_roll)
		if(1 to 70)		current_effect = null
		if(71 to 80)	current_effect = "nausea_minor"
		if(81 to 88)	current_effect = "nausea_mild"
		if(89 to 94)	current_effect = "nausea_strong"
		if(95 to 99)	current_effect = "surge_default"
		if(99 to 100)	current_effect = "surge_hilarious"

	if(!current_effect)
		return

	for(var/obj/machinery/gravity_generator/main/grav_gen in SSmachinery.gravity_generators)
		if(!(grav_gen?.z in affecting_z))
			return
		else if(!grav_gen?.on)
			return

	for(var/mob/living/carbon/human/potential_victim in valid_victims)
		// Have they entered or left the Horizon? Skip if not aboard.
		if(!(potential_victim.z in affecting_z))
			continue
		// Is there gravity where they are? IE. is the grav generator on/off OR are they on the holodeck w/ zero gravity, OR are they EVA? Skip if no artificial gravity for whatever reason.
		if(!potential_victim.has_gravity())
			continue
		current_victims += potential_victim

	for(var/mob/living/carbon/human/victim in current_victims)
		switch(current_effect)
			if("nausea_minor")
				victim.dizziness += rand(2,4)
				victim.confused += rand(2,4)
				to_chat(victim, SPAN_WARNING(pick(
					"You feel the deck lurch beneath you.",
					"The world feels like it's tilting madly.",
					"An illusory sense of your center of gravity shifting briefly comes over you."
					)))

			if("nausea_mild")
				victim.dizziness += rand(4,10)
				victim.confused += rand(4,10)
				if(isipc(victim))
					to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_mild_ipc)))
				else
					to_chat(victim, SPAN_WARNING(pick(nausea_mild_organic)))
					if(prob(5))
						victim.vomit()

			if("nausea_strong")
				victim.dizziness += rand(8,15)
				victim.confused += rand(8,15)
				if(isipc(victim))
					to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_strong_ipc)))
				else
					to_chat(victim, SPAN_WARNING(pick(nausea_strong_organic)))
					if(prob(10))
						victim.vomit()

			// Copypaste job from shuttle movements in 'code\modules\shuttles\helm.dm
			if("surge_default")
				victim.dizziness += rand(4,10)
				victim.confused += rand(4,10)
				if(isipc(victim))
					to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_strong_ipc)))
				else
					to_chat(victim, SPAN_WARNING(pick(nausea_strong_organic)))
					if(prob(25))
						victim.vomit()
				if(prob(60))
					if(victim.buckled_to)
						to_chat(victim, SPAN_WARNING("Sudden gravity flux presses you into your chair!"))
						shake_camera(victim, 3, 1)
					else if(victim.Check_Shoegrip(FALSE))
						to_chat(victim, SPAN_WARNING("You feel immense pressure in your feet as the artificial gravity surges!"))
						victim.apply_damage(10, DAMAGE_PAIN, BP_L_FOOT)
						victim.apply_damage(10, DAMAGE_PAIN, BP_R_FOOT)
						shake_camera(victim, 5, 1)
					else
						to_chat(victim, SPAN_WARNING("The floor lurches beneath you!"))
						shake_camera(victim, 10, 1)
						victim.visible_message(SPAN_DANGER("[victim.name] is tossed around by a sudden knot in the artifical gravity field!"))
						victim.throw_at_random(FALSE, 4, 1)
						victim.Weaken(3)

			if("surge_hilarious")
				victim.dizziness += rand(8,15)
				victim.confused += rand(8,15)
				if(isipc(victim))
					to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_strong_ipc)))
				else
					to_chat(victim, SPAN_WARNING(pick(nausea_strong_organic)))
					if(prob(33))
						victim.vomit()
				if(prob(60))
					if(victim.buckled_to)
						to_chat(victim, SPAN_WARNING("Sudden gravity flux rattles you in your chair!"))
						shake_camera(victim, 5, 2)
					else if(victim.Check_Shoegrip(FALSE))
						victim.apply_damage(20, DAMAGE_PAIN, BP_L_FOOT)
						victim.apply_damage(10, DAMAGE_BRUTE, BP_L_FOOT)
						victim.apply_damage(20, DAMAGE_PAIN, BP_R_FOOT)
						victim.apply_damage(10, DAMAGE_BRUTE, BP_R_FOOT)
						to_chat(victim, SPAN_WARNING("You feel like your ankles are about to be ripped apart as the artificial gravity surges!"))
						shake_camera(victim, 8, 2)
					else
						victim.visible_message(SPAN_DANGER("[victim.name] is flung violently by a horrible gravity flux!"))
						victim.Weaken(8)
						if(prob(90))
							victim.throw_at_random(FALSE, 7, 1)
						else
							victim.fall_impact(1)

/datum/event/grav_anomaly/announce_end()
	. = ..()
	if(.)
		command_announcement.Announce("Gravimetric sensors indicate reduced levels of dark matter flux; artificial gravity is now safe for regular use.", "Dark Matter Influx", zlevels = affecting_z)
