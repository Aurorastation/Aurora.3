
/datum/artifact_effect/teleport
	effecttype = "teleport"
	effect_type = 6

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/living/user)
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		to_chat(user, SPAN_ALERT("You are suddenly zapped away elsewhere!"))
		if (user.buckled_to)
			user.buckled_to.unbuckle()

		spark(get_turf(user), 3)

		user.Move(pick(RANGE_TURFS(50, holder)))

		spark(get_turf(user), 3)

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, SPAN_ALERT("You are displaced by a strange force!"))
				if(M.buckled_to)
					M.buckled_to.unbuckle()

				spark(get_turf(M), 3)

				M.Move(pick(RANGE_TURFS(50, T)))

				spark(get_turf(M), 3)

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, SPAN_ALERT("You are displaced by a strange force!"))
				if(M.buckled_to)
					M.buckled_to.unbuckle()

				spark(get_turf(M), 3)

				M.Move(pick(RANGE_TURFS(50, T)))

				spark(get_turf(M), 3)
