//This proc handles the effects of being intoxicated. Removal of intoxication is done elswhere: By the liver, in organ_internal.dm
/mob/living/carbon/human/proc/handle_intoxication()


	var/SR = species.ethanol_resistance
	if (SR == -1)
		//This species can't get drunk, how did we even get here?
		intoxication = 0
		return

	//Godmode messes some things up, so no more BSTs getting drunk unless they toggle it off
	if (status_flags & GODMODE)
		intoxication = 0 //Zero out intoxication but don't return, let the rest of this function run to remove any residual effects
		slurring = 0
		confused = 0
		eye_blurry = 0
		drowsyness = 0
		paralysis = 0
		sleeping = 0
		//Many of these parameters normally tick down in life code, but some parts of that code don't run in godmode, so this prevents a BST being stuck with blurred vision

	var/bac = get_blood_alcohol()

	if(bac > INTOX_BUZZED*SR && bac < INTOX_MUSCLEIMP*SR && !(locate(/datum/modifier/buzzed) in modifiers))
		to_chat(src,"<span class='notice'>You feel buzzed.</span>")
		add_modifier(/datum/modifier/buzzed, MODIFIER_CUSTOM)

	if(bac > INTOX_JUDGEIMP*SR)
		if (dizziness == 0)
			to_chat(src,"<span class='notice'>You feel a little tipsy.</span>")
		var/target_dizziness = BASE_DIZZY + ((bac - INTOX_JUDGEIMP*SR)*DIZZY_ADD_SCALE*100)
		make_dizzy(target_dizziness - dizziness)

	if(bac > INTOX_MUSCLEIMP*SR)
		slurring = max(slurring, 25)
		if (!(locate(/datum/modifier/drunk) in modifiers))
			to_chat(src,"<span class='notice'>You feel drunk!</span>")
			add_modifier(/datum/modifier/drunk, MODIFIER_CUSTOM)

	if(bac > INTOX_REACTION*SR)
		if (confused == 0)
			to_chat(src,"<span class='warning'>You feel uncoordinated and unsteady on your feet!</span>")
		confused = max(confused, 10)
		slurring = max(slurring, 50)

	if(bac > INTOX_VOMIT*SR)
		slurring = max(slurring, 75)
		if (life_tick % 4 == 1)
			var/chance = BASE_VOMIT_CHANCE + ((bac - INTOX_VOMIT*SR)*VOMIT_CHANCE_SCALE*100)
			if (prob(chance))
				delayed_vomit()
				add_chemical_effect(CE_ALCOHOL_TOXIC, 1)

	if(bac > INTOX_BALANCE*SR)
		slurring = max(slurring, 100)
		if (life_tick % 4 == 1 && !lying && !buckled && prob(10))
			src.visible_message("<span class='warning'>[src] loses balance and falls to the ground!</span>","<span class='warning'>You lose balance and fall to the ground!</span>")
			Paralyse(3 SECONDS)
			if(bac > INTOX_CONSCIOUS*SR)
				slurring = max(slurring, 90)
				src.visible_message("<span class='danger'>[src] loses consciousness!</span>","<span class='danger'>You lose consciousness!</span>")
				paralysis = max(paralysis, 60 SECONDS)
				sleeping  = max(sleeping, 60 SECONDS)
				adjustBrainLoss(5,30)
			else if(bac > INTOX_BLACKOUT*SR)
				slurring = max(slurring, 80)
				src.visible_message("<span class='danger'>[src] blackouts!</span>","<span class='danger'>You blackout!</span>")
				paralysis = max(paralysis, 20 SECONDS)
				sleeping  = max(sleeping, 20 SECONDS)
				adjustBrainLoss(3,10)
			else if(prob(10))
				slurring = max(slurring, 70)
				to_chat(src,"<span class='warning'>You decide that you like the ground and spend a few seconds to rest.</span>")
				sleeping  = max(sleeping, 6 SECONDS)
				adjustBrainLoss(1,5)

	if (bac > INTOX_DEATH*SR && !src.reagents.has_reagent("ethylredoxrazine")) //Death usually occurs here
		add_chemical_effect(CE_ALCOHOL_TOXIC, 10)
		adjustOxyLoss(3,100)
		adjustBrainLoss(1,50)


//Pleasant feeling from being slightly drunk
//Makes you faster and reduces sprint cost
//Wears off if you get too drunk or too sober, a balance must be maintained
/datum/modifier/buzzed

/datum/modifier/buzzed/activate()
	..()
	var/mob/living/carbon/human/H = target
	if(istype(H))
		H.move_delay_mod += -0.75
		H.sprint_cost_factor += -0.1

/datum/modifier/buzzed/deactivate()
	..()
	var/mob/living/carbon/human/H = target
	if(istype(H))
		H.move_delay_mod -= -0.75
		H.sprint_cost_factor -= -0.1

/datum/modifier/buzzed/custom_validity()
	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0
	var/bac = H.get_blood_alcohol()
	if(bac >= INTOX_BUZZED*H.species.ethanol_resistance && bac <= INTOX_MUSCLEIMP*H.species.ethanol_resistance)
		return 1

	return 0

/datum/modifier/drunk

/datum/modifier/drunk/activate()
	..()
	var/mob/living/carbon/human/H = target
	if(istype(H))
		H.move_delay_mod += 2
		H.sprint_cost_factor += 0.2

/datum/modifier/drunk/deactivate()
	..()
	var/mob/living/carbon/human/H = target
	if(istype(H))
		H.move_delay_mod -= 2
		H.sprint_cost_factor -= -0.2

/datum/modifier/drunk/custom_validity()
	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0
	if(H.get_blood_alcohol() >= INTOX_MUSCLEIMP*H.species.ethanol_resistance)
		return 1

	return 0