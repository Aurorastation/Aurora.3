/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	var/species_check = src.species.bullet_act(hitting_projectile, def_zone, src)
	if(species_check)
		return species_check

	if(!is_physically_disabled())
		var/deflection_chance = check_martial_deflection_chance()
		if(prob(deflection_chance))
			visible_message(SPAN_WARNING("\The [src] deftly dodges \the [hitting_projectile]!"), SPAN_NOTICE("You deftly dodge \the [hitting_projectile]!"))
			playsound(src, /singleton/sound_category/bulletflyby_sound, 75, TRUE)
			return BULLET_ACT_FORCE_PIERCE

	def_zone = check_zone(def_zone)
	if(!has_organ(def_zone))
		return BULLET_ACT_FORCE_PIERCE //if they don't have the organ in question then the projectile just passes by.

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	var/obj/item/organ/external/organ = get_organ(def_zone)

	// Tell clothing we're wearing that it got hit by a bullet/laser/etc
	var/list/clothing = get_clothing_list_organ(organ)
	for(var/obj/item/clothing/C in clothing)
		C.clothing_impact(hitting_projectile, hitting_projectile.damage)

	//Shrapnel
	if(!(species.flags & NO_EMBED) && hitting_projectile.can_embed())
		var/armor = get_blocked_ratio(def_zone, DAMAGE_BRUTE, hitting_projectile.damage_flags(), armor_pen = hitting_projectile.armor_penetration, damage = hitting_projectile.damage)*100
		if(prob(20 + max(hitting_projectile.damage + hitting_projectile.embed_chance - armor, -10)))
			hitting_projectile.do_embed(organ)

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon, var/damage_flags)
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
				msg_admin_attack("[src.name] ([src.ckey]) was disarmed by a stun effect (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src))

				drop_from_inventory(c_hand)
				if (affected.status & ORGAN_ROBOT)
					visible_message("<b>[src]</b> drops what they were holding, their [affected.name] malfunctioning!")
				else
					var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
					visible_message("<b>[src]</b> [(!can_feel_pain()) ? "" : emote_scream ]drops what they were holding in their [affected.name]!")

	..(stun_amount, agony_amount, def_zone, used_weapon, damage_flags)

/mob/living/carbon/human/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	if(!def_zone && (damage_flags & DAMAGE_FLAG_DISPERSED))
		var/tally
		for(var/zone in GLOB.organ_rel_size)
			tally += GLOB.organ_rel_size[zone]
		for(var/zone in GLOB.organ_rel_size)
			def_zone = zone
			. += .() * GLOB.organ_rel_size/tally
		return
	return ..()

/mob/living/carbon/human/get_armors_by_zone(obj/item/organ/external/def_zone, damage_type, damage_flags)
	. = ..()
	if(!def_zone)
		def_zone = ran_zone()
	if(!istype(def_zone))
		def_zone = get_organ(check_zone(def_zone))
	if(!def_zone)
		return
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/gear in protective_gear)
		if(gear.accessories && length(gear.accessories))
			for(var/obj/item/clothing/accessory/bling in gear.accessories)
				if(bling.body_parts_covered & def_zone.body_part)
					var/armor = bling.GetComponent(/datum/component/armor)
					if(armor)
						. += armor
		if(gear.body_parts_covered & def_zone.body_part)
			var/armor = gear.GetComponent(/datum/component/armor)
			if(armor)
				. += armor

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = max(species.siemens_coefficient, 0)

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

/mob/living/carbon/human/proc/check_head_coverage()
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/check_head_airtight_coverage()
	var/list/clothing = list(head, wear_mask, wear_suit)
	for(var/obj/item/clothing/C in clothing)
		if((C.body_parts_covered & HEAD) && (C.item_flags & (ITEM_FLAG_AIRTIGHT)))
			return TRUE
	return FALSE

//Used to check if they can be fed food/drinks/pills
/mob/living/carbon/human/proc/check_mouth_coverage()
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & ITEM_FLAG_FLEXIBLE_MATERIAL))
			return gear
	return null

/mob/living/carbon/human/check_shields(damage, atom/damage_source, mob/attacker, def_zone, attack_text = "the attack")
	for(var/obj/item/shield in list(l_hand, r_hand, wear_suit, back))
		if(!shield)
			continue
		var/is_on_back = FALSE
		if(back && back == shield)
			if(!shield.can_shield_back())
				continue
			is_on_back = TRUE
		return shield.handle_shield(src, is_on_back, damage, damage_source, attacker, def_zone, attack_text)

	return BULLET_ACT_HIT

/mob/living/carbon/human/emp_act(severity)
	/*
		OK LISTEN UP this is absolutely shitcode but it works, basically we need the species EMP protection
		to avoid antag IPCs being smoked by EMPs in one hit and the surge protection nanopaste is handled in their specie
		and we have to call parent to have the signals working properly, hence we add an element to the mob to handle the protection
		and then we remove it after the EMP is done. Yes this is garbage, but it works
	*/
	var/emp_protect_ipc = species.handle_emp_act(src, severity)
	if(emp_protect_ipc)
		AddElement(/datum/element/empprotection, emp_protect_ipc)

	. = ..()

	if(emp_protect_ipc)
		RemoveElement(/datum/element/empprotection, emp_protect_ipc)

	if(!(.|emp_protect_ipc & EMP_PROTECT_CONTENTS))
		for(var/obj/O in src)
			O.emp_act(severity)

/mob/living/carbon/human/get_attack_victim(obj/item/I, mob/living/user, var/target_zone)
	if(a_intent != I_HELP)
		var/list/holding = list(get_active_hand() = 60, get_inactive_hand() = 40)
		for(var/obj/item/grab/G in holding)
			if(G.affecting && prob(holding[G]) && G.affecting != user)
				visible_message(SPAN_WARNING("[src] repositions \the [G.affecting] to block \the [I]'s attack!"), SPAN_NOTICE("You reposition \the [G.affecting] to block \the [I]'s attack!"))
				return G.affecting
	return src

/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	if(check_attack_throat(I, user))
		return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/hit_zone = get_zone_with_miss_chance(target_zone, src)

	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_sel.selecting

	if(!hit_zone)
		visible_message(SPAN_DANGER("[user] misses [src] with \the [I]!"))
		return

	if(check_shields(I.force, I, user, target_zone, "the [I.name]") != BULLET_ACT_HIT)
		return

	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, SPAN_DANGER("They are missing that limb!"))
		return

	return hit_zone

/mob/living/carbon/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	visible_message(SPAN_DANGER("[src] has been [LAZYPICK(I.attack_verb, "attacked")] in the [affecting.name] with [I] by [user]!"))
	return standard_weapon_hit_effects(I, user, effective_force, hit_zone)

/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
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
		if(!..(I, user, effective_force, hit_zone))
			return FALSE

		attack_joint(affecting, I) //but can dislocate joints

	else if(!..())
		return FALSE

	// forceglove amplification
	if(ishuman(user))
		var/mob/living/carbon/human/X = user
		if(X.gloves && istype(X.gloves,/obj/item/clothing/gloves/force))
			var/obj/item/clothing/gloves/force/G = X.gloves
			effective_force *= G.amplification

	if((I.damtype == DAMAGE_BRUTE || I.damtype == DAMAGE_PAIN) && prob(25 + (effective_force * 2)))
		if(!stat)
			if(headcheck(hit_zone))
				//Harder to score a stun but if you do it lasts a bit longer
				if(prob(effective_force) && head && !istype(head, /obj/item/clothing/head/helmet))
					visible_message(SPAN_DANGER("[src] [species.knockout_message]"))
					apply_effect(20, PARALYZE, GLOB.blocked)

		//Apply blood
		if(!(I.atom_flags & ATOM_FLAG_NO_BLOOD))
			I.add_blood(src)

		var/is_sharp_weapon = is_sharp(I)
		var/blood_probability = is_sharp_weapon ? effective_force * 4 : effective_force * 2
		if(prob(blood_probability))
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
				if(is_sharp_weapon)
					var/turf/splatter_turf
					var/list/splatter_turfs = RANGE_TURFS(2, location) - location - get_turf(user)
					for(var/turf/st as anything in splatter_turfs)
						if(!st.Adjacent(location))
							splatter_turfs -= st
					splatter_turf = pick(splatter_turfs)
					if(splatter_turf)
						var/obj/effect/decal/cleanable/blood/B = blood_splatter(splatter_turf, src, TRUE, get_dir(src, splatter_turf))
						B.icon_state = pick("dir_splatter_1", "dir_splatter_2")
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

	return TRUE

/mob/living/carbon/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/blocked)
	if(!organ || (organ.dislocated == 2) || (organ.dislocated == -1))
		return 0

	var/blocked_ratio = get_blocked_ratio(organ.limb_name, W.damtype, W.damage_flags(), W.armor_penetration, W.force)
	if(prob(W.force * (1 - blocked_ratio)))
		visible_message(SPAN_DANGER("[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!"))
		organ.dislocate(1)
		return 1
	return 0

/mob/living/carbon/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = get_organ(user.zone_sel.selecting)
	if(!affecting || !(affecting.status & ORGAN_ROBOT))
		to_chat(user, SPAN_WARNING("That limb isn't robotic."))
		return -1
	if(affecting.sabotaged)
		to_chat(user, SPAN_WARNING("[src]'s [affecting.name] is already sabotaged!"))
		return -1
	to_chat(user, SPAN_NOTICE("You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties."))
	affecting.sabotaged = 1
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(hitting_atom))
		var/obj/O = hitting_atom

		if(in_throw_mode && !get_active_hand() && throwingdatum?.speed <= THROWFORCE_SPEED_DIVISOR)	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message(SPAN_WARNING("[src] catches [O]!"))
					throw_mode_off()
					return

		var/dtype = O.damtype
		var/throw_damage = O.throwforce
		if(throwingdatum)
			throw_damage *= (throwingdatum.speed/THROWFORCE_SPEED_DIVISOR)

		var/zone
		if (istype(O.throwing?.thrower?.resolve(), /mob/living))
			var/mob/living/L = O.throwing?.thrower?.resolve()
			zone = check_zone(L.zone_sel.selecting)
		else
			zone = ran_zone(BP_CHEST,75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		var/miss_chance = 15
		if (O.throwing?.thrower?.resolve())
			var/distance = get_dist(O.throwing?.thrower?.resolve(), loc)
			miss_chance = 15 * (distance - 2)
		zone = get_zone_with_miss_chance(zone, src, miss_chance, 1)

		if(zone && O.throwing?.thrower?.resolve() != src)
			var/shield_check = check_shields(throw_damage, O, throwing?.thrower?.resolve(), zone, "[O]")
			if(shield_check != BULLET_ACT_HIT)
				zone = null

		if(!zone)
			visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"))
			playsound(src, 'sound/effects/throw_miss.ogg', rand(10, 50), 1)
			return

		var/obj/item/organ/external/affecting = get_organ(zone)
		var/hit_area = affecting.name

		src.visible_message(SPAN_WARNING("[src] has been hit in the [hit_area] by [O]."),
							SPAN_WARNING("<font size=2>You're hit in the [hit_area] by [O]!</font>"))
		apply_damage(throw_damage, dtype, zone, used_weapon = O, damage_flags = O.damage_flags(), armor_pen = O.armor_penetration)

		if(ismob(O.throwing?.thrower?.resolve()))
			var/mob/M = O.throwing?.thrower?.resolve()
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>"
				M.attack_log += "\[[time_stamp()]\] <span class='warning'>Hit [src.name] ([src.ckey]) with a thrown [O]</span>"
				if(!istype(src,/mob/living/simple_animal/rat))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(M),ckey_target=key_name(src))

		//thrown weapon embedded object code.
		if(dtype == DAMAGE_BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!is_robot_module(I))
				var/sharp = is_sharp(I)
				var/damage = throw_damage
				damage *= (1 - get_blocked_ratio(zone, DAMAGE_BRUTE, O.damage_flags(), O.armor_penetration, damage))

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp ? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp ? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I)

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(isitem(O))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR

		var/momentum = 0
		if(throwingdatum)
			momentum = throwingdatum.speed*mass

		if(O.throwing?.thrower?.resolve() && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throwing?.thrower?.resolve(), src)

			visible_message(SPAN_WARNING("[src] staggers under the impact!"),
							SPAN_WARNING("You stagger under the impact!"))
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O != WEIGHT_CLASS_TINY)
				if(O.loc == src && O.sharp) //Projectile is embedded and suitable for pinning.
					var/turf/T = near_wall(dir,2)

					if(T)
						src.forceMove(T)
						visible_message(
							SPAN_WARNING("\The [src] is pinned to the wall by \the [O]!"),
							SPAN_WARNING("You are pinned to the wall by \the [O]!")
						)
						src.anchored = TRUE
						src.pinned += O
	else if(ishuman(hitting_atom))
		var/mob/living/carbon/human/H = hitting_atom
		H.Weaken(3)
		Weaken(3)
		visible_message(SPAN_WARNING("[src] get knocked over by [H]!"), SPAN_WARNING("You get knocked over by [H]!"))

/mob/living/carbon/human/embed(var/obj/O, var/def_zone=null)
	if(!def_zone) ..()

	var/obj/item/organ/external/affecting = get_organ(def_zone)
	if(affecting)
		affecting.embed(O)


/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if(istype(gloves, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = gloves
		G.add_blood(source)
		G.transfer_blood = amount
		G.bloody_hands_mob = WEAKREF(source)
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = WEAKREF(source)
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
	if(damtype != DAMAGE_BURN && damtype != DAMAGE_BRUTE) return

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
		to_chat(user, SPAN_NOTICE("You don't want to risk hurting [src]!"))
		return 0

	for(var/obj/item/grab/G in user.grabbed_by)
		if(G.assailant == user)
			to_chat(user, SPAN_NOTICE("You already grabbed [src]."))
			return

	if (!attempt_grab(user))
		return

	if(src.w_uniform)
		src.w_uniform.add_fingerprint(src)

	var/obj/item/grab/G = new /obj/item/grab(user, user, src)
	if(buckled_to)
		to_chat(user, SPAN_NOTICE("You cannot grab [src], [get_pronoun("he")] [get_pronoun("is")] buckled in!"))
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
		visible_message(SPAN_WARNING("[user] gets a strong grip on [src]!"))
		return 1
	visible_message(SPAN_WARNING("[user] has grabbed [src] passively!"))
	return 1

/mob/living/carbon/human/set_on_fire()
	..()
	for(var/obj/item/I in contents)
		I.catch_fire()

/mob/living/carbon/human/extinguish_fire()
	..()
	for(var/obj/item/I in contents)
		I.extinguish_fire()
