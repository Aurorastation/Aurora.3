/obj/item/organ/internal/parasite
	name = "parasite"

	organ_tag = "parasite"
	var/stage = 1
	var/max_stage = 4
	var/stage_ticker = 0
	var/recession = 0

	///Infection progress speed, will be determined by get_infect_speed()
	var/infection_speed = 2

	///The fastest the parasite will advance its stage
	var/infect_speed_high = 35

	///The fastest the parasite will advance its stage
	var/infect_speed_low = 15

	///Time between stages, in seconds. interval of 300 allows convenient treating with antiparasitics, higher will require spaced dosing of medications.
	var/stage_interval = 300

	///Boolean, if the body should reject the parasite naturally
	var/subtle = FALSE

	///Does the parasite have a reagent which seeds an infection?
	var/egg = null

	//Boolean, if the parasite is resistant to antiparasitic medications
	var/drug_resistance = FALSE

/obj/item/organ/internal/parasite/Initialize()
	. = ..()
	get_infect_speed()

/obj/item/organ/internal/parasite/proc/get_infect_speed() //Slightly randomizes how fast each infection progresses.
	infection_speed = rand(infect_speed_low, infect_speed_high) / 10

/obj/item/organ/internal/parasite/process()
	..()
	if(!owner)
		return

	if(owner.chem_effects[CE_ANTIPARASITE] && !drug_resistance)
		recession = owner.chem_effects[CE_ANTIPARASITE]/10

	if((stage < max_stage) && !recession)
		stage_ticker = Clamp(stage_ticker+=infection_speed, 0, stage_interval*max_stage)
		if(stage_ticker >= stage*stage_interval)
			process_stage()
			get_infect_speed() //Each stage may progress faster or slower than the previous one
			stage_effect()

	if(recession)
		stage_ticker = Clamp(stage_ticker-=recession, 0, stage_interval*max_stage)
		if(stage_ticker <= stage*stage_interval-stage_interval)
			stage = max(stage-1, 1)
			stage_effect()
		if(!owner.chem_effects[CE_ANTIPARASITE] || drug_resistance)
			recession = 0
		if(stage_ticker == 0)
			qdel(src)

/obj/item/organ/internal/parasite/handle_rejection()
	if(subtle)
		return ..()
	else
		if(rejecting)
			rejecting = 0
		return

/obj/item/organ/internal/parasite/proc/process_stage()
	stage = min(stage+1,max_stage)

/obj/item/organ/internal/parasite/proc/stage_effect()
	return
