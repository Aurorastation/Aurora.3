
//todo
/datum/artifact_effect/dnaswitch
	effecttype = "dnaswitch"
	effect_type = 5
	var/severity

/datum/artifact_effect/dnaswitch/New()
	..()
	if(effect == EFFECT_AURA)
		severity = rand(5,30)
	else
		severity = rand(25,95)

/datum/artifact_effect/dnaswitch/DoEffectTouch(var/mob/toucher)
	var/weakness = GetAnomalySusceptibility(toucher)
	if(ishuman(toucher) && prob(weakness * 100))
		var/DoEffectAuraVariable = "<span class='good'>[pick("You feel a little different.","You feel very strange.","Your stomach churns.","Your skin feels loose.","You feel a stabbing pain in your head.")]</span>"
		to_chat(toucher, DoEffectAuraVariable)
		if(prob(75))
			scramble(1, toucher, weakness * severity)
		else
			scramble(0, toucher, weakness * severity)
	return 1

/datum/artifact_effect/dnaswitch/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				if(prob(30))
					var/DoEffectAuraVariable = "<span class='good'>[pick("You feel a little different.","You feel very strange.","Your stomach churns.","Your skin feels loose.","You feel a stabbing pain in your head.")]</span>"
					to_chat(H, DoEffectAuraVariable)
				if(prob(50))
					scramble(1, H, weakness * severity)
				else
					scramble(0, H, weakness * severity)

/datum/artifact_effect/dnaswitch/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(200, T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				if(prob(75))
					var/DoEffectPulseVariable = "<span class='good'>[pick("You feel a little different.","You feel very strange.","Your stomach churns.","Your skin feels loose.","You feel a stabbing pain in your head.")]</span>"
					to_chat(H, DoEffectPulseVariable)
				if(prob(25))
					if(prob(75))
						scramble(1, H, weakness * severity)
					else
						scramble(0, H, weakness * severity)
