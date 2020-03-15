/mob/living/silicon/robot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

/mob/living/silicon/robot/getBruteLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed)
			amount += Clamp(C.brute_damage, 0, C.max_damage)
		else if(C.installed == -1)
			amount += C.max_damage / 2
	return amount

/mob/living/silicon/robot/getFireLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed)
			amount += Clamp(C.electronics_damage, 0, C.max_damage)
		else if(C.installed == -1)
			amount += C.max_damage / 2
	return amount

/mob/living/silicon/robot/adjustBruteLoss(var/amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/silicon/robot/adjustFireLoss(var/amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/silicon/robot/proc/get_damaged_components(var/brute, var/burn, var/destroyed = 0)
	var/list/datum/robot_component/parts = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.electronics_damage) || (!C.toggled) || (!C.powered && C.toggled))
				parts += C
	return parts

/mob/living/silicon/robot/proc/get_damageable_components()
	var/list/rval = new
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1) rval += C
	return rval

/mob/living/silicon/robot/proc/get_armour()
	if(!length(components))
		return FALSE
	var/datum/robot_component/C = components["armour"]
	if(C?.installed == TRUE)
		return C
	return FALSE

/mob/living/silicon/robot/heal_organ_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute, burn)
	if(!length(parts))
		return
	var/datum/robot_component/picked = pick(parts)
	picked.heal_damage(brute, burn)

/mob/living/silicon/robot/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/edge = 0, var/emp = 0)
	var/list/components = get_damageable_components()
	if(!length(components))
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active, /obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute * shield.shield_level
		var/absorb_burn = burn * shield.shield_level
		var/cost = (absorb_brute + absorb_burn) * 100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, SPAN_WARNING("Your shield has overloaded!"))
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, SPAN_WARNING("Your shield absorbs some of the impact!"))

	if(!emp)
		var/datum/robot_component/armor/A = get_armour()
		if(A)
			A.take_damage(brute, burn, sharp, edge)
			return

	var/datum/robot_component/C = pick(components)
	C.take_damage(brute, burn, sharp, edge)

/mob/living/silicon/robot/heal_overall_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)

	while(length(parts) && (brute > 0 || burn > 0))
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.electronics_damage)

		parts -= picked

/mob/living/silicon/robot/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	if(status_flags & GODMODE)
		return

	var/list/datum/robot_component/parts = get_damageable_components()
	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute * shield.shield_level
		var/absorb_burn = burn * shield.shield_level
		var/cost = (absorb_brute + absorb_burn) * 100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, SPAN_WARNING("Your shield has overloaded!"))
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, SPAN_WARNING("Your shield absorbs some of the impact!"))

	var/datum/robot_component/armor/A = get_armour()
	if(A)
		A.take_damage(brute, burn, sharp)
		return

	while(length(parts) && (brute > 0 || burn > 0))
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.take_damage(brute,burn)

		brute -= (picked.brute_damage - brute_was)
		burn -= (picked.electronics_damage - burn_was)

		parts -= picked

/mob/living/silicon/robot/emp_act(severity)
	var/datum/robot_component/surge/C = components["surge"]
	if(C?.installed)
		if(C.surge_left >= 1)
			playsound(src.loc, 'sound/magic/LightningShock.ogg', 25, 1)
			C.surge_left -= 1
			visible_message(SPAN_WARNING("\The [src] was not affected by the EMP pulse!"), SPAN_WARNING("Warning: Power surge detected, source - EMP. Surge prevention module re-routed surge to prevent damage to vital electronics."))
			if(C.surge_left)
				to_chat(src, SPAN_NOTICE("Surge protection module can only withstand [C.surge_left] more EMPs!"))
			else
				C.destroy()
				to_chat(src, SPAN_WARNING("Surge protection module fried! Replacement is recommended."))
			return
		else if(C.surge_left == 0.5)
			to_chat(src, SPAN_WARNING("Warning: Power surge detected, source - EMP, integrated surge prevention module is damaged and was unable to fully protect from EMP. Half of the damage taken. Replacement recommended."))
			..(2) // borgs only take 1-2 EMP
			return
		else
			to_chat(src, SPAN_WARNING("Warning: Power surge detected, source - EMP. Surge prevention module is depleted and requires replacement!"))
	..()