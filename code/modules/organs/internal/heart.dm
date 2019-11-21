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
	var/next_blood_squirt = 0

/obj/item/organ/internal/heart/process()
	if(owner)
		if(owner.isonlifesupport())
			return 1
		handle_pulse()
		if(pulse)
			handle_heartbeat()
		handle_blood()
	..()

/obj/item/organ/internal/heart/proc/handle_pulse()
	if((species && species.flags & NO_BLOOD)) //No heart, no pulse, buddy.
		pulse = PULSE_NONE

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
			if(rand(0,6) == 3)
				take_internal_damage(5)
		if(R.id in cheartstopper) //Conditional heart-stoppage
			if(R.volume >= R.overdose)
				if(rand(0,6) == 3)
					take_internal_damage(5)

	pulse = temp

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse == PULSE_NONE || !owner.species.has_organ[BP_HEART])
		return

	if(!src || status & ORGAN_ROBOT)
		return

	if(pulse >= PULSE_2FAST || owner.shock_stage >= 10 || istype(get_turf(src), /turf/space))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse) / 2

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound('sound/effects/singlebeat.ogg', 0, 0, 0, 50))
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
				if(CE_BLOODRESTORE in owner.chem_effects)
					B.volume += owner.chem_effects[CE_BLOODRESTORE]


		var/onlifesupport = 0
		if (owner.buckled && istype(owner.buckled, /obj/machinery/optable/lifesupport))
			var/obj/machinery/optable/lifesupport/A = owner.buckled
			onlifesupport = A.onlifesupport()

		if (!onlifesupport)
			if(!src)
				blood_volume = 0
			else if (is_damaged())
				blood_volume = min(BLOOD_VOLUME_SAFE - 1,blood_volume)
				blood_volume = (BLOOD_VOLUME_SURVIVE + (BLOOD_VOLUME_NORMAL-BLOOD_VOLUME_SURVIVE) * max(1 - damage/min_broken_damage,0)) * (blood_volume/BLOOD_VOLUME_NORMAL)

		//Effects of bloodloss
		if(blood_volume < BLOOD_VOLUME_SAFE && owner.oxyloss < 100 * (1 - blood_volume/BLOOD_VOLUME_NORMAL))
			owner.oxyloss += 3

		//TODOMATT move this to brain
		switch(blood_volume)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				var/word = pick("dizzy","woosey","faint")
				to_chat(owner, "<span class='warning'>You feel [word]...</span>")
				if(prob(1))
					word = pick("dizzy","woosey","faint")
					to_chat(owner, "<span class='warning'>You feel [word]...</span>")
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				owner.eye_blurry = max(owner.eye_blurry,6)
				owner.oxyloss += 1
				if(prob(15))
					owner.Paralyse(rand(1,3))
					var/word = pick("dizzy","woosey","faint")
					to_chat(owner, "<span class='warning'>You feel extremely [word]...</span>")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				owner.oxyloss += 3
				owner.toxloss += 3
				if(prob(15))
					var/word = pick("dizzy","woosey","faint")
					to_chat(owner, "<span class='warning'>You feel extremely [word]...</span>")
			if(0 to BLOOD_VOLUME_SURVIVE)
				// There currently is a strange bug here. If the mob is not below -100 health
				// when death() is called, apparently they will be just fine, and this way it'll
				// spam deathgasp. Adjusting toxloss ensures the mob will stay dead.
				owner.toxloss += 300 // just to be safe!
				owner.death()

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
				var/bleed_amount = Floor(owner.vessel.total_volume / (temp.applied_pressure || !open_wound ? 450 : 300))
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
			owner.visible_message("<span class='danger'>Blood squirts from \the [owner]'s [pick(do_spray)]!</span>", "<span class='danger'><font size='3'>Blood is squirting out of your [pick(do_spray)]!</font></span>")
			owner.eye_blurry = 2
			owner.Stun(1)
			next_blood_squirt = world.time + 100
			var/turf/sprayloc = get_turf(src)
			blood_max -= owner.drip(Ceiling(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc)
				if(blood_max > 0)
					owner.drip(blood_max, get_turf(src))
		else
			owner.drip(blood_max)