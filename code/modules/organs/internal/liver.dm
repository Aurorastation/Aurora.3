/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	robotic_name = "toxin filter"
	robotic_sprite = "liver-prosthetic"
	var/tolerance = 5

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

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//A liver's duty is to get rid of toxins
		if(owner.getToxLoss() > 0 && owner.getToxLoss() <= tolerance)
			owner.adjustToxLoss(-0.2) //there isn't a lot of toxin damage, so we're going to be chill and slowly filter it out
		else if(owner.getToxLoss() > tolerance)
			if(is_bruised())
				//damaged liver works less efficiently
				owner.adjustToxLoss(-0.5)
				if(!owner.reagents.has_reagent("anti_toxin")) //no damage to liver if anti-toxin is present
					src.damage += 0.1 * PROCESS_ACCURACY
			else if(is_broken())
				//non-functioning liver ADDS toxins
				owner.adjustToxLoss(-0.1) //roughly 33 minutes to kill someone straight out, stacks with 60+ tox proc tho
			else 
				//functioning liver removes toxins at a cost
				owner.adjustToxLoss(-1)
				if(!owner.reagents.has_reagent("anti_toxin")) //no damage to liver if anti-toxin is present
					src.damage += 0.05 * PROCESS_ACCURACY


		//High toxins levels are super dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else
				var/obj/item/organ/O = pick(owner.internal_organs)
				if(O)
					O.damage += 0.2  * PROCESS_ACCURACY

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		var/filter_strength = INTOX_FILTER_HEALTHY
		if(is_bruised())
			filter_strength = INTOX_FILTER_BRUISED
		if(is_broken())
			filter_strength = INTOX_FILTER_DAMAGED

		if (owner.intoxication > 0)
			owner.intoxication -= filter_strength*PROCESS_ACCURACY
			owner.intoxication = max(owner.intoxication, 0)
			if (!owner.intoxication)
				owner.handle_intoxication()

		if(owner.chem_effects[CE_ALCOHOL_TOXIC])
			take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY, prob(1))
			if(is_damaged())
				owner.adjustToxLoss(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY)