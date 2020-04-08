/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/living/carbon/human/target, var/hit_zone)

	if(src.default_attack && src.default_attack.is_usable(src, target, hit_zone))
		if(pulling_punches)
			var/datum/unarmed_attack/soft_type = src.default_attack.get_sparring_variant()
			if(soft_type)
				return soft_type
		return src.default_attack

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/unarmed_attack/soft_variant = u_attack.get_sparring_variant()
				if(soft_variant)
					return soft_variant
			return u_attack
	return null

/mob/living/carbon/human/attack_hand(mob/living/carbon/M as mob)

	var/mob/living/carbon/human/H = M
	if(!M.can_use_hand())
		return

	..()
	if ((H.invisibility == INVISIBILITY_LEVEL_TWO) && M.back && (istype(M.back, /obj/item/rig)))
		to_chat(H, "<span class='danger'>You are now visible.</span>")
		H.invisibility = 0

		anim(get_turf(H), H,'icons/mob/mob.dmi',,"uncloak",,H.dir)
		anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

		for(var/mob/O in oviewers(H))
			O.show_message("[H.name] appears from thin air!",1)
		playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 75, 1)

	// Should this all be in Touch()?
	if(istype(H))
		if(H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
			H.do_attack_animation(src)
			return 0

		if(H.gloves && istype(H.gloves,/obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.cell)
				if(M.a_intent == I_HURT)//Stungloves. Any contact will stun the alien.
					if(G.cell.charge >= 2500)
						G.cell.use(G.cell.charge)	//So it drains the cell.
						visible_message("<span class='danger'>[src] has been touched with the stun gloves by [M]!</span>")
						M.attack_log += text("\[[time_stamp()]\] <font color='red'>Stungloved [src.name] ([src.ckey])</font>")
						src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stungloved by [M.name] ([M.ckey])</font>")

						msg_admin_attack("[key_name_admin(M)] stungloved [src.name] ([src.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>)",ckey=key_name(M),ckey_target=key_name(src))

						var/armorblock = run_armor_check(M.zone_sel.selecting, "energy")
						apply_effects(5,5,0,0,5,0,0,0,0,armorblock)
						apply_damage(rand(5,25), BURN, M.zone_sel.selecting,armorblock)

						if(prob(15))
							playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
							M.visible_message("<span class='warning'>The power source on [M]'s stun gloves overloads in a terrific fashion!</span>", "<span class='warning'>Your jury rigged stun gloves malfunction!</span>", "<span class='warning'>You hear a loud sparking.</span>")

							if(prob(50))
								M.apply_damage(rand(1,5), BURN)

							for(M in viewers(3, null))
								var/safety = M:eyecheck(TRUE)
								if(!safety)
									if(!M.blinded)
										flick("flash", M.flash)

						return 1
					else
						to_chat(M, "<span class='warning'>Not enough charge!</span>")
						visible_message("<span class='danger'>[src] has been touched with the stun gloves by [M]!</span>")
					return


		if(istype(H.gloves, /obj/item/clothing/gloves/boxing/hologlove))
			H.do_attack_animation(src)
			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>[H] has attempted to punch [src]!</span>")
				return 0
			var/obj/item/organ/external/affecting = get_organ(ran_zone(H.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(HULK in H.mutations)
				damage += 5

			playsound(loc, "punch", 25, 1, -1)

			visible_message("<span class='danger'>[H] has punched [src]!</span>")

			apply_damage(damage, PAIN, affecting, armor_block)
			if(damage >= 9)
				visible_message("<span class='danger'>[H] has weakened [src]!</span>")
				apply_effect(4, WEAKEN, armor_block)

			return

	if(istype(M,/mob/living/carbon))
		M.spread_disease_to(src, "Contact")

	var/datum/martial_art/attacker_style = H.martial_art

	switch(M.a_intent)
		if(I_HELP)
			if(H != src && istype(H) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath))
				if (!cpr_time)
					return 0

				cpr_time = 0

				H.visible_message("<span class='notice'>\The [H] is trying to perform CPR on \the [src].</span>")

				if(!do_after(H, rand(3, 5), src))
					cpr_time = 1
					return
				cpr_time = 1

				H.visible_message("<span class='notice'>\The [H] performs CPR on \the [src]!</span>")

				if(is_asystole())
					if(prob(5 * rand(0.5, 1)))
						var/obj/item/organ/external/chest = get_organ(BP_CHEST)
						if(chest)
							chest.fracture()

					var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
					if(heart)
						heart.external_pump = list(world.time, 0.4 + 0.1 + rand(-0.1,0.1))

					if(stat != DEAD && prob(10 * rand(0.5, 1)))
						resuscitate()

				if(!H.check_has_mouth())
					to_chat(H, "<span class='warning'>You don't have a mouth, you cannot do mouth-to-mouth resuscitation!</span>")
					return
				if(!check_has_mouth())
					to_chat(H, "<span class='warning'>They don't have a mouth, you cannot do mouth-to-mouth resuscitation!</span>")
					return
				if((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='warning'>You need to remove your mouth covering for mouth-to-mouth resuscitation!</span>")
					return 0
				if((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='warning'>You need to remove \the [src]'s mouth covering for mouth-to-mouth resuscitation!</span>")
					return 0
				if (!H.internal_organs_by_name[H.species.breathing_organ])
					to_chat(H, "<span class='danger'>You need lungs for mouth-to-mouth resuscitation!</span>")
					return
				if(!need_breathe())
					return
				var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species.breathing_organ]
				if(L)
					var/datum/gas_mixture/breath = H.get_breath_from_environment()
					var/fail = L.handle_breath(breath, 1)
					if(!fail)
						to_chat(src, "<span class='notice'>You feel a breath of fresh air enter your lungs. It feels good.</span>")

			else if(!(M == src && apply_pressure(M, M.zone_sel.selecting)))
				help_shake_act(M)
			return 1

		if(I_GRAB)
			if(M == src || anchored)
				return 0
			if(M.is_pacified())
				to_chat(M, "<span class='notice'>You don't want to risk hurting [src]!</span>")
				return 0

			if(attacker_style && attacker_style.grab_act(H, src))
				return 1

			for(var/obj/item/grab/G in src.grabbed_by)
				if(G.assailant == M)
					to_chat(M, "<span class='notice'>You already grabbed [src].</span>")
					return

			if (!attempt_grab(M))
				return

			if(w_uniform)
				w_uniform.add_fingerprint(M)

			var/obj/item/grab/G = new /obj/item/grab(M, src)
			if(buckled)
				to_chat(M, "<span class='notice'>You cannot grab [src], \he [gender_datums[gender].is] buckled in!</span>")
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			G.synch()
			LAssailant = WEAKREF(M)

			H.do_attack_animation(src)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if(H.gloves && istype(H.gloves,/obj/item/clothing/gloves/force/syndicate)) //only antag gloves can do this for now
				G.state = GRAB_AGGRESSIVE
				G.icon_state = "grabbed1"
				G.hud.icon_state = "reinforce1"
				G.last_action = world.time
				visible_message("<span class='warning'>[M] gets a strong grip on [src]!</span>")
				return 1
			visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			return 1

		if(I_HURT)
			if(M.is_pacified())
				to_chat(M, "<span class='notice'>You don't want to risk hurting [src]!</span>")
				return 0

			if(attacker_style && attacker_style.harm_act(H, src))
				return 1

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/obj/item/organ/external/affecting = get_organ(hit_zone)

			if(!affecting || affecting.is_stump())
				to_chat(M, "<span class='danger'>They are missing that limb!</span>")
				return 1

			switch(src.a_intent)
				if(I_HELP)
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if(I_HURT, I_GRAB)
					// We're in a fighting stance, there's a chance we block
					if(src.canmove && src!=H && prob(20))
						block = 1

			if (M.grabbed_by.len)
				// Someone got a good grip on them, they won't be able to do much damage
				rand_damage = max(1, rand_damage - 2)

			if(src.grabbed_by.len || src.buckled || !src.canmove || src==H)
				accurate = 1 // certain circumstances make it impossible for us to evade punches
				rand_damage = 5

			// Process evasion and blocking
			var/miss_type = 0
			var/attack_message
			if(!accurate)
				/* ~Hubblenaut
					This place is kind of convoluted and will need some explaining.
					ran_zone() will pick out of 11 zones, thus the chance for hitting
					our target where we want to hit them is circa 9.1%.

					Now since we want to statistically hit our target organ a bit more
					often than other organs, we add a base chance of 20% for hitting it.

					This leaves us with the following chances:

					If aiming for chest:
						27.3% chance you hit your target organ
						70.5% chance you hit a random other organ
						 2.2% chance you miss

					If aiming for something else:
						23.2% chance you hit your target organ
						56.8% chance you hit a random other organ
						15.0% chance you miss

					Note: We don't use get_zone_with_miss_chance() here since the chances
						  were made for projectiles.
					TODO: proc for melee combat miss chances depending on organ?
				*/
				if(prob(80))
					hit_zone = ran_zone(hit_zone)
				if(prob(15) && hit_zone != BP_CHEST) // Missed!
					if(!src.lying)
						attack_message = "[H] attempted to strike [src], but missed!"
					else
						attack_message = "[H] attempted to strike [src], but \he rolled out of the way!"
						src.set_dir(pick(cardinal))
					miss_type = 1

			if(!miss_type && block)
				attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
				miss_type = 2

			// See what attack they use
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, hit_zone)
			if(!attack)
				return 0

			H.do_attack_animation(src)
			if(!attack_message)
				attack.show_attack(H, src, hit_zone, rand_damage)
			else
				H.visible_message("<span class='danger'>[attack_message]</span>")

			playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
			H.attack_log += text("\[[time_stamp()]\] <font color='red'>[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>[miss_type ? (miss_type == 1 ? "Was missed by" : "Has blocked") : "Has Been [pick(attack.attack_verb)]"] by [H.name] ([H.ckey])</font>")
			msg_admin_attack("[key_name(H)] [miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"] [key_name(src)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)",ckey=key_name(H),ckey_target=key_name(src))

			if(miss_type)
				return 0

			var/real_damage = rand_damage
			var/hit_dam_type = attack.damage_type
			var/is_sharp = 0
			var/is_edge = 0

			real_damage += attack.get_unarmed_damage(H)
			real_damage *= damage_multiplier
			rand_damage *= damage_multiplier

			if(HULK in H.mutations)
				real_damage *= 2 // Hulks do twice the damage
				rand_damage *= 2

			real_damage = max(1, real_damage)

			if(H.gloves)
				if(istype(H.gloves, /obj/item/clothing/gloves))
					var/obj/item/clothing/gloves/G = H.gloves
					real_damage += G.punch_force
					hit_dam_type = G.punch_damtype
					if(H.pulling_punches)
						hit_dam_type = PAIN

					if(G.sharp)
						is_sharp = 1

					if(G.edge)
						is_edge = 1

					if(istype(H.gloves,/obj/item/clothing/gloves/force))
						var/obj/item/clothing/gloves/force/X = H.gloves
						real_damage *= X.amplification

			if(attack.sharp)
				is_sharp = 1

			if(attack.edge)
				is_edge = 1

			var/armour = run_armor_check(hit_zone, "melee")
			// Apply additional unarmed effects.
			attack.apply_effects(H, src, armour, rand_damage, hit_zone)

			// Finally, apply damage to target
			apply_damage(real_damage, hit_dam_type, hit_zone, armour, sharp=is_sharp, edge=is_edge)


			if(M.resting && src.help_up_offer)
				M.visible_message(span("warning", "[M] slaps away [src]'s hand!"))
				src.help_up_offer = 0

		if(I_DISARM)
			var/disarm_cost
			var/usesStamina

			if(M.max_stamina > 0)
				disarm_cost = M.max_stamina / 6
				usesStamina = TRUE
			else if(M.max_stamina <= 0)
				disarm_cost = M.max_nutrition / 8
				usesStamina = FALSE

			if(usesStamina)
				if(M.stamina <= disarm_cost)
					to_chat(M, "<span class='danger'>You're too tired to disarm someone!</span>")
					return FALSE
			else
				if(M.nutrition <= disarm_cost)
					to_chat(M, "<span class='danger'>You don't have enough power to disarm someone!</span>")
					return FALSE

			if(M.is_pacified())
				to_chat(M, "<span class='notice'>You don't want to risk hurting [src]!</span>")
				return FALSE

			if(attacker_style && attacker_style.disarm_act(H, src))
				return TRUE

			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			msg_admin_attack("[key_name(M)] disarmed [src.name] ([src.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>)",ckey=key_name(M),ckey_target=key_name(src))
			M.do_attack_animation(src)

			if(usesStamina)
				M.stamina = M.stamina - disarm_cost //attempting to knock something out of someone's hands, or pushing them over, is exhausting!
				M.stamina = Clamp(M.stamina, 0, M.max_stamina)
			else
				M.nutrition = M.nutrition - disarm_cost
				M.nutrition = Clamp(M.nutrition, 0, M.max_nutrition)

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			var/list/holding = list(get_active_hand() = 40, get_inactive_hand() = 20)

			//See if they have any weapons to retaliate with
			if(src.a_intent != I_HELP)
				for(var/obj/item/W in holding)
					if(W && prob(holding[W]))
						if(istype(W, /obj/item/grab))
							continue
						if(istype(W,/obj/item/gun))
							var/list/turfs = list()
							for(var/turf/T in view())
								turfs += T
							if(turfs.len)
								var/turf/target = pick(turfs)
								visible_message("<span class='danger'>[src]'s [W] goes off during the struggle!</span>")
								return W.afterattack(target,src)
						else
							if(M.Adjacent(src))
								visible_message("<span class='danger'>[src] retaliates against [M]'s disarm attempt with [W]!</span>")
								return M.attackby(W,src)

			var/randn = rand(1, 100)
			if(randn <= 25)
				if(H.gloves && istype(H.gloves,/obj/item/clothing/gloves/force))
					apply_effect(6, WEAKEN, run_armor_check(affecting, "melee"))
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					visible_message("<span class='danger'>[M] hurls [src] to the floor!</span>")
					step_away(src,M,15)
					sleep(3)
					step_away(src,M,15)
					return

				else
					var/armor_check = run_armor_check(affecting, "melee")
					apply_effect(3, WEAKEN, armor_check)
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					if(armor_check < 100)
						visible_message("<span class='danger'>[M] has pushed [src]!</span>")
					else
						visible_message("<span class='warning'>[M] attempted to push [src]!</span>")
					return

			if(randn <= 60)
				if(H.gloves && istype(H.gloves,/obj/item/clothing/gloves/force))
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					visible_message("<span class='danger'>[M] shoves, sending [src] flying!</span>")
					step_away(src,M,15)
					sleep(1)
					step_away(src,M,15)
					sleep(1)
					step_away(src,M,15)
					sleep(1)
					step_away(src,M,15)
					sleep(1)
					apply_effect(1, WEAKEN, run_armor_check(affecting, "melee"))
					return

				//See about breaking grips or pulls
				if(break_all_grabs(M))
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return

				//Actually disarm them
				for(var/obj/item/I in holding)
					drop_from_inventory(I)
					visible_message("<span class='danger'>[M] has disarmed [src]!</span>")
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message("<span class='danger'>[M] attempted to disarm [src]!</span>")
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/attack_generic(var/mob/user, var/damage, var/attack_message)

	if(!damage)
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>")
	src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)

	var/dam_zone = pick(organs_by_name)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, "melee")
	apply_damage(damage, BRUTE, affecting, armor_block)
	updatehealth()
	return 1

//Used to attack a joint through grabbing
/mob/living/carbon/human/proc/grab_joint(var/mob/living/user, var/def_zone)
	var/has_grab = 0

	if(user.limb_breaking)
		return 0
	for(var/obj/item/grab/G in list(user.l_hand, user.r_hand))
		if(G.affecting == src && G.state == GRAB_NECK)
			has_grab = 1
			break

	if(!has_grab)
		return 0

	if(!def_zone) def_zone = user.zone_sel.selecting
	var/target_zone = check_zone(def_zone)
	if(!target_zone)
		return 0
	var/obj/item/organ/external/organ = get_organ(check_zone(target_zone))
	if(!organ || organ.is_dislocated() || organ.dislocated == -1)
		return 0

	user.visible_message("<span class='warning'>[user] begins to dislocate [src]'s [organ.joint]!</span>")
	user.limb_breaking = TRUE
	if(do_after(user, 100))
		organ.dislocate(1)
		admin_attack_log(user, src, "dislocated [organ.joint].", "had his [organ.joint] dislocated.", "dislocated [organ.joint] of")
		src.visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		user.limb_breaking = FALSE
		return 1
	user.visible_message("<span class='warning'>[user] fails to dislocate [src]'s [organ.joint]!</span>")
	user.limb_breaking = FALSE
	return 0

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = 0
	if(pulling)
		visible_message("<span class='danger'>[user] has broken [src]'s grip on [pulling]!</span>")
		success = 1
		stop_pulling()

	if(istype(l_hand, /obj/item/grab))
		var/obj/item/grab/lgrab = l_hand
		if(lgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [lgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(lgrab)
	if(istype(r_hand, /obj/item/grab))
		var/obj/item/grab/rgrab = r_hand
		if(rgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [rgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(rgrab)
	return success

//Apply pressure to wounds.
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || organ.status & ORGAN_ROBOT)
		return 0

	if(organ.applied_pressure)
		var/message = "<span class='warning'>[ismob(organ.applied_pressure)? "Someone" : "\A [organ.applied_pressure]"] is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].</span>"
		to_chat(user, message)
		return 0

	if(user == src)
		user.visible_message("<span class='notice'>\The [user] starts applying pressure to \his [organ.name]!</span>", "<span class='notice'>You start applying pressure to your [organ.name]!</span>")
	else
		user.visible_message("<span class='notice'>\The [user] starts applying pressure to [src]'s [organ.name]!</span>", "<span class='notice'>You start applying pressure to [src]'s [organ.name]!</span>")
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_after(user, INFINITY, TRUE, display_progress = FALSE)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message("<span class='notice'>\The [user] stops applying pressure to \his [organ.name]!</span>", "<span class='notice'>You stop applying pressure to your [organ.name]!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] stops applying pressure to [src]'s [organ.name]!</span>", "<span class='notice'>You stop applying pressure to [src]'s [organ.name]!</span>")

	return 1


/mob/living/carbon/human/verb/check_attacks()
	set name = "Check Attacks"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		dat += "<b>Primarily [u_attack.attack_name] </b><br/><br/><br/>"

	src << browse(dat, "window=checkattack")
	return

/mob/living/carbon/human/check_attacks()
	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	if(default_attack)
		dat += "Current default attack: [default_attack.attack_name] - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack == default_attack)
			dat += "<b>Primarily [u_attack.attack_name]</b> - default - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/><br/>"
		else
			dat += "<b>Primarily [u_attack.attack_name]</b> - <a href='byond://?src=\ref[src];default_attk=\ref[u_attack]'>set default</a><br/><br/><br/>"

	src << browse(dat, "window=checkattack")

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["default_attk"])
		if(href_list["default_attk"] == "reset_attk")
			set_default_attack(null)
		else
			var/datum/unarmed_attack/u_attack = locate(href_list["default_attk"])
			if(u_attack && (u_attack in species.unarmed_attacks))
				set_default_attack(u_attack)
		check_attacks()
		return 1
	else
		return ..()

/mob/living/carbon/human/proc/set_default_attack(var/datum/unarmed_attack/u_attack)
	default_attack = u_attack
