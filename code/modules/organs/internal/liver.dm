/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	robotic_name = "toxin filter"
	toxin_type = CE_HEPATOTOXIC
	min_bruised_damage = 25
	min_broken_damage = 55

	max_damage = 70
	relative_size = 60

/obj/item/organ/internal/liver/process()

	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			to_chat(owner, "<span class='warning'>Your skin itches.</span>")
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.delayed_vomit()

	//Detox can heal small amounts of damage
	if (damage < max_damage && !owner.chem_effects[CE_TOXIN])
		heal_damage(0.3 * owner.chem_effects[CE_ANTITOXIN])

	// Get the effectiveness of the liver.
	var/filter_effect = 3
	if(is_bruised())
		filter_effect -= 1
	if(is_broken())
		filter_effect -= 2
	// Robotic organs filter better but don't get benefits from dylovene for filtering.
	if(BP_IS_ROBOTIC(src))
		filter_effect += 1
	if(getToxLoss() >= 60) //Too many toxins to process. Abort, abort.
		filter_effect -= 2
	else if(owner.chem_effects[CE_ANTITOXIN])
		filter_effect += 1

	if(filter_effect < 2) //Trouble. You're not filtering well.
		if(owner.intoxication > 0)
			owner.adjustToxLoss(0.5 * max(2 - filter_effect, 0))

	var/filter_strength = INTOX_FILTER_HEALTHY
	if(is_bruised())
		filter_strength = INTOX_FILTER_BRUISED
	if(is_broken())
		filter_strength = INTOX_FILTER_DAMAGED
	if(BP_IS_ROBOTIC(src))
		filter_strength *= 1.1

	if (owner.intoxication > 0)
		var/bac = owner.get_blood_alcohol()
		var/res = owner.species ? owner.species.ethanol_resistance : 1
		if(bac >= INTOX_MUSCLEIMP * res) //Excessive blood alcohol, difficult to filter
			owner.intoxication -= min(owner.intoxication, filter_strength/2)
		else
			owner.intoxication -= min(owner.intoxication, filter_strength)
		if(!owner.intoxication)
			owner.handle_intoxication()

	if(toxin_type in owner.chem_effects)
		if(is_damaged())
			owner.adjustToxLoss(owner.chem_effects[toxin_type] * 0.1 * PROCESS_ACCURACY) // as actual organ damage is handled elsewhere

/obj/item/organ/internal/liver/handle_regeneration()
	if(..())
		testing("Liver regenerating!")
		if(!owner.total_radiation && damage > 0)
			if(damage < min_broken_damage)
				heal_damage(0.2)
			if(damage < min_bruised_damage)
				heal_damage(0.3)
			return TRUE
	return FALSE
