/datum/species/proc/take_manifest_ghost_damage(var/mob/living/carbon/C)
	C.take_organ_damage(1, 0)
	return TRUE

/datum/species/diona/take_manifest_ghost_damage(mob/living/carbon/C)
	C.take_organ_damage(2, 0)
	C.adjustNutritionLoss(5)
	if(C.nutrition <= C.max_nutrition * 0.05)
		to_chat(C, SPAN_WARNING("We cannot support our summoned apparitions with our biomass any longer..."))
		return FALSE
	return TRUE