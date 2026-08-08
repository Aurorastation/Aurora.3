/singleton/maneuver/kick
	name = "kick"
	delay = 0
	cooldown = 5 SECONDS
	stamina_cost = 10
	charge_cost = 500
	required_intent = I_HURT

/singleton/maneuver/kick/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	if(!istype(user) || user.a_intent != I_HURT)
		if(!silent && istype(user))
			to_chat(user, SPAN_WARNING("You must be on harm intent to kick."))
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	if((!istype(target, /mob/living) && !isobj(target)) || target == user)
		if(!silent)
			to_chat(user, SPAN_WARNING("You can only kick another living target or an object."))
		return FALSE
	if(!user.Adjacent(target))
		if(!silent)
			to_chat(user, SPAN_WARNING("You are too far away to kick [target]."))
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.legcuffed)
			if(!silent)
				to_chat(user, SPAN_WARNING("You cannot kick while your legs are restrained."))
			return FALSE
		var/obj/item/organ/external/left_foot = human_user.organs_by_name[BP_L_FOOT]
		var/obj/item/organ/external/right_foot = human_user.organs_by_name[BP_R_FOOT]
		if((!left_foot || left_foot.is_stump()) && (!right_foot || right_foot.is_stump()))
			if(!silent)
				to_chat(user, SPAN_WARNING("You need a functioning foot to kick."))
			return FALSE
	return TRUE

/singleton/maneuver/kick/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	. = ..()
	if(!.)
		return

	var/atom/movable/movable_target = target
	user.do_attack_animation(movable_target, ATTACK_EFFECT_KICK)
	playsound(user.loc, SFX_SWING_HIT, 25, 1, -1)
	var/kick_distance = max(2, round(strength * 2))
	if(istype(movable_target, /mob/living))
		var/mob/living/living_target = movable_target
		if(living_target.attack_generic(user, 10, "kicked", damage_type = DAMAGE_BRUTE) && !QDELETED(living_target))
			living_target.throw_at(get_edge_target_turf(user, get_dir(user, living_target)), kick_distance, 1, user)
	else if(movable_target.anchored)
		user.visible_message(
			SPAN_WARNING("\The [user] kicks \the [movable_target], but it does not budge!"),
			SPAN_WARNING("You kick \the [movable_target], but it does not budge!")
		)
	else
		user.visible_message(
			SPAN_WARNING("\The [user] kicks \the [movable_target], sending it flying!"),
			SPAN_WARNING("You kick \the [movable_target], sending it flying!")
		)
		movable_target.throw_at(get_edge_target_turf(user, get_dir(user, movable_target)), kick_distance, 1, user)
	user.post_maneuver()
