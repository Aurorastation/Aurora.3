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
	var/arterial_check = 0
	for(var/obj/item/organ/external/O in organs)
		damage_this_tick += O.burn_dam + O.brute_dam
		if(O.status & ORGAN_ARTERY_CUT)
			arterial_check = 1

	if(damage_this_tick > last_dam || arterial_check != 0)
		. = TRUE
	last_dam = damage_this_tick

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs(seconds_per_tick)
	number_wounds = 0
	var/force_process = recheck_bad_external_organs()

	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs |= Ex

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/I in internal_organs)
		if (QDELETED(I))
			LOG_DEBUG("Organ [DEBUG_REF(src)] was not properly removed from its parent!")
			internal_organs -= I
			continue

		if(I.status & ORGAN_DEAD)
			continue

		I.process(seconds_per_tick)

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

			if (!lying && !buckled_to && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && E.is_broken() && E.internal_organs.len)
					var/obj/item/organ/I = pick(E.internal_organs)
					custom_pain("Pain jolts through your broken [E.name]!", 50)
					I.take_damage(rand(3,5))

				//Moving makes open wounds get infected much faster
				for(var/datum/wound/W in E.wounds)
					if (W.infection_check())
						W.germ_level += 1

/mob/living/carbon/human
	var/next_stance_collapse = 0

/mob/living/carbon/human/proc/handle_stance()
	// Don't need to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if(!stance_damage && (lying || resting))
		return

	stance_damage = 0

	if(next_stance_collapse > world.time)
		return

	// buckled_to to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled_to, /obj/structure/bed))
		return

	stance_damage = species.handle_stance_damage(src)

	//Standing is poor.
	if(stance_damage >= 4 || (stance_damage >= 2 && prob(5)))
		if(!(lying || resting))
			emote("scream")
			if(!weakened)
				custom_emote(VISIBLE_MESSAGE, "collapses!")

		if(stance_damage <= 5)
			Weaken(3)
			next_stance_collapse = world.time + (rand(8, 16) SECONDS)
		else
			Weaken(6) //No legs or feet means you should be really fucked.

/mob/living/carbon/human/proc/handle_grasp()
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		var/holding = inv_slot?.holding
		if(holding)
			var/obj/item/organ/external/E = organs_by_name[bp]
			if((!E || !E.is_usable() || ORGAN_IS_DISLOCATED(E)) && unEquip(holding))
				grasp_damage_disarm(inv_slot)

/mob/living/carbon/human/proc/grasp_damage_disarm(var/obj/item/organ/external/affected)
	var/list/drop_held_item_slots
	if(istype(affected))
		for(var/bp in (list(affected.organ_tag) | affected.children))
			var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, bp)
			if(inv_slot?.holding)
				LAZYDISTINCTADD(drop_held_item_slots, inv_slot)
	else if(istype(affected, /datum/inventory_slot))
		drop_held_item_slots = list(affected)

	if(!LAZYLEN(drop_held_item_slots))
		return

	for(var/datum/inventory_slot/inv_slot in drop_held_item_slots)
		if(!unEquip(inv_slot.holding))
			continue
		var/obj/item/organ/external/E = organs_by_name[inv_slot.slot_id]
		if(!E)
			continue
		if(BP_IS_ROBOTIC(E))
			visible_message("<B>\The [src]</B> drops what they were holding, \his [affected.name] malfunctioning!")
			spark(5)
			continue

		var/grasp_name = E.name
		if((E.body_part in list(ARM_LEFT, ARM_RIGHT)) && length(E.children))
			var/obj/item/organ/external/hand = pick(E.children)
			grasp_name = hand.name

		if(ORGAN_CAN_FEEL_PAIN(E))
			var/emote_scream = pick("screams in pain", "lets out a sharp cry", "cries out")
			var/emote_scream_alt = pick("scream in pain", "let out a sharp cry", "cry out")
			visible_message(
				"<B>\The [src]</B> [emote_scream] and drops what they were holding in their [grasp_name]!",
				null,
				"You hear someone [emote_scream_alt]!"
			)
			custom_pain("The sharp pain in your [E.name] forces you to drop what you were holding in your [grasp_name]!", 30)
		else
			visible_message("<B>\The [src]</B> drops what they were holding in their [grasp_name]!")

/// Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/_A in reagents.reagent_volumes)
		var/singleton/reagent/A = GET_SINGLETON(_A)
		var/obj/item/organ/O = pick(organs)
		O.trace_chemicals[A.name] = 100

/mob/living/carbon/human/proc/sync_organ_dna()
	var/list/all_bits = internal_organs|organs
	for(var/obj/item/organ/O in all_bits)
		O.set_dna(dna)

/mob/living/carbon/human/proc/get_blood_alcohol()
	return round(intoxication/max(REAGENT_VOLUME(vessel, /singleton/reagent/blood),1),0.01)

/mob/living/proc/is_asystole()
	return FALSE

/mob/living/carbon/human/is_asystole()
	if(isSynthetic())
		var/obj/item/organ/internal/machine/power_core/C = internal_organs_by_name[BP_CELL]
		if(istype(C) && C.is_usable() && C.percent())
			var/obj/item/organ/internal/machine/posibrain/posi = internal_organs_by_name[BP_BRAIN]
			if(istype(posi) && !posi.self_preservation_activated)
				return FALSE
		return TRUE

	else if(should_have_organ(BP_HEART))
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
			brain_result = SPAN_BAD("none, patient is braindead")
		if(-1)
			brain_result = "<span class='average'>ERROR - Nonstandard biology</span>"
		else
			if(brain_result <= 50)
				brain_result = SPAN_BAD("[brain_result]%")
			else if(brain_result <= 80)
				brain_result = "<span class='average'>[brain_result]%</span>"
			else
				brain_result = "<span class ='scan_green'>[brain_result]%</span>"
	return brain_result
