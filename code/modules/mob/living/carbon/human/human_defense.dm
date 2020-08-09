/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

	var/species_check = src.species.bullet_act(P, def_zone, src)

	if(species_check)
		return species_check

	if(!is_physically_disabled())
		if(martial_art && martial_art.deflection_chance)
			if(prob(martial_art.deflection_chance))
				src.visible_message("<span class='danger'>\The [src] deflects \the [P]!</span>")
				playsound(src, "bulletflyby_sound", 75, 1)
				return 0

	def_zone = check_zone(def_zone)
	if(!has_organ(def_zone))
		return PROJECTILE_FORCE_MISS //if they don't have the organ in question then the projectile just passes by.

	//Shields
	var/shield_check = check_shields(P.damage, P, null, def_zone, "the [P.name]")
	if(shield_check)
		if(shield_check < 0)
			return shield_check
		else
			P.on_hit(src, 100, def_zone)
			return 100

	var/obj/item/organ/external/organ = get_organ(def_zone)

	// Tell clothing we're wearing that it got hit by a bullet/laser/etc
	var/list/clothing = get_clothing_list_organ(organ)
	for(var/obj/item/clothing/C in clothing)
		C.clothing_impact(P, P.damage)

	//Shrapnel
	if(!(species.flags & NO_EMBED) && P.can_embed())
		var/armor = getarmor_organ(organ, "bullet")
		if(prob(20 + max(P.damage - armor, -10)))
			var/obj/item/SP = new P.shrapnel_type()
			SP.name = (P.name != "shrapnel")? "[P.name] shrapnel" : "shrapnel"
			SP.desc = "[SP.desc] It looks like it was fired from [P.shot_from]."
			SP.forceMove(organ)
			organ.embed(SP)

	return (..(P , def_zone))

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/item/organ/external/affected = get_organ(check_zone(def_zone))
	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff

	switch (def_zone)
		if(BP_HEAD)
			eye_blurry += min((rand(1,3) * (agony_amount/40)), 12)
			confused = min(max(confused, 2 * (agony_amount/40)), 8)
		if(BP_L_HAND, BP_R_HAND)
			var/c_hand
			if (def_zone == BP_L_HAND)
				c_hand = l_hand
			else
				c_hand = r_hand

			if(c_hand && (stun_amount || agony_amount > 10))
				msg_admin_attack("[src.name] ([src.ckey]) was disarmed by a stun effect (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src))

				drop_from_inventory(c_hand)
				if (affected.status & ORGAN_ROBOT)
					emote("me", 1, "drops what they were holding, their [affected.name] malfunctioning!")
				else
					var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
					emote("me", 1, "[(!can_feel_pain()) ? "" : emote_scream ]drops what they were holding in their [affected.name]!")

	..(stun_amount, agony_amount, def_zone)

/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getarmor_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				armorval += getarmor_organ(organ, type) * weight
				total += weight
	return (armorval/max(total, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = species.siemens_coefficient

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	return siemens_coefficient

// Returns a list of clothing that is currently covering def_zone.
/mob/living/carbon/human/proc/get_clothing_list_organ(var/obj/item/organ/external/def_zone, var/type)
	var/list/results = list()
	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part))
			results.Add(C)
	return results

//this proc returns the armor value for a particular external organ.
/mob/living/carbon/human/proc/getarmor_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone) return 0
	var/protection = 0
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/gear in protective_gear)
		if(!isnull(gear.armor) && gear.body_parts_covered & def_zone.body_part)
			protection = add_armor(protection, gear.armor[type])
		for(var/obj/item/clothing/accessory/A in gear.accessories)
			if(!isnull(A.armor) && A.body_parts_covered & def_zone.body_part)
				protection = add_armor(protection, A.armor[type])

	return protection

/mob/living/carbon/human/proc/check_head_coverage()

	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return 1
	return 0

/mob/living/carbon/human/proc/check_head_airtight_coverage()
	var/list/clothing = list(head, wear_mask, wear_suit)
	for(var/obj/item/clothing/C in clothing)
		if((C.body_parts_covered & HEAD) && (C.item_flags & (AIRTIGHT|STOPPRESSUREDAMAGE)))
			return TRUE
	return FALSE

//Used to check if they can be fed food/drinks/pills
/mob/living/carbon/human/proc/check_mouth_coverage()
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & FLEXIBLEMATERIAL))
			return gear
	return null

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	for(var/obj/item/shield in list(l_hand, r_hand, wear_suit, back))
		if(!shield)
			continue
		if(!shield.can_shield_back())
			continue
		var/is_on_back = FALSE
		if(back && back == shield)
			is_on_back = TRUE
		. = shield.handle_shield(src, is_on_back, damage, damage_source, attacker, def_zone, attack_text)
		if(.)
			return
	return 0

/mob/living/carbon/human/emp_act(severity)
	if(isipc(src))
		var/obj/item/organ/internal/surge/s = src.internal_organs_by_name["surge"]
		if(!isnull(s))
			if(s.surge_left >= 1)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 25, 1)
				s.surge_left -= 1
				if(s.surge_left)
					visible_message("<span class='warning'>[src] was not affected by EMP pulse.</span>", "<span class='warning'>Warning: EMP detected, integrated surge prevention module activated. There are [s.surge_left] preventions left.</span>")
				else
					s.broken = 1
					s.icon_state = "surge_ipc_broken"
					visible_message("<span class='warning'>[src] was not affected by EMP pulse.</span>", "<span class='warning'>Warning: EMP detected, integrated surge prevention module activated. The surge prevention module is fried, replacement recommended.</span>")
				return 1
			else if(s.surge_left == 0.5)
				to_chat(src, "<span class='danger'>Warning: EMP detected, integrated surge prevention module is damaged and was unable to fully protect from EMP. Half of the damage taken. Replacement recommended.</span>")
				for(var/obj/O in src)
					if(!O)	continue
					O.emp_act(severity * 2) // EMP act takes reverse numbers
				for(var/obj/item/organ/external/O  in organs)
					O.emp_act(severity)
					for(var/obj/item/organ/I  in O.internal_organs)
						if(I.robotic == 0)	continue
						I.emp_act(severity * 2) // EMP act takes reverse numbers
				return 1
			else
				to_chat(src, "<span class='danger'>Warning: EMP detected, integrated surge prevention module is fried and unable to protect from EMP. Replacement recommended.</span>")
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	for(var/obj/item/organ/external/O  in organs)
		O.emp_act(severity)
		for(var/obj/item/organ/I  in O.internal_organs)
			if(I.robotic == 0)	continue
			I.emp_act(severity)
	..()

/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	if(check_attack_throat(I, user))
		return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/hit_zone = get_zone_with_miss_chance(target_zone, src)

	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_sel.selecting
	if(!target_zone)
		visible_message("<span class='danger'>[user] misses [src] with \the [I]!</span>")
		return 0

	//var/obj/item/organ/external/affecting = get_organ(target_zone)

	if(check_shields(I.force, I, user, target_zone, "the [I.name]"))
		return null

	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return null

	return hit_zone

/mob/living/carbon/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	visible_message("<span class='danger'>[src] has been [LAZYPICK(I.attack_verb, "attacked")] in the [affecting.name] with [I] by [user]!</span>")

	var/blocked = run_armor_check(hit_zone, "melee", I.armor_penetration, "Your armor has protected your [affecting.name].", "Your armor has softened the blow to your [affecting.name].")
	standard_weapon_hit_effects(I, user, effective_force, blocked, hit_zone)

	return blocked

/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return 0

	// Allow clothing to respond to being hit.
	// This is done up here so that clothing damage occurs even if fully blocked.
	var/list/clothing = get_clothing_list_organ(affecting)
	for(var/obj/item/clothing/C in clothing)
		C.clothing_impact(I, effective_force)

	// Handle striking to cripple.
	if(user.a_intent == I_DISARM)
		effective_force /= 2 //half the effective force
		if(!..(I, effective_force, blocked, hit_zone))
			return 0

		attack_joint(affecting, I, blocked) //but can dislocate joints
	else if(!..())
		return 0

	// forceglove amplification
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(X.gloves && istype(X.gloves,/obj/item/clothing/gloves/force))
			var/obj/item/clothing/gloves/force/G = X.gloves
			effective_force *= G.amplification

	if(effective_force > 10 || effective_force >= 5 && prob(33))
		forcesay(hit_appends)	//forcesay checks stat already

	if((I.damtype == BRUTE || I.damtype == PAIN) && prob(25 + (effective_force * 2)))
		if(!stat)
			if(headcheck(hit_zone))
				//Harder to score a stun but if you do it lasts a bit longer
				if(prob(effective_force) && head && !istype(head, /obj/item/clothing/head/helmet))
					visible_message("<span class='danger'>[src] [species.knockout_message]</span>")
					apply_effect(20, PARALYZE, blocked)

		//Apply blood
		if(!(I.flags & NOBLOODY))
			I.add_blood(src)

		if(prob(effective_force * 2))
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

			switch(hit_zone)
				if(BP_HEAD)
					if(wear_mask)
						wear_mask.add_blood(src)
						update_inv_wear_mask(0)
					if(head)
						head.add_blood(src)
						update_inv_head(0)
					if(glasses && prob(33))
						glasses.add_blood(src)
						update_inv_glasses(0)
				if(BP_CHEST)
					bloody_body(src)

	return 1

/mob/living/carbon/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/blocked)
	if(!organ || (organ.dislocated == 2) || (organ.dislocated == -1) || blocked >= 100)
		return 0
	if(prob(W.force * BLOCKED_MULT(blocked)))
		visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		organ.dislocate(1)
		return 1
	return 0

/mob/living/carbon/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = get_organ(user.zone_sel.selecting)
	if(!affecting || !(affecting.status & ORGAN_ROBOT))
		to_chat(user, "<span class='warning'>That limb isn't robotic.</span>")
		return -1
	if(affecting.sabotaged)
		to_chat(user, "<span class='warning'>[src]'s [affecting.name] is already sabotaged!</span>")
		return -1
	to_chat(user, "<span class='notice'>You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties.</span>")
	affecting.sabotaged = 1
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)
	if(istype(AM,/obj/))
		var/obj/O = AM

		if(in_throw_mode && !get_active_hand() && speed <= THROWFORCE_SPEED_DIVISOR)	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message("<span class='warning'>[src] catches [O]!</span>")
					throw_mode_off()
					return

		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR)

		var/zone
		if (istype(O.thrower, /mob/living))
			var/mob/living/L = O.thrower
			zone = check_zone(L.zone_sel.selecting)
		else
			zone = ran_zone(BP_CHEST,75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		var/miss_chance = 15
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			miss_chance = max(15*(distance-2), 0)
		zone = get_zone_with_miss_chance(zone, src, miss_chance, ranged_attack=1)

		if(zone && O.thrower != src)
			var/shield_check = check_shields(throw_damage, O, thrower, zone, "[O]")
			if(shield_check == PROJECTILE_FORCE_MISS)
				zone = null
			else if(shield_check)
				return

		if(!zone)
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			playsound(src, 'sound/effects/throw_miss.ogg', rand(10, 50), 1)
			return

		O.throwing = 0		//it hit, so stop moving

		var/obj/item/organ/external/affecting = get_organ(zone)
		var/hit_area = affecting.name

		src.visible_message("<span class='warning'>[src] has been hit in the [hit_area] by [O].</span>", "<span class='warning'><font size='2'>You're hit in the [hit_area] by [O]!</font></span>")
		var/armor = run_armor_check(affecting, "melee", O.armor_penetration, "Your armor has protected your [hit_area].", "Your armor has softened the hit to your [hit_area].") //I guess "melee" is the best fit here

		if(armor < 100)
			var/damage_flags = O.damage_flags()
			apply_damage(throw_damage, dtype, zone, armor, O, damage_flags = damage_flags)

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
				if(!istype(src,/mob/living/simple_animal/rat))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(M),ckey_target=key_name(src))

		//thrown weapon embedded object code.
		if(dtype == BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!is_robot_module(I))
				var/sharp = is_sharp(I)
				var/damage = throw_damage
				if (armor)
					damage *= BLOCKED_MULT(armor)

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I)

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = speed*mass

		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throw_source, src)

			visible_message("<span class='warning'>[src] staggers under the impact!</span>","<span class='warning'> You stagger under the impact!</span>")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O.loc == src && O.sharp) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.forceMove(T)
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = 1
					src.pinned += O

/mob/living/carbon/human/embed(var/obj/O, var/def_zone=null)
	if(!def_zone) ..()

	var/obj/item/organ/external/affecting = get_organ(def_zone)
	if(affecting)
		affecting.embed(O)


/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damtype != BURN && damtype != BRUTE) return

	// The rig might soak this hit, if we're wearing one.
	if(back && istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	var/obj/item/clothing/suit/space/SS = wear_suit
	var/penetrated_dam = max(0,(damage - SS.breach_threshold))
	if(penetrated_dam) SS.create_breaches(damtype, penetrated_dam)

/mob/living/carbon/human/reagent_permeability()
	var/perm = 0

	var/list/perm_by_part = list(
		BP_HEAD = THERMAL_PROTECTION_HEAD,
		"upper_torso" = THERMAL_PROTECTION_UPPER_TORSO,
		"lower_torso" = THERMAL_PROTECTION_LOWER_TORSO,
		"legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT,
		"feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT,
		"arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT,
		"hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT
		)

	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.permeability_coefficient == 1 || !C.body_parts_covered)
			continue
		if(C.body_parts_covered & HEAD)
			perm_by_part[BP_HEAD] *= C.permeability_coefficient
		if(C.body_parts_covered & UPPER_TORSO)
			perm_by_part["upper_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & LOWER_TORSO)
			perm_by_part["lower_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & LEGS)
			perm_by_part["legs"] *= C.permeability_coefficient
		if(C.body_parts_covered & FEET)
			perm_by_part["feet"] *= C.permeability_coefficient
		if(C.body_parts_covered & ARMS)
			perm_by_part["arms"] *= C.permeability_coefficient
		if(C.body_parts_covered & HANDS)
			perm_by_part["hands"] *= C.permeability_coefficient

	for(var/part in perm_by_part)
		perm += perm_by_part[part]

	return perm

/mob/living/carbon/human/proc/grabbedby(mob/living/carbon/human/user,var/supress_message = 0)
	if(user == src || anchored)
		return 0
	if(user.is_pacified())
		to_chat(user, "<span class='notice'>You don't want to risk hurting [src]!</span>")
		return 0

	for(var/obj/item/grab/G in user.grabbed_by)
		if(G.assailant == user)
			to_chat(user, "<span class='notice'>You already grabbed [src].</span>")
			return

	if (!attempt_grab(user))
		return

	if(src.w_uniform)
		src.w_uniform.add_fingerprint(src)

	var/obj/item/grab/G = new /obj/item/grab(user, src)
	if(buckled)
		to_chat(user, "<span class='notice'>You cannot grab [src], \he [gender_datums[gender].is] buckled in!</span>")
	if(!G)	//the grab will delete itself in New if affecting is anchored
		return
	user.put_in_active_hand(G)
	G.synch()
	LAssailant = WEAKREF(user)

	user.do_attack_animation(src)
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(user.gloves && istype(user.gloves,/obj/item/clothing/gloves/force/syndicate)) //only antag gloves can do this for now
		G.state = GRAB_AGGRESSIVE
		G.icon_state = "grabbed1"
		G.hud.icon_state = "reinforce1"
		G.last_action = world.time
		visible_message("<span class='warning'>[user] gets a strong grip on [src]!</span>")
		return 1
	visible_message("<span class='warning'>[user] has grabbed [src] passively!</span>")
	return 1
