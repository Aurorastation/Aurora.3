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
		if(prob(5))
			to_chat(src, SPAN_NOTICE("You feel buzzed."))

	if(bac > INTOX_JUDGEIMP*SR)
		if (dizziness == 0)
			to_chat(src, SPAN_NOTICE("You feel a little tipsy."))
		var/target_dizziness = BASE_DIZZY + ((bac - INTOX_JUDGEIMP*SR)*DIZZY_ADD_SCALE*100)
		make_dizzy(target_dizziness - dizziness)

	if(bac > INTOX_MUSCLEIMP*SR && bac < INTOX_REACTION*SR)
		slurring = max(slurring, 25)
		if (prob(5))
			to_chat(src, SPAN_NOTICE("You feel drunk!"))
		move_delay_mod += 2
		sprint_cost_factor += 0.2

	if(bac > INTOX_REACTION*SR && bac < INTOX_BALANCE*SR)
		if (prob(5))
			to_chat(src, SPAN_NOTICE("You feel absolutely smashed!"))
		if (confused == 0)
			to_chat(src, SPAN_WARNING("You feel uncoordinated and unsteady on your feet!"))
		confused = max(confused, 10)
		slurring = max(slurring, 50)

	if(bac > INTOX_VOMIT*SR)
		slurring = max(slurring, 75)
		if (life_tick % 4 == 1)
			var/chance = BASE_VOMIT_CHANCE + ((bac - INTOX_VOMIT*SR)*VOMIT_CHANCE_SCALE*100)
			if (prob(chance))
				delayed_vomit()

	if(bac > INTOX_BALANCE*SR)
		slurring = max(slurring, 100)
		if (prob(5))
			to_chat(src, SPAN_NOTICE("You feel the room spinning..."))
		if (life_tick % 4 == 1 && !lying && !buckled_to && prob(10))
			src.visible_message(SPAN_WARNING("[src] loses balance and falls to the ground!"),SPAN_WARNING("You lose balance and fall to the ground!"))
			Paralyse(3 SECONDS)
			if(bac > INTOX_CONSCIOUS*SR)
				slurring = max(slurring, 90)
				src.visible_message(SPAN_DANGER("[src] loses consciousness!"),SPAN_DANGER("You lose consciousness!"))
				paralysis = max(paralysis, 60 SECONDS)
				sleeping  = max(sleeping, 60 SECONDS)
				adjustBrainLoss(5,30)
				add_chemical_effect(CE_HEPATOTOXIC, 3)
			else if(bac > INTOX_BLACKOUT*SR)
				slurring = max(slurring, 80)
				src.visible_message(SPAN_DANGER("[src] blacks out!"),SPAN_DANGER("You black out!"))
				paralysis = max(paralysis, 20 SECONDS)
				sleeping  = max(sleeping, 20 SECONDS)
				adjustBrainLoss(3,10)
				add_chemical_effect(CE_HEPATOTOXIC, 1)
			else if(prob(10))
				slurring = max(slurring, 70)
				to_chat(src,SPAN_WARNING("You decide that you like the ground and spend a few seconds to rest."))
				sleeping  = max(sleeping, 6 SECONDS)
				adjustBrainLoss(1,5)

	if (bac > INTOX_DEATH*SR && !src.reagents.has_reagent(/singleton/reagent/ethylredoxrazine)) //Death usually occurs here
		add_chemical_effect(CE_HEPATOTOXIC, 10)
		adjustOxyLoss(3,100)
		adjustBrainLoss(1,50)

/mob/living/carbon/human/proc/is_drunk()
	var/SR = species.ethanol_resistance
	if(SR == -1)
		return FALSE

	var/bac = get_blood_alcohol()
	if(bac > (INTOX_MUSCLEIMP * SR))
		return TRUE

	return FALSE
