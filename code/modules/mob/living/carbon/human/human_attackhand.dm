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

/mob/living/carbon/human/attack_hand(mob/user)
	. = ..()
	if(.) return

	if ((user.invisibility == INVISIBILITY_LEVEL_TWO) && user.back && (istype(user.back, /obj/item/rig)))
		to_chat(user, SPAN_DANGER("You are now visible."))
		user.set_invisibility(0)

		anim(get_turf(user), user,'icons/mob/mob.dmi',,"uncloak",,user.dir)
		anim(get_turf(user), user, 'icons/effects/effects.dmi', "electricity",null,20,null)

		for(var/mob/O in oviewers(user))
			O.show_message("[user.name] appears from thin air!",1)
		playsound(get_turf(user), 'sound/effects/stealthoff.ogg', 75, 1)

	if(user.a_intent != I_GRAB)
		for(var/obj/item/grab/G as anything in user.get_active_grabs())
			if(G.grabber == user && G.grabbed == src && G.resolve_openhand_attack())
				return TRUE
		if(ishuman(user) && user != src && check_shields(0, null, user, user.zone_sel.selecting, user) != BULLET_ACT_HIT)
			user.do_attack_animation(src)
			return TRUE

/mob/living/carbon/human/default_help_interaction(mob/user)
	var/user_target_zone = user.zone_sel.selecting
	if(apply_pressure(user, user_target_zone))
		return TRUE
	if(user == src)
		check_self_injuries()
		if((isskeleton(src)) && (!w_uniform) && (!wear_suit))
			play_xylophone()
		return TRUE
	if(ishuman(user) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath) && !on_fire)
		if(cpr)
			cpr = FALSE
		else
			cpr = TRUE
			cpr(user, TRUE)
		return TRUE
	return ..()

/mob/living/carbon/human/default_disarm_interaction(mob/user)
	var/datum/species/user_species = user.get_species(TRUE)
	if(istype(user_species))
		. = user_species.disarm_attackhand(user, src)
	return . || ..()

/mob/living/carbon/human/default_grab_interaction(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H))
		var/datum/martial_art/attacker_style = H.primary_martial_art
		if(attacker_style && attacker_style.grab_act(H, src))
			return TRUE
	return ..()

/mob/living/carbon/human/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		return TRUE
	var/mob/living/carbon/human/H = user
	if(istype(H))
		var/datum/martial_art/attacker_style = H.primary_martial_art
		if(attacker_style && attacker_style.harm_act(H, src))
			return TRUE
	else
		attack_generic(H, rand(1,3), "punched")
		return TRUE

	var/rand_damage = rand(1, 5)
	var/block = 0
	var/accurate = 0
	var/hit_zone = H.zone_sel.selecting
	var/obj/item/organ/external/affecting = get_organ(hit_zone)

	if(!affecting || affecting.is_stump())
		to_chat(H, SPAN_DANGER("They are missing that limb!"))
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

	if (LAZYLEN(H.grabbed_by))
		// Someone got a good grip on them, they won't be able to do much damage
		rand_damage = max(1, rand_damage - 2)

	if(LAZYLEN(grabbed_by) || src.buckled_to || !src.canmove || src==H)
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
			hit_zone = ran_zone(src, hit_zone)
		if(prob(15) && hit_zone != BP_CHEST) // Missed!
			if(!src.lying)
				attack_message = "[H] attempted to strike [src], but missed!"
			else
				attack_message = "[H] attempted to strike [src], but [src.get_pronoun("he")] rolled out of the way!"
				src.set_dir(pick(GLOB.cardinals))
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
		H.visible_message(SPAN_DANGER("[attack_message]"))

	playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
	H.attack_log += "\[[time_stamp()]\] <span class='warning'>[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] [src.name] ([src.ckey])</span>"
	src.attack_log += "\[[time_stamp()]\] <font color='orange'>[miss_type ? (miss_type == 1 ? "Was missed by" : "Has blocked") : "Has Been [pick(attack.attack_verb)]"] by [H.name] ([H.ckey])</font>"
	msg_admin_attack("[key_name(H)] [miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"] [key_name(src)] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)",ckey=key_name(H),ckey_target=key_name(src))

	if(miss_type)
		return 0

	var/real_damage = rand_damage
	var/hit_dam_type = attack.damage_type
	var/damage_flags = attack.damage_flags()

	real_damage += attack.get_unarmed_damage(src, H)
	real_damage *= damage_multiplier
	rand_damage *= damage_multiplier

	if((H.mutations & HULK))
		real_damage *= 2 // Hulks do twice the damage
		rand_damage *= 2
	if(H.is_berserk())
		real_damage *= 1.5 // Nightshade increases damage by 50%
		rand_damage *= 1.5
	var/obj/item/organ/internal/parasite/blackkois/P = H.internal_organs_by_name["blackkois"]
	if(istype(P))
		if(P.stage >= 5)
			real_damage *= 1.5 // Final stage black k'ois mycosis increases damage by 50%
			rand_damage *= 1.5

	real_damage = max(1, real_damage)

	if(H.gloves)
		if(istype(H.gloves, /obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = H.gloves
			real_damage += G.punch_force
			hit_dam_type = G.punch_damtype
			if(H.pulling_punches)
				hit_dam_type = DAMAGE_PAIN

			if(istype(H.gloves,/obj/item/clothing/gloves/force))
				var/obj/item/clothing/gloves/force/X = H.gloves
				real_damage *= X.amplification

	// Apply additional unarmed effects.
	attack.apply_effects(H, src, rand_damage, hit_zone)

	// Finally, apply damage to target
	apply_damage(real_damage, hit_dam_type, hit_zone, damage_flags = damage_flags, armor_pen = attack.armor_penetration)


	if(H.resting && src.help_up_offer)
		H.visible_message(SPAN_WARNING("[H] slaps away [src]'s hand!"))
		src.help_up_offer = 0

	return TRUE

/mob/living/carbon/human/proc/cpr(mob/living/carbon/human/H, var/starting = FALSE, var/cpr_mode)
	if(LAZYLEN(H.get_held_items()))
		cpr = FALSE
		to_chat(H, SPAN_NOTICE("You cannot perform CPR with anything in your hands."))
		return
	if(!(cpr && H.Adjacent(src) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath))) //Keeps doing CPR unless cancelled, or the target recovers
		cpr = FALSE
		to_chat(H, SPAN_NOTICE("You stop performing [cpr_mode] on \the [src]."))
		return
	else if (starting)
		var/list/options = list(
			"Full CPR" = image('icons/mob/screen/radial.dmi', "cpro2"),
			"Compressions" = image('icons/mob/screen/generic.dmi', "cpr"),
			"Mouth-to-Mouth" = image('icons/mob/screen/radial.dmi', "iv_tank")
		)
		cpr_mode = show_radial_menu(H, src, options, require_near = TRUE, tooltips = TRUE, no_repeat_close = TRUE)
		if(!cpr_mode)
			cpr = FALSE
			return
		to_chat(H, SPAN_NOTICE("You begin performing [cpr_mode] on \the [src]."))

	H.do_attack_animation(src, null, image('icons/mob/screen/generic.dmi', src, "cpr", src.layer + 1))
	var/starting_pixel_y = pixel_y
	animate(src, pixel_y = starting_pixel_y + 4, time = 2)
	animate(src, pixel_y = starting_pixel_y, time = 2)

	if(!do_after(H, 8, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT)) //Chest compressions are fast, need to wait for the loading bar to do mouth to mouth
		to_chat(H, SPAN_NOTICE("You stop performing [cpr_mode] on \the [src]."))
		cpr = FALSE //If it cancelled, cancel it. Simple.

	if(cpr_mode == "Full CPR")
		cpr_compressions(H)
		cpr_ventilation(H)

	if(cpr_mode == "Compressions")
		cpr_compressions(H)

	if(cpr_mode == "Mouth-to-Mouth")
		cpr_ventilation(H)

	cpr(H, FALSE, cpr_mode) //Again.

/mob/living/carbon/human/proc/cpr_compressions(mob/living/carbon/human/H)
	if(is_asystole())
		if(prob(5 * rand(2, 3)))
			var/obj/item/organ/external/chest = get_organ(BP_CHEST)
			if(chest)
				chest.fracture()

		var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
		if(heart)
			heart.external_pump = list(world.time, 0.4 + 0.1 + rand(-0.1,0.1))

		if(stat != DEAD && prob(10 * rand(0.5, 1)))
			resuscitate()

/mob/living/carbon/human/proc/cpr_ventilation(mob/living/carbon/human/H)
	if(!H.check_has_mouth())
		to_chat(H, SPAN_WARNING("You don't have a mouth, you cannot do mouth-to-mouth resuscitation!"))
		return
	if(!check_has_mouth())
		to_chat(H, SPAN_WARNING("They don't have a mouth, you cannot do mouth-to-mouth resuscitation!"))
		return
	if((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
		to_chat(H, SPAN_WARNING("You need to remove your mouth covering for mouth-to-mouth resuscitation!"))
		return 0
	if((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
		to_chat(H, SPAN_WARNING("You need to remove \the [src]'s mouth covering for mouth-to-mouth resuscitation!"))
		return 0
	if (!H.internal_organs_by_name[H.species.breathing_organ])
		to_chat(H, SPAN_DANGER("You need lungs for mouth-to-mouth resuscitation!"))
		return
	if(!need_breathe())
		return
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species.breathing_organ]
	if(L)
		var/datum/gas_mixture/breath = H.get_breath_from_environment()
		var/fail = L.handle_breath(breath, 1)
		if(!fail)
			if(!L.is_bruised() || (L.is_bruised() && L.rescued))
				losebreath = 0
				to_chat(src, SPAN_NOTICE("You feel a breath of fresh air enter your lungs. It feels good."))

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	if(!damage)
		return

	user.attack_log += "\[[time_stamp()]\] <span class='warning'>attacked [src.name] ([src.ckey])</span>"
	src.attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>"
	user.do_attack_animation(src)
	if(damage < 15 && (check_shields(damage, null, user, null, "\the [user]") != BULLET_ACT_HIT))
		return

	visible_message(SPAN_DANGER("[user] has [attack_message] [src]!"))

	var/dam_zone = user.zone_sel?.selecting
	var/obj/item/organ/external/affecting = dam_zone ? get_organ(dam_zone) : pick(organs)
	if(affecting)
		apply_damage(damage, damage_type ? damage_type : DAMAGE_BRUTE, affecting, armor_pen = armor_penetration, damage_flags = attack_flags)
		updatehealth()
	return affecting

//Apply pressure to wounds.
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || organ.status & ORGAN_ROBOT)
		return 0

	if(organ.applied_pressure)
		var/message = SPAN_WARNING("[ismob(organ.applied_pressure)? "Someone" : "\A [organ.applied_pressure]"] is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].")
		to_chat(user, message)
		return 0

	if(user == src)
		user.visible_message(SPAN_NOTICE("\The [user] starts applying pressure to [user.get_pronoun("his")] [organ.name]!"),
								SPAN_NOTICE("You start applying pressure to your [organ.name]!"))
	else
		user.visible_message(SPAN_NOTICE("\The [user] starts applying pressure to [src]'s [organ.name]!"),
								SPAN_NOTICE("You start applying pressure to [src]'s [organ.name]!"))
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_after(user, INFINITY, do_flags = (DO_DEFAULT & ~DO_SHOW_PROGRESS) | DO_USER_UNIQUE_ACT)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message(SPAN_NOTICE("\The [user] stops applying pressure to [user.get_pronoun("his")] [organ.name]!"),
									SPAN_NOTICE("You stop applying pressure to your [organ.name]!"))
		else
			user.visible_message(SPAN_NOTICE("\The [user] stops applying pressure to [src]'s [organ.name]!"),
									SPAN_NOTICE("You stop applying pressure to [src]'s [organ.name]!"))

	return 1


/mob/living/carbon/human/verb/check_attacks()
	set name = "Check Attacks"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		dat += "<b>Primarily [u_attack.attack_name] </b><br/><br/><br/>"

	if(default_attack)
		dat += "Current default attack: [default_attack.attack_name] - <a href='byond://?src=[REF(src)];default_attk=reset_attk'>Reset</a><br/><br/>"

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		var/sparring_variant = ""
		var/sparring_variant_desc = ""
		if(u_attack.sparring_variant_type)
			var/datum/unarmed_attack/spar_attack = u_attack.sparring_variant_type
			sparring_variant = " | Sparring Variant: [capitalize_first_letters(initial(spar_attack.attack_name))]"
			sparring_variant_desc = "[initial(spar_attack.desc)]<br/>"
		if(u_attack == default_attack)
			dat += "<b>Primarily [capitalize_first_letters(u_attack.attack_name)][sparring_variant]</b> - default - <a href='byond://?src=[REF(src)];default_attk=reset_attk'>Reset</a><br/>"
			dat += "Description: [u_attack.desc]<br/>[sparring_variant_desc]"
			dat += "<br/>"
		else
			dat += "<b>Primarily [capitalize_first_letters(u_attack.attack_name)][sparring_variant]</b> - <a href='byond://?src=[REF(src)];default_attk=[REF(u_attack)]'>Set Default</a><br/>"
			dat += "Description: [u_attack.desc]<br/>[sparring_variant_desc]"
			dat += "<br/>"

	var/datum/browser/attack_win = new(src, "checkattack", "Known Attacks", 450, 500)
	attack_win.set_content(dat)
	attack_win.open()

/mob/living/carbon/human/proc/set_default_attack(var/datum/unarmed_attack/u_attack)
	default_attack = u_attack

/mob/living/carbon/human/proc/check_self_injuries(include_pain = TRUE, include_visible = TRUE)
	if(include_visible)
		visible_message("[src] examines [get_pronoun("himself")].", SPAN_NOTICE("You check yourself for injuries."))
	else if(include_pain)
		to_chat(src, SPAN_NOTICE("You take note of how your body feels..."))

	for(var/obj/item/organ/external/org in organs)
		var/list/status = org.get_injury_status(include_pain, include_visible)
		if(length(status))
			to_chat(src, "Your [org.name] is [SPAN_WARNING(english_list(status))].")
		else if(is_blind() || !include_visible)
			to_chat(src, "You [SPAN_NOTICE("can't feel anything wrong")] with your [org.name].")
		else if(!include_pain)
			to_chat(src, "You [SPAN_NOTICE("can't see anything wrong")] with your [org.name].")
		else
			to_chat(src, "Your [org.name] is [SPAN_NOTICE("OK")].")
