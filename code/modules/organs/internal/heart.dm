/obj/item/organ/internal/heart
	name = "heart"
	desc = "When it's calling to you, you'd better listen."
	icon_state = "heart-on"
	organ_tag = BP_HEART
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	robotic_name = "circulatory pump"
	toxin_type = CE_CARDIOTOXIC

	max_damage = 60
	min_broken_damage = 45
	relative_size = 5
	damage_reduction = 0.7

	var/pulse = PULSE_NORM	//current pulse level
	var/heartbeat = 0
	var/next_blood_squirt = 0
	var/list/external_pump

	/**
	 * The amount of damage a heart takes per second while in fibrillation(red pulse).
	 * A Heart risks stopping as it takes damage.
	 */
	var/heart_fibrillation_damage = 0.16666

	/**
	 * The amount of damage a heart takes per second while in tachycardia(yellow pulse).
	 * A Heart risks stopping as it takes damage.
	 */
	var/heart_tachycardia_damage = 0.033333

	/// The percent chance each tick that a heart in fibrillation will immediately stop
	var/fibrillation_stop_risk = 5

	/// How much pain is required for a heart attack to be possible.
	var/shock_stage_for_fibrillation = 120

	/// Percent chance of a heart attack when above a certain amount of pain.
	var/shock_risk_from_pain = 30

	/// Over this amount of shock, worsen the heart's condition step by one step
	var/first_shock_stage = 30

	/// Over this amount of shock, worsen the heart's condition step by one step, cumulative with the previous stage.
	var/second_shock_stage = 80

	/// How much this heart modifies the owner's blood regeneration, needed for Bioaugmented hearts
	var/blood_regen_modifier = 1

	/// How much this heart modifies the rate of bloodloss per arterial wound.
	var/base_arterial_bloodloss_modifier = 1

	/// How much this heart modifies the rate of bloodloss per cut wound.
	var/base_cut_bloodloss_modifier = 1

	/// How much this heart modifies nutrition loss while regenerating blood.
	var/nutrition_cost_per_blood_regen = 2

	/// How much this heart modifies hydration loss while regenerating blood.
	var/hydration_cost_per_blood_regen = 1

	/// The temperature at which the heart "Freezes" in Cryostasis.
	var/minimum_temperature_to_pump_blood = 170

	/// The amount of time (in seconds) that pass between arterial sprays if injured as such.
	var/time_between_arterial_sprays = 100

	/// How much this heart modifies the rate of bloodloss from external dripping. This is a more general clotting factor.
	var/bleed_drip_modifier = 1

	/// The threshold of pain for which the player will experience "Heart palpitations", IE: Hearing your own heartbeat.
	var/palpitations_threshold = 10

	/// How much "Slow" pulse modifies bleed rate
	var/slow_bleeding_modifier = 0.8

	/// How much "Fast" pulse modifies bleed rate
	var/fast_bleeding_modifier = 1.25

	/// How much Tachycardia modifies bleed rate
	var/too_fast_bleeding_modifier = 1.5

	/// How much fibrillation modifies bleed rate
	var/thready_bleeding_modifier = 1.5

	/// The base rate at which this heart pumps blood regardless of pulse rate.
	var/base_pump_rate = 1

	/// The "base blood circulation" for if the heart is fully stopped. This can get floored later to as little as 0.075 on default settings.
	var/none_pump_modifier = 0.25

	/// Modifier on how much blood this heart pumps while at a "slow" pulse rate.
	var/slow_pump_modifier = 0.9

	/// Modifier on how much blood this heart pumps at a "normal" pulse rate.
	var/norm_pump_modifier = 1

	/// Modifier on how much blood this heart pumps at a "fast" pulse rate.
	var/fast_pump_modifier = 1.1

	/// Modifier on how much blood this heart pumps at a "2fast" pulse rate.
	var/too_fast_pump_modifier = 1.25

	/// Modifier on how much blood this heart pumps at a "thready" pulse rate.
	var/thready_pump_modifier = 1.25

	/// Useful for high end robotic hearts, whether they have ways of faking the appearance of a pulse so long as they're active.
	var/fake_pulse = FALSE

	/// How much damage this heart can take from chemically induced arythmia per instance.
	var/damage_from_chemicals = 0.5

	/// Sound effect used for heartbeat warnings, such as when the user is in pain/risk of dying.
	var/heartbeat_sound = 'sound/effects/singlebeat.ogg'

	/// Distance effects for arterial sprays.
	var/blood_spray_distance = 2

/obj/item/organ/internal/heart/process(seconds_per_tick)
	if(!owner)
		return ..()
	handle_pulse()
	if(pulse)
		if(pulse == PULSE_2FAST)
			take_internal_damage(heart_tachycardia_damage * seconds_per_tick)
		if(pulse == PULSE_THREADY)
			take_internal_damage(heart_fibrillation_damage * seconds_per_tick)
		handle_heartbeat()
	handle_blood()
	..()

/obj/item/organ/internal/heart/proc/handle_pulse()
	if(owner.stat == DEAD || (species && species.flags & NO_BLOOD) || BP_IS_ROBOTIC(src)) //No heart, no pulse, buddy. Or if the heart is robotic. Or you're dead.
		pulse = PULSE_NONE
		return

	// pulse mod starts out as just the chemical effect amount
	var/pulse_mod = owner.chem_effects[CE_PULSE] // TODO: Make chems go through signals.
	var/is_stable = owner.chem_effects[CE_STABLE]
	var/oxy = owner.get_blood_oxygenation()
	var/circulation = owner.get_blood_circulation()
	var/canceled = FALSE

	// Check if any components on the user wish to mess with the pulse calculations.
	SEND_SIGNAL(owner, COMSIG_HEART_PULSE_EVENT, &pulse_mod, &is_stable, &oxy, &circulation, &canceled)
	if(canceled)
		return // Oh hey someone stopped my heart from beating via a SIGNAL response!

	// If you have enough heart chemicals to be over 2, take extra damage per tick.
	if(pulse_mod > 2 && !is_stable)
		var/damage_chance = (pulse_mod - 2) ** 2
		if(prob(damage_chance))
			take_internal_damage(damage_from_chemicals)

	// Now pulse mod is impacted by shock stage and other things too
	if(owner.shock_stage > first_shock_stage)
		pulse_mod++
	if(owner.shock_stage > second_shock_stage)
		pulse_mod++

	if(oxy < BLOOD_VOLUME_OKAY) //brain wants us to get moar oxygen
		pulse_mod++
	if(oxy < BLOOD_VOLUME_BAD) //MOAR
		pulse_mod++

	if(owner.status_flags & FAKEDEATH)
		pulse = clamp(PULSE_NONE + pulse_mod, PULSE_NONE, PULSE_2FAST) //pretend that we're dead. unlike actual death, can be inflienced by meds
		return

	//If heart is stopped, it isn't going to restart itself randomly.
	if(pulse == PULSE_NONE)
		return
	else //and if it's beating, let's see if it should
		var/should_stop = prob(80) && circulation < BLOOD_VOLUME_SURVIVE //cardiovascular shock, not enough liquid to pump
		should_stop = should_stop || prob(max(0, owner.getBrainLoss() - owner.maxHealth * 0.75)) //brain failing to work heart properly
		should_stop = should_stop || (prob(fibrillation_stop_risk) && pulse == PULSE_THREADY) //erratic heart patterns, usually caused by oxyloss
		should_stop = should_stop || owner.chem_effects[CE_NOPULSE]
		if(should_stop) // The heart has stopped due to going into traumatic or cardiovascular shock.
			to_chat(owner, SPAN_DANGER("Your heart has stopped!"))
			pulse = PULSE_NONE
			return

	// Pulse normally shouldn't go above PULSE_2FAST
	pulse = clamp(PULSE_NORM + pulse_mod, PULSE_SLOW, PULSE_2FAST)

	// If fibrillation, then it can be PULSE_THREADY
	var/fibrillation = oxy <= BLOOD_VOLUME_SURVIVE || (owner.shock_stage > shock_stage_for_fibrillation && prob(shock_risk_from_pain))
	if(pulse && fibrillation)	//I SAID MOAR OXYGEN
		pulse = PULSE_THREADY

	// Stablising chemicals pull the heartbeat towards the center
	if(pulse != PULSE_NORM && is_stable)
		if(pulse > PULSE_NORM)
			pulse--
		else
			pulse++

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= PULSE_2FAST || owner.shock_stage >= palpitations_threshold)
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
			sound_to(owner, sound(heartbeat_sound, 0, 0, 0, 50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_blood()
	if(!owner)
		return

	if(owner.species && owner.species.flags & NO_BLOOD)
		return

	if(!owner || owner.stat == DEAD || owner.bodytemperature < minimum_temperature_to_pump_blood || owner.InStasis())	//Dead or cryosleep people do not pump the blood.
		return

	if(pulse != PULSE_NONE || BP_IS_ROBOTIC(src))
		var/blood_volume = round(REAGENT_VOLUME(owner.vessel, /singleton/reagent/blood))
		var/cut_bloodloss_modifier = base_cut_bloodloss_modifier
		var/arterial_bloodloss_modifier = base_arterial_bloodloss_modifier

		SEND_SIGNAL(owner, COMSIG_HEART_BLEED_EVENT, &blood_volume, &cut_bloodloss_modifier, &arterial_bloodloss_modifier)

		//Blood regeneration if there is some space
		if(blood_volume < species.blood_volume && blood_volume)
			if(REAGENT_DATA(owner.vessel, /singleton/reagent/blood)) // Make sure there's blood at all
				owner.vessel.add_reagent(/singleton/reagent/blood, (BLOOD_REGEN_RATE * blood_regen_modifier) + LAZYACCESS(owner.chem_effects, CE_BLOODRESTORE), temperature = species?.body_temperature)
				if(blood_volume <= BLOOD_VOLUME_SAFE) //We lose nutrition and hydration very slowly if our blood is too low
					owner.adjustNutritionLoss(nutrition_cost_per_blood_regen)
					owner.adjustHydrationLoss(hydration_cost_per_blood_regen)

		//Bleeding out
		var/blood_max = 0
		var/open_wound
		var/list/do_spray = list()
		for(var/obj/item/organ/external/temp in owner.bad_external_organs)
			if((temp.status & ORGAN_BLEEDING) && !BP_IS_ROBOTIC(temp))
				for(var/datum/wound/W in temp.wounds)
					if(W.bleeding())
						open_wound = TRUE
						if(temp.applied_pressure)
							if(ishuman(temp.applied_pressure))
								var/mob/living/carbon/human/H = temp.applied_pressure
								H.bloody_hands(src, 0)
							var/min_eff_damage = max(0, W.damage - 10) / 6
							blood_max += max(min_eff_damage, W.damage - 30) / 40 * cut_bloodloss_modifier
						else
							blood_max += ((W.damage / 40) * species.bleed_mod * cut_bloodloss_modifier)

			if(temp.status & ORGAN_ARTERY_CUT)
				var/bleed_amount = FLOOR((owner.vessel.total_volume / (temp.applied_pressure || !open_wound ? 450 : 250)) * temp.arterial_bleed_severity, 0.1)
				if(bleed_amount)
					if((CE_BLOODCLOT in owner.chem_effects) && !(owner.chem_effects[CE_BLOODTHIN]))
						bleed_amount *= 0.8 // won't do much, but it'll help
					if(CE_BLOODTHIN in owner.chem_effects)
						bleed_amount *= 1+(owner.chem_effects[CE_BLOODTHIN]/100)
					if(open_wound)
						blood_max += bleed_amount
						do_spray += "[temp.name]"
					else
						owner.vessel.remove_reagent(/singleton/reagent/blood, bleed_amount * arterial_bloodloss_modifier)

		switch(pulse)
			if(PULSE_SLOW)
				blood_max *= slow_bleeding_modifier
			if(PULSE_FAST)
				blood_max *= fast_bleeding_modifier
			if(PULSE_2FAST)
				blood_max *= too_fast_bleeding_modifier
			if (PULSE_THREADY)
				blood_max *= thready_bleeding_modifier

		blood_max *= bleed_drip_modifier

		if(CE_BLOODCLOT in owner.chem_effects)
			blood_max *= 0.7
		else if(CE_STABLE in owner.chem_effects)
			blood_max *= 0.8

		if(world.time >= next_blood_squirt && istype(owner.loc, /turf) && do_spray.len)
			owner.visible_message(SPAN_DANGER("Blood squirts from \the [owner]'s [pick(do_spray)]!"), \
								SPAN_DANGER("<font size=3>Blood sprays out of your [pick(do_spray)]!</font>"))
			owner.eye_blurry = 2
			owner.Stun(1)
			next_blood_squirt = world.time + time_between_arterial_sprays
			var/turf/sprayloc = get_turf(owner)
			blood_max -= owner.drip(Ceiling(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc, blood_spray_distance)
				if(blood_max > 0)
					owner.drip(blood_max, get_turf(owner))
		else
			owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return pulse > PULSE_NONE || BP_IS_ROBOTIC(src) || (owner.status_flags & FAKEDEATH)

/obj/item/organ/internal/heart/do_surge_effects()
	var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
	if(prob(surge_damage))
		owner.custom_pain(SPAN_DANGER("Your [E.name] stings horribly!"), 15, FALSE, E)
		sound_to(owner, sound(heartbeat_sound, 0, 0, 0, 100))

/obj/item/organ/internal/heart/listen()
	if((BP_IS_ROBOTIC(src) && is_working()) && !fake_pulse)
		if(is_bruised())
			return "sputtering pump"
		else
			return "steady whirr of the pump"

	if (owner.status_flags & FAKEDEATH)
		return "no pulse"

	if (fake_pulse)
		return "normal pulse"

	if(!pulse)
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

// Example heart item that has significantly higher statistics.
// Also to be used for the Galatean Bio-augments PRs.
// TODO: After refactoring the organ selector, make it so that this is a selectable heart type(For Galateans)
/obj/item/organ/internal/heart/boosted_heart
	name = "boosted heart"
	desc = "Intended for athletes, some workers, and soldiers, this improved heart increases blood flow and circulation." \
					+ "It provides an improvement to blood oxygenation and stamina, at the cost of requiring more food and water." \
					+ "Outside of Galatea, this augment is popular among professional athletes."
	icon = 'icons/obj/organs/bioaugs.dmi'
	icon_state = "boosted_heart"
	max_damage = 80
	min_broken_damage = 60
	shock_stage_for_fibrillation = 140
	fibrillation_stop_risk = 3.5
	base_pump_rate = 1.15
	nutrition_cost_per_blood_regen = 4
	hydration_cost_per_blood_regen = 3
	blood_regen_modifier = 1.1
	bleed_drip_modifier = 1.1
	blood_spray_distance = 3

// Example heart item that has significantly lowered statistics.
// TODO: After refactoring the organ selector, make it so that this is a selectable heart type.
/obj/item/organ/internal/heart/scarred_heart
	name = "scarred heart"
	desc = "Life has not been good to this old ticker."
	icon = 'icons/obj/organs/bioaugs.dmi'
	icon_state = "scarred_heart"
	max_damage = 45
	min_broken_damage = 30
	fibrillation_stop_risk = 7.5
	shock_stage_for_fibrillation = 100
	blood_regen_modifier = 0.9
	base_pump_rate = 0.9
	thready_pump_modifier = 1.5
	damage_from_chemicals = 0.7
	blood_spray_distance = 1

/obj/item/organ/internal/heart/alien_heart
	name = "anomalous mercurial flesh"
	desc = "A slab of flesh made seemingly from mercury, yet with a recognizably organic shape. It is soft to the touch, pliable like skin, yet is as tough as steel."
	icon = 'icons/obj/organs/bioaugs.dmi'
	icon_state = "alien_heart"
	max_damage = 200
	min_bruised_damage = 150
	min_broken_damage = 175

/obj/item/organ/internal/heart/alien_heart/Initialize()
	. = ..()
	// RANDOMIZE EVERYTHING.
	// DEAR READER, I HOPE YOU HAVE FUN IF YOU MAKE THE MISTAKE OF PUTTING THIS IN A HUMAN.
	// BECAUSE YOU ARE NOT GUARANTEED IT CAN SUSTAIN LIFE.
	heart_fibrillation_damage *= rand(0.5, 2)
	heart_tachycardia_damage *= rand(0.5, 2)
	fibrillation_stop_risk = rand(1, 99)
	shock_stage_for_fibrillation *= rand(0.5, 2)
	shock_risk_from_pain = rand(1, 99)
	first_shock_stage *= rand(0.75, 1.33)
	second_shock_stage *= rand(0.75, 1.33)
	blood_regen_modifier *= rand(0.5, 2)
	base_arterial_bloodloss_modifier *= rand(0.5, 2)
	base_cut_bloodloss_modifier *= rand(0.5, 2)
	nutrition_cost_per_blood_regen *= rand(0.5, 2)
	hydration_cost_per_blood_regen *= rand(0.5, 2)
	minimum_temperature_to_pump_blood *= rand(0.75, 1.33)
	time_between_arterial_sprays *= rand(0.5, 2)
	bleed_drip_modifier *= rand(0.5, 2)
	palpitations_threshold *= rand(0.5, 2)
	slow_bleeding_modifier *= rand(0.75, 1.33)
	fast_bleeding_modifier *= rand(0.75, 1.33)
	thready_bleeding_modifier *= rand(0.75, 1.33)
	base_pump_rate *= rand(0.75, 1.33)
	none_pump_modifier *= rand(0.75, 1.33)
	slow_pump_modifier *= rand(0.75, 1.33)
	fast_pump_modifier *= rand(0.75, 1.33)
	too_fast_pump_modifier *= rand(0.75, 1.33)
	thready_pump_modifier *= rand(0.75, 1.33)
	if(prob(50))
		fake_pulse = TRUE
	damage_from_chemicals *= rand(0.75, 1.33)
	blood_spray_distance = rand(1, 9)
