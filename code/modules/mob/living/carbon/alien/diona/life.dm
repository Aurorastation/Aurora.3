//Dionaea regenerate health and nutrition in light.

/mob/living/carbon/alien/diona/handle_environment(datum/gas_mixture/environment)
	if (stat != DEAD)
		diona_handle_light(DS)

/mob/living/carbon/alien/diona/handle_chemicals_in_body()
	chem_effects.Cut()
	analgesic = 0

	if(touching) touching.metabolize()
	if(ingested) ingested.metabolize()
	if(bloodstr) bloodstr.metabolize()

	// nutrition decrease
	if (nutrition > 0 && stat != 2)
		nutrition = max (0, nutrition - nutrition_loss)

	if (nutrition > max_nutrition)
		nutrition = max_nutrition

	//handle_trace_chems() implement this later maybe
	updatehealth()

	return

/mob/living/carbon/alien/diona/handle_mutations_and_radiation()
	diona_handle_radiation(DS)


/mob/living/carbon/alien/diona/Life()
	if (gestalt && (gestalt.life_tick % 5 == 0))//Minimal processing while in stasis
		updatehealth()
		check_status_as_organ()

	if (!gestalt)
		..()

/mob/living/carbon/alien/diona/think()
	..()
	if (!gestalt)
		if(master_nymph && !client && master_nymph != src)
			walk_to(src,master_nymph,1,movement_delay())
		else
			walk_to(src,0)
