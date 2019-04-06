
/datum/artifact_effect/robohurt
	effecttype = "robohurt"
	var/last_message

/datum/artifact_effect/robohurt/New()
	..()
	effect_type = pick(3,4)

/datum/artifact_effect/robohurt/DoEffectTouch(var/mob/user)
	if(user)
		if (istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			R << "<span class='warning'>Your systems report severe damage has been inflicted!</span>"
			R.adjustBruteLoss(rand(10,50))
			R.adjustFireLoss(rand(10,50))
			return 1

/datum/artifact_effect/robohurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(src.effectrange,T))
			if(world.time - last_message > 200)
				M << "<span class='warning'>SYSTEM ALERT: Harmful energy field detected!</span>"
				last_message = world.time
			M.adjustBruteLoss(1)
			M.adjustFireLoss(1)
			M.updatehealth()
		return 1

/datum/artifact_effect/robohurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(src.effectrange,T))
			if(world.time - last_message > 200)
				M << "<span class='warning'>SYSTEM ALERT: Structural damage inflicted by energy pulse!</span>"
				last_message = world.time
			M.adjustBruteLoss(10)
			M.adjustFireLoss(10)
			M.updatehealth()
		return 1
