#define		AE_DIZZY 		5
#define		AE_BUZZED_MIN	6
#define 	AE_SLURRING 	15
#define 	AE_CONFUSION 	18
#define		AE_CLUMSY		22
#define 	AE_BUZZED_MAX	24
#define 	AE_BLURRING 	25
#define		AE_VOMIT		40
#define 	AE_DROWSY 		55
#define 	AE_OVERDOSE 	70
#define 	AE_BLACKOUT		80

#define		BASE_DIZZY		100

#define 	ALCOHOL_FILTRATION_RATE		0.02//The base rate at which intoxication decreases per proc. this is actually multiplied by 3 most of the time if the liver is healthy
#define		BASE_VOMIT_CHANCE			2
#define		VOMIT_CHANCE_SCALE			0.2//An extra 1% for every 5 units over the vomiting threshold

var/mob/living/carbon/human/alcohol_clumsy = 0

//This proc handles the effects of being intoxicated. Removal of intoxication is done elswhere: By the liver, in organ_internal.dm
/mob/living/carbon/human/proc/handle_intoxication()
	var/SR = species.ethanol_resistance
	if (SR == -1)
		//This species can't get drunk, how did we even get here?
		intoxication = 0
		return

	if(intoxication > AE_DIZZY*SR) // Early warning
		if (dizziness == 0)
			src << "<span class='notice'>The room starts spinning!</span>"
		var/target_dizziness = min(1000,(BASE_DIZZY + ((intoxication - AE_DIZZY*SR)*10)/SR))
		make_dizzy(target_dizziness - dizziness) // We will repeatedly set our target dizziness to a desired value based on intoxication level

	if(intoxication > AE_SLURRING*SR) // Slurring
		slurring = max(slurring, 30)

	if(intoxication > AE_CONFUSION*SR) // Confusion - walking in random directions
		if (confused == 0)
			src << "<span class='notice'>You feel unsteady on your feet!</span>"
		confused = max(confused, 20)

	//Make the drinker temporarily clumsy if intoxication is high enough
	//We use a var to track if alcohol caused it, we won't add nor remove it if the drinker was already clumsy from some other source
	if(intoxication > AE_CLUMSY*SR)
		if (!alcohol_clumsy && !(CLUMSY in mutations))
			src << "<span class='notice'>You feel a bit clumsy and uncoordinated.</span>"
			mutations.Add(CLUMSY)
			alcohol_clumsy = 1
	else //Remove it if intoxication drops too low. We'll also have another check to remove it in life.dm
		if (alcohol_clumsy)
			src << "<span class='notice'>You feel more sober and steady</span>"
			mutations.Remove(CLUMSY)
			alcohol_clumsy = 0

	if(intoxication > AE_BLURRING*SR) // Blurry vision
		if (prob(10))//blurry vision effect is annoying, so nerfing it
			eye_blurry = max(eye_blurry, 2)

	if(intoxication > AE_DROWSY*SR) // Drowsyness - periodically falling asleep
		drowsyness = max(drowsyness, 20)

	if(intoxication > AE_VOMIT*SR)//Vomiting, the body's natural defense mechanism against poisoning.
		if (life_tick % 4 == 1)//Only process vomit chance periodically
			var/chance = BASE_VOMIT_CHANCE + ((intoxication - AE_VOMIT)*VOMIT_CHANCE_SCALE)
			if (prob(chance))
				delayed_vomit()

	if(intoxication > AE_OVERDOSE*SR) // Toxic dose
		add_chemical_effect(CE_ALCOHOL_TOXIC, 1)

	if(intoxication > AE_BLACKOUT*SR) // Pass out
		paralysis = max(paralysis, 20)
		sleeping  = max(sleeping, 30)

	if( intoxication >= AE_BUZZED_MIN && intoxication <= AE_BUZZED_MAX && !(locate(/datum/modifier/buzzed) in modifiers))
		add_modifier(/datum/modifier/buzzed, MODIFIER_CUSTOM)


//Pleasant feeling from being slightly drunk
//Makes you faster and reduces sprint cost
//Wears off if you get too drunk or too sober, a balance must be maintained
/datum/modifier/buzzed

/datum/modifier/buzzed/activate()
	..()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.move_delay_mod += -0.75

		H.sprint_cost_factor += -0.1

/datum/modifier/buzzed/deactivate()
	..()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.move_delay_mod -= -0.75

		H.sprint_cost_factor -= -0.1

/datum/modifier/buzzed/custom_validity()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		if (H.intoxication >= AE_BUZZED_MIN && H.intoxication <= AE_BUZZED_MAX)

			return 1
	return 0

#undef		AE_DIZZY
#undef		AE_BUZZED_MIN
#undef 		AE_SLURRING
#undef 		AE_CONFUSION
#undef		AE_CLUMSY
#undef 		AE_BUZZED_MAX
#undef 		AE_BLURRING
#undef		AE_VOMIT
#undef 		AE_DROWSY
#undef 		AE_OVERDOSE
#undef 		AE_BLACKOUT