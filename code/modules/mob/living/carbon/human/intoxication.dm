//This proc handles the effects of being intoxicated. Removal of intoxication is done elswhere: By the liver, in organ_internal.dm
/mob/living/carbon/human/proc/handle_intoxication()


	var/SR = species.ethanol_resistance
	if (SR == -1)
		//This species can't get drunk, how did we even get here?
		intoxication = 0
		return

	if(HAS_TRAIT(src, TRAIT_ORIGIN_ALCOHOL_RESISTANCE))
		SR = 1.5

	//Godmode messes some things up, so no more BSTs getting drunk unless they toggle it off
	if (status_flags & GODMODE)
		intoxication = 0 //Zero out intoxication but don't return, let the rest of this function run to remove any residual effects
		slurring = 0
		confused = 0
		eye_blurry = 0
		drowsiness = 0
		paralysis = 0
		sleeping = 0
		//Many of these parameters normally tick down in life code, but some parts of that code don't run in godmode, so this prevents a BST being stuck with blurred vision

	var/bac = get_blood_alcohol()

	if(bac > INTOX_BUZZED*SR && bac < INTOX_MUSCLEIMP*SR)
		sprint_cost_factor += -0.1
		if(prob(3))
			to_chat(src, SPAN_GOOD(pick("You feel buzzed.","You feel good!","You feel less inhibited.","You feel relaxed.")))

	if(bac > INTOX_JUDGEIMP*SR)
		if (dizziness == 0)
			to_chat(src, SPAN_GOOD("You feel a little tipsy!"))
		var/target_dizziness = BASE_DIZZY + ((bac - INTOX_JUDGEIMP*SR)*DIZZY_ADD_SCALE*100)
		make_dizzy(target_dizziness - dizziness)

	//To handle the speed modifier, because this system was made stupidly
	//If there's enough alcohol and the modifier wasn't applied yet, apply it
	//if there's not enough alcohol and the modifier was applied, remove it
	var/datum/movespeed_modifier/has_alcohol_modifier = src.has_movespeed_modifier(/datum/movespeed_modifier/alcohol/intoxication)
	if((bac > INTOX_MUSCLEIMP*SR) && !has_alcohol_modifier)
		src.add_movespeed_modifier(/datum/movespeed_modifier/alcohol/intoxication)
	else if(has_alcohol_modifier)
		src.remove_movespeed_modifier(/datum/movespeed_modifier/alcohol/intoxication)

	if(bac > INTOX_MUSCLEIMP*SR && bac < INTOX_REACTION*SR)
		if (prob(3))
			to_chat(src, SPAN_GOOD(pick("You feel drunk!", "You feel great!", "Your inhibitions fall away...", "All your anxieties melt away.")))
		sprint_cost_factor += 0.2

	if(bac > INTOX_REACTION*SR)
		if (prob(3) && bac < INTOX_BALANCE*SR)
			to_chat(src, SPAN_GOOD(pick("You feel very drunk!", "You feel reckless!", "You don't have a care in the world!", "You feel amazing!")))
		if (confused == 0)
			to_chat(src, SPAN_WARNING("You feel uncoordinated and unsteady on your feet!"))
		var/target_slurring = BASE_SLUR + ((bac - INTOX_REACTION*SR)*SLUR_ADD_SCALE*100)
		slurring = max(slurring, target_slurring)
		confused = max(confused, 10)
		eye_blurry = max(eye_blurry, 10)
		//Change the speed modifier, but only if it's not already what we want
		if(has_alcohol_modifier.multiplicative_slowdown < 4)
			src.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/alcohol/intoxication, TRUE, 4)
		sprint_cost_factor += 0.2

	if(bac > INTOX_VOMIT*SR)//Vomiting starts here. 1% chance every 10 ticks, escalating with increased intoxication (1% per 0.01 BAC)
		if (prob(3))
			to_chat(src, SPAN_WARNING("You feel a little nauseous..."))
		if (life_tick % 10 == 1)
			var/vomitchance = BASE_VOMIT_CHANCE + ((bac - INTOX_VOMIT*SR)*VOMIT_CHANCE_SCALE*100)
			if (prob(vomitchance))
				delayed_vomit()

	if(bac > INTOX_BALANCE*SR)//Can no longer walk properly. Will fall to the ground very often. Good drunkeness messages replaced by alcohol dysphoria and confusion
		var/fallchance = ((bac - INTOX_BALANCE*SR)*100)
		if (prob(3))
			to_chat(src, SPAN_WARNING(pick("You feel the room spinning...", "It's hard to think...", "You can't see straight...", "You feel absolutely hammered!")))
		if (life_tick % 4 == 1 && !lying && !buckled_to && prob(fallchance))
			src.visible_message(SPAN_WARNING("[src] loses balance and falls to the ground!"),SPAN_WARNING("You lose balance and fall to the ground!"))
			Paralyse(3 SECONDS)
			if(prob(33) && stat == CONSCIOUS && !src.reagents.has_reagent(/singleton/reagent/ethylredoxrazine))
				slurring = max(slurring, 70)
				to_chat(src,SPAN_GOOD("You decide that you like the ground and spend a few seconds to rest."))
				sleeping  = max(sleeping, 6 SECONDS)
				adjustBrainLoss(1,5)

	if(bac > INTOX_BLACKOUT*SR && bac < INTOX_CONSCIOUS*SR && !src.reagents.has_reagent(/singleton/reagent/ethylredoxrazine))//Alcohol poisoing causing short blackouts.
		if (prob(3) && bac < INTOX_BLACKOUT*SR)
			to_chat(src, SPAN_GOOD(pick("You feel very drunk!", "You feel invincible!", "You don't have a care in the world!", "You feel amazing!")))
		if (life_tick % 4 == 1 && prob(5) && stat == CONSCIOUS)
			src.visible_message(SPAN_DANGER("[src] blacks out!"),SPAN_DANGER("You black out!"))
			paralysis = max(paralysis, 6 SECONDS)
			sleeping  = max(sleeping, 6 SECONDS)
			adjustBrainLoss(3,10)

	if(bac > INTOX_CONSCIOUS*SR && !src.reagents.has_reagent(/singleton/reagent/ethylredoxrazine)) //Life threatening alcohol poisoning causing coma and possible loss of breathing.
		if (stat == CONSCIOUS)//Put them into a coma
			src.visible_message(SPAN_DANGER("[src] loses consciousness!"),SPAN_DANGER("You lose consciousness!"))
			paralysis = max(paralysis, 60 SECONDS)
			sleeping  = max(sleeping, 60 SECONDS)
			adjustBrainLoss(5,30)
		if(losebreath && losebreath < 15)//Patient's breathing is suppressed. If already not breathing, don't start again. Stay not breathing.
			losebreath++
		if(prob(1) && life_tick % 10 == 1 && stat == UNCONSCIOUS && bac < INTOX_DEATH*SR)//2.5% chance every minute, roughly, to stop breathing while unconscious.
			if (!losebreath)//To prevent this message from being spammed.
				src.visible_message(SPAN_DANGER("[src] stops breathing!"),SPAN_DANGER("You stop breathing!"))
			losebreath += 15

	if (bac > INTOX_DEATH*SR && !src.reagents.has_reagent(/singleton/reagent/ethylredoxrazine)) //Fatal alcohol poisoning. Central nervous system no longer able to promote unconscious breathing
		if (!losebreath)//To prevent this message from being spammed.
			src.visible_message(SPAN_DANGER("[src] stops breathing!"),SPAN_DANGER("You stop breathing!"))
		if(losebreath < 15)//Stop breathing
			losebreath++

/mob/living/carbon/human/proc/is_drunk()
	var/SR = species.ethanol_resistance
	if(SR == -1)
		return FALSE

	var/bac = get_blood_alcohol()
	if(bac > (INTOX_MUSCLEIMP * SR))
		return TRUE

	return FALSE
