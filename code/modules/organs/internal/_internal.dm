/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.
	var/damage_reduction = 0.5     //modifier for internal organ injury
	var/unknown_pain_location = TRUE // if TRUE, pain messages will point to the parent organ, otherwise it will print the organ name
	var/toxin_type = "undefined"
	var/relative_size = 25 //Used for size calcs
	var/on_mob_icon
	var/list/possible_modifications = list("Normal","Assisted","Mechanical") //this is used in the character setup

	min_broken_damage = 10 //Internal organs are frail, man.

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

/obj/item/organ/internal/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	if(!istype(target))
		return 0

	// robotic organs emulate behavior of the equivalent flesh organ of the species
	if(BP_IS_ROBOTIC(src) || !species)
		species = target.species

	..()

	STOP_PROCESSING(SSprocessing, src)
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	return 1

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/proc/surgical_fix(mob/user)
	if(damage > min_broken_damage && !(status & ORGAN_ROBOT))
		var/scarring = damage / max_damage
		scarring = 1 - 0.5 * scarring ** 2 // Between ~15 and 50 percent loss.
		var/new_max_dam = Floor(scarring * max_damage)
		if(new_max_dam < max_damage)
			to_chat(user, SPAN_WARNING("Not every part of [src] could be saved; some dead tissue had to be removed, making it more susceptible to future damage."))
			set_max_damage(new_max_dam)
	heal_damage(damage)

/obj/item/organ/internal/proc/get_scarring_level()
	. = (initial(max_damage) - max_damage)/initial(max_damage)

/obj/item/organ/internal/proc/get_scarring_results()
	var/scar_level = get_scarring_level()
	if(scar_level > 0.01)
		. += "[get_wound_severity(get_scarring_level())] scarring"

/obj/item/organ/internal/is_usable()
	if(robotize_type)
		var/datum/robolimb/R = all_robolimbs[robotize_type]
		if(!R.malfunctioning_check(owner))
			return TRUE
	else
		return ..() && !is_broken()

/obj/item/organ/internal/proc/is_damaged()
	return damage > 0 || special_condition()

/obj/item/organ/internal/proc/special_condition() // For unique conditions
	return

/obj/item/organ/internal/robotize(var/company = "Unbranded")
	..()
	min_bruised_damage += 5
	min_broken_damage += 10

	if(company)
		model = company
		var/datum/robolimb/R = all_robolimbs[company]

		if(R)
			if(robotic_sprite)
				icon_state = "[initial(icon_state)]-[R.internal_organ_suffix]"

			robotize_type = company

/obj/item/organ/internal/proc/getToxLoss()
	if(BP_IS_ROBOTIC(src))
		return damage * 0.5
	return damage

/obj/item/organ/internal/proc/set_max_damage(var/ndamage)
	max_damage = Floor(ndamage)
	min_broken_damage = Floor(0.75 * max_damage)
	min_bruised_damage = Floor(0.25 * max_damage)

/obj/item/organ/internal/proc/take_internal_damage(amount, var/silent=0)
	if(BP_IS_ROBOTIC(src))
		damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && ORGAN_CAN_FEEL_PAIN(src) && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(damage < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree]!", amount, affecting = parent)

/obj/item/organ/internal/proc/get_visible_state()
	if(damage > max_damage)
		. = "bits and pieces of a destroyed "
	else if(is_broken())
		. = "broken "
	else if(is_bruised())
		. = "badly damaged "
	else if(damage > 5)
		. = "damaged "
	if(status & ORGAN_DEAD)
		if(can_recover())
			. = "decaying [.]"
		else
			. = "necrotic [.]"
	. = "[.][name]"

/obj/item/organ/internal/process()
	..()
	if(istype(owner) && (toxin_type in owner.chem_effects))
		take_damage(owner.chem_effects[toxin_type] * 0.1 * PROCESS_ACCURACY, prob(1))
	handle_regeneration()
	tick_surge_damage() //Yes, this is intentional.

/obj/item/organ/internal/proc/handle_regeneration()
	SHOULD_CALL_PARENT(TRUE)
	if(damage && !BP_IS_ROBOTIC(src) && istype(owner))
		if(!owner.is_asystole())
			if(!(owner.chem_effects[CE_TOXIN] || (toxin_type in owner.chem_effects)))
				var/repair_modifier = owner.chem_effects[CE_ORGANREPAIR] || 0.1
				if(damage < repair_modifier*max_damage)
					heal_damage(repair_modifier)
				return TRUE // regeneration is allowed
	return FALSE // regeneration is prevented
