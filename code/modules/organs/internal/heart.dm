/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = BP_HEART
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	robotic_name = "circulatory pump"
	robotic_sprite = "heart-prosthetic"
	var/pulse = PULSE_NORM	//current pulse level
	var/heartbeat = 0

/obj/item/organ/internal/heart/process()
	//Check if we're on lifesupport, and whether or not organs should be processing.
	if(owner && owner.isonlifesupport())
		return 1
	else
		return 0

	if(owner)
		handle_pulse()
		if(pulse)
			handle_heartbeat()
		handle_blood()

/obj/item/organ/internal/heart/proc/handle_pulse()
	if((species && species.flags & NO_BLOOD)) //No heart, no pulse, buddy.
		pulse = NONE

	var/temp = PULSE_NORM

	if(round(owner.vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
		temp = PULSE_THREADY	//not enough :(

	if(owner.status_flags & FAKEDEATH)
		temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

	//handles different chems' influence on pulse
	for(var/datum/reagent/R in owner.reagents.reagent_list)
		if(R.id in bradycardics)
			if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
				temp--
		if(R.id in tachycardics)
			if(temp <= PULSE_FAST && temp >= PULSE_NONE)
				temp++
		if(R.id in heartstopper) //To avoid using fakedeath
			var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
			if(rand(0,6) == 3)
				H.take_damage(5)
		if(R.id in cheartstopper) //Conditional heart-stoppage
			if(R.volume >= R.overdose)
				var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
				if(rand(0,6) == 3)
					H.take_damage(5)

	pulse = temp

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse == PULSE_NONE || !owner.species.has_organ[BP_HEART])
		return

	if(!src || status & ORGAN_ROBOT)
		return

	if(pulse >= PULSE_2FAST || shock_stage >= 10 || istype(get_turf(src), /turf/space))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse) / 2

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, 'sound/effects/singlebeat.ogg',0,0,0,50)
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_blood()
	if(owner.in_stasis)
		return

	if(owner.species && owner.species.flags & NO_BLOOD)
		return

	if(owner.stat == DEAD && owner.bodytemperature < 170)	//Dead or cryosleep people do not pump the blood.
		return
		
	if(pulse != PULSE_NONE || BP_IS_ROBOTIC(src))
		var/blood_volume = round(owner.vessel.get_reagent_amount("blood"))

		//Blood regeneration if there is some space
		if(blood_volume < BLOOD_VOLUME_NORMAL && blood_volume)
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
				if(CE_BLOODRESTORE in chem_effects)
					B.volume += chem_effects[CE_BLOODRESTORE]

		//The heartfix to end all heartfixes
		if(owner.species && owner.species.has_organ[BP_HEART])
			var/onlifesupport = 0
			if (buckled && istype(buckled, /obj/machinery/optable/lifesupport))
				var/obj/machinery/optable/lifesupport/A = buckled
				onlifesupport = A.onlifesupport()

			if (!onlifesupport)
				if(!src)
					blood_volume = 0
				else if (is_damaged())
					blood_volume = min(BLOOD_VOLUME_SAFE - 1,blood_volume)
					blood_volume = (BLOOD_VOLUME_SURVIVE + (BLOOD_VOLUME_NORMAL-BLOOD_VOLUME_SURVIVE) * max(1 - heart.damage/heart.min_broken_damage,0)) * (blood_volume/BLOOD_VOLUME_NORMAL)

		//Effects of bloodloss
		if(blood_volume < BLOOD_VOLUME_SAFE && oxyloss < 100 * (1 - blood_volume/BLOOD_VOLUME_NORMAL))
			oxyloss += 3

		//TODOMATT move this to brain
		switch(blood_volume)
			if(BLOOD_VOLUME_SAFE to 10000)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				var/word = pick("dizzy","woosey","faint")
				to_chat(src, "<span class='warning'>You feel [word]...</span>")
				if(prob(1))
					var/word = pick("dizzy","woosey","faint")
					to_chat(src, "<span class='warning'>You feel [word]...</span>")
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				eye_blurry = max(eye_blurry,6)
				oxyloss += 1
				if(prob(15))
					Paralyse(rand(1,3))
					var/word = pick("dizzy","woosey","faint")
					to_chat(src, "<span class='warning'>You feel extremely [word]...</span>")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				oxyloss += 3
				toxloss += 3
				if(prob(15))
					var/word = pick("dizzy","woosey","faint")
					to_chat(src, "<span class='warning'>You feel extremely [word]...</span>")
			if(0 to BLOOD_VOLUME_SURVIVE)
				// There currently is a strange bug here. If the mob is not below -100 health
				// when death() is called, apparently they will be just fine, and this way it'll
				// spam deathgasp. Adjusting toxloss ensures the mob will stay dead.
				owner.toxloss += 300 // just to be safe!
				owner.death()

		//Bleeding out
		var/blood_max = 0
		for(var/obj/item/organ/external/temp in owner.organs)
			if(!(temp.status & ORGAN_BLEEDING) || temp.status & ORGAN_ROBOT)
				continue
			for(var/datum/wound/W in temp.wounds)
				if(W.bleeding())
					blood_max += ((W.damage / 40) * species.bleed_mod)
			if (temp.open)
				blood_max += 2 * species.bleed_mod  //Yer stomach is cut open
		owner.drip(blood_max)