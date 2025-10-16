/// Return TRUE if resolved successfully. Return FALSE if resolved unsuccessfully. Return NULL if ready to continue with disarm.
/datum/species/proc/before_disarm(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/martial_art/attacker_style = user.primary_martial_art
	var/has_stamina = user.max_stamina > 0
	var/disarm_cost = has_stamina ? user.max_stamina / 6 : user.max_nutrition / 6
	if(has_stamina && attacker_style && attacker_style.disarm_act(user, target))
		return TRUE

	if(has_stamina)
		if(user.is_drowsy())
			disarm_cost *= 1.25
		if(user.stamina <= disarm_cost)
			to_chat(user, SPAN_DANGER("You're too tired to disarm [target]!"))
			return FALSE
		user.stamina = clamp(user.stamina - disarm_cost, 0, user.max_stamina)
	else
		if(user.nutrition <= disarm_cost)
			to_chat(user, SPAN_DANGER("You don't have enough power to disarm [target]"))
			return FALSE
		user.nutrition = clamp(user.nutrition - disarm_cost, 0, user.max_nutrition)

/datum/species/proc/disarm_attackhand(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!istype(user) || !istype(target))
		return FALSE

	if(user.is_pacified())
		to_chat(user, SPAN_NOTICE("You don't want to risk hurting [target]!"))
		return FALSE

	var/disarm_status = before_disarm(user, target)

	if(!isnull(disarm_status))
		return disarm_status

	user.attack_log += "\[[time_stamp()]\] <span class='warning'>Disarmed [target.name] ([target.ckey])</span>"
	target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been disarmed by [user.name] ([user.ckey])</font>"

	msg_admin_attack("[key_name(user)] disarmed [target.name] ([target.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
	user.do_attack_animation(target)

	if(target.w_uniform)
		target.w_uniform.add_fingerprint(user)

	var/obj/item/organ/external/limb = target.get_organ(ran_zone(target, user.zone_sel.selecting))
	var/list/holding = list(target.get_active_hand() = 40)
	for(var/offhand in target.get_inactive_held_items())
		LAZYSET(holding, offhand, 20)

	if(target.a_intent != I_HELP)
		for(var/obj/item/W in holding)
			if(W && prob(holding[W]))
				var/obj/item/grab/grab = W
				var/obj/item/gun/gun = W
				if(istype(grab) && grab.has_grab_flags(GRAB_SHIELDS_YOU) && grab.grabbed != user && grab.grabbed != target)
					target.visible_message(SPAN_WARNING("[target] repositions \the [grab.grabbed] to block \the [user]'s disarm attempt!"), SPAN_NOTICE("You reposition \the [grab.grabbed] to block \the [user]'s disarm attempt!"))
					grab.grabbed.attack_hand(user)
					return TRUE
				if(istype(gun))
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					if(turfs.len)
						var/turf/TT = pick(turfs)
						target.visible_message(SPAN_DANGER("[target]'s [gun] goes off during the struggle!"))
						return gun.afterattack(TT, target)
				if(user.Adjacent(target))
					target.visible_message(SPAN_DANGER("[target] retaliates against [user]'s disarm attempt with \a [W]!"))
					return user.attackby(W, target)

	if(target.z_eye) // Looking down from a railing
		var/turf/T = get_turf(target)
		var/obj/structure/railing/problem_railing
		var/same_loc = FALSE
		for(var/obj/structure/railing/R in T)
			if(R.dir == target.dir)
				problem_railing = R
				break
		for(var/obj/structure/railing/R in get_step(T, target.dir))
			if(R.dir == REVERSE_DIR(target.dir))
				problem_railing = R
				same_loc = TRUE
				break
		if(!problem_railing)
			target.visible_message(SPAN_DANGER("[user] pushes [target] forward!"), SPAN_DANGER("[user] pushes you forward!"))
			target.apply_effect(5, WEAKEN)
			var/turf/current_turf = get_turf(target.z_eye)
			target.forceMove(GET_TURF_ABOVE(current_turf))
			return TRUE

		if(problem_railing.turf_is_crowded(TRUE))
			to_chat(user, SPAN_NOTICE("It's too crowded, you can't push \the [src] off the railing!"))
			// do not return
		else
			target.visible_message(SPAN_DANGER("[user] shoves [target] over the railing!"), SPAN_DANGER("[user] shoves you over the railing!"))
			target.apply_effect(5, WEAKEN)
			target.forceMove(same_loc ? problem_railing.loc : problem_railing.get_destination_turf(src))
			return TRUE

	var/obj/item/clothing/gloves/force/fgloves = user.gloves
	if(istype(fgloves))
		. = fgloves.try_shove(user, target)
		if(!.)
			. = fgloves.try_throw(user, target)
		return
	else if(prob(25))
		// push instead of disarm
		var/armor_check = 100 * target.get_blocked_ratio(limb, DAMAGE_BRUTE, damage = 20)
		target.apply_effect(3, WEAKEN, armor_check)
		if(armor_check < 100)
			target.visible_message(SPAN_DANGER("[user] has pushed [target]!"))
			playsound(target.loc, 'sound/weapons/push_connect.ogg', 50, 1, -1)
		else
			target.visible_message(SPAN_DANGER("[user] attempted to push [target]!"))
			playsound(target.loc, 'sound/weapons/push.ogg', 50, 1, -1)
		return TRUE

	for(var/obj/item/grab/G in target.get_active_grabs())
		G.force_drop()
		. = TRUE

	for(var/obj/item/I in holding)
		if(target.unEquip(I))
			target.visible_message(SPAN_DANGER("\The [user] knocks \the [I] from \the [target]'s grasp!"))
			. = TRUE
			break

	if(.)
		playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	else
		playsound(target.loc, /singleton/sound_category/punchmiss_sound, 25, 1, -1)
		target.visible_message(SPAN_DANGER("[user] attempted to disarm [target]!"))

/datum/species/machine/before_disarm(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/internal/cell/cell = user.internal_organs_by_name[BP_CELL]
	if(!istype(cell))
		return FALSE
	var/obj/item/cell/potato = cell.cell
	if(!istype(potato))
		return FALSE

	if(!potato.checked_use(potato.maxcharge / 24))
		to_chat(user, SPAN_DANGER("You don't have enough charge to disarm someone!"))
		return FALSE
