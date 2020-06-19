/mob/proc/can_use_codex()
	return FALSE

/mob/new_player/can_use_codex()
	return TRUE

/mob/living/silicon/can_use_codex()
	return TRUE

/mob/observer/can_use_codex()
	return TRUE

/mob/living/carbon/human/can_use_codex()
	var/obj/item/organ/internal/augment/codex/C = internal_organs_by_name[BP_AUG_CODEX]
	if(C && !C.is_broken())
		return TRUE
	return FALSE

/mob/living/carbon/human/get_codex_value()
	return "[lowertext(species.name)] (species)"