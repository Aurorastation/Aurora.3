//Dionaea regenerate health and nutrition in light.

/mob/living/carbon/alien/diona/handle_environment(datum/gas_mixture/environment)
	if(environment && consume_nutrition_from_air)
		environment.remove(diona_handle_air(get_dionastats(), pressure))

	if(stat != DEAD)
		diona_handle_light(DS)

/mob/living/carbon/alien/diona/handle_chemicals_in_body()
	chem_effects.Cut()
	analgesic = 0

	if(touching) touching.metabolize()
	if(bloodstr) bloodstr.metabolize()
	if(breathing) breathing.metabolize()

	// nutrition decrease
	if(nutrition > 0 && stat != DEAD)
		adjustNutritionLoss(nutrition_loss)

	//handle_trace_chems() implement this later maybe
	updatehealth()

	return

/mob/living/carbon/alien/diona/handle_mutations_and_radiation()
	diona_handle_radiation(DS)


/mob/living/carbon/alien/diona/Life()
	if(!detached && gestalt && (gestalt.life_tick % 5 == 0)) // Minimal processing while in stasis
		updatehealth()
		check_status_as_organ()

	else if(!gestalt || detached)
		..()

/mob/living/carbon/alien/diona/think()
	..()
	if(!gestalt)
		if(stat != DEAD)
			if(master_nymph && !client && master_nymph != src)
				walk_to(src, master_nymph, 1, movement_delay())
			else
				walk_to(src, 0)
