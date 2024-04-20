//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(is_diona())
		return ..()

	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
		return

	health = maxHealth - getBrainLoss()

	if(stat == DEAD)
		var/genetic_damage = getCloneLoss()
		if(genetic_damage > 100 && !(mutations & SKELETON)) //They need flesh to slough off
			visible_message(SPAN_WARNING("\The [src]'s flesh sloughs off [get_pronoun("his")] body into a puddle of viscera and goop."), SPAN_WARNING("Your flesh sloughs off your body into a puddle of viscera and goop."), range = 5)
			ChangeToSkeleton(FALSE)
		else
			var/fire_dmg = getFireLoss()
			if(fire_dmg > maxHealth * 3)
				ChangeToSkeleton(FALSE)
			else if(fire_dmg > maxHealth * 1.5)
				ChangeToHusk()

	UpdateDamageIcon() // to fix that darn overlay bug

/mob/living/carbon/human/proc/get_total_health()
	var/amount = maxHealth - getFireLoss() - getBruteLoss() - getOxyLoss() - getToxLoss() - getBrainLoss()
	return amount

/mob/living/carbon/human/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)
		return 0	//godmode

	if(should_have_organ(BP_BRAIN) && internal_organs_by_name)
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.take_internal_damage(amount)

/mob/living/carbon/human/setBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode

	if(should_have_organ(BP_BRAIN) && internal_organs_by_name)
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.damage = min(max(amount, 0),sponge.species.total_health)
			updatehealth()

/mob/living/carbon/human/getBrainLoss()
	if(status_flags & GODMODE)
		return 0	//godmode


	if(should_have_organ(BP_BRAIN))

		//Get the brain organ, if it's there
		var/obj/item/organ/internal/brain/sponge = null
		if(internal_organs_by_name)
			sponge = internal_organs_by_name[BP_BRAIN]

		if(sponge)
			if(sponge.status & ORGAN_DEAD)
				return sponge.species.total_health
			else
				return sponge.damage
		else
			return species.total_health
	return 0

/mob/living/carbon/human/getHalLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in organs)
		amount += E.get_pain()
	return amount

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if(BP_IS_ROBOTIC(O) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if(BP_IS_ROBOTIC(O) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/adjustBruteLoss(var/amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/adjustFireLoss(var/amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/Stun(amount)
	if((mutations & HULK))
		return
	..()

/mob/living/carbon/human/Weaken(amount)
	if((mutations & HULK))
		return
	..()

/mob/living/carbon/human/Paralyse(amount)
	if((mutations & HULK))
		return
	// Notify our AI if they can now control the suit.
	if(wearing_rig?.ai_override_enabled && !stat && paralysis < amount) //We are passing out right this second.
		wearing_rig.notify_ai("<span class='danger'>Warning: user consciousness failure. Mobility control passed to integrated intelligence system.</span>")
	..()

/mob/living/carbon/human/update_canmove()
	var/old_lying = lying
	. = ..()
	if(lying && !old_lying && !resting && !buckled_to && isturf(loc)) // fell down
		playsound(loc, species.bodyfall_sound, 50, 1, -1)

/mob/living/carbon/human/getCloneLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in organs)
		amount += E.get_genetic_damage()
	return amount

/mob/living/carbon/human/setCloneLoss(var/amount)
	adjustCloneLoss(getCloneLoss()-amount)

/mob/living/carbon/human/adjustCloneLoss(var/amount)
	var/heal = amount < 0
	amount = abs(amount)

	var/list/pick_organs = organs.Copy()
	while(amount > 0 && pick_organs.len)
		var/obj/item/organ/external/E = pick(pick_organs)
		pick_organs -= E
		if(heal)
			amount -= E.remove_genetic_damage(amount)
		else
			amount -= E.add_genetic_damage(amount)
	BITSET(hud_updateflag, HEALTH_HUD)

// Defined here solely to take species flags into account without having to recast at mob/living level.
/mob/living/carbon/human/getOxyLoss()
	if(!need_breathe())
		return 0
	else

		//Get the breathe organ, if it's there
		var/obj/item/organ/internal/lungs/breathe_organ = null
		if(internal_organs_by_name)
			breathe_organ = internal_organs_by_name[species.breathing_organ]

		if(!breathe_organ)
			return maxHealth/2
		return breathe_organ.get_oxygen_deprivation()

/mob/living/carbon/human/setOxyLoss(var/amount)
	if(!need_breathe())
		return 0
	else
		adjustOxyLoss(getOxyLoss()-amount)

/mob/living/carbon/human/adjustOxyLoss(var/amount)
	if(!need_breathe())
		return
	var/heal = amount < 0

	var/obj/item/organ/internal/lungs/breathe_organ = null
	if(internal_organs_by_name)
		breathe_organ = internal_organs_by_name[species.breathing_organ]

	if(breathe_organ)
		if(heal)
			breathe_organ.remove_oxygen_deprivation(abs(amount))
		else
			breathe_organ.add_oxygen_deprivation(abs(amount*species.oxy_mod))
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/getToxLoss()
	if(species.flags & NO_POISON)
		return 0

	var/amount = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		amount += I.getToxLoss()
	return amount

/mob/living/carbon/human/adjustToxLoss(var/amount)
	if(species && species.toxins_mod && amount > 0)
		amount *= species.toxins_mod
	if(species.flags & NO_POISON)
		return 0

	var/heal = amount < 0
	amount = abs(amount)

	if (!heal)
		if(species?.toxins_mod)
			amount *= species.toxins_mod
		if (CE_ANTITOXIN in chem_effects)
			amount *= 1 - (chem_effects[CE_ANTITOXIN] * 0.25)

	var/list/pick_organs = shuffle(internal_organs.Copy())

	// Prioritize damaging our filtration organs first.
	var/obj/item/organ/internal/kidneys/kidneys = null
	if(internal_organs_by_name)
		kidneys = internal_organs_by_name[BP_KIDNEYS]
		if(kidneys)
			pick_organs -= kidneys
			pick_organs.Insert(1, kidneys)


	var/obj/item/organ/internal/liver/liver = null
	if(internal_organs_by_name)
		liver = internal_organs_by_name[BP_LIVER]
		if(liver)
			pick_organs -= liver
			pick_organs.Insert(1, liver)

	// Move the brain to the very end since damage to it is vastly more dangerous
	// (and isn't technically counted as toxloss) than general organ damage.
	var/obj/item/organ/internal/brain/brain = null
	if(internal_organs_by_name)
		brain = internal_organs_by_name[BP_BRAIN]
		if(brain)
			pick_organs -= brain
			pick_organs += brain

	for(var/internal in pick_organs)
		var/obj/item/organ/internal/I = internal
		if(amount <= 0)
			break
		if(BP_IS_ROBOTIC(I))
			continue //Chems won't help, you need surgery to fix robot organs
		if(heal)
			if(I.damage < amount)
				amount -= I.damage
				I.damage = 0
			else
				I.damage -= amount
				amount = 0
		else
			var/cap_dam = I.max_damage - I.damage
			if(amount >= cap_dam)
				I.take_internal_damage(cap_dam, silent=TRUE)
				amount -= cap_dam
			else
				I.take_internal_damage(amount, silent=TRUE)
				amount = 0

/mob/living/carbon/human/setToxLoss(var/amount)
	if(species.flags & NO_POISON)
		return
	else
		adjustToxLoss(getToxLoss()-amount)

/mob/living/carbon/human/adjustHalLoss(var/amount)
	var/heal = (amount < 0)
	amount = abs(amount)
	var/list/pick_organs = organs.Copy()
	while(amount > 0 && pick_organs.len)
		var/obj/item/organ/external/E = pick(pick_organs)
		pick_organs -= E
		if(!istype(E))
			continue

		if(heal)
			amount -= E.remove_pain(amount)
		else
			amount -= E.add_pain(amount)
	BITSET(hud_updateflag, HEALTH_HUD)

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn, var/prosthetic = TRUE)
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if(!prosthetic && BP_IS_ROBOTIC(O))
			continue
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if(O.is_damageable())
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(var/brute, var/burn, var/prosthetic = FALSE)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute, burn, prosthetic)
	if(!length(parts))
		return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute, burn, robo_repair = prosthetic))
		UpdateDamageIcon()
		BITSET(hud_updateflag, HEALTH_HUD)
	updatehealth()


/*
In most cases it makes more sense to use apply_damage() instead! And make sure to check armor if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(var/brute, var/burn, var/damage_flags)
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	if(!parts.len)
		return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.take_damage(brute, burn, damage_flags))
		UpdateDamageIcon()
		BITSET(hud_updateflag, HEALTH_HUD)
	updatehealth()


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)

	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	if(update)
		UpdateDamageIcon()

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(var/brute, var/burn, var/damage_flags, var/used_weapon = null)
	if(status_flags & GODMODE)
		return	//godmode
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.take_damage(brute, burn, damage_flags, used_weapon)
		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	if(update)
		UpdateDamageIcon()


////////////////////////////////////////////

/*
This function restores the subjects blood to max.
*/
/mob/living/carbon/human/proc/restore_blood()
	if(!(species.flags & NO_BLOOD))
		var/total_blood = REAGENT_VOLUME(vessel, /singleton/reagent/blood)
		vessel.add_reagent(/singleton/reagent/blood, species.blood_volume - total_blood, temperature = species.body_temperature)


/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs()
	for(var/obj/item/organ/external/current_organ in organs)
		current_organ.rejuvenate()

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/obj/item/organ/external/E = get_organ(zone)
	if(istype(E, /obj/item/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon()
			BITSET(hud_updateflag, HEALTH_HUD)
	else
		return 0
	return


/mob/living/carbon/human/proc/get_organ(var/zone, var/allow_no_result = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/obj/item/organ)
	if(!zone)
		if(allow_no_result)
			return
		else
			zone = BP_CHEST
	if (zone in list(BP_EYES, BP_MOUTH))
		zone = BP_HEAD
	return organs_by_name[zone]

/mob/living/carbon/human/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, blocked, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	if (invisibility == INVISIBILITY_LEVEL_TWO && back && (istype(back, /obj/item/rig)))
		if(damage > 0)
			to_chat(src, "<span class='danger'>You are now visible.</span>")
			set_invisibility(0)

	var/obj/item/organ/external/organ = isorgan(def_zone) ? def_zone : get_organ(def_zone, TRUE)
	if(!organ)
		if(!def_zone)
			if(damage_flags & DAMAGE_FLAG_DISPERSED)
				var/old_damage = damage
				var/tally
				silent = TRUE // Will damage a lot of organs, probably, so avoid spam.
				for(var/zone in organ_rel_size)
					tally += organ_rel_size[zone]
				for(var/zone in organ_rel_size)
					damage = old_damage * organ_rel_size[zone]/tally
					def_zone = zone
					. = .() || .
				return
			def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))

	//Handle other types of damage
	if(!(damagetype in list(DAMAGE_BRUTE, DAMAGE_BURN, DAMAGE_PAIN, DAMAGE_CLONE)))
		if(!stat && damagetype == DAMAGE_PAIN)
			if((damage > 25) || (damage > 50))
				force_say()
				if((damage > 25 && prob(20) || (damage > 50 && prob(60))))
					emote("scream")
		return ..()

	if(!organ)
		return FALSE

	handle_suit_punctures(damagetype, damage, def_zone)

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damagetype = after_armor[2]
	damage_flags = after_armor[3]
	if(!damage)
		return FALSE

	if(damage > 15 && ORGAN_CAN_FEEL_PAIN(organ))
		force_say()
		if(prob(damage*4))
			if(REAGENT_VOLUME(reagents, /singleton/reagent/adrenaline) < 15)
				make_adrenaline(round(damage/10))

	switch(damagetype)
		if(DAMAGE_BRUTE)
			damageoverlaytemp = 20
			if(damage > 0)
				damage *= species.brute_mod
			organ.take_damage(damage, 0, damage_flags, used_weapon)
			UpdateDamageIcon()
		if(DAMAGE_BURN)
			damageoverlaytemp = 20
			if(damage > 0)
				damage *= species.burn_mod
			organ.take_damage(0, damage, damage_flags, used_weapon)
			UpdateDamageIcon()
		if(DAMAGE_PAIN)
			organ.add_pain(damage)
		if(DAMAGE_CLONE)
			organ.add_genetic_damage(damage)

	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	return TRUE

/mob/living/carbon/human/apply_radiation(var/rads)
	if(species && rads > 0)
		rads = rads * species.radiation_mod
	..(rads)

/mob/living/carbon/human/get_shock()
	if(!can_feel_pain())
		return 0

	var/traumatic_shock = getHalLoss()                 // Pain.
	traumatic_shock -= chem_effects[CE_PAINKILLER]

	return max(0,traumatic_shock)

/mob/living/carbon/human/remove_blood_simple(var/blood)
	if(should_have_organ(BP_HEART))
		vessel.remove_reagent(/singleton/reagent/blood, blood)
