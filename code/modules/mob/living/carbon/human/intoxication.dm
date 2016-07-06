#define		AE_DIZZY 		5
#define 	AE_SLURRING 	10
#define 	AE_CONFUSION 	18
#define 	AE_BLURRING 	30
#define 	AE_DROWSY 		55
#define 	AE_OVERDOSE 	80
#define 	AE_BLACKOUT		90

#define		BASE_DIZZY		100

#define 	ALCOHOL_FILTRATION_RATE		0.02//The base rate at which intoxication decreases per proc. this is actually multiplied by 3 most of the time if the liver is healthy

//This proc handles the effects of being intoxicated. Removal of intoxication is done elswhere: By the liver, in organ_internal.dm
/mob/living/carbon/human/proc/handle_intoxication()
	var/SR = species.ethanol_resistance
	if (SR == -1)
		//This species can't get drunk, how did we even get here?
		intoxication = 0
		return

	if(intoxication > AE_DIZZY*SR) // Early warning
		var/target_dizziness = min(1000,(BASE_DIZZY + ((intoxication - AE_DIZZY*SR)*20)/SR))
		make_dizzy(target_dizziness - dizziness) // We will repeatedly set our target dizziness to a desired value based on intoxication level

	if(intoxication > AE_SLURRING*SR) // Slurring
		slurring = max(slurring, 30)

	if(intoxication > AE_CONFUSION*SR) // Confusion - walking in random directions
		confused = max(confused, 20)

	if(intoxication > AE_BLURRING*SR) // Blurry vision
		eye_blurry = max(eye_blurry, 10)

	if(intoxication > AE_DROWSY*SR) // Drowsyness - periodically falling asleep
		drowsyness = max(drowsyness, 20)

	if(intoxication > AE_OVERDOSE*SR) // Toxic dose
		add_chemical_effect(CE_ALCOHOL_TOXIC, 1)

	if(intoxication > AE_BLACKOUT*SR) // Pass out
		paralysis = max(paralysis, 20)
		sleeping  = max(sleeping, 30)
