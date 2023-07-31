/mob/living/carbon/human/get_acrobatics_multiplier(var/singleton/maneuver/attempting_maneuver)
	. = ..()

	// Broken limb checks
	for (var/_limb in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/limb = get_organ(_limb)
		if (limb.status & ORGAN_BROKEN)
			. -= limb.status & ORGAN_SPLINTED ? 0.25 : 0.5

/mob/living/carbon/human/get_jump_distance()
	. = species.standing_jump_range
	
	var/obj/item/organ/internal/augment/suspension/suspension = internal_organs_by_name[BP_AUG_SUSPENSION]

	if(suspension && . < 3)
		. = max(. + suspension.jump_bonus, 3) 

/mob/living/carbon/human/can_do_maneuver(var/singleton/maneuver/maneuver, var/silent = FALSE)
	. = ..()
	if(.)
		if(nutrition <= 20)
			if(!silent)
				to_chat(src, SPAN_WARNING("You are too hungry to jump around."))
			return FALSE
		if(hydration <= 20)
			if(!silent)
				to_chat(src, SPAN_WARNING("You are too thirsty to jump around."))
			return FALSE

/mob/living/carbon/human/post_maneuver()
	..()

	var/broken_limb_fail_chance = 0
	var/list/broken_limbs = list()
	for (var/_limb in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/limb = get_organ(_limb)
		if (limb.status & ORGAN_BROKEN)
			broken_limbs += limb
			broken_limb_fail_chance += limb.status & ORGAN_SPLINTED ? 25 : 50
	if (broken_limb_fail_chance)
		var/obj/item/organ/external/limb = pick(broken_limbs)
		if (prob(broken_limb_fail_chance))
			visible_message(
				SPAN_WARNING("\The [src]'s [limb.name] buckles beneath them as they land!"),
				SPAN_DANGER("Your [limb.name] buckles beneath you as you land!")
			)
			apply_effect(1, WEAKEN)
			limb.add_pain(30)
			limb.take_damage(5)
		else
			to_chat(src, SPAN_DANGER("You feel a sharp pain through your [limb.name] as you land!"))
			apply_effect(1, STUN)
			limb.add_pain(15)
