/datum/event/random_brain_trauma

/datum/event/random_brain_trauma/start()

	var/luckypeople = severity
	var/brain_traumas = list(
		/datum/brain_trauma/special/bluespace_prophet,
		/datum/brain_trauma/special/imaginary_friend,
		/datum/brain_trauma/severe/split_personality
	)

	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		if(!H.client || H.stat == DEAD)
			continue

		var/datum/brain_trauma/selected_trauma = pick(brain_traumas)

		if(H.has_trauma_type(selected_trauma))
			continue

		H.gain_trauma(selected_trauma,0)
		luckypeople -=1

		if(luckypeople <= 0)
			break

/datum/event/random_brain_trauma/announce()
	command_announcement.Announce("Space-time anomalies have been detected aboard the station. Report to the medical bay if any strange symptoms occur.", "Space-time alert", new_sound = 'sound/AI/spanomalies.ogg')
