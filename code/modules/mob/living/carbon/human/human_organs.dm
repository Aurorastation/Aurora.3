/mob/living/carbon/human/proc/update_eyes()
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[species.vision_organ || BP_EYES]
	if(eyes)
		eyes.update_colour()
		regenerate_icons()

/mob/living/carbon/var/list/internal_organs = list()
/mob/living/carbon/var/shock_stage = 0
/mob/living/carbon/human/var/list/organs = list()

/mob/living/carbon/human/proc/recheck_bad_external_organs()
	var/damage_this_tick = getToxLoss()
	for(var/obj/item/organ/external/O in organs)
		damage_this_tick += O.burn_dam + O.brute_dam

	if(damage_this_tick > last_dam)
		. = TRUE
	last_dam = damage_this_tick

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()

	number_wounds = 0
	var/force_process = recheck_bad_external_organs()

	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs |= Ex

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/I in internal_organs)
		if (QDELETED(I))
			log_debug("Organ [DEBUG_REF(src)] was not properly removed from its parent!")
			internal_organs -= I
			continue

		I.process()

	handle_stance()
	handle_grasp()

	if(!force_process && !bad_external_organs.len)
		return

	for(var/obj/item/organ/external/E in bad_external_organs)
		if(QDELETED(E))
			continue
		if(!E.need_process())
			bad_external_organs -= E
			continue
		else
			E.process()
			number_wounds += E.number_wounds

			if (!lying && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && E.is_broken() && E.internal_organs.len)
					var/obj/item/organ/I = pick(E.internal_organs)
					custom_pain("Pain jolts through your broken [E.name]!", 50)
					I.take_damage(rand(3,5))

				//Moving makes open wounds get infected much faster
				if (E.wounds.len)
					for(var/datum/wound/W in E.wounds)
						if (W.infection_check())
							W.germ_level += 1

/mob/living/carbon/human/proc/handle_stance()
	// Don't need to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if (!stance_damage && (lying || resting) && (life_tick % 4) == 0)
		return

	stance_damage = 0

	// Buckled to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled, /obj/structure/bed))
		return

	for(var/limb_tag in list(BP_L_LEG,BP_R_LEG,BP_L_FOOT,BP_R_FOOT))
		var/obj/item/organ/external/E = organs_by_name[limb_tag]
		if(!E || (E.status & (ORGAN_MUTATED|ORGAN_DEAD)) || E.is_stump()) //should just be !E.is_usable() here but dislocation screws that up.
			stance_damage += 2 // let it fail even if just foot&leg
		else if (E.is_malfunctioning())
			//malfunctioning only happens intermittently so treat it as a missing limb when it procs
			stance_damage += 2
			if(prob(10))
				visible_message("\The [src]'s [E.name] [pick("twitches", "shudders")] and sparks!")
				spark(src, 5)
		else if (E.is_broken() || !E.is_usable())
			stance_damage += 1
		else if (E.is_dislocated())
			stance_damage += 0.5

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane mitigates a broken leg+foot, or a missing foot.
	// Two canes are needed for a lost leg. If you are missing both legs, canes aren't gonna help you.
	if (l_hand && istype(l_hand, /obj/item/cane))
		stance_damage -= 2
	if (r_hand && istype(r_hand, /obj/item/cane))
		stance_damage -= 2

	// standing is poor
	if(stance_damage >= 4 || (stance_damage >= 2 && prob(5)))
		if(!(lying || resting))
			if(can_feel_pain())
				emote("scream")
			custom_emote(1, "collapses!")
		Weaken(5) //can't emote while weakened, apparently.

/mob/living/carbon/human/proc/handle_grasp()
	if(!l_hand && !r_hand)
		return

	// You should not be able to pick anything up, but stranger things have happened.
	if(l_hand)
		for(var/limb_tag in list(BP_L_HAND,BP_L_ARM))
			var/obj/item/organ/external/E = get_organ(limb_tag)
			if(!E)
				visible_message("<span class='danger'>Lacking a functioning left hand, \the [src] drops \the [l_hand].</span>")
				drop_from_inventory(l_hand)
				break

	if(r_hand)
		for(var/limb_tag in list(BP_R_HAND,BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(limb_tag)
			if(!E)
				visible_message("<span class='danger'>Lacking a functioning right hand, \the [src] drops \the [r_hand].</span>")
				drop_from_inventory(r_hand)
				break

	// Check again...
	if(!l_hand && !r_hand)
		return

	for (var/obj/item/organ/external/E in organs)
		if(!E || !(E.limb_flags & ORGAN_CAN_GRASP) || (E.status & ORGAN_SPLINTED))
			continue

		if(E.is_broken() || E.is_dislocated())
			switch(E.body_part)
				if(HAND_LEFT, ARM_LEFT)
					if(!l_hand)
						continue
					drop_from_inventory(l_hand)
				if(HAND_RIGHT, ARM_RIGHT)
					if(!r_hand)
						continue
					drop_from_inventory(r_hand)

			var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
			emote("me", 1, "[(species.flags & NO_PAIN) ? "" : emote_scream ]drops what they were holding in their [E.name]!")

		else if(!(E.status & ORGAN_ROBOT) && CE_DROPITEM in chem_effects && prob(chem_effects[CE_DROPITEM]))
			to_chat(src, span("warning", "Your [E.name] goes limp and unresponsive for a moment, dropping what it was holding!"))
			emote("me", 1, "drops what they were holding in their [E.name]!")
			switch(E.body_part)
				if(HAND_LEFT, ARM_LEFT)
					if(!l_hand)
						continue
					drop_from_inventory(l_hand)
				if(HAND_RIGHT, ARM_RIGHT)
					if(!r_hand)
						continue
					drop_from_inventory(r_hand)

		else if(E.is_malfunctioning())
			switch(E.body_part)
				if(HAND_LEFT, ARM_LEFT)
					if(!l_hand)
						continue
					drop_from_inventory(l_hand)
				if(HAND_RIGHT, ARM_RIGHT)
					if(!r_hand)
						continue
					drop_from_inventory(r_hand)

			emote("me", 1, "drops what they were holding, their [E.name] malfunctioning!")

			spark(src, 5)

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.reagent_list)
		var/obj/item/organ/O = pick(organs)
		O.trace_chemicals[A.name] = 100

/mob/living/carbon/human/proc/sync_organ_dna()
	var/list/all_bits = internal_organs|organs
	for(var/obj/item/organ/O in all_bits)
		O.set_dna(dna)

/mob/living/carbon/human/proc/get_blood_alcohol()
	return round(intoxication/max(vessel.get_reagent_amount("blood"),1),0.01)

/mob/living/proc/is_asystole()
	return FALSE

/mob/living/carbon/human/is_asystole()
	if(species.has_organ[BP_HEART] && !isSynthetic())
		var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
		if(!istype(heart) || !heart.is_working())
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/get_brain_result()
	var/brain_result
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = internal_organs_by_name[BP_BRAIN]
		if(!brain || stat == DEAD || (status_flags & FAKEDEATH))
			brain_result = 0
		else if(stat != DEAD)
			brain_result = round(max(0,(1 - brain.damage/brain.max_damage)*100))
	else
		brain_result = -1
	return brain_result

/mob/living/carbon/human/proc/get_brain_status()
	var/brain_result = get_brain_result()
	switch(brain_result)
		if(0)
			brain_result = "<span class='bad'>none, patient is braindead</span>"
		if(-1)
			brain_result = "<span class='average'>ERROR - Nonstandard biology</span>"
		else
			if(brain_result <= 50)
				brain_result = "<span class='bad'>[brain_result]%</span>"
			else if(brain_result <= 80)
				brain_result = "<span class='average'>[brain_result]%</span>"
			else
				brain_result = "<span class ='scan_green'>[brain_result]%</span>"
	return brain_result
