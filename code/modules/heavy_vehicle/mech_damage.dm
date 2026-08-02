///Returns TRUE if an incomming attack should target the pilot instead of the mech, FALSE otherwise.
/mob/living/heavy_vehicle/proc/should_target_pilot()
	if(!body || !LAZYLEN(pilots)) //If there is no pilot, or the mech somehow doesn't have a body don't try hit the pilot.
		return FALSE

	if(!prob(body.pilot_coverage)) //If the cockpit doesn't cover the pilot completely, attacks have a chance to hit the pilot instead of the mech.
		return TRUE

	if(!hatch_closed) //If the hatch is open, attacks have a chance to hit the pilot instead of the mech.
		if(prob(80)) //80% chance to hit the pilot if the hatch is open. If this is 100% turrets will shoot mechs with open hatches forever.
			return TRUE

	return FALSE

/mob/living/heavy_vehicle/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))
		return 0

	if(should_target_pilot())
		if(effect > 0 && effecttype == DAMAGE_RADIATION)
			var/mob/living/pilot = pick(pilots)
			return pilot.apply_effect(effect, effecttype, blocked)
	if(!(effecttype in list(DAMAGE_PAIN, STUTTER, EYE_BLUR, DROWSY, STUN, WEAKEN)))
		. = ..()

/mob/living/heavy_vehicle/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(should_target_pilot())
		var/mob/living/pilot = pick(pilots)
		return pilot.hitby(arglist(args))
	. = ..()

/mob/living/heavy_vehicle/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(should_target_pilot())
		var/mob/living/pilot = pick(pilots)
		if(pilot)
			return pilot.bullet_act(hitting_projectile, def_zone, piercing_hit)
	return ..()

/mob/living/heavy_vehicle/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = ..()
	if(body)
		if(body.mech_armor)
			var/body_armor = body.mech_armor.GetComponent(/datum/component/armor)
			if(body_armor)
				. += body_armor
		else
			var/chassis_armor = body.GetComponent(/datum/component/armor)
			if(chassis_armor)
				. += chassis_armor

/mob/living/heavy_vehicle/updatehealth()
	maxhealth = body.mech_health
	health = maxhealth-(getFireLoss()+getBruteLoss())

/mob/living/heavy_vehicle/adjustFireLoss(var/amount, var/obj/item/mech_component/C)
	if(C)
		C.take_brute_damage(amount)
		C.update_component_damage()
	else
		var/list/components = list(body, arms, legs, head)
		components = shuffle(components)
		for(var/obj/item/mech_component/MC in components)
			MC.take_burn_damage(amount)
			MC.update_component_damage()
			break

/mob/living/heavy_vehicle/adjustBruteLoss(var/amount, var/obj/item/mech_component/C)
	if(C)
		C.take_brute_damage(amount)
		C.update_component_damage()
	else
		var/list/components = list(body, arms, legs, head)
		components = shuffle(components)
		for(var/obj/item/mech_component/MC in components)
			MC.take_burn_damage(amount)
			MC.update_component_damage()
			break

/mob/living/heavy_vehicle/proc/zoneToComponent(var/zone)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	RETURN_TYPE(/obj/item/mech_component)

	switch(zone)
		if(BP_EYES, BP_HEAD)
			return head
		if(BP_L_ARM, BP_R_ARM)
			return arms
		if(BP_L_LEG, BP_R_LEG)
			return legs
		else
			return body

/mob/living/heavy_vehicle/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	if(!damage)
		return 0

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, TRUE)
	damage = after_armor[1]
	damagetype = after_armor[2]

	if(!damage)
		return 0

	var/target = zoneToComponent(def_zone)

	if(target == body && body.damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL) //If the cockpit is destroyed, subsequent damage is applied to the pilot, modified by the mech's armour.
		if(body && LAZYLEN(pilots))
			var/mob/living/pilot = pick(pilots)
			visible_message(SPAN_DANGER("\The [used_weapon] pierces the mangled cockpit of \the [src], striking the pilot inside!"))
			pilot.apply_damage(damage, damagetype, def_zone, used_weapon, damage_flags, armor_pen, silent = FALSE)

	//Only 2 types of damage concern mechs and vehicles
	switch(damagetype)
		if(DAMAGE_BRUTE)
			adjustBruteLoss(damage, target)
		if(DAMAGE_BURN)
			adjustFireLoss(damage, target)

	if((damagetype == DAMAGE_BRUTE || damagetype == DAMAGE_BURN) && prob(25+(damage*2)))
		spark(src, 3)
	updatehealth()

	return 1

/mob/living/heavy_vehicle/getFireLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.burn_damage
	return total

/mob/living/heavy_vehicle/getBruteLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.brute_damage
	return total

/mob/living/heavy_vehicle/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		var/obj/item/cell/C = get_cell()
		if(C.charge > 8000) //Don't completely run a mech out of power this way.
			var/power_used = use_cell_power(severity * 1000)
			var/percent_power_used = 0
			if(C && C.maxcharge)
				percent_power_used = round((power_used / C.maxcharge) * 100)
			visible_message(SPAN_NOTICE("\The [src]'s active EM defenses flash brightly, negating the EMP!"))
			for(var/pilot in pilots)
				if(ismob(pilot))
					to_chat(pilot, SPAN_NOTICE("Your mech reports that negating the EMP cost [(percent_power_used)]% charge."))
		else
			for(var/pilot in pilots)
				if(ismob(pilot))
					to_chat(pilot, SPAN_NOTICE("Your mech's EMP countermeasures deactivate as power levels drop too low."))

	else
		var/ratio = get_blocked_ratio(null, DAMAGE_BURN, null, (4-severity) * 20)
		emp_damage += round((12 - (severity*3))*( 1 - ratio))
		for(var/obj/item/thing in list(arms,legs,head,body))
			thing.emp_act(severity)

	update_emp_protection()

/mob/living/heavy_vehicle/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if(isspace(loc) || (area && !area.has_gravity()))
		return FALSE

	visible_message(SPAN_DANGER("\The [src] falls and lands on \the [loc]!"), "", SPAN_DANGER("You hear a thud!"))

	var/z_velocity = 5 * (levels_fallen**2) // 1z - 5, 2z - 20, 3z - 45
	var/damage = max((z_velocity + rand(-10, 10)) * damage_mod, 0)

	apply_damage(damage, DAMAGE_BRUTE, BP_L_LEG) // can target any leg, it will be changed to the proper component

	playsound(loc, 'sound/effects/bang.ogg', 100, 1)
	playsound(loc, 'sound/effects/bamf.ogg', 100, 1)
	return TRUE

/mob/living/heavy_vehicle/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL
