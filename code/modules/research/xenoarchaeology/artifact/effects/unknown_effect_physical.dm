//Effects that affect crew/bots physically, such as harming, healing, status effects, etc.

/datum/artifact_effect/heal
	effecttype = "heal"
	effect_type = 5

/datum/artifact_effect/heal/DoEffectTouch(var/mob/living/toucher)
	//todo: check over this properly
	if(!toucher.isSynthetic() && iscarbon(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, SPAN_NOTICE("You feel a soothing energy invigorate you."))

			if(ishuman(toucher))
				var/mob/living/carbon/human/H = toucher
				for(var/obj/item/organ/external/affecting in H.organs)
					if(affecting && istype(affecting))
						affecting.heal_damage(25 * weakness, 25 * weakness)
				//H:heal_organ_damage(25, 25)
				H.vessel.add_reagent(/singleton/reagent/blood,5, temperature = H.species?.body_temperature)
				H.adjustNutritionLoss(-50 * weakness)
				H.adjustHydrationLoss(-50 * weakness)
				H.adjustBrainLoss(-25 * weakness)
				H.apply_radiation(-1*min(H.total_radiation, 25 * weakness))
				H.bodytemperature = initial(H.bodytemperature)
				H.fixblood()
			//
			C.adjustOxyLoss(-25 * weakness)
			C.adjustToxLoss(-25 * weakness)
			C.adjustBruteLoss(-25 * weakness)
			C.adjustFireLoss(-25 * weakness)
			//
			C.regenerate_icons()
			return TRUE

/datum/artifact_effect/heal/DoEffectAura()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/C in range(effectrange,T))
			if(C.isSynthetic())
				continue
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(C, "<span class='notice'>You feel a soothing energy radiating from something nearby.</span>")
				C.adjustBruteLoss(-1 * weakness)
				C.adjustFireLoss(-1 * weakness)
				C.adjustToxLoss(-1 * weakness)
				C.adjustOxyLoss(-1 * weakness)
				C.adjustBrainLoss(-1 * weakness)
				C.updatehealth()

/datum/artifact_effect/heal/DoEffectPulse()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/C in range(effectrange,T))
			if(C.isSynthetic())
				continue
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, "<span class='notice'>A wave of energy invigorates you.</span>")
				C.adjustBruteLoss(-5 * weakness)
				C.adjustFireLoss(-5 * weakness)
				C.adjustToxLoss(-5 * weakness)
				C.adjustOxyLoss(-5 * weakness)
				C.adjustBrainLoss(-5 * weakness)
				C.updatehealth()


/datum/artifact_effect/hurt
	effecttype = I_HURT
	effect_type = 5

/datum/artifact_effect/hurt/DoEffectTouch(var/mob/living/toucher)
	if(!toucher.isSynthetic())
		var/weakness = GetAnomalySusceptibility(toucher)
		if(iscarbon(toucher) && prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, "<span class='danger'>A painful discharge of energy strikes you!</span>")
			C.adjustOxyLoss(rand(5,25) * weakness)
			C.adjustToxLoss(rand(5,25) * weakness)
			C.adjustBruteLoss(rand(5,25) * weakness)
			C.adjustFireLoss(rand(5,25) * weakness)
			C.adjustBrainLoss(rand(5,25) * weakness)
			C.apply_damage(25 * weakness, IRRADIATE, damage_flags = DAM_DISPERSED)
			C.adjustNutritionLoss(50 * weakness)
			C.adjustHydrationLoss(50 * weakness)
			C.make_dizzy(6 * weakness)
			C.weakened += 6 * weakness

/datum/artifact_effect/hurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effectrange,T))
			if(C.isSynthetic())
				continue
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(C, "<span class='danger'>You feel a painful force radiating from something nearby.</span>")
				C.adjustBruteLoss(1 * weakness)
				C.adjustFireLoss(1 * weakness)
				C.adjustToxLoss(1 * weakness)
				C.adjustOxyLoss(1 * weakness)
				C.adjustBrainLoss(1 * weakness)
				C.updatehealth()

/datum/artifact_effect/hurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/C in range(effectrange, T))
			if(C.isSynthetic())
				continue
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, "<span class='danger'>A wave of painful energy strikes you!</span>")
				C.adjustBruteLoss(3 * weakness)
				C.adjustFireLoss(3 * weakness)
				C.adjustToxLoss(3 * weakness)
				C.adjustOxyLoss(3 * weakness)
				C.adjustBrainLoss(3 * weakness)
				C.updatehealth()


/datum/artifact_effect/roboheal
	effecttype = "roboheal"
	var/last_message

/datum/artifact_effect/roboheal/New()
	..()
	effect_type = pick(3,4)

/datum/artifact_effect/roboheal/DoEffectTouch(var/mob/living/user)
	if(user.isSynthetic())
		to_chat(user, SPAN_NOTICE("Your systems report damaged components mending by themselves!"))
		user.adjustBruteLoss(rand(-10,-30))
		user.adjustFireLoss(rand(-10,-30))
		return TRUE

/datum/artifact_effect/roboheal/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/M in range(effectrange,T))
			if(!M.isSynthetic())
				continue
			if(world.time - last_message > 200)
				to_chat(M, SPAN_NOTICE("Your systems report damaged components mending by themselves!"))
				last_message = world.time
			M.adjustBruteLoss(-1)
			M.adjustFireLoss(-1)
			M.updatehealth()
		return TRUE

/datum/artifact_effect/roboheal/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/M in range(effectrange,T))
			if(!M.isSynthetic())
				continue
			if(world.time - last_message > 200)
				to_chat(M, SPAN_NOTICE("Diagnostics Alert: Structural damage has been repaired by energy pulse!"))
				last_message = world.time
			M.adjustBruteLoss(-10)
			M.adjustFireLoss(-10)
			M.updatehealth()
		return TRUE

/datum/artifact_effect/robohurt
	effecttype = "robohurt"
	var/last_message

/datum/artifact_effect/robohurt/New()
	..()
	effect_type = pick(3,4)

/datum/artifact_effect/robohurt/DoEffectTouch(var/mob/living/user)
	if(user.isSynthetic())
		to_chat(user, SPAN_WARNING("Your systems report severe damage has been inflicted!"))
		user.adjustBruteLoss(rand(10,50))
		user.adjustFireLoss(rand(10,50))
		return TRUE

/datum/artifact_effect/robohurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/M in range(effectrange,T))
			if(!M.isSynthetic())
				continue
			if(world.time - last_message > 200)
				to_chat(M, SPAN_WARNING("Your systems report severe damage has been inflicted!"))
				last_message = world.time
			M.adjustBruteLoss(1)
			M.adjustFireLoss(1)
			M.updatehealth()
		return TRUE

/datum/artifact_effect/robohurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(effectrange,T))
			if(!M.isSynthetic())
				continue
			if(world.time - last_message > 200)
				to_chat(M, SPAN_WARNING("Your systems report severe damage has been inflicted!"))
				last_message = world.time
			M.adjustBruteLoss(10)
			M.adjustFireLoss(10)
			M.updatehealth()
		return TRUE

/datum/artifact_effect/sleepy
	effecttype = "sleepy"

/datum/artifact_effect/sleepy/New()
	..()
	effect_type = pick(5,2)

/datum/artifact_effect/sleepy/DoEffectTouch(var/mob/living/toucher)
	if(toucher)
		var/weakness = GetAnomalySusceptibility(toucher)
		if(!toucher.isSynthetic())
			if(ishuman(toucher) && prob(weakness * 100))
				var/mob/living/carbon/human/H = toucher
				to_chat(H, pick("<span class='notice'>You feel like taking a nap.</span>","<span class='notice'>You feel a yawn coming on.</span>","<span class='notice'>You feel a little tired.</span>"))
				H.drowsiness = min(H.drowsiness + rand(5,25) * weakness, 50 * weakness)
				H.eye_blurry = min(H.eye_blurry + rand(1,3) * weakness, 50 * weakness)
		else
			to_chat(toucher, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down!"))
		return TRUE

/datum/artifact_effect/sleepy/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/L in range(effectrange,T))
			if(L.isSynthetic())
				to_chat(L, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down!"))
				continue
			else if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/weakness = GetAnomalySusceptibility(H)
				if(prob(weakness * 100))
					if(prob(10))
						to_chat(H, pick("<span class='notice'>You feel like taking a nap.</span>","<span class='notice'>You feel a yawn coming on.</span>","<span class='notice'>You feel a little tired.</span>"))
					H.drowsiness = min(H.drowsiness + 1 * weakness, 25 * weakness)
					H.eye_blurry = min(H.eye_blurry + 1 * weakness, 25 * weakness)
		return TRUE

/datum/artifact_effect/sleepy/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/L in range(effectrange,T))
			if(L.isSynthetic())
				to_chat(L, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down!"))
				continue
			else if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/weakness = GetAnomalySusceptibility(H)
				if(prob(weakness * 100))
					to_chat(H, pick("<span class='notice'>You feel like taking a nap.</span>","<span class='notice'>You feel a yawn coming on.</span>","<span class='notice'>You feel a little tired.</span>"))
					H.drowsiness = min(H.drowsiness + rand(5,15) * weakness, 50 * weakness)
					H.eye_blurry = min(H.eye_blurry + rand(5,15) * weakness, 50 * weakness)

		return TRUE

/datum/artifact_effect/stun
	effecttype = "stun"

/datum/artifact_effect/stun/New()
	..()
	effect_type = pick(2,5)

/datum/artifact_effect/stun/DoEffectTouch(var/mob/living/toucher)
	if(iscarbon(toucher))
		var/mob/living/carbon/C = toucher
		var/susceptibility = GetAnomalySusceptibility(C)
		if(prob(susceptibility * 100))
			to_chat(C, "<span class='warning'>A powerful force overwhelms your consciousness.</span>")
			C.Weaken(rand(1,10) * susceptibility)
			C.stuttering += 30 * susceptibility
			C.Stun(rand(1,10) * susceptibility)

/datum/artifact_effect/stun/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effectrange,T))
			var/susceptibility = GetAnomalySusceptibility(C)
			if(prob(10 * susceptibility))
				to_chat(C, "<span class='warning'>Your body goes numb for a moment.</span>")
				C.Weaken(2)
				C.stuttering += 2
				if(prob(10))
					C.Stun(1)
			else if(prob(10))
				to_chat(C, "<span class='warning'>You feel numb.</span>")

/datum/artifact_effect/stun/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effectrange,T))
			var/susceptibility = GetAnomalySusceptibility(C)
			if(prob(100 * susceptibility))
				to_chat(C, "<span class='warning'>A wave of energy overwhelms your senses!</span>")
				C.SetWeakened(4 * susceptibility)
				C.stuttering = 4 * susceptibility
				if(prob(10))
					C.SetStunned(1 * susceptibility)

/datum/artifact_effect/radiate
	effecttype = "radiate"
	var/radiation_amount

/datum/artifact_effect/radiate/New()
	..()
	radiation_amount = rand(1, 10)
	effect_type = pick(4,5)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
		user.apply_effect(radiation_amount * 5,IRRADIATE,0)
		user.updatehealth()
		return TRUE

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			M.apply_effect(radiation_amount,IRRADIATE,0)
			M.updatehealth()
		return TRUE

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			M.apply_damage(radiation_amount * 25, IRRADIATE, damage_flags = DAM_DISPERSED)
			M.updatehealth()
		return TRUE
