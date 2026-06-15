/datum/event/gravity_anomaly
	announceWhen = 0
	startWhen = 90 SECONDS
	endWhen = 60 SECONDS // Actually gets set in setup()
	ic_name = "a gravitational anomaly"
	var/list/valid_victims
	has_skybox_image = TRUE
	var/global/lightning_color
	var/next_camera_drift = 0
	var/next_gravity_surge = 0
	var/nausea_minor = list(
		"You feel the deck lurch beneath you.",
		"The world feels like it's tilting madly.",
		"An illusory sense of your center of gravity shifting briefly comes over you."
		)
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

/datum/event/gravity_anomaly/setup()
	endWhen = rand(5 MINUTES, 25 MINUTES)

/datum/event/gravity_anomaly/announce()
	command_announcement.Announce(
		"Feedback surge detected in gravity generation systems due to influx of dark matter. Instability to be expected until clear of the effect; gravity shutdown recommended for the duration of the effect.",
		"Dark Matter Influx",
		zlevels = affecting_z
		)

/datum/event/gravity_anomaly/start()
	..()
	next_camera_drift = activeFor
	schedule_next_gravity_surge()
	valid_victims = list()
	for(var/mob/living/carbon/human/victim in GLOB.player_list)
		// We don't bother excluding players not on the Horizon here; we check for that whenever we're going to potentially shove them around.
		// This way, someone entering or leaving the Horizon z-levels will be affected by the event appropriately.
		valid_victims += victim
		if(!(victim.z in affecting_z))
			continue
		notify_victim_of_start(victim)

/datum/event/gravity_anomaly/end(faked)
	valid_victims?.Cut()
	..()

/datum/event/gravity_anomaly/get_skybox_image()
	if(!lightning_color)
		lightning_color = pick( "#aa11ee")
	var/image/res = overlay_image('icons/skybox/electrobox.dmi', "lightning", lightning_color, RESET_COLOR)
	res.blend_mode = BLEND_ADD
	return res

/datum/event/gravity_anomaly/tick()
	..()

	if(!has_active_gravity_generator())
		return

	var/list/current_victims = get_current_victims()
	if(!length(current_victims))
		return

	if(activeFor >= next_camera_drift)
		apply_camera_drift(current_victims)
		next_camera_drift = activeFor + rand(2, 4)

	for(var/mob/living/carbon/human/victim in current_victims)
		var/current_effect = pick_victim_disturbance()
		if(current_effect)
			apply_effect(victim, current_effect)

/datum/event/gravity_anomaly/proc/notify_victim_of_start(var/mob/living/carbon/human/victim)
	if(isipc(victim))
		to_chat(victim, SPAN_MACHINE_WARNING("Your proprioceptive faculties briefly surge with misinputs; something is definitely Wrong with the gravity."))
	else
		to_chat(victim, SPAN_WARNING("You suddenly feel a nauseating sense of vertigo; something is definitely Wrong with the gravity."))

/datum/event/gravity_anomaly/proc/has_active_gravity_generator()
	for(var/obj/structure/machinery/gravity_generator/main/grav_gen in SSmachinery.gravity_generators)
		if(!(grav_gen?.z in affecting_z))
			continue
		if(grav_gen.on)
			return TRUE
	return FALSE

/datum/event/gravity_anomaly/proc/pick_victim_disturbance()
	if(activeFor >= next_gravity_surge && prob(50))
		schedule_next_gravity_surge()
		if(prob(10))
			return "surge_hilarious"
		return "surge_default"

	switch(rand(1,100))
		if(1 to 20)
			return "nausea_minor"
		if(21 to 28)
			return "nausea_mild"
		if(29 to 31)
			return "nausea_strong"
		else
			return null

/datum/event/gravity_anomaly/proc/schedule_next_gravity_surge()
	next_gravity_surge = activeFor + rand(20, 60)

/datum/event/gravity_anomaly/proc/get_current_victims()
	var/list/current_victims = list()
	for(var/mob/living/carbon/human/potential_victim in valid_victims)
		if(can_affect_victim(potential_victim))
			current_victims += potential_victim
	return current_victims

/datum/event/gravity_anomaly/proc/can_affect_victim(var/mob/living/carbon/human/potential_victim)
	if(!potential_victim)
		return FALSE
	// Have they entered or left the Horizon? Skip if not aboard.
	if(!(potential_victim.z in affecting_z))
		return FALSE
	// Is there gravity where they are? IE. is the grav generator on/off OR are they on the holodeck w/ zero gravity, OR are they EVA? Skip if no artificial gravity for whatever reason.
	if(!potential_victim.has_gravity())
		return FALSE
	// Are they in one of the shuttles? Bandaid case, whatever.
	var/turf/potential_victim_turf = potential_victim.loc
	var/area/potential_victim_area = potential_victim_turf?.loc
	if(istype(potential_victim_area, /area/horizon/shuttle))
		return FALSE
	return TRUE

/datum/event/gravity_anomaly/proc/apply_effect(var/mob/living/carbon/human/victim, var/current_effect)
	switch(current_effect)
		if("nausea_minor")
			apply_nausea_minor(victim)
		if("nausea_mild")
			apply_nausea_mild(victim)
		if("nausea_strong")
			apply_nausea_strong(victim)
		if("surge_default")
			apply_surge_default(victim)
		if("surge_hilarious")
			apply_surge_hilarious(victim)
		else
			log_admin("Failed to generate grav anom result for user [victim].")

/datum/event/gravity_anomaly/proc/apply_camera_drift(var/list/current_victims)
	for(var/mob/living/carbon/human/victim in current_victims)
		if(prob(15))
			continue
		shake_camera(victim, rand(3 SECONDS, 10 SECONDS), 0.1, TRUE)

/datum/event/gravity_anomaly/proc/apply_nausea_minor(var/mob/living/carbon/human/victim)
	victim.dizziness += rand(4, 8)
	victim.confused += 10
	if(prob(10))
		to_chat(victim, SPAN_WARNING(pick(nausea_minor)))

/datum/event/gravity_anomaly/proc/apply_nausea_mild(var/mob/living/carbon/human/victim)
	victim.dizziness += rand(5, 8)
	victim.confused += rand(10, 15)
	if(isipc(victim))
		if(prob(20))
			to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_mild_ipc)))
	else
		if(prob(20))
			to_chat(victim, SPAN_WARNING(pick(nausea_mild_organic)))
		if(prob(10))
			victim.vomit()

/datum/event/gravity_anomaly/proc/apply_nausea_strong(var/mob/living/carbon/human/victim)
	victim.dizziness += rand(8, 15)
	victim.confused += rand(15, 20)
	if(prob(50))
		if(isipc(victim))
			to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_strong_ipc)))
		else
			to_chat(victim, SPAN_WARNING(pick(nausea_strong_organic)))
			victim.vomit()

/datum/event/gravity_anomaly/proc/apply_surge_default(var/mob/living/carbon/human/victim)
	victim.dizziness += rand(10, 20)
	victim.confused += rand(20, 25)
	if(prob(50))
		if(isipc(victim))
			to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_strong_ipc)))
		else
			to_chat(victim, SPAN_WARNING(pick(nausea_strong_organic)))
			victim.vomit()
	if(prob(70))
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

/datum/event/gravity_anomaly/proc/apply_surge_hilarious(var/mob/living/carbon/human/victim)
	victim.dizziness += rand(20, 80)
	victim.confused += rand(20, 80)
	if(isipc(victim))
		to_chat(victim, SPAN_MACHINE_WARNING(pick(nausea_strong_ipc)))
	else
		to_chat(victim, SPAN_WARNING(pick(nausea_strong_organic)))
		if(prob(80))
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

/datum/event/gravity_anomaly/announce_end()
	. = ..()
	if(.)
		command_announcement.Announce("Gravimetric sensors indicate reduced levels of dark matter flux; artificial gravity is now safe for regular use.", "Dark Matter Influx", zlevels = affecting_z)
