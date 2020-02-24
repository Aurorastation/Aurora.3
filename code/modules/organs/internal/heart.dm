/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = BP_HEART
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	robotic_name = "circulatory pump"
	robotic_sprite = "heart-prosthetic"
	toxin_type = CE_CARDIOTOXIC

	max_damage = 45
	relative_size = 5
	damage_reduction = 0.7

	var/pulse = PULSE_NORM	//current pulse level
	var/heartbeat = 0
	var/next_blood_squirt = 0
	var/list/external_pump

/obj/item/organ/internal/heart/process()
	if(owner)
		handle_pulse()
		if(pulse)
			if(pulse == PULSE_2FAST && prob(1))
				take_internal_damage(0.5)
			if(pulse == PULSE_THREADY && prob(5))
				take_internal_damage(0.5)
			handle_heartbeat()
		handle_blood()
	..()

/obj/item/organ/internal/heart/proc/handle_pulse()
	if(owner.stat == DEAD || (species && species.flags & NO_BLOOD) || BP_IS_ROBOTIC(src)) //No heart, no pulse, buddy. Or if the heart is robotic. Or you're dead.
		pulse = PULSE_NONE
		return

	// pulse mod starts out as just the chemical effect amount
	var/pulse_mod = owner.chem_effects[CE_PULSE]
	var/is_stable = owner.chem_effects[CE_STABLE]

	// If you have enough heart chemicals to be over 2, you're likely to take extra damage.
	if(pulse_mod > 2 && !is_stable)
		var/damage_chance = (pulse_mod - 2) ** 2
		if(prob(damage_chance))
			take_internal_damage(0.5)

	// Now pulse mod is impacted by shock stage and other things too
	if(owner.shock_stage > 30)
		pulse_mod++
	if(owner.shock_stage > 80)
		pulse_mod++

	var/oxy = owner.get_blood_oxygenation()
	if(oxy < BLOOD_VOLUME_OKAY) //brain wants us to get MOAR OXY
		pulse_mod++
	if(oxy < BLOOD_VOLUME_BAD) //MOAR
		pulse_mod++

	if(owner.status_flags & FAKEDEATH || owner.chem_effects[CE_NOPULSE])
		pulse = Clamp(PULSE_NONE + pulse_mod, PULSE_NONE, PULSE_2FAST) //pretend that we're dead. unlike actual death, can be inflienced by meds
		return

	//If heart is stopped, it isn't going to restart itself randomly.
	if(pulse == PULSE_NONE)
		return
	else //and if it's beating, let's see if it should
		var/should_stop = prob(80) && owner.get_blood_circulation() < BLOOD_VOLUME_SURVIVE //cardiovascular shock, not enough liquid to pump
		should_stop = should_stop || prob(max(0, owner.getBrainLoss() - owner.maxHealth * 0.75)) //brain failing to work heart properly
		should_stop = should_stop || (prob(5) && pulse == PULSE_THREADY) //erratic heart patterns, usually caused by oxyloss
		if(should_stop) // The heart has stopped due to going into traumatic or cardiovascular shock.
			to_chat(owner, "<span class='danger'>Your heart has stopped!</span>")
			pulse = PULSE_NONE
			return

	// Pulse normally shouldn't go above PULSE_2FAST
	pulse = Clamp(PULSE_NORM + pulse_mod, PULSE_SLOW, PULSE_2FAST)

	// If fibrillation, then it can be PULSE_THREADY
	var/fibrillation = oxy <= BLOOD_VOLUME_SURVIVE || (prob(30) && owner.shock_stage > 120)
	if(pulse && fibrillation)	//I SAID MOAR OXYGEN
		pulse = PULSE_THREADY

	// Stablising chemicals pull the heartbeat towards the center
	if(pulse != PULSE_NORM && is_stable)
		if(pulse > PULSE_NORM)
			pulse--
		else
			pulse++

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= PULSE_2FAST || owner.shock_stage >= 10)
		//PULSE_THREADY - maximum value for pulse, currently it is 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2
		switch(owner.chem_effects[CE_PULSE])
			if(2 to INFINITY)
				heartbeat++
			if(-INFINITY to -2)
				heartbeat--

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound('sound/effects/singlebeat.ogg', 0, 0, 0, 50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_blood()
	if(!owner)
		return

	if(owner.species && owner.species.flags & NO_BLOOD)
		return

	if(!owner || owner.stat == DEAD || owner.bodytemperature < 170 || owner.in_stasis)	//Dead or cryosleep people do not pump the blood.
		return

	if(pulse != PULSE_NONE || BP_IS_ROBOTIC(src))
		var/blood_volume = round(owner.vessel.get_reagent_amount("blood"))

		//Blood regeneration if there is some space
		if(blood_volume < species.blood_volume && blood_volume)
			var/datum/reagent/blood/B = locate() in owner.vessel.reagent_list //Grab some blood
			if(B) // Make sure there's some blood at all
				if(weakref && B.data["donor"] != weakref) //If it's not theirs, then we look for theirs - donor is a weakref here, but it should be safe to just directly compare it.
					for(var/datum/reagent/blood/D in owner.vessel.reagent_list)
						if(weakref && D.data["donor"] == weakref)
							B = D
							break

				B.volume += 0.1 // regenerate blood VERY slowly
				if(blood_volume <= BLOOD_VOLUME_SAFE) //We loose nutrition and hydration very slowly if our blood is too low
					owner.adjustNutritionLoss(2)
					owner.adjustHydrationLoss(1)
				if(CE_BLOODRESTORE in owner.chem_effects)
					B.volume += owner.chem_effects[CE_BLOODRESTORE]

		//Bleeding out
		var/blood_max = 0
		var/open_wound
		var/list/do_spray = list()
		for(var/obj/item/organ/external/temp in owner.organs)
			if((temp.status & ORGAN_BLEEDING) && !BP_IS_ROBOTIC(temp))
				for(var/datum/wound/W in temp.wounds)
					if(W.bleeding())
						open_wound = TRUE
						if(temp.applied_pressure)
							if(ishuman(temp.applied_pressure))
								var/mob/living/carbon/human/H = temp.applied_pressure
								H.bloody_hands(src, 0)
							var/min_eff_damage = max(0, W.damage - 10) / 6
							blood_max += max(min_eff_damage, W.damage - 30) / 40
						else
							blood_max += ((W.damage / 40) * species.bleed_mod)

			if(temp.status & ORGAN_ARTERY_CUT)
				var/bleed_amount = Floor(owner.vessel.total_volume / (temp.applied_pressure || !open_wound ? 450 : 250))
				if(bleed_amount)
					if(open_wound)
						blood_max += bleed_amount
						do_spray += "[temp.name]"
					else
						owner.vessel.remove_reagent("blood", bleed_amount)

		switch(pulse)
			if(PULSE_SLOW)
				blood_max *= 0.8
			if(PULSE_FAST)
				blood_max *= 1.25
			if(PULSE_2FAST, PULSE_THREADY)
				blood_max *= 1.5

		if(CE_STABLE in owner.chem_effects)
			blood_max *= 0.8

		if(world.time >= next_blood_squirt && istype(owner.loc, /turf) && do_spray.len)
			owner.visible_message("<span class='danger'>Blood squirts from \the [owner]'s [pick(do_spray)]!</span>", "<span class='danger'><font size=3>Blood is squirting out of your [pick(do_spray)]!</font></span>")
			owner.eye_blurry = 2
			owner.Stun(1)
			next_blood_squirt = world.time + 100
			var/turf/sprayloc = get_turf(owner)
			blood_max -= owner.drip(Ceiling(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc)
				if(blood_max > 0)
					owner.drip(blood_max, get_turf(owner))
		else
			owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return pulse > PULSE_NONE || BP_IS_ROBOTIC(src) || (owner.status_flags & FAKEDEATH)

/obj/item/organ/internal/heart/listen()
	if(BP_IS_ROBOTIC(src) && is_working())
		if(is_bruised())
			return "sputtering pump"
		else
			return "steady whirr of the pump"

	if(!pulse || (owner.status_flags & FAKEDEATH))
		return "no pulse"

	var/pulsesound = "normal"
	if(is_bruised())
		pulsesound = "irregular"

	switch(pulse)
		if(PULSE_SLOW)
			pulsesound = "slow"
		if(PULSE_FAST)
			pulsesound = "fast"
		if(PULSE_2FAST)
			pulsesound = "very fast"
		if(PULSE_THREADY)
			pulsesound = "extremely fast and faint"

	. = "[pulsesound] pulse"
